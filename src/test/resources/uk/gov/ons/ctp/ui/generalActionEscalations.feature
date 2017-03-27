#Author: Kieran Wardle 15/12/16
#Keywords Summary : This feature tests that the General Escalated Case lists correctly upddate upon Operator actions.
#				https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?spaceKey=SDC&title=Helpline+Interface+Test+Scenarios
#
#Feature: Clean DB to pre test condition
#															Create Sample
#															IAC Generation
#                             UI created case event and test event and case states using Chrome
#                             UI created case escalated event and test event and case states using Chrome
#															UI checked that the operator case lists were updated correctly
#
# Feature Tag:@helplineUI  @actionEscalation
#
# Scenario Tags: @complaintCreateEventExistCheck
#                

@helplineUI @generalActionEscalation
Feature: Test general user can view and perform actions upon escalation action.

  @uiCleanEnvironment
  Scenario: Clean DB to pre test condition
    When reset the postgres DB
    Then check "casesvc.case" records in DB equal 0
    And check "casesvc.caseevent" records in DB equal 0
		And check "casesvc.casegroup" records in DB equal 0
		And check "casesvc.contact" records in DB equal 0
		And check "casesvc.response" records in DB equal 0
    And check "casesvc.messagelog" records in DB equal 0
    And check "casesvc.unlinkedcasereceipt" records in DB equal 0
    And check "action.action" records in DB equal 0
    And check "action.actionplanjob" records in DB equal 0
    And check "action.case" records in DB equal 0
    And check "action.messagelog" records in DB equal 0
    And check "casesvc.caseeventidseq" sequence in DB equal 1
    And check "casesvc.caseidseq" sequence in DB equal 1
    And check "casesvc.casegroupidseq" sequence in DB equal 1
    And check "casesvc.caserefseq" sequence in DB equal 1000000000000001
    And check "casesvc.responseidseq" sequence in DB equal 1
    And check "casesvc.messageseq" sequence in DB equal 1
    And check "action.actionidseq" sequence in DB equal 1
    And check "action.actionplanjobseq" sequence in DB equal 1
    And check "action.messageseq" sequence in DB equal 1


	# Sample Creation -----

	# PUT /samples/{sampleId}
	# 200
	@uiCreateSample
	Scenario: Put request for sample to create online cases for the specified sample id
		When I make the PUT call to the caseservice sample endpoint for sample id "1" for area "REGION" code "E12000005"
		Then the response status should be 200
		And the response should contain the field "name" with value "C2EO332E"
		And the response should contain the field "survey" with value "2017 TEST"
		Then check "casesvc.case" records in DB equal 10 for "state = 'SAMPLED_INIT'"
		And check "casesvc.caseevent" records in DB equal 10


	@generateIAC
	Scenario: Each case has a unique IAC assigned to it
			and in Actionable state
			and action service has been notified case has been created
		Given after a delay of 30 seconds
		When check "casesvc.case" distinct records in DB equal 10 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 17"
		And check "action.case" records in DB equal 1 for "caseid = 10"
		
		
	# Create general complaint Escalated
	@complaintCreateEvent
  Scenario: Escalation manager creates a Pending case event on Complaint - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 1 											 		|
			| description 				| Created by cucumber test		|
			| category 						| General_Complaint_Escalated |
			| subCategory 				| test										 		|
			| createdBy 					| Cucumber Test						 		|
			| caseCreationRequest |													 		|
			| caseTypeId 					| 17											 		|
			| actionPlanMappingId | 17											 		|
			| title 							| Mr											 		|
			| forename 						| Cucumber								 		|
			| surname 						| Cucumber Test						 		|
			| phoneNumber 				| 07777123456              		|
			| emailAddress 				| test@ons.gov.uk					 		|
    And the response status should be 201
    
  Scenario: Escalation manager creates a Pending case event on Complaint - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 2											 		|
			| description 				| Created by cucumber test		|
			| category 						| General_Complaint_Escalated |
			| subCategory 				| test										 		|
			| createdBy 					| Cucumber Test						 		|
			| caseCreationRequest |													 		|
			| caseTypeId 					| 17											 		|
			| actionPlanMappingId | 17											 		|
			| title 							| Mr											 		|
			| forename 						| Cucumber								 		|
			| surname 						| Cucumber Test						 		|
			| phoneNumber 				| 07777123456              		|
			| emailAddress 				| test@ons.gov.uk					 		|
    And the response status should be 201
    
  Scenario: Escalation manager creates a Pending case event on Complaint - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 3											 		|
			| description 				| Created by cucumber test		|
			| category 						| General_Complaint_Escalated |
			| subCategory 				| test										 		|
			| createdBy 					| Cucumber Test						 		|
			| caseCreationRequest |													 		|
			| caseTypeId 					| 17											 		|
			| actionPlanMappingId | 17											 		|
			| title 							| Mr											 		|
			| forename 						| Cucumber								 		|
			| surname 						| Cucumber Test						 		|
			| phoneNumber 				| 07777123456              		|
			| emailAddress 				| test@ons.gov.uk					 		|
    And the response status should be 201
   
  Scenario: Escalation manager creates a Pending case event on Complaint - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 4											 		|
			| description 				| Created by cucumber test		|
			| category 						| General_Complaint_Escalated |
			| subCategory 				| test										 		|
			| createdBy 					| Cucumber Test						 		|
			| caseCreationRequest |													 		|
			| caseTypeId 					| 17											 		|
			| actionPlanMappingId | 17											 		|
			| title 							| Mr											 		|
			| forename 						| Cucumber								 		|
			| surname 						| Cucumber Test						 		|
			| phoneNumber 				| 07777123456              		|
			| emailAddress 				| test@ons.gov.uk					 		|
    And the response status should be 201
    
  Scenario: Escalation manager creates a Pending case event on Enquiry - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 5 											 		|
			| description 				| Created by cucumber test		|
			| category 						| General_Enquiry_Escalated |
			| subCategory 				| test										 		|
			| createdBy 					| Cucumber Test						 		|
			| caseCreationRequest |													 		|
			| caseTypeId 					| 17											 		|
			| actionPlanMappingId | 17											 		|
			| title 							| Mr											 		|
			| forename 						| Cucumber								 		|
			| surname 						| Cucumber Test						 		|
			| phoneNumber 				| 07777123456              		|
			| emailAddress 				| test@ons.gov.uk					 		|
    And the response status should be 201
    
  Scenario: Escalation manager creates a Pending case event on Enquiry - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 6											 		|
			| description 				| Created by cucumber test		|
			| category 						| General_Enquiry_Escalated |
			| subCategory 				| test										 		|
			| createdBy 					| Cucumber Test						 		|
			| caseCreationRequest |													 		|
			| caseTypeId 					| 17											 		|
			| actionPlanMappingId | 17											 		|
			| title 							| Mr											 		|
			| forename 						| Cucumber								 		|
			| surname 						| Cucumber Test						 		|
			| phoneNumber 				| 07777123456              		|
			| emailAddress 				| test@ons.gov.uk					 		|
    And the response status should be 201
    
  Scenario: Escalation manager creates a Pending case event on Enquiry - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 7											 		|
			| description 				| Created by cucumber test		|
			| category 						| General_Enquiry_Escalated |
			| subCategory 				| test										 		|
			| createdBy 					| Cucumber Test						 		|
			| caseCreationRequest |													 		|
			| caseTypeId 					| 17											 		|
			| actionPlanMappingId | 17											 		|
			| title 							| Mr											 		|
			| forename 						| Cucumber								 		|
			| surname 						| Cucumber Test						 		|
			| phoneNumber 				| 07777123456              		|
			| emailAddress 				| test@ons.gov.uk					 		|
    And the response status should be 201
    
  Scenario: Escalation manager creates a Pending case event on Enquiry - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 8											 		|
			| description 				| Created by cucumber test		|
			| category 						| General_Enquiry_Escalated |
			| subCategory 				| test										 		|
			| createdBy 					| Cucumber Test						 		|
			| caseCreationRequest |													 		|
			| caseTypeId 					| 17											 		|
			| actionPlanMappingId | 17											 		|
			| title 							| Mr											 		|
			| forename 						| Cucumber								 		|
			| surname 						| Cucumber Test						 		|
			| phoneNumber 				| 07777123456              		|
			| emailAddress 				| test@ons.gov.uk					 		|
    And the response status should be 201
		And after a delay of 60 seconds
    
    
  # Complaint Escalated - Close Escalation
  Scenario: Escalation manager creates a close escalation case event on General Complaint - Escalated and checks that the case was removed.
    Given the "General" user has logged in using "Chrome"
    And the user navigates to the page for escalations
    When navigates to the escalated page "View escalated general complaint cases" 
    And navigates to the cases page for case "1"
    And the user creates a new event for
      | Close Escalation | Manager test description. | Mr | General Integration | Tester | 07777123456 |
    Then the case event category should be "Close Escalation"
    And the case event description should be "name: Mr general integration tester phone: 07777123456 Manager test description."
    And the user navigates to the page for escalations
    And navigates to the escalated page "View escalated general complaint cases" 
    And the escalated user checks case is not present for "1"
    And the user logs out
    
  Scenario: Helpline Operator checks that the case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state for "1" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Pending Escalation
  Scenario: Escalation manager creates a pending escalation case event on General Complaint - Escalated and checks that the case was not removed.
    Given the "General" user has logged in using "Chrome"
    And the user navigates to the page for escalations
    When navigates to the escalated page "View escalated general complaint cases"
    And navigates to the cases page for case "2"
    And the user creates a new event for
      | Pending | Manager test description. | Mrs | General Integration | Tester | 07777123456 |
    Then the case event category should be "Pending"
    And the case event description should be "name: Mrs general integration tester phone: 07777123456 Manager test description."
    And the user navigates to the page for escalations
    And navigates to the escalated page "View escalated general complaint cases" 
    And the escalated user checks case is present for "2"
    And the user logs out
    
  Scenario: Helpline Operator checks that a closed case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 2"
    And the case state for "2" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Incorrect Escalation
  Scenario: Escalation manager creates an incorrect escalation case event on General Complaint - Escalated and checks that the case was removed.
    Given the "General" user has logged in using "Chrome"
    And the user navigates to the page for escalations
    When navigates to the escalated page "View escalated general complaint cases"
    And navigates to the cases page for case "3"
    And the user creates a new event for
      | Incorrect Escalation | Manager test description. | Miss | General Integration | Tester | 07777123456 |
    Then the case event category should be "Incorrect Escalation"
    And the case event description should be "name: Miss general integration tester phone: 07777123456 Manager test description."
    And the user navigates to the page for escalations
    And navigates to the escalated page "View escalated general complaint cases" 
    And the escalated user checks case is not present for "3"
    And the user logs out
    
  Scenario: Helpline Operator checks that the  case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 3"
    And the case state for "3" should be "ACTIONABLE"
    And the user logs out
    
   
  # Complaint Escalated - Escalated Refusal
  Scenario: Escalation manager creates an escalated refusal case event on General Complaint - Escalated and checks that the case was not removed.
    Given the "General" user has logged in using "Chrome"
    And the user navigates to the page for escalations
    When navigates to the escalated page "View escalated general complaint cases" 
    And navigates to the cases page for case "4"
    And the user creates a new event for
      | Escalated Refusal | Manager test description. | Ms | General Integration | Tester | 07777123456 |
    Then the case event category should be "Escalated Refusal"
    And the case event description should be "name: Ms general integration tester phone: 07777123456 Manager test description."
    And the user navigates to the page for escalations
    And navigates to the escalated page "View escalated general complaint cases" 
    And the escalated user checks case is not present for "4"
    And the user logs out
    
  Scenario: Helpline Operator checks that the  case is Inactionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 4"
    And the case state for "4" should be "INACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Close Escalation
  Scenario: Escalation manager creates a close escalation case event on General Complaint - Escalated and checks that the case was removed.
    Given the "General" user has logged in using "Chrome"
    And the user navigates to the page for escalations
    When navigates to the escalated page "View escalated general enquiry cases"
    And navigates to the cases page for case "5"
    And the user creates a new event for
      | Close Escalation | Manager test description. | Dr | General Integration | Tester | 07777123456 |
    Then the case event category should be "Close Escalation"
    And the case event description should be "name: Dr general integration tester phone: 07777123456 Manager test description."
    And the user navigates to the page for escalations
    And navigates to the escalated page "View escalated general enquiry cases" 
    And the escalated user checks case is not present for "5"
    And the user logs out
    
  Scenario: Helpline Operator checks that the case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 5"
    And the case state for "5" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Pending Escalation
  Scenario: Escalation manager creates a pending escalation case event on General Complaint - Escalated and checks that the case was not removed.
    Given the "General" user has logged in using "Chrome"
    And the user navigates to the page for escalations
    When navigates to the escalated page "View escalated general enquiry cases"
    And navigates to the cases page for case "6"
    And the user creates a new event for
      | Pending | Manager test description. | Prof. | General Integration | Tester | 07777123456 |
    Then the case event category should be "Pending"
    And the case event description should be "name: Prof general integration tester phone: 07777123456 Manager test description."
    And the user navigates to the page for escalations
    And navigates to the escalated page "View escalated general enquiry cases" 
    And the escalated user checks case is present for "6"
    And the user logs out
    
  Scenario: Helpline Operator checks that a closed case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 6"
    And the case state for "6" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Incorrect Escalation
  Scenario: Escalation manager creates an incorrect escalation case event on General Complaint - Escalated and checks that the case was removed.
    Given the "General" user has logged in using "Chrome"
    And the user navigates to the page for escalations
    When navigates to the escalated page "View escalated general enquiry cases"
    And navigates to the cases page for case "7"
    And the user creates a new event for
      | Incorrect Escalation | Manager test description. | Rev. | General Integration | Tester | 07777123456 |
    Then the case event category should be "Incorrect Escalation"
    And the case event description should be "name: Rev general integration tester phone: 07777123456 Manager test description."
    And the user navigates to the page for escalations
    And navigates to the escalated page "View escalated general enquiry cases" 
    And the escalated user checks case is not present for "7"
    And the user logs out
    
  Scenario: Helpline Operator checks that the  case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 7"
    And the case state for "7" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Escalated Refusal
  Scenario: Escalation manager creates an escalated refusal case event on General Complaint - Escalated and checks that the case was not removed.
    Given the "General" user has logged in using "Chrome"
    And the user navigates to the page for escalations
    When navigates to the escalated page "View escalated general enquiry cases" 
    And navigates to the cases page for case "8"
    And the user creates a new event for
      | Escalated Refusal | Manager test description. | Sir | General Integration | Tester | 07777123456 |
    Then the case event category should be "Escalated Refusal"
    And the case event description should be "name: Sir general integration tester phone: 07777123456 Manager test description."
    And the user navigates to the page for escalations
    And navigates to the escalated page "View escalated general enquiry cases" 
    And the escalated user checks case is not present for "8"
    And the user logs out
    
  Scenario: Helpline Operator checks that the  case is Inactionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 8"
    And the case state for "8" should be "INACTIONABLE"
    And the user logs out
    