package uk.gov.ons.ctp.response.samplesvc.util;

import java.util.ArrayList;
import java.util.List;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

/**
 * Created by stephen.goddard on 4/4/17.
 */
public class XsdErrorHandler implements ErrorHandler {
  private List<String> warnings = new ArrayList<String>();
  private List<String> errors = new ArrayList<String>();

  /**
   * Get list of warnings from validation
   *
   * @return list of warnings
   */
  public List<String> getWarnings() {
    return warnings;
  }

  /**
   * Get list of errors from validation
   *
   * @return list of errors
   */
  public List<String> getErrors() {
    return errors;
  }

  /**
   * Store warning in list
   *
   * @param spex SAXParseException
   */
  public void warning(SAXParseException spex) {
    warnings.add(spex.getMessage());
  }

  /**
   * Store error in list
   *
   * @param spex SAXParseException
   */
  public void error(SAXParseException spex) {
    errors.add(spex.getMessage());
  }

  /**
   * Throw SAXException for fatal error
   *
   * @param spex SAXParseException
   * @throws SAXException pass the exception
   */
  public void fatalError(SAXParseException spex) throws SAXException {
    throw spex;
  }
}
