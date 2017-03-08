package uk.gov.ons.ctp.util;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;
import org.apache.jmeter.engine.StandardJMeterEngine;
import org.apache.jmeter.reporters.ResultCollector;
import org.apache.jmeter.reporters.Summariser;
import org.apache.jmeter.save.SaveService;
import org.apache.jmeter.util.JMeterUtils;
import org.apache.jorphan.collections.HashTree;

import com.jayway.jsonpath.JsonPath;

import net.minidev.json.JSONArray;

/**
 * Created by Stephen Goddard on 27/01/17.
 */
public class JmeterResponseAware {
  private static final String JMETER_HOME = "/var/lib/apache-jmeter-3.1";
  private static final String JMETER_PROP_FILE = JMETER_HOME + "/bin/jmeter.properties";
  // Jmeter test plans
  private static final String TEST_PLAN_LOC = "./JMeter";
  private static final String TEST_FILES_LOC = TEST_PLAN_LOC + "/test_files";
  private static final String TEST_SETUP_PLAN = TEST_PLAN_LOC + "/Test_Setup.jmx";
  private static final String TEST_STAB_PLAN = TEST_PLAN_LOC + "/Stability_Load.jmx";
  private static final String TEST_PLAN_LOC_MI = TEST_PLAN_LOC + "/MIReports_Download.jmx";
  // Jmeter logs
  private static final String TEST_PLAN_LOG_LOC = JMETER_HOME + "/logs";
  private static final String TEST_PAPER_FILE = TEST_PLAN_LOG_LOC + "/paperquestionnairereceipts.csv";
  private static final String TEST_SETUP_LOG = TEST_PLAN_LOG_LOC + "/setup.csv";
  private static final String TEST_STAB_LOG = TEST_PLAN_LOG_LOC + "/stability.csv";
  private static final String TEST_REPORT_LOG = TEST_PLAN_LOG_LOC + "/MIreports.csv";

  private HTTPResponseAware responseAware;
  private World world;
  private String reportNumber;

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public JmeterResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
  }

  /**
   * Run Jmeter setup test plan to prepare environment
   *
   * @param jmeterProperties properties passed into Cucumber
   */
  public void invokeEnvironmentSetupTestPlan(Properties jmeterProperties) {
    jmeterProperties.setProperty("env", world.getProperty("cuc.ui.server"));
    jmeterProperties.setProperty("testFilesLoc", TEST_FILES_LOC);
    System.out.println(jmeterProperties);

    runJmeter(jmeterProperties, TEST_SETUP_PLAN, TEST_SETUP_LOG);
  }

  /**
   * Get the most recent report number and store for other steps to use
   *
   * @param reportType report type to get
   */
  public void invokeGetReportNumber(String reportType) {
    try {
      String url = String.format("/reports/types/%s", reportType);
      responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
    } catch (AuthenticationException ae) {
      ae.printStackTrace();
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }

    JSONArray jsonArray = (JSONArray) JsonPath.read(responseAware.getBody(), "$");
    Map<?, ?> entry = (Map<?, ?>) jsonArray.get(0);
    reportNumber = entry.get("reportId").toString();
  }

  /**
   * Run Jmeter to download MI report
   *
   * @param jmeterProperties properties passed into Cucumber
   */
  public void invokeDownloadMIReport(Properties jmeterProperties) {
    jmeterProperties.setProperty("env", world.getProperty("cuc.ui.server"));
    jmeterProperties.setProperty("uiPort", world.getProperty("cuc.ui.port"));
    jmeterProperties.setProperty("reportUser", world.getProperty("integration.test.report.username"));
    jmeterProperties.setProperty("reportPassword", world.getProperty("integration.test.report.password"));
    jmeterProperties.setProperty("reportNumber", reportNumber);
    System.out.println(jmeterProperties);

    runJmeter(jmeterProperties, TEST_PLAN_LOC_MI, TEST_REPORT_LOG);
  }

  /**
   * Run Jmeter stability test plan
   *
   * @param jmeterProperties data to run test plan
   */
  public void invokeSimulatedResponsesTestPlan(Properties jmeterProperties) {
    jmeterProperties.setProperty("env", world.getProperty("cuc.ui.server"));
    jmeterProperties.setProperty("sdxUser", world.getProperty("cuc.collect.sdxgateway.username"));
    jmeterProperties.setProperty("sdxPassword", world.getProperty("cuc.collect.sdxgateway.password"));
    jmeterProperties.setProperty("sdxPort", world.getProperty("cuc.collect.sdxgateway.port"));
    jmeterProperties.setProperty("uiUser", world.getProperty("integration.test.username"));
    jmeterProperties.setProperty("uiPassword", world.getProperty("integration.test.password"));
    jmeterProperties.setProperty("uiPort", world.getProperty("cuc.ui.port"));
    jmeterProperties.setProperty("paperReceiptsFileLoc", TEST_PAPER_FILE);
    jmeterProperties.setProperty("eventDataLoc", TEST_FILES_LOC);
    System.out.println(jmeterProperties);

    runJmeter(jmeterProperties, TEST_STAB_PLAN, TEST_STAB_LOG);
  }

  /**
   * Run Jmeter test plan from the parameters
   *
   * @param jmeterProperties properties to be sent to jmeter
   * @param testPlan to run
   * @param testLog log to record results in
   */
  private void runJmeter(Properties jmeterProperties, String testPlan, String testLog) {
    System.out.println("Run Jmeter From: " + JMETER_HOME);
    System.out.println("Run Jmeter Test Plan: " + testPlan);

    HashTree testPlanTree = null;
    File jmeterHome = new File(JMETER_HOME);

    if (jmeterHome.exists()) {
      File jmeterPropFile = new File(JMETER_PROP_FILE);
      if (jmeterPropFile.exists()) {
        StandardJMeterEngine jmeter = new StandardJMeterEngine();

        JMeterUtils.setJMeterHome(JMETER_HOME);
        JMeterUtils.loadJMeterProperties(JMETER_PROP_FILE);

        // Comment this line out to see extra log messages of i.e. DEBUG level
        JMeterUtils.initLogging();
        JMeterUtils.initLocale();

        for (Entry<Object, Object> property : jmeterProperties.entrySet()) {
          JMeterUtils.setProperty(property.getKey().toString(), property.getValue().toString());
        }

        try {
          SaveService.loadProperties();
          testPlanTree = SaveService.loadTree(new File(testPlan));
        } catch (IOException e) {
          e.printStackTrace();
        }

        Summariser summer = null;
        String summariserName = JMeterUtils.getPropDefault("summariser.name", "summary");
        if (summariserName.length() > 0) {
            summer = new Summariser(summariserName);
        }
        String logFile = testLog;
        ResultCollector logger = new ResultCollector(summer);
        logger.setFilename(logFile);
        testPlanTree.add(testPlanTree.getArray()[0], logger);

        // Run Test Plan
        jmeter.configure(testPlanTree);
        jmeter.run();
      }
    } else {
      System.out.println("jmeter.home property is not set or pointing to incorrect location");
    }
  }
}
