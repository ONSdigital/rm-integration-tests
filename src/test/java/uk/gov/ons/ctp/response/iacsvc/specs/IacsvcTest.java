package uk.gov.ons.ctp.response.iacsvc.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 4/10/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/iacsvc/iacsvc.feature"},
        glue = {"uk.gov.ons.ctp.response.iacsvc.steps",
            "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/iacsvc-cucumber-html-report", "json:build/jenkins/iacsvc.json"}
)
public class IacsvcTest {

}
