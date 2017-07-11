package uk.gov.ons.ctp.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.io.IOUtils;
import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpRequest;
import org.apache.http.auth.AuthenticationException;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CookieStore;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.auth.BasicScheme;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URI;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;

/**
 * Created by Stephen Goddard on 04/05/16.
 */
public class HTTPResponseAware {

  private String basicAuthUsername;
  private String basicAuthPassword;

  // For processing a response
  private String body;
  private int status;
  private CookieStore cookieStore = new BasicCookieStore();

  private static HTTPResponseAware instance = null;

  /**
   * Exists only to defeat instantiation.
   */
  private HTTPResponseAware() {
  }

  /**
   * Control singleton creation.
   *
   * @return HTTPResponseAware
   */
  public static synchronized HTTPResponseAware getInstance() {
    if (instance == null) {
      instance = new HTTPResponseAware();
    }

    return instance;
  }

  /**
   * Get response status.
   *
   * @return status int
   */
  public int getStatus() {
    return status;
  }

  /**
   * Get response body.
   *
   * @return body as string
   */
  public String getBody() {
    return body;
  }

  /**
   * Set authentication credentials.
   *
   * @param username string
   * @param password string
   */
  public void enableBasicAuth(String username, String password) {
    basicAuthUsername = username;
    basicAuthPassword = password;
  }

  /**
   * Generate JSON StringEntity from properties.
   *
   * @param properties JSON properties
   * @return StringEntity
   * @throws JsonProcessingException JSON exception
   */
  protected StringEntity propertiesToJsonEntity(final Properties properties) throws JsonProcessingException {
    final ObjectMapper om = new ObjectMapper();
    StringEntity entity = new StringEntity(om.writeValueAsString(properties), ContentType.APPLICATION_JSON);
    System.out.println(om.writeValueAsString(properties));
    return entity;
  }

  /**
   * Invoke a get http request.
   *
   * @param endpoint url
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeGet(final String endpoint) throws IOException, AuthenticationException {
    executeRequest(new HttpGet(URI.create(endpoint)));
  }

  /**
   * Invoke a put http request.
   *
   * @param endpoint url
   * @param data payload
   * @param contentType MimeType
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePut(final String endpoint, String data, ContentType contentType)
      throws IOException, AuthenticationException {
    final HttpPut put = new HttpPut(URI.create(endpoint));
    put.setEntity(new StringEntity(data, contentType == null ? ContentType.DEFAULT_TEXT : contentType));
    executeRequest(put);
  }

  /**
   * Create JSON before invoking a put http request.
   *
   * @param endpoint url
   * @param properties  for JSON content
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeJsonPut(final String endpoint, Properties properties) throws IOException, AuthenticationException {
    final HttpPut put = new HttpPut(URI.create(endpoint));
    put.setEntity(propertiesToJsonEntity(properties));
    executeRequest(put);
  }

  /**
   * Invoke a post http request.
   *
   * @param endpoint url
   * @param data payload
   * @param contentType MimeType
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokePost(final String endpoint, String data, ContentType contentType)
      throws IOException, AuthenticationException {
    final HttpPost post = new HttpPost(URI.create(endpoint));
    post.setEntity(new StringEntity(data, contentType == null ? ContentType.DEFAULT_TEXT : contentType));
    System.out.println(data);
    executeRequest(post);
  }

  /**
   * Create JSON before invoking a post http request.
   *
   * @param endpoint url
   * @param properties  for JSON content
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeJsonPost(final String endpoint, Properties properties) throws IOException, AuthenticationException {
    final HttpPost post = new HttpPost(URI.create(endpoint));
    post.setEntity(propertiesToJsonEntity(properties));
    executeRequest(post);
  }

  /**
   * Pass in JSON before invoking a post http request.
   *
   * @param endpoint url
   * @param jsonStr string representation of JSON
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeJsonPost(final String endpoint, String jsonStr) throws IOException, AuthenticationException {
    final HttpPost post = new HttpPost(URI.create(endpoint));
    post.setEntity(new StringEntity(jsonStr, ContentType.APPLICATION_JSON));
    executeRequest(post);
  }

  /**
   * Pass in XML before invoking a post http request.
   *
   * @param endpoint url
   * @param xmlStr string representation of XML
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeXmlPost(final String endpoint, String xmlStr) throws IOException, AuthenticationException {
    final HttpPost post = new HttpPost(URI.create(endpoint));
    post.setEntity(new StringEntity(xmlStr, ContentType.APPLICATION_XML));
    executeRequest(post);
  }

  /**
   * Attach file before invoking a post http request.
   *
   * @param endpoint url
   * @param file to be sent to SDX Gateway
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeFilePost(final String endpoint, File file) throws IOException, AuthenticationException {
    final HttpPost post = new HttpPost(URI.create(endpoint));

    MultipartEntityBuilder builder = MultipartEntityBuilder.create();
    builder.addBinaryBody("file", new FileInputStream(file), ContentType.APPLICATION_OCTET_STREAM, file.getName());
    HttpEntity multipart = builder.build();
    post.setEntity(multipart);

    executeRequest(post);
  }

  /**
   * Attach multipartFile before invoking a post http request.
   *
   * @param endpoint url
   * @param file to be sent to actionexporter template
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeMultipartFilePost(final String endpoint, MultipartFile file) throws IOException, AuthenticationException {
    final HttpPost post = new HttpPost(URI.create(endpoint));

    MultipartEntityBuilder builder = MultipartEntityBuilder.create();
    builder.addBinaryBody("file", file.getInputStream(), ContentType.APPLICATION_OCTET_STREAM, file.getName());
    HttpEntity multipart = builder.build();
    post.setEntity(multipart);

    executeRequest(post);
  }

  /**
   * Execute http request.
   *
   * @param request to run
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  private void executeRequest(HttpUriRequest request) throws AuthenticationException, IOException {
    CloseableHttpResponse response = null;
    CloseableHttpClient client = null;

    try {
      applyBasicAuth(request);
      addRequestHeaders(request);

      List<Header> httpHeaders = Arrays.asList(request.getAllHeaders());
      for (Header header : httpHeaders) {
          System.out.println("Headers.. name,value:" + header.getName() + "," + header.getValue());
      }

      System.out.format(
          "----------------------------- Request ----------------------------"
          + "\n%s\n----------------------------------------------------------------\n",
          request.getRequestLine().toString());
      client = HttpClientBuilder.create().setDefaultCookieStore(cookieStore).build();
      response = client.execute(request);

      HttpEntity entity = response.getEntity();
      if (entity != null) {
        body = IOUtils.toString(entity.getContent());
      }
      System.out.format("the body is: " + body + "\n");

      status = response.getStatusLine().getStatusCode();
      System.out.format(
          "----------------------------- Response ----------------------------"
          + "\n%s\n----------------------------------------------------------------\n",
          body);
    } finally {
      if (response != null) {
        response.close();
      }
      if (client != null) {
        client.close();
      }
    }
  }

  /**
   * If basic authentication credentials have been provided for this invocation
   * then apply them to the request by adding an appropriate header.
   *
   * @param request for authentication
   * @throws AuthenticationException authentication exception
   */
  private void applyBasicAuth(final HttpRequest request) throws AuthenticationException {
    if (basicAuthUsername != null) {
      final UsernamePasswordCredentials credentials = new UsernamePasswordCredentials(basicAuthUsername,
          basicAuthPassword);
      request.addHeader(new BasicScheme().authenticate(credentials, request, null));
    }
  }

  /**
   * Add request headers.
   *
   * @param request for headers
   */
  private void addRequestHeaders(final HttpRequest request) {

  }
}
