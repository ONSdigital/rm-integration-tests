#Author: Kieran Wardle 15/12/16
#Keywords Summary : This feature tests that the Field Escalated Case lists correctly upddate upon Operator actions.
#										https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?spaceKey=SDC&title=Helpline+Interface+Test+Scenarios
#
#Feature: Clean DB to pre test condition
#															Create Sample
#															IAC Generation
#                             UI created case event and test event and case states using Chrome
#                             UI created case escalated event and test event and case states using Chrome
#															UI checked that the operator case lists were updated correctly
#
# Feature Tag:@helplineUI  @fieldActionEscalation
#
# Scenario Tags: @complaintCreateEventExistCheck
#                

#Sample Feature Definition Template
@helplineUI @fieldActionEscalation
Feature: Test user can view and perform actions upon escalation action.

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
		Then I make the PUT call to the caseservice sample endpoint for sample id "2" for area "REGION" code "E12000005"
		And the response status should be 200
		And the response should contain the field "name" with value "C2EO331BIE"
		And the response should contain the field "survey" with value "2017 TEST"
		Then check "casesvc.case" records in DB equal 20 for "state = 'SAMPLED_INIT'"
		And check "casesvc.caseevent" records in DB equal 20

	@generateIAC
	Scenario: Each case has a unique IAC assigned to it
			and in Actionable state
			and action service has been notified case has been created
		Given after a delay of 120 seconds
		When check "casesvc.case" distinct records in DB equal 20 for "iac" where "state = 'ACTIONABLE'"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 17"
		And check "casesvc.case" records in DB equal 10 for "state = 'ACTIONABLE' AND casetypeid = 18"
		And check "action.case" records in DB equal 1 for "caseid = 20"
	
	# Create general complaint Escalated
	@complaintCreateEvent
  Scenario: Escalation manager creates a Pending case event on Complaint - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 1 											 		|
			| description 				| Created by cucumber test		|
			| category 						| Field_Complaint_Escalated |
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
			| category 						| Field_Complaint_Escalated |
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
			| category 						| Field_Complaint_Escalated |
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
			| category 						| Field_Complaint_Escalated |
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
    
  Scenario: Escalation manager creates a Pending case event on Emergency - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 5 											 		|
			| description 				| Created by cucumber test		|
			| category 						| Field_Emergency_Escalated |
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
    
  Scenario: Escalation manager creates a Pending case event on Emergency - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 6											 		|
			| description 				| Created by cucumber test		|
			| category 						| Field_Emergency_Escalated |
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
    
  Scenario: Escalation manager creates a Pending case event on Emergency - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 7 										 		|
			| description 				| Created by cucumber test		|
			| category 						| Field_Emergency_Escalated |
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
    
  Scenario: Escalation manager creates a Pending case event on Emergency - Escalated
    When I make the POST call to the caseservice cases events
			| caseid							| 8											 		|
			| description 				| Created by cucumber test		|
			| category 						| Field_Emergency_Escalated |
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
  Scenario: Escalation manager creates a close escalation case event on Field Complaint - Escalated and checks that the case was removed.
    Given the "Field" user has logged in using "Test"
    And navigates to the escalated page "View escalated field complaint cases" 
    And selects case page for "1"
    And the user creates a new event for
      | Close Escalation | Manager test description. | Mr | Integration | Tester | 07777123456 |
    Then the case event category should be "Close Escalation"
    And the case event description should be "name: Mr integration tester phone: 07777123456 Manager test description."
    And navigates to the escalated page "View escalated field complaint cases" 
    And the case page for "1" is no longer present
    And the user logs out
    
  Scenario: Helpline Operator checks that the case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 1"
    And the case state for "1" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Pending Escalation
  Scenario: Escalation manager creates a pending escalation case event on Field Complaint - Escalated and checks that the case was not removed.
    Given the "Field" user has logged in using "Chrome"
    And navigates to the escalated page "View escalated field complaint cases" 
    And selects case page for "2"
    And the user creates a new event for
      | Pending | Manager test description. | Mrs | Integration | Tester | 07777123456 |
    Then the case event category should be "Pending"
    And the case event description should be "name: Mrs integration tester phone: 07777123456 Manager test description."
    And navigates to the escalated page "View escalated field complaint cases"
    And the case page for "2" is present
    And the user logs out
    
     Scenario: Helpline Operator checks that the case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 2"
    And the case state for "2" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Incorrect Escalation
  Scenario: Escalation manager creates a incorrect escalation case event on Field Complaint - Escalated and checks that the case was removed.
    Given the "Field" user has logged in using "Chrome"
    And navigates to the escalated page "View escalated field complaint cases" 
    And selects case page for "3"
    And the user creates a new event for
      | Incorrect Escalation | Manager test description. | Miss | Integration | Tester | 07777123456 |
    Then the case event category should be "Incorrect Escalation"
    And the case event description should be "name: Miss integration tester phone: 07777123456 Manager test description."
    And navigates to the escalated page "View escalated field complaint cases" 
    And the case page for "3" is no longer present
    And the user logs out
    
  Scenario: Helpline Operator checks that the case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 3"
    And the case state for "3" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Escalated Refusal
  Scenario: Escalation manager creates a escalated refusal case event on Field Complaint - Escalated and checks that the case was not removed.
    Given the "Field" user has logged in using "Chrome"
    And navigates to the escalated page "View escalated field complaint cases" 
    And selects case page for "4"
    And the user creates a new event for
      | Escalated Refusal | Manager test description. | Ms | Integration | Tester | 07777123456 |
    Then the case event category should be "Escalated Refusal"
    And the case event description should be "name: Ms integration tester phone: 07777123456 Manager test description."
    And navigates to the escalated page "View escalated field complaint cases" 
    And the case page for "4" is no longer present
    And the user logs out
    
  Scenario: Helpline Operator checks that the case is Inactionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 4"
    And the case state for "4" should be "INACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Close Escalation
  Scenario: Escalation manager creates a close escalation case event on Field Complaint - Escalated and checks that the case was removed.
    Given the "Field" user has logged in using "Chrome"
    And navigates to the escalated page "View escalated field emergency cases" 
    And selects case page for "5"
    And the user creates a new event for
      | Close Escalation | Manager test description. | Dr | Integration | Tester | 07777123456 |
    Then the case event category should be "Close Escalation"
    And the case event description should be "name: Dr integration tester phone: 07777123456 Manager test description."
    And navigates to the escalated page "View escalated field emergency cases" 
    And the case page for "5" is no longer present
    And the user logs out
    
  Scenario: Helpline Operator checks that the case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 5"
    And the case state for "5" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Pending Escalation
  Scenario: Escalation manager creates a pending escalation case event on Field Complaint - Escalated and checks that the case was not removed.
    Given the "Field" user has logged in using "Chrome"
    And navigates to the escalated page "View escalated field emergency cases" 
    And selects case page for "6"
    And the user creates a new event for
      | Pending | Manager test description. | Prof. | Integration | Tester | 07777123456 |
    Then the case event category should be "Pending"
    And the case event description should be "name: Prof integration tester phone: 07777123456 Manager test description."
    And navigates to the escalated page "View escalated field emergency cases"
    And the case page for "6" is present
    And the user logs out
    
  Scenario: Helpline Operator checks that the case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 6"
    And the case state for "6" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Incorrect Escalation
  Scenario: Escalation manager creates a incorrect escalation case event on Field Complaint - Escalated and checks that the case was removed.
    Given the "Field" user has logged in using "Chrome"
    And navigates to the escalated page "View escalated field emergency cases" 
    And selects case page for "7"
    And the user creates a new event for
      | Incorrect Escalation | Manager test description. | Rev. | Integration | Tester | 07777123456 |
    Then the case event category should be "Incorrect Escalation"
    And the case event description should be "name: Rev integration tester phone: 07777123456 Manager test description."
    And navigates to the escalated page "View escalated field emergency cases" 
    And the case page for "7" is no longer present
    And the user logs out
    
  Scenario: Helpline Operator checks that the case is still Actionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 7"
    And the case state for "7" should be "ACTIONABLE"
    And the user logs out
    
    
  # Complaint Escalated - Escalated Refusal
  Scenario: Escalation manager creates a escalated refusal case event on Field Complaint - Escalated and checks that the case was not removed.
    Given the "Field" user has logged in using "Chrome"
    And navigates to the escalated page "View escalated field emergency cases" 
    And selects case page for "8"
    And the user creates a new event for
      | Escalated Refusal | Manager test description. | Sir | Integration | Tester | 07777123456 |
    Then the case event category should be "Escalated Refusal"
    And the case event description should be "name: Sir integration tester phone: 07777123456 Manager test description."
    And navigates to the escalated page "View escalated field emergency cases" 
    And the case page for "8" is no longer present
    And the user logs out
    
  Scenario: Helpline Operator checks that the case is Inactionable.
  	Given the "Test" user has logged in using "Chrome"
    When the user gets the addresses for postcode "TF107BH"
    And selects case for address "BEDSIT 8"
    And the case state for "8" should be "INACTIONABLE"
    And the user logs out