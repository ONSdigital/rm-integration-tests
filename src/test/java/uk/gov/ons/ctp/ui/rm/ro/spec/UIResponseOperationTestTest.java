package uk.gov.ons.ctp.ui.rm.ro.spec;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 01/08/17.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
  features = {"classpath:uk/gov/ons/ctp/ui/rm/ro/uiTest.feature"},
  glue = {"uk.gov.ons.ctp.ui.rm.ro.steps"},
  plugin = {"pretty", "html:build/toBeNamed-cuc-html-report", "json:build/jenkins/toBeNamed.json"}
)
public class UiTestTest {

}
