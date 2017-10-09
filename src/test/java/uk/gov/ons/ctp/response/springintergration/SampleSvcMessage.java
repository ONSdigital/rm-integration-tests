package uk.gov.ons.ctp.response.springintergration;

import com.rabbitmq.client.*;

import java.io.IOException;

import com.rabbitmq.client.Channel;


public class SampleSvcMessage {
  
  private final static String EXCHANGE_NAME = "event-message-outbound-exchange";
  private static Boolean gotMessage = false;
  private static String bodyMessage = "not got";
  private static int numberMessages = 0;
  
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
          bodyMessage = message;
          numberMessages += 1;
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
  
  public static int getNumberMessage() {
    return numberMessages;
  }
  
  public static void resetNumberMessage() {
    numberMessages = 0;
  }
}
