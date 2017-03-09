# Author: Stephen Goddard 27/01/2017
#
# Keywords Summary : Run Jmeter to run through random sequence of events to prove system stability
#
# Feature: List of scenarios: Setup environment
#															Run random sequence of events
#
# Feature Tag: @jmeterStability
#
# Scenario Tags: @jmeterSetup
#                @jmeterTestRun

@jmeterStability
Feature: Run Jmeter Tests

	@jmeterSetup
	Scenario: Setup environment so it is clean and the samples have been created
		Given I run test setup using jmeter with 1 threads and looping 1
		When there are no reported errors in "./jmeter.log"
		Then after a delay of 180 seconds
		
	@jmeterTestRun
	Scenario: Run stability test plan for a duration in seconds and delays in milliseconds
		Given I run stability plan using jmeter
			| Test   | Threads | Duration | start Caseref    | End Caseref      |Less CaseRef     | Greater Caseref  | AppendFile | Delay Min | Delay Max |
			| Online | 100     | 60       | 1000000000000001 | 1000000000002044 |1000000000000140 | 1000000000000181 |            |           |           |
			| Paper  | 2       | 60       | 1000000000000141 | 1000000000000180 |                 |                  | false			| 500       | 5000      |
			| Event  | 5       | 60       |                  |                  |                 |                  |            | 300       | 3000      |
		When there are no reported errors in "./jmeter.log"
		Then the average time per request is 5000 in "./jmeter.log"
		And the min time per request is 400 in "./jmeter.log"
		And the max time per request is 6100 in "./jmeter.log"
