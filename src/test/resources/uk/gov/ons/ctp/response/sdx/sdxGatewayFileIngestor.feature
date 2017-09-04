# Author: Gareth Turner 06/02/2017 Edited by Kieran Wardle 23/02/2017
# Keywords Summary : This feature file contains the scenario tests for the sdxgateway - receipt - details are in the swagger spec
#
# Feature: List of survey data exchange scenarios: Add a valid csv in stfp location for SDX Gateway
#
# Feature Tags: @sdxGatewayFileIngestor
#								@sdxGateway
#
# Scenario Tags: @paperQuestionnaireReceipts
#
@sdxGatewayOld @sdxGatewayFileIngestor
Feature: validate sdx paper response ingestor

	@paperQuestionnaireReceipts
	Scenario: Add a valid txt file in stfp location for SDX Gateway
		When I create a file in "/var/sdxgateway-sftp/" named "Receipttest.txt" containing
			| 25/12/2016,1000000000000011\n |
			| 25/12/2016,1000000000000012\n |
			| 25/12/2016,1000000000000013 |
		And after a delay of 90 seconds
		Then the file "Receipttest.txt" in "/var/sdxgateway-sftp/" will no longer exist
		And the txt file will be renamed to "Receipttest.txt.processed" in "/var/sdxgateway-sftp/" to indicate it has been processed
