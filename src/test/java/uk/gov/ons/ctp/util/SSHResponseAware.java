package uk.gov.ons.ctp.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.time.Duration;

import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;

/**
 * Created by Stephen Goddard on 15/8/16.
 */
public class SSHResponseAware {
  private static final int BYTE_SIZE = 1024;
  private static final long DEFAULT_TIMEOUT = Duration.ofMinutes(1).toMillis();
  private static final String MKDIR_CMD = "echo Make Dir;[ ! -d %s ] && mkdir %s || echo Directory exists";
  private static final String RESET_PRINT_CMD = "echo Reset Print Files;find %s -maxdepth 1 -type f -exec mv {} %s \\;";
  private static final String CAT_FILE_CMD = "cat %s%s*";
  private static final String TOUCH_FILE_CMD = "sudo echo '%s' | cat > %s%s";
  private static final String CHECK_FILE = "ls %s | grep %s$";
  private World world;
  private Session session = null;
  private ChannelExec channel = null;
  private int port;
  private String ciServer = null;
  private String username = null;
  private String password = null;
  private boolean cancel = false;

  //For processing
  private int status;
  private String body;

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public SSHResponseAware(final World newWorld) {
    this.world = newWorld;
    this.port = Integer.parseInt(world.getProperty("cuc.collect.ssh.port"));
    this.ciServer = world.getProperty("cuc.server");
    this.username = world.getProperty("cuc.collect.ssh.username");
    this.password = world.getProperty("cuc.collect.ssh.password");
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
   * Create the directory if it does not exist
   *
   * @param location source folder
   */
  public void invokeMkdir(String location) {
    String mkdirScript = String.format(MKDIR_CMD, location, location);
    executeCommand(DEFAULT_TIMEOUT, mkdirScript);
  }

  /**
   * Move any files to the destination folder
   *
   * @param location source folder
   * @param copyLocation destination folder
   */
  public void invokePrintFileReset(String location, String copyLocation) {
    String resetScript = String.format(RESET_PRINT_CMD, location, copyLocation);
    executeCommand(DEFAULT_TIMEOUT, resetScript);
  }

  /**
   * Get file contents for given action type
   *
   * @param location source folder
   * @param actionType action type to be found in file name
   */
  public void invokeGetFileContentsForActionType(String location, String actionType) {
    String catScript = String.format(CAT_FILE_CMD, location, actionType);
    executeCommand(DEFAULT_TIMEOUT, catScript);
  }

  /**
   * Create a file in a given path
   *
   * @param filename name of test file
   * @param path location of file
   * @param content content of file
   */
  public void invokeCreateTestReceipt(String filename, String path, String content) {
    String touchScript = String.format(TOUCH_FILE_CMD, content, path, filename);
    executeCommand(DEFAULT_TIMEOUT, touchScript);
  }

  /**
   * Move any files to the destination folder
   *
   * @param fileName name of test file
   * @param path location of file
   * @return status returned by last bash command
   */
  public boolean fileExists(String path, String fileName) {
    String checkFile = String.format(CHECK_FILE, path, fileName);
    executeCommand(DEFAULT_TIMEOUT, checkFile);
    int commandStatus = getStatus();
    return commandStatus == 0;
  }

  /**
   * Set ssh connection to be used
   */
  private void connect() {
    try {
      JSch jsch = new JSch();
      session = jsch.getSession(username, ciServer, port);
      session.setPassword(password);

      java.util.Properties config = new java.util.Properties();
      config.put("StrictHostKeyChecking", "no");
      session.setConfig(config);
      session.connect();
    } catch (JSchException jse) {
      System.out.println(jse.getMessage());
    }
  }

  /**
   * Close ssh connection used
   */
  private void disconnect() {
    session.disconnect();
  }

  /**
   * Set DB connection to be used
   *
   * @param runTime time in milliseconds to run script if not completed before
   * @param script command line instructions to be run
   *
   * @throws JSchException pass the exception
   * @throws IOException pass the exception
   */
  public void executeCommand(long runTime, String script) {
    StringBuffer sshBody = new StringBuffer();
    boolean run = true;
    connect();

    try {
      channel = (ChannelExec) session.openChannel("exec");
      channel.setPty(true);

      System.out.println("Execute: " + script);
      channel.setCommand(script);

      InputStream in = channel.getInputStream();
      OutputStream out = channel.getOutputStream();
      channel.setErrStream(System.err);

      channel.connect();

      if (script.contains("sudo")) {
        out.write((password + "\n").getBytes());
        out.flush();
      }

      long stopTime = System.currentTimeMillis() + runTime;

      byte[] tmp = new byte[BYTE_SIZE];
      while (run && !cancel) {
        while (in.available() > 0) {
          int i = in.read(tmp, 0, BYTE_SIZE);
          if (i < 0) {
            run = false;
            break;
          }
          sshBody.append(new String(tmp, 0, i));

          long now = System.currentTimeMillis();
          if (now > stopTime) {
            cancel = true;
            break;
          }
        }
        if (channel.isClosed()) {
          System.out.println("exit-status: " + channel.getExitStatus());
          break;
        }
        try {
          Thread.sleep(Duration.ofSeconds(1).toMillis());
        } catch (InterruptedException ie) {
          System.out.println(ie.getMessage());
        }
      }

      if (cancel) {
        System.out.println("Command cancelled with ctrl C: " + script);

        channel.setInputStream(null);
        if (in != null) {
          in.close();
        }

        out.write(3); // ctrl c command
        out.flush();
        try {
          Thread.sleep(Duration.ofSeconds(1).toMillis());
        } catch (InterruptedException ie) {
          System.out.println(ie.getMessage());
        }
      }

      status = channel.getExitStatus();
    } catch (JSchException e) {
      System.out.println("SSH connection failed: " + e.getMessage());
    } catch (IOException e) {
      System.out.println("IO operation failed: " + e.getMessage());
    } finally {
      if (channel != null) {
        channel.disconnect();
      }
      if (session != null) {
        disconnect();
      }
    }
    this.body = sshBody.toString();
    System.out.println("Script Response Body: " + body);
    System.out.println("Ssh disconnect");
  }
}
