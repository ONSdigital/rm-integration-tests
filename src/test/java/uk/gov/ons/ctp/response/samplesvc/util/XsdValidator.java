package uk.gov.ons.ctp.response.samplesvc.util;

import java.io.IOException;
import java.util.List;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.springframework.core.io.ClassPathResource;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;

/**
 * Created by stephen.goddard on 4/4/17.
 */
public class XsdValidator {
  private ErrorHandler errorHandler = new XsdErrorHandler();
  private ResourceResolver resourceResolver;

  /**
   * Constructor - also sets the xsd validator
   *
   * @param setXsdLocation path for xsd files
   */
  public XsdValidator(String setXsdLocation) {
    resourceResolver = new ResourceResolver(setXsdLocation);
  }

  /**
   * Run validation
   *
   * @param xsdFile location of xsd files
   * @param xmlFile location of xml files
   */
  public void Validate(String xsdFile, String xmlFile) {
    try {
      SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");

      factory.setResourceResolver(resourceResolver);
      Source xsdSource = new StreamSource(new ClassPathResource(xsdFile).getInputStream());
      Schema schema = factory.newSchema(xsdSource);

      Validator validator = schema.newValidator();
      validator.setErrorHandler(errorHandler);
      validator.setResourceResolver(resourceResolver);

      Source source = new StreamSource(xmlFile);

      validator.validate(source);
      System.out.println(xmlFile + " has been processed using " + xsdFile);
    } catch (SAXException | IOException ex) {
      System.out.println(ex.getMessage());
    }
  }

  /**
   * Get list of warnings
   *
   * @return List of warnings
   */
  public List<String> getWarningsList() {
    return ((XsdErrorHandler) errorHandler).getWarnings();
  }

  /**
   * Get list of errors
   *
   * @return List of errors
   */
  public List<String> getErrorsList() {
    return ((XsdErrorHandler) errorHandler).getErrors();
  }
}
