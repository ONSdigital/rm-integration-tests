package uk.gov.ons.ctp.response.sdx.specs;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Created by Gareth Turner 06/02/2017
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"classpath:uk/gov/ons/ctp/response/sdx/sdxGatewayFileIngestor.feature"},
        glue = {"uk.gov.ons.ctp.response.sdx.steps",
            "uk.gov.ons.ctp.response.casesvc.steps",
            "uk.gov.ons.ctp.ui.steps",
            "uk.gov.ons.ctp.response.common.steps",
            "uk.gov.ons.ctp.util"},
        plugin = {"pretty", "html:build/sdxGatewayFileIngestor-html-report",
            "json:build/jenkins/sdxGatewayFileIngestor.json"})

public class SdxGatewayFileIngestorTest {

}
