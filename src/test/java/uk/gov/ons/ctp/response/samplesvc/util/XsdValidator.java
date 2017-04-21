package uk.gov.ons.ctp.response.samplesvc.util;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;

/**
 * Created by stephen.goddard on 4/4/17.
 */
public class XsdValidator {
  private ErrorHandler errorHandler = new XsdErrorHandler();

  /**
   * Run validation
   *
   * @param xsdLocation location of xsd files
   * @param xmlLocation location of xml files
   */
  public void Validate(String xsdLocation, String xmlLocation) {
    try {
      SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");

      File schemaLocation = new File(xsdLocation);
      Schema schema = factory.newSchema(schemaLocation);

      Validator validator = schema.newValidator();
      validator.setErrorHandler(errorHandler);

      Source source = new StreamSource(xmlLocation);

      validator.validate(source);
      System.out.println(xmlLocation + " has been processed using " + schemaLocation);
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
