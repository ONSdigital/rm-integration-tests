package uk.gov.ons.ctp.respondenthomeui.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Edward Stevens on 17/11/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/ui/respondentHomeUi/respondentUi.feature"},
        glue = {"uk.gov.ons.ctp.respondenthomeui.steps", "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/respondHomeUi-cucumber-html-report", "json:build/jenkins/respondHomeUi.json"}
)
public class RespondentHomeUiTest {

}
