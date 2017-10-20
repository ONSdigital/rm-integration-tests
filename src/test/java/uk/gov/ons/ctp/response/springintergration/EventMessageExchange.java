package uk.gov.ons.ctp.response.springintergration;

import com.rabbitmq.client.*;

import java.io.IOException;

import com.rabbitmq.client.Channel;


public class EventMessageExchange {
  
  private final static String EXCHANGE_NAME = "event-message-outbound-exchange";
  private static Boolean gotMessage = false;
  private static String bodyMessage = "not got";
  private static int numberActionMessages = 0;
  private static int numberCaseMessages = 0;
  private static int numberSampleMessages = 0;
  private static int numberActionCaseMessages = 0;
  private static int numberActionExporterMessages = 0;
  
  public void setUpConsumer() throws Exception {

    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    factory.setPort(6672);
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();
    
    channel.exchangeDeclare(EXCHANGE_NAME, "fanout", true);
    String queueName = channel.queueDeclare().getQueue();
    channel.queueBind(queueName, EXCHANGE_NAME, "");
    
    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");
    
    Consumer consumer = new DefaultConsumer(channel) {
      @Override
      public void handleDelivery(String consumerTag, Envelope envelope,
                AMQP.BasicProperties properties, byte[] body) throws IOException {
        String message = new String(body, "UTF-8");
        System.out.println(" [x] Received '" + message + "'");
        gotMessage = true;
        switch(message){
          case "Sample PERSISTED": 
            numberSampleMessages += 1;
            break;
          case "case Activated": 
            numberCaseMessages += 1;
            break;
          case "Action Case":
            numberActionCaseMessages += 1;
            break;
          case "Action Completed": 
            numberActionMessages += 1;
            break;
          case "Print file":
            numberActionExporterMessages  += 1;
            break;
        }
        bodyMessage = message;
      }
    };
    channel.basicConsume(queueName, true, consumer);

  }

  public static Boolean getGotMessage() {
    return gotMessage;
  }
  
  public static void resetGotMessage() {
    gotMessage = false;
  }
  
  public static String getBodyMessage() {
    return bodyMessage;
  }
  
  public static int getNumberCaseMessage() {
    return numberCaseMessages;
  }
  
  public static void resetNumberCaseMessage() {
    numberCaseMessages = 0;
  }
  public static int getNumberActionMessage() {
    return numberActionMessages;
  }
  
  public static void resetNumberActionMessage() {
    numberActionMessages = 0;
  }
  
  public static int getNumberSampleMessage() {
    return numberSampleMessages;
  }
  
  public static void resetNumberSampleMessage() {
    numberSampleMessages = 0;
  }
  
  public static int getNumberActionCaseMessages() {
    return numberActionCaseMessages;
  }
  
  public static void resetNumberActionCaseMessages() {
    numberActionCaseMessages = 0;
  }
  
  public static int getNumberActionExporterMessages() {
    return numberActionExporterMessages;
  }
  
  public static void resetNumberActionExporterMessages() {
    numberActionExporterMessages = 0;
  }
}
