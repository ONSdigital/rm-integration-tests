package uk.gov.ons.ctp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Stephen Goddard on 25/5/16.
 */
public class PostgresResponseAware {
  private static Connection conn = null;
  private static final String DRIVER = "org.postgresql.Driver";
  private World world;

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public PostgresResponseAware(final World newWorld) {
    this.world = newWorld;
  }

  /**
   * Set DB connection to be used
   *
   * @throws ClassNotFoundException pass the exception
   * @throws SQLException pass the exception
   */
  private void getConnection() throws ClassNotFoundException, SQLException {
    Class.forName(DRIVER);
    conn = DriverManager.getConnection(world.getPostgresUrl(),
        world.getProperty("cuc.postgres.username"), world.getProperty("cuc.postgres.password"));
    System.out.println("Opened database successfully");
  }

  /**
   * Close DB connection
   *
   * @throws ClassNotFoundException pass the exception
   * @throws SQLException pass the exception
   */
  private void closeConnection() throws SQLException {
    conn.close();
  }

  /**
   * Run DB select commands
   *
   * @param sql to be run
   * @return List to contain the result of running sql
   * @throws ClassNotFoundException pass the exception
   * @throws SQLException pass the exception
   */
  public List<Object> dbSelect(String sql) throws ClassNotFoundException, SQLException {
    Statement stmt = null;
    List<Object> result = new ArrayList<Object>();

    getConnection();

    try {
      stmt = conn.createStatement();
      ResultSet rs = stmt.executeQuery(sql);
      ResultSetMetaData rsmd = rs.getMetaData();

      while (rs.next()) {
        for (int i = 1; i <= rsmd.getColumnCount(); i++) {
          result.add(rs.getObject(i));
        }
      }
    } finally {
      stmt.close();
      closeConnection();
    }

    System.out.println("Select operation done successfully");
    return result;
  }

  /**
   * Run DB update commands
   *
   * @param sql to be run
   * @return int to indicate result of running sql
   * @throws ClassNotFoundException pass the exception
   * @throws SQLException pass the exception
   */
  public int dbUpdateInsert(String sql) throws ClassNotFoundException, SQLException {
    Statement stmt = null;
    int result = 0;

    getConnection();

    try {
      stmt = conn.createStatement();
      result = stmt.executeUpdate(sql);
    } finally {
      stmt.close();
      closeConnection();
    }

    System.out.println("Update operation done successfully");
    return result;
  }

  /**
   * Run DB query to get row count commands
   *
   * @param sql to be run
   * @return long to indicate result of running sql
   * @throws ClassNotFoundException pass the exception
   * @throws SQLException pass the exception
   */
  public long rowCount(String sql) throws ClassNotFoundException, SQLException {
    Statement stmt = null;
    long result = -1;

    getConnection();

    try {
      stmt = conn.createStatement();
      ResultSet rs = stmt.executeQuery(sql);
      rs.next();
      result = rs.getLong(1);
    } finally {
      stmt.close();
      closeConnection();
    }

    System.out.println("Row count operation successfully");
    return result;
  }
}
