package uk.gov.ons.ctp.other.fulfilment.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 10/10/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/other/fulfilment/translationBooklets.feature"},
        glue = {"uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/translation-cucumber-html-report", "json:build/jenkins/translation.json"}
)
public class TranslationBookletsTest {

}
