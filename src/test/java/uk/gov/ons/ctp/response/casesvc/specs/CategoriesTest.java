package uk.gov.ons.ctp.response.casesvc.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Stephen Goddard on 18/3/16.
 */

@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/casesvc/categories.feature"},
        glue = {"uk.gov.ons.ctp.response.casesvc.steps", "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/categories-cucumber-html-report", "json:build/jenkins/categories.json"}
)
public class CategoriesTest {
}
