package uk.gov.ons.ctp.util;

import java.io.IOException;
import java.net.URL;
import java.util.Properties;

/**
 * This class ensures that only one instance of the application properties is
 * read from the file system, avoiding repetition.
 *
 * Created by philippe.brossier on 2/10/16.
 */
public class AbstractPropertyLoader {
  private static final Properties PROPERTIES = new Properties();
//  private static final String LIMIT_SQL = "SELECT %s FROM %s LIMIT %s;";

  // Load the properties once. Reads system property 'profile' and defaults to 'local'.
  static {
    for (final String profile : new String[] {"", System.getProperty("cuc.env", "local") }) {
      final String filename = "test" + (profile.isEmpty() ? "" : "-" + profile) + ".properties";
      final URL psource = AbstractPropertyLoader.class.getClassLoader().getResource(filename);

      if (psource == null) {
        throw new ExceptionInInitializerError(
            String.format("Failed to find property file '%s' in classpath", filename));
      }

      System.out.format("Loading properties from file '%s'.\n", filename);
      final Properties p = new Properties();
      try {
        p.load(psource.openStream());
        PROPERTIES.putAll(p);
      } catch (IOException e) {
        ExceptionInInitializerError ex = new ExceptionInInitializerError("Failed to load test.properties");
        ex.initCause(e);
        throw ex;
      }
    }
    for (Object key : PROPERTIES.keySet()) {
      final String val = PROPERTIES.getProperty((String) key);
      System.out.format("'%s' = '%s'\n", key, val);
    }
  }

  /**
   * Get specified property.
   *
   * @param name of property
   * @return property as string
   */
  public final String getProperty(final String name) {
    if (!PROPERTIES.containsKey(name)) {
      throw new RuntimeException(String.format("Property '%s' not defined in this environment!", name));
    }
    return PROPERTIES.getProperty(name);
  }

  /**
   * Get specified property. If not found return the default value.
   *
   * @param name of property
   * @param defaultValue default value
   * @return property as string
   */
  public final String getProperty(final String name, final String defaultValue) {
    return (PROPERTIES.containsKey(name)) ? PROPERTIES.getProperty(name) : defaultValue;
  }

  /**
   * Constructs the URL of service from environment specific components
   * gleaned from property files.
   *
   * The URL is constructed as follows:
   * ${cuc.protocol}://${cuc.collect.*.host}:${cuc.collect.*.port}
   *
   * @param name the name of the path
   * @param service name of service to build URL for
   * @return constructed URL
   */
  public final String getUrl(final String name, final String service) {
    final StringBuilder url = new StringBuilder();
    url.append(getProperty("cuc.protocol"))
        .append("://")
        .append(getProperty("cuc.collect." + service + ".host"))
        .append(":")
        .append(getProperty("cuc.collect." + service + ".port"));
    if (!name.startsWith("/")) {
      url.append("/");
    }
    url.append(name);
    System.out.format("For '%s' '%s', constructed URL '%s'.\n", service, name, url.toString());
    return url.toString();
  }

  /**
   * Get UUID from DB
   *
   * @param id to be found
   * @param table to run against
   * @param quantity number of UUID,s to recover
   * @param dbResponseAware database runner
   * @return string UUID
   */
  // TODO refactor with new db tool
//  public final String getIdFromDB(String id, String table, String quantity, PostgresResponseAware dbResponseAware) {
//    List<Object> result = new ArrayList<Object>();
//
//    String sql = String.format(LIMIT_SQL, id, table, quantity);
//    try {
//      result = (ArrayList<Object>) dbResponseAware.dbSelect(sql);
//    } catch (ClassNotFoundException | SQLException e) {
//      e.printStackTrace();
//    }
//
//    return result.get(0).toString();
//  }

//  /**
//   * Constructs the URL of an endpoint from environment specific components
//   * gleaned from property files.
//   *
//   * The name is used to obtain the endpoint path from a property with key
//   * "cuc.endpoint.${name}".
//   *
//   * If the property does not exist then the name will be assumed to be the
//   * endpoint.
//   *
//   * When an endpoint is found as a property the URL is constructed as follows:
//   * ${cuc.protocol}://${cuc.server}:${cuc.collect.actionservice.port}${cuc.
//   * endpoint.${name}}
//   *
//   * When an endpoint is NOT found as a property the URL is constructed as
//   * follows:
//   * ${cuc.protocol}://${cuc.server}:${cuc.collect.actionservice.port}/${name}
//   *
//   * @param name the name of the endpoint, for example ping
//   * @return constructed URL
//   */
//  public final String getActionServiceEndpoint(final String name) {
//    final StringBuilder url = new StringBuilder();
//    url.append(getProperty("cuc.protocol")).append("://").append(getProperty("cuc.server")).append(":")
//        .append(getProperty("cuc.collect.actionservice.port"));
//    final String ep = getProperty("cuc.endpoint." + name, name);
//    if (!ep.startsWith("/")) {
//      url.append("/");
//    }
//    url.append(ep);
//    System.out.format("For endpoint '%s', constructed URL '%s'.\n", name, url.toString());
//    return url.toString();
//  }

