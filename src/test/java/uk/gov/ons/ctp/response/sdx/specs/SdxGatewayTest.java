package uk.gov.ons.ctp.response.sdx.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Gareth Turner 06/02/2017.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/sdx/sdxGateway.feature"},
        glue = {"uk.gov.ons.ctp.response.sdx.steps",
            "uk.gov.ons.ctp.response.samplesvc.steps",
            "uk.gov.ons.ctp.response.collectionexercisesvc.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.response.action.steps",
            "uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.common.steps"},
        plugin = {"pretty", "html:build/sdx-cucumber-html-report", "json:build/jenkins/sdx.json"}
)
public class SdxGatewayTest {

}
