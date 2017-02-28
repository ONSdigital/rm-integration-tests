package uk.gov.ons.ctp.no.response.specs;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
 * Created by stephen.goddard on 07/10/16.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/no/response/field.feature"},
        glue = {"uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.iacsvc.steps",
            "uk.gov.ons.ctp.response.drs.steps",
            "uk.gov.ons.ctp.response.action.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/field-cucumber-html-report", "json:build/jenkins/field.json"}
)
public class FieldTest {

}
