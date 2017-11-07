package uk.gov.ons.ctp.util;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class DoNotPush {

  public void runTimeout() throws InterruptedException, ExecutionException {
    System.out.println("In Here");
    ExecutorService executor = Executors.newSingleThreadExecutor();
    Future<String> future = executor.submit(() -> {
      Thread.sleep(3000); // delay to trip timeout
      //do operations you want
      return "OK";
    });
    try {
      System.out.println(future.get(4, TimeUnit.SECONDS)); //timeout is in 2 seconds
    } catch (TimeoutException e) {
      System.err.println("Timeout");
    }
    executor.shutdownNow();
  }

  public static void main(String[] args) {
    DoNotPush app = new DoNotPush();
    try {
      app.runTimeout();
    } catch (InterruptedException | ExecutionException e) {
      e.printStackTrace();
    }
  }

}