  /**
   * Constructs the URL of UI from environment specific components
   * gleaned from property files.
   *
   * The URL is constructed as follows:
   * ${cuc.protocol}://${cuc.server}/${name}
   *
   * @param name the name of the UI page
   * @return constructed URL
   */
  public final String getUiUrl(final String name) {
    final StringBuilder url = new StringBuilder();
    url.append(getProperty("cuc.protocol")).append("://").append(getProperty("cuc.ui.server")).append(":")
            .append(getProperty("cuc.ui.port"));
    if (!name.startsWith("/")) {
      url.append("/");
    }
    url.append(name);
    System.out.format("For UI '%s', constructed URL '%s'.\n", name, url.toString());
    return url.toString();
  }

  /**
   * Constructs the URL of an endpoint from environment specific components
   * gleaned from property files.
   *
   * The name is used to obtain the endpoint path from a property with key
   * "cuc.endpoint.${name}".
   *
   * If the property does not exist then the name will be assumed to be the
   * endpoint.
   *
   * When an endpoint is found as a property the URL is constructed as follows:
   * ${cuc.protocol}://${cuc.server}:${cuc.collect.actionservice.port}${cuc.
   * endpoint.${name}}
   *
   * When an endpoint is NOT found as a property the URL is constructed as
   * follows:
   * ${cuc.protocol}://${cuc.server}:${cuc.collect.actionservice.port}/${name}
   *
   * @return constructed URL
   */
//  public final String getPostgresUrl() {
//    final String postgresUrl = getProperty("cuc.postgres.url");
//    String url = String.format(postgresUrl, getProperty("cuc.postgres.server"), getProperty("cuc.postgres.port"),
//        getProperty("cuc.postgres.db"));
//    System.out.format("Postgres DB, constructed URL '%s'.\n", url);
//    return url;
//  }

  /**
   * Constructs the URL of SDX Gateway from environment specific components
   * gleaned from property files.
   *
   * The URL is constructed as follows:
   * ${cuc.protocol}://${cuc.collect.sdxgateway.host}:${cuc.collect.sdxgateway.port}
   *
   * @param name the name of the path
   * @return constructed URL
   */
  public final String getSdxGatewayUrl(final String name) {
    final StringBuilder url = new StringBuilder();
    url.append(getProperty("cuc.protocol")).append("://").append(getProperty("cuc.collect.sdxgateway.host"))
        .append(":").append(getProperty("cuc.collect.sdxgateway.port"));
    if (!name.startsWith("/")) {
      url.append("/");
    }
    url.append(name);
    System.out.format("For UI '%s', constructed URL '%s'.\n", name, url.toString());
    return url.toString();
  }

//  /**
//   * Constructs the URL of DRS Gateway from environment specific components
//   * gleaned from property files.
//   *
//   * The URL is constructed as follows:
//   * ${cuc.protocol}://${cuc.collect.drsgateway.host}:${cuc.collect.drsgateway.port}
//   *
//   * @param name the name of the path
//   * @return constructed URL
//   */
//  public final String getDrsGatewayUrl(final String name) {
//    final StringBuilder url = new StringBuilder();
//    url.append(getProperty("cuc.protocol")).append("://").append(getProperty("cuc.collect.drsgateway.host"))
//        .append(":").append(getProperty("cuc.collect.drsgateway.port"));
//    if (!name.startsWith("/")) {
//      url.append("/");
//    }
//    url.append(name);
//    System.out.format("For UI '%s', constructed URL '%s'.\n", name, url.toString());
//    return url.toString();
//  }
}
