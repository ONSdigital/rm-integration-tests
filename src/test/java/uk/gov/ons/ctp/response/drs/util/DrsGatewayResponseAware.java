package uk.gov.ons.ctp.response.drs.util;

import java.io.IOException;

import org.apache.http.auth.AuthenticationException;

import uk.gov.ons.ctp.util.HTTPResponseAware;
import uk.gov.ons.ctp.util.World;

/**
 * Created by Stephen Goddard on 16/12/16.
 */
public class DrsGatewayResponseAware {
  private World world;
  private HTTPResponseAware responseAware;
  private String response = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">"
      + "<soapenv:Header/><soapenv:Body><completedBooking><theOrders><order><orderId>8706</orderId>"
      + "<primaryOrderNumber>%s</primaryOrderNumber>"
      + "<orderComments>ActionCompleted : HouseholdUploadIAC : SYSTEM : Household upload IAC Lime Survey Id: "
      + "33ActionCrea</orderComments><contract>Census2016</contract>"
      + "<locationID>10012128317</locationID><priority>medium</priority><targetDate>2016-06-15T01:53:38</targetDate>"
      + "<earliestBookingDate>2016-05-24T13:53:00</earliestBookingDate><userId/><message>false</message>"
      + "<orderComplete>false</orderComplete><theBusinessData><businessData><name>LAST_UPDATED</name>"
      + "<description>LAST_UPDATED</description><mandatory>false</mandatory><dataTypeList>notaList</dataTypeList>"
      + "<type>string</type><value>2016-05-24T13:53:38</value></businessData><businessData><name>STATUS</name>"
      + "<description>STATUS</description><mandatory>false</mandatory><defaultValue>PLANNED</defaultValue>"
      + "<dataTypeList>closedList</dataTypeList><type>string</type><value>PLANNED</value><values><value>PLANNED</value>"
      + "<value>STARTED</value><value>COMPLETED</value></values></businessData></theBusinessData><theLocation>"
      + "<locationId>10012128317</locationId><name>11 VINEYARD ROAD CI Test</name><address1></address1>"
      + "<address2>11 VINEYARD ROAD</address2><postCode>TF1 1HB</postCode><contract>Census2016</contract>"
      + "<agency>FarehamTEST</agency><city>FAREHAM</city><country>United Kingdom</country><latitude>50.85165</latitude>"
      + "<longitude>-1.17044</longitude><workflowType>0000</workflowType></theLocation><theBookings><booking>"
      + "<bookingId>7352</bookingId><orderId>8706</orderId><tokenId>LuP4sH7vwgVnBOfzLHtCXnfAU0sdv41sAyDA2V7f</tokenId>"
      + "<primaryOrderNumber>%s</primaryOrderNumber><planningWindowStart>2016-05-24T13:53:38</planningWindowStart>"
      + "<planningWindowEnd>2016-06-14T13:53:38</planningWindowEnd><userId>gateway</userId>"
      + "<bookingReason>FIRST</bookingReason><contract>Census2016</contract>"
      + "<taskLifeCycleStatus>COMPLETED</taskLifeCycleStatus><taskCompletionStatus>%s</taskCompletionStatus>"
      + "<taskCompletionDate>2016-05-24T15:09:00</taskCompletionDate><theBookingCodes><bookingCode>"
      + "<orderId>8706</orderId><bookingId>7352</bookingId><bookingCodeSORCode>Household</bookingCodeSORCode>"
      + "<primaryOrderNumber>%s</primaryOrderNumber><quantity>1</quantity><standardMinuteValue>10</standardMinuteValue>"
      + "<itemNumberWithinBooking>1</itemNumberWithinBooking><itemValue>1</itemValue>"
      + "<bookingCodeDescription>Visit a Household</bookingCodeDescription></bookingCode></theBookingCodes>"
      + "<theBusinessData><businessData><name>APPOINTMENT_SEQUENCE</name>"
      + "<description>APPOINTMENT_SEQUENCE</description><mandatory>true</mandatory><defaultValue>FIRST</defaultValue>"
      + "<dataTypeList>closedList</dataTypeList><type>string</type><value>FIRST</value><values><value>FIRST</value>"
      + "<value>FOLLOW ON</value></values></businessData><businessData><name>EMERGENCY</name>"
      + "<description>EMERGENCY</description><mandatory>true</mandatory><defaultValue>NO</defaultValue>"
      + "<dataTypeList>closedList</dataTypeList><type>string</type><value>NO</value><values><value>NO</value>"
      + "<value>YES</value></values></businessData><businessData><name>ORIG_PLAN_WIN_END</name>"
      + "<description>ORIG_PLAN_WIN_END</description><mandatory>false</mandatory><dataTypeList>notaList</dataTypeList>"
      + "<type>string</type><value>14/06/2016 13:53:38</value></businessData><businessData>"
      + "<name>ORIG_PLAN_WIN_START</name><description>ORIG_PLAN_WIN_START</description><mandatory>false</mandatory>"
      + "<dataTypeList>notaList</dataTypeList><type>string</type><value>24/05/2016 13:53:38</value></businessData>"
      + "<businessData><name>ORIGINAL_USER</name><description>ORIGINAL_USER</description><mandatory>false</mandatory>"
      + "<defaultValue>admin</defaultValue><dataTypeList>notaList</dataTypeList><type>string</type>"
      + "<value>gateway</value></businessData><businessData><name>SERVICE_REQUIREMENT</name>"
      + "<description>SERVICE_REQUIREMENT</description><mandatory>false</mandatory>"
      + "<dataTypeList>closedList</dataTypeList><type>string</type><value>FALSE</value><values><value>FALSE</value>"
      + "<value>TRUE</value></values></businessData><businessData><name>BOOKING_TYPE</name>"
      + "<description>BOOKING_TYPE</description><mandatory>false</mandatory><dataTypeList>notaList</dataTypeList>"
      + "<type>string</type><value>Housing Repair</value></businessData><businessData><name>BOOKING_SUB_TYPE</name>"
      + "<description>BOOKING_SUB_TYPE</description><mandatory>false</mandatory><dataTypeList>notaList</dataTypeList>"
      + "<type>string</type><value>Basic</value></businessData><businessData><name>ORIGINAL_DURATION</name>"
      + "<description>ORIGINAL_DURATION</description><mandatory>false</mandatory><dataTypeList>notaList</dataTypeList>"
      + "<type>numeric</type><value>10</value></businessData></theBusinessData></booking></theBookings></order>"
      + "</theOrders></completedBooking></soapenv:Body></soapenv:Envelope>";

  /**
   * Constructor - also gets singleton of http request runner.
   *
   * @param newWorld class with application and environment properties
   */
  public DrsGatewayResponseAware(final World newWorld) {
    this.world = newWorld;
    this.responseAware = HTTPResponseAware.getInstance();
  }

  /**
   * DRS Gateway Service - / post endpoints.
   *
   * @param outcome DRS out come code
   * @param actionId DRS primary order number or RM actionId
   * @throws IOException IO exception
   * @throws AuthenticationException authentication exception
   */
  public void invokeDRSResponse(String outcome, String actionId) throws IOException, AuthenticationException {
    final String url = "/";
    String body = String.format(response, actionId, actionId, outcome, actionId);

    responseAware.enableBasicAuth(world.getProperty("cuc.collect.drsgateway.username"),
        world.getProperty("cuc.collect.drsgateway.password"));

    System.out.println(body);
    responseAware.invokeXmlPost(world.getDrsGatewayUrl(url), body);
  }
}
