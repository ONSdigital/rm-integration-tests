package uk.gov.ons.ctp.dtm.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by kieran.wardle on 13/02/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/dtm/dtmData.feature"},
        glue = {"uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/dtmData-cucumber-html-report",
            "json:build/jenkins/dtmData.json"}
)
public class DtmDataTest {

}
