package uk.gov.ons.ctp.response.sdx.util;

import java.io.File;
import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 30/9/16.
 */
public class SdxGatewayResponseAware {
  private World world;
  private HTTPResponseAware responseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   */
  public SdxGatewayResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
  }

  /**
   * sdx gateway - /questionnairereceipts post endpoint.
   *
   * @param properties to construct JSON from
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeSdxReceiptEndpoint(Properties properties) throws IOException, AuthenticationException {
    final String url = "/questionnairereceipts";
    responseAware.enableBasicAuth(world.getProperty("cuc.collect.sdxgateway.username"),
        world.getProperty("cuc.collect.sdxgateway.password"));
    responseAware.invokeJsonPost(world.getSdxGatewayUrl(url), properties);
  }

  /**
   * sdx gateway - /paperquestionnairereceipts post endpoint.
   *
   * @param file to be sent to SDX Gateway
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeSdxPaperReceiptEndpoint(File file) throws IOException, AuthenticationException {
    final String url = "/paperquestionnairereceipts";
    responseAware.enableBasicAuth(world.getProperty("cuc.collect.sdxgateway.username"),
        world.getProperty("cuc.collect.sdxgateway.password"));
    responseAware.invokeFilePost(world.getSdxGatewayUrl(url), file);
  }
}
