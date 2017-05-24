package uk.gov.ons.ctp.response.samplesvc.util;

import java.io.InputStream;

import org.apache.cxf.common.xmlschema.LSInputImpl;
import org.w3c.dom.ls.LSInput;
import org.w3c.dom.ls.LSResourceResolver;

/**
 * Created by stephen.goddard on 23/5/17.
 */
public class ResourceResolver implements LSResourceResolver {
  private String xsdLocation;

  /**
   * Constructor
   *
   * @param setXsdLocation sets the path where the xsd files can be found
   */
  public ResourceResolver(String setXsdLocation) {
    xsdLocation = setXsdLocation;
  }

  /**
   * Get list of warnings
   *
   * @param type resource type
   * @param namespaceURI resource namespace URI
   * @param publicId resource public id
   * @param systemId resource system id
   * @param baseURI resource base URI
   * @return List of warnings
   */
  @Override
  public LSInput resolveResource(String type, String namespaceURI, String publicId, String systemId, String baseURI) {
    InputStream resourceAsStream = this.getClass().getClassLoader().getResourceAsStream(xsdLocation + systemId);
    return new LSInputImpl(publicId, systemId, resourceAsStream);
  }
}
