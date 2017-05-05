package uk.gov.ons.ctp.util;

/**
 * Created by Stephen Goddard on 7/4/17
 */
public class SSHScripts {
  /*
   * If file(s) exists then delete them
   */
  public static final String DELETE_FILES_CMD = "find %s -name \"*.*\" -type f -delete";

  /*
   * Transfer file(s)
   */
  public static final String FILES_TRANSFER_CMD = "scp -t %s";

  /*
   * Localhost transfer file(s)
   */
  public static final String FILES_TRANSFER_CMD_LOCAL = "scp %s %s";

  /*
   * If file exists then output message of the result
   */
  public static final String FILES_EXIST_CMD = "[ -f %s ] && echo Found || echo Not Found";

  /*
   * Get file contents
   */
  public static final String GET_FILE_CONTENTS_CMD = "cat %s";
}
