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
import com.jcraft.jsch.ChannelSftp.LsEntry;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;
import com.jcraft.jsch.SftpException;

/**
 * Created by Stephen Goddard on 5/5/17.
 */
public class SFTPResponseAware {
  /* Property keys */
  private static final String SFTP_PORT = "cuc.sftp.port";
  private static final String SFTP_SERVER = "cuc.sftp.server";
//  private static final String SFTP_USERNAME = "cuc.collect.sftp.username";
//  private static final String SFTP_PASSWORD = "cuc.collect.sftp.password";

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
//    this.username = world.getProperty(SFTP_USERNAME);
//    this.password = world.getProperty(SFTP_PASSWORD);
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
   * Set credentials for sftp as per service.
   *
   * @param user user name as string
   * @param pw password as string
   */
  public void setCredentials(String user, String pw) {
    this.username = user;
    this.password = pw;
  }

  /**
   * Make directory on sftp area
   *
   * @param workingDir base directory
   * @param newDir directory to create
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void makeDir(String workingDir, String newDir) throws JSchException, SftpException, IOException {
    boolean notFound = true;
    connect(workingDir);

    try {
      List<LsEntry> foundFiles = getListDirectoriesInDirectory("*");

      for (LsEntry file: foundFiles) {
        if (file.getFilename().equals(newDir)) {
          notFound = false;
        }
      }

      if (notFound) {
        System.out.println("Creating dir: " + workingDir + newDir);
        sftpChannel.mkdir(newDir);
      }

      System.out.println("Status: " + sftpChannel.getExitStatus());
      status = sftpChannel.getExitStatus();
    } finally {
      disconnect();
    }
  }

  /**
   * Make directory on sftp area
   *
   * @param workingDir base directory
   * @param copyLocation directory to move files to
   * @throws JSchException JSch exception
   * @throws SftpException SFTP exception
   * @throws IOException IO exception
   */
  public void moveFiles(String workingDir, String copyLocation) throws JSchException, SftpException, IOException {
    connect(workingDir);

    try {
      List<LsEntry> foundFiles = getListFilesInDirectory("*");

      for (LsEntry file: foundFiles) {
        SftpATTRS attr = file.getAttrs();
        if (!attr.isDir()) {
          String filename = file.getFilename();
          System.out.println("File to be Moved: " + sftpChannel.pwd() + "/" + filename);
          sftpChannel.rename(filename, copyLocation + filename);
        }
      }

      System.out.println("Status: " + sftpChannel.getExitStatus());
      status = sftpChannel.getExitStatus();
    } finally {
      disconnect();
    }
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
      List<LsEntry> foundFiles = getListFilesInDirectory("*");

      for (LsEntry file: foundFiles) {
        SftpATTRS attr = file.getAttrs();
        if (!attr.isDir()) {
          System.out.println("File to be deleted: " + sftpChannel.pwd() + "/" + file.getFilename());
          sftpChannel.rm(file.getFilename());
        }
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
      System.out.println("File moved to: " + sftpChannel.pwd() + "/" + filename);

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
      Vector<LsEntry> list = sftpChannel.ls(filename);
      for (LsEntry entry : list) {
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
      List<LsEntry> files = getListFilesInDirectory(filename);

      for (LsEntry entry : files) {
        InputStream inStream = sftpChannel.get(entry.getFilename());
        BufferedReader br = new BufferedReader(new InputStreamReader(inStream));
        String line;
        while ((line = br.readLine()) != null) {
          System.out.println(line);
          buffer.append(line + System.lineSeparator());
        }
        body = buffer.toString();
      }
      System.out.println("Status: " + sftpChannel.getExitStatus());
      status = sftpChannel.getExitStatus();
    } finally {
      disconnect();
    }
  }

  /**
   * Get list of directories found in directory
   *
   * @param search criteria
   * @return List of directories as LsEntry
   * @throws SftpException SFTP exception
   */
  private List<LsEntry> getListDirectoriesInDirectory(String search) throws SftpException {
    List<LsEntry> dirs =  new ArrayList<LsEntry>();

    @SuppressWarnings("unchecked")
    Vector<LsEntry> list = sftpChannel.ls(search);
    for (LsEntry entry : list) {
      SftpATTRS attr = entry.getAttrs();
      if (attr.isDir()) {
        dirs.add(entry);
      }
    }
    System.out.println("Directories found: " + dirs);

    return dirs;
  }

  /**
   * Get list of files found in directory
   *
   * @param search criteria
   * @return List of files as LsEntry
   * @throws SftpException SFTP exception
   */
  private List<LsEntry> getListFilesInDirectory(String search) throws SftpException {
    List<LsEntry> files =  new ArrayList<LsEntry>();

    @SuppressWarnings("unchecked")
    Vector<LsEntry> list = sftpChannel.ls(search);
    for (LsEntry entry : list) {
      SftpATTRS attr = entry.getAttrs();
      if (!attr.isDir()) {
        files.add(entry);
      }
    }
    System.out.println("Files found: " + files);

    return files;
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
