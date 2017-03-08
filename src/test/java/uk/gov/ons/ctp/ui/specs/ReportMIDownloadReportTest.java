package uk.gov.ons.ctp.ui.specs;
import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Chirstopher Hardman on 24/02/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/ui/ReportMI/downloadMIReport.feature"},
        glue = {"uk.gov.ons.ctp.response.actionexporter.steps",
            "uk.gov.ons.ctp.response.common.steps",
            "uk.gov.ons.ctp.jmeter.steps",
            "uk.gov.ons.ctp.ui.steps"},
        plugin = {"pretty", "html:build/ReportMIDownload-cucumber-html-report",
            "json:build/jenkins/REportMIDownload.json"}
)

public class ReportMIDownloadReportTest {

}
