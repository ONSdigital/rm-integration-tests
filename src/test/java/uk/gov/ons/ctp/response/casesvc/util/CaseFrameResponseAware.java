package uk.gov.ons.ctp.response.casesvc.util;

import java.io.IOException;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 04/05/16.
 */
public class CaseFrameResponseAware {
  private World world;
  private HTTPResponseAware responseAware;

  /**
   * Constructor - also gets singleton of http request runner
   *
   * @param newWorld class with application and environment properties
   */
  public CaseFrameResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
  }

  /**
   * @caseframe Service - /addresses/{uprnCode} get endoints.
   *
   * @param uprnCode uprn code
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeAddressesEndpoint(String uprnCode) throws IOException, AuthenticationException {
    final String url = String.format("/addresses/%s", uprnCode);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseframe Service - /addresses/postcode/{postcode} get endpoints.
   *
   * @param postcode post code
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeAddressesPostcodeEndpoint(String postcode) throws IOException, AuthenticationException {
    final String url = String.format("/addresses/postcode/%s", postcode);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }
}
