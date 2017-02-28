package uk.gov.ons.ctp.response.casesvc.specs;
import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Kieran Wardle on 09/02/17.
 */

@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/casesvc/reportMIReportListEndpoint.feature"},
        glue = {"uk.gov.ons.ctp.response.casesvc.steps", "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/caseReportList-cucumber-html-report", "json:build/jenkins/caseReportList.json"}
)
public class ReportMIReportListEndpointTest {

}
