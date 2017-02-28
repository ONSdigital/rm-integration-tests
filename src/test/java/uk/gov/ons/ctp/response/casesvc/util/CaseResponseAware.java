package uk.gov.ons.ctp.response.casesvc.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 04/05/16.
 */
public class CaseResponseAware {
  private World world;
  private HTTPResponseAware responseAware;

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   */
  public CaseResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
  }

  /**
   * Get body of response from run end point.
   *
   * @return String value of body
   * @throws Throwable pass the exception
   */
  public String getBody() {
    return responseAware.getBody();
  }

  /**
   * @caseresponse Service - /actionplanmappings/{mappingid} get endoints.
   *
   * @param mappingId action plan mapping id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionPlanMappingIdEndpoint(String mappingId)  throws IOException, AuthenticationException {
    final String url = String.format("/actionplanmappings/%s", mappingId);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /actionplanmappings/casetype/{casetypeid} get endoints.
   *
   * @param casetypeId case type id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeActionPlanMappingCaseTypeIdEndpoint(String casetypeId)
      throws IOException, AuthenticationException {
    final String url = String.format("/actionplanmappings/casetype/%s", casetypeId);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /casegroup/uprn/{uprn} get endoints.
   *
   * @param uprn for case group
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCaseGroupUprnEndpoint(String uprn) throws IOException, AuthenticationException {
    final String url = String.format("/casegroups/uprn/%s", uprn);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /casegroup/{casegroupid} get endoints.
   *
   * @param caseGroupId for case group
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCaseGroupIdEndpoint(String caseGroupId) throws IOException, AuthenticationException {
    final String url = String.format("/casegroups/%s", caseGroupId);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /cases/casegroup/{casegroupid} get endoints.
   *
   * @param caseGroupId case group id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCaseGroupEndpoint(String caseGroupId) throws IOException, AuthenticationException {
    final String url = String.format("/cases/casegroup/%s", caseGroupId);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /cases/iac/{iac} get endoints.
   *
   * @param iac code to get case for
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCaseIACEndpoint(String iac) throws IOException, AuthenticationException {
    final String url = String.format("/cases/iac/%s", iac);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /cases/{caseId} get endoints.
   *
   * @param caseId case id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCasesEndpoint(String caseId) throws IOException, AuthenticationException {
    final String url = String.format("/cases/%s", caseId);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /cases/{caseId}/events get endoints.
   *
   * @param caseId case id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCasesEventsEndpoint(String caseId) throws IOException, AuthenticationException {
    final String url = String.format("/cases/%s/events", caseId);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /cases/{caseId}/events post endoints.
   *
   * @param caseId case id
   * @param properties to construct JSON from
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePostCasesEventsEndpoint(String caseId, Properties properties)
      throws IOException, AuthenticationException {
    final String url = String.format("/cases/%s/events", caseId);
    responseAware.invokeJsonPost(world.getCaseframeserviceEndpoint(url), properties);
  }

  /**
   * @caseresponse Service - /cases/{caseId}/events post endoints.
   *
   * @param caseId case id
   * @param jsonStr string representation of JSON
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePostCasesEventsEndpoint(String caseId, String jsonStr)
      throws IOException, AuthenticationException {
    final String url = String.format("/cases/%s/events", caseId);
    responseAware.invokeJsonPost(world.getCaseframeserviceEndpoint(url), jsonStr);
  }

  /**
   * @caseresponse Service - /casetypes/{casetype} get endoints.
   *
   * @param casetype case type
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCasetypesEndpoint(String casetype) throws IOException, AuthenticationException {
    final String url = String.format("/casetypes/%s", casetype);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /categories get endoints.
   *
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCategoriesEndpoint() throws IOException, AuthenticationException {
    final String url = "/categories";
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /categories/{categoryName} get endoints.
   *
   * @param categoryName category id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeCategoriesEndpoint(String categoryName) throws IOException, AuthenticationException {
    final String url = String.format("/categories/%s", categoryName);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /samples/{sampleId} get endoints.
   *
   * @param sampleId sample id
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeSamplesEndpoint(String sampleId) throws IOException, AuthenticationException {
    final String url = String.format("/samples/%s", sampleId);
    responseAware.invokeGet(world.getCaseframeserviceEndpoint(url));
  }

  /**
   * @caseresponse Service - /samples/{sampleId} put endoints.
   *
   * @param sampleId sample id
   * @param properties to construct JSON from
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeSamplesSamplesidEndpoint(String sampleId, Properties properties)
      throws IOException, AuthenticationException {
    final String url = String.format("/samples/%s", sampleId);
    responseAware.invokeJsonPut(world.getCaseframeserviceEndpoint(url), properties);
  }
}
