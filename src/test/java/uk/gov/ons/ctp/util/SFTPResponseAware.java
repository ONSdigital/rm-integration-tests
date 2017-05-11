package uk.gov.ons.ctp.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;

/**
 * Created by Stephen Goddard on 5/5/17.
 */
public class SFTPResponseAware {
  /* Property keys */
  private static final String SFTP_PORT = "cuc.collect.sftp.port";
  private static final String SFTP_SERVER = "cuc.sftp.server";
  private static final String SFTP_USERNAME = "cuc.collect.sftp.username";
  private static final String SFTP_PASSWORD = "cuc.collect.sftp.password";

  private World world;
  private int port;
  private String sftpServer = null;
  private String username = null;
  private String password = null;

  private Session session;
  private ChannelSftp sftpChannel;

  private int status;
  private String body;

  /**
   * Constructor
   *
   * @param newWorld class with application and environment properties
   */
  public SFTPResponseAware(final World newWorld) {
    this.world = newWorld;
    this.port = Integer.parseInt(world.getProperty(SFTP_PORT));
    this.sftpServer = world.getProperty(SFTP_SERVER);
    this.username = world.getProperty(SFTP_USERNAME);
    this.password = world.getProperty(SFTP_PASSWORD);
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
   * Delete all files from the specified location
   *
   * @param workingDir directory to be cleaned
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   */
  public void deleteAllFilesInDirectory(String workingDir) throws JSchException, SftpException {
    connect(workingDir);

    try {
      @SuppressWarnings("unchecked")
      Vector<ChannelSftp.LsEntry> list = sftpChannel.ls("*");
      for (ChannelSftp.LsEntry entry : list) {
        System.out.println("File to be deleted: " + sftpChannel.pwd() + "/" + entry.getFilename());
        sftpChannel.rm(entry.getFilename());
      }
      System.out.println("Status: " + sftpChannel.getExitStatus());
      status = sftpChannel.getExitStatus();
    } finally {
      disconnect();
    }
  }

  /**
   * Copy file from the local machine to the remote
   *
   * @param workingDir directory to be cleaned
   * @param srcLocation source location of file
   * @param filename filename to be copied
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   */
  public void copyFileFromLocalToRemote(String workingDir, String srcLocation, String filename)
      throws JSchException, SftpException {
    connect(workingDir);

    try {
      sftpChannel.put(srcLocation + filename, filename);
      @SuppressWarnings("unchecked")
      Vector<ChannelSftp.LsEntry> list = sftpChannel.ls("*");
      for (ChannelSftp.LsEntry entry : list) {
        System.out.println("File moved to: " + sftpChannel.pwd() + "/" + entry.getFilename());
      }
      System.out.println("Status: " + sftpChannel.getExitStatus());
      status = sftpChannel.getExitStatus();
    } finally {
      disconnect();
    }
  }

  /**
   * Find file(s) in directory
   *
   * @param workingDir directory to be cleaned
   * @param filename filename to be found
   * @return List of string of filenames
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   */
  public List<String> findFilesInDirectory(String workingDir, String filename) throws JSchException, SftpException {
    List<String> foundFiles = new ArrayList<String>();
    connect(workingDir);

    try {
      @SuppressWarnings("unchecked")
      Vector<ChannelSftp.LsEntry> list = sftpChannel.ls(filename);
      for (ChannelSftp.LsEntry entry : list) {
        System.out.println("File found: " + sftpChannel.pwd() + "/" + entry.getFilename());
        foundFiles.add(entry.getFilename());
      }
      System.out.println("Status: " + sftpChannel.getExitStatus());
      status = sftpChannel.getExitStatus();
    } finally {
      disconnect();
    }

    return foundFiles;
  }

  /**
   * Get the contents of the file in directory
   *
   * @param workingDir directory work in
   * @param filename filename to extract contents of
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void getContentsOfFile(String workingDir, String filename) throws JSchException, SftpException, IOException {
    StringBuffer buffer = new StringBuffer();
    connect(workingDir);

    try {
      InputStream inStream = sftpChannel.get(filename);
      BufferedReader br = new BufferedReader(new InputStreamReader(inStream));
      String line;
      while ((line = br.readLine()) != null) {
        System.out.println(line);
        buffer.append(line);
      }
      body = buffer.toString();
      System.out.println("Status: " + sftpChannel.getExitStatus());
      status = sftpChannel.getExitStatus();
    } finally {
      disconnect();
    }
  }

  /**
   * Set SFTP connection to be used
   *
   * @param workingDir directory for SFTP to work in
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   */
  private void connect(String workingDir) throws JSchException, SftpException {
    JSch jsch = new JSch();

    session = jsch.getSession(username, sftpServer, port);
    session.setConfig("StrictHostKeyChecking", "no");
    session.setPassword(password);
    session.connect();

    Channel channel = session.openChannel("sftp");

    sftpChannel = (ChannelSftp) channel;
    sftpChannel.setPty(true);
    sftpChannel.connect();
    sftpChannel.cd(workingDir);
  }

  /**
   * Close SFTP connections used
   */
  private void disconnect() {
    if (sftpChannel != null) {
      sftpChannel.exit();
    }
    if (session != null) {
      session.disconnect();
    }
  }

}
