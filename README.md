# Integration Tests

This project is a Cucumber suite that consists of a set of tests for the Response Management service. It is not intended as a full acceptance suite. These are run on the Jenkins overnight CI server in the order they appear in this document. The Jenkins tests are set up with names matching the scripts. On the CI Jenkins server the first test (CTP_Cucumber_Initial_Response_Online) is set to run at 23:00 Monday - Friday. All the other tests are triggered by the completion of the previous test. Jenkins is configured to process the results of the tests using a cucumber plugin to Jenkins. This provides a visual presentation of the result and gives a breakdown of the tests down to step method usage. Currently on the results are posted to Slack, channel #tests.

These tests are based on the requirements as detailed in:

* End to End: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?pageId=3690875
* Helpline UI: https://collaborate2.ons.gov.uk/confluence/display/SDC/Helpline+Interface+Test+Scenarios
* Sample Scenarios: https://collaborate2.ons.gov.uk/confluence/pages/viewpage.action?spaceKey=SDC&title=Test+Scenarios
* Swagger Specs:
  * https://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
  * https://github.com/ONSdigital/response-management-service/blob/master/actionsvc-api/swagger.yml
  * https://github.com/ONSdigital/response-management-service/blob/master/actionexportersvc/swagger.yml
  * https://github.com/ONSdigital/iac-service/blob/master/iacsvc-api/swagger.yml
  * https://github.com/ONSdigital/rm-sdx-gateway/blob/master/swagger.yml

The environment parameter is used to provide configuration for a specific environment. The 'ci' environment is used only by the Jenkins build and should not be edited. The 'local' environment is used when running the tests against the local machine assuming it is running the required services. The 'test' environment is the main non Jenkins environment in this property file the IP address of any machine can be specified. This way the tests can be run against any installation so long as there is IP access across the network e.g. the CI server or another installation.

Before the integration tests are run it is assumed that a base environment has been deployed and the addresses have been loaded into the casesvc.

# CTP_Cucumber_Initial_Response_Online

This tests the end to end happy path for an online response with an English and Welsh version of the test. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Initial_Response_Online {environment}

Features:

```
onlineResponse.feature
welshOnlineResponse.feature
```

Tag: `@onlineResponse`

# CTP_Cucumber_Initial_Response_Paper

This test is is similar to the online test but is for a paper response. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Initial_Response_Paper {environment}

Features:

```
paperResponse.feature
welshPaperResponse.feature
```

Tag: `@paperResponse`

# CTP_Cucumber_Additional_Response_Individual_Online

Again this follows the similar pattern but instead of the household responding online an individual requests online access and responds online. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Additional_Individual_Online {environment}

Features:

```
indOnlineResponse.feature
```

Tag: `@individualOnlineResponse`

# CTP_Cucumber_Additional_Response_Individual_Paper

Following the same pattern as the individual online but in this test the treatment is by paper. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Additional_Individual_Paper {environment}

Features:

```
indPaperResponse.feature
```

Tag: `@individualPaperResponse`

# CTP_Cucumber_Additional_Response_Replacement_Online

This tests the household and the individual where they request a replacement and respond online. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Additional_Replacement_Online {environment}

Features:

```
replaceOnlineResponse.feature
```

Tag: `@replaceOnlineResponse`

# CTP_Cucumber_Additional_Response_Replacement_Paper

Similarly this tests the household and individual where they request a replacement and respond by paper. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Additional_Replacement_Paper {environment}

Features:

```
replacePaperResponse.feature
```

Tag: `@replacePaperResponse`

# CTP_Cucumber_No_Response_Helpline

This tests when the helpline or field visit receives a call leading to no expected response. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_No_Response_Helpline {environment}

Features:

```
helpline.feature
field.feature
```

Tag: `@refusal`

# CTP_Cucumber_Follow_UP

This tests the different follow up action plans to cases, field visits, paper forms and reminder letters. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Follow_Up {environment}

Features:

```
fieldVisit.feature
paperForms.feature
reminderLetters.feature
```

Tag: `@followUp`

# CTP_Cucumber_Other_Fulfilment_Translations

This tests when the helpline receives a call requesting a translation booklet. All 14 translation options are tested. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Other_Fulfilment_Booklets {environment}

Features:

```
translationBooklets.feature
```

Tag: `@translationBooklets`

# CTP_Cucumber_End_To_End_Test_Suite

This is not a Jenkins test it is a merely a script which can run all the end to end tests above. It can be run as /testScripts/CTP_Cucumber_End_To_End_Test_Suite {environment}

# CTP_Cucumber_Casesvc_Endpoints

This tests the casesvc end points against the swagger spec. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Casesvc_Endpoints {environment}

Features:

```
actionplanmappings.feature
addresses.feature
casegroup.feature
cases.feature
casetypes.feature
categories.feature
reportMIReportContentEndpoint.feature
reportMIReportListEndpoint.feature
reportMIReportTypeListEndpoint.feature
samples.feature
```

Tag: `@casesvc`

# CTP_Cucumber_Actionsvc_Endpoints

This tests the actionsvc end points against the swagger spec. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Actionsvc_Endpoints {environment}

Features:

```
action.feature
actionplan.feature
actionplanjob.feature
```

Tag: `@actionsvc`

# CTP_Cucumber_ActionExporter_Endpoints

This tests the actionexportersvc end points against the swagger spec. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_ActionExporter_Endpoints {environment}

Features:

```
actionExporterEndpoint.feature
reportMIReportContentEndpointAE.feature
reportMIReportListEndpointAE.feature
reportMIReportTypeListEndpointAE.feature
```

Tag: `@actionexporter`

# CTP_Cucumber_Iacsvc_Endpoints

This tests the iacsvc end points against the swagger spec. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Iacsvc_Endpoints {environment}

Features:

```
iacsvc.feature
```

Tag: `@iacsvc`

# CTP_Cucumber_SDX_Gateway_Endpoints

This tests the SDX gateway end points against the swagger spec. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_SDX_Gateway_Endpoints {environment}

Features:

```
sdxGateway.feature
sdxGatewayFileIngestor.feature
```

Tag: `@sdxGateway`

# CTP_Cucumber_Endpoint_Test_Suite

This is not a Jenkins test it is a merely a script which can run all the endpoint tests above. It can be run as /testScripts/CTP_Cucumber_Endpoint_Test_Suite {environment}

# CTP_Cucumber_Helpline_UI

This tests the helpline UI. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Helpline_UI {environment}

Features:

```
caseEvent.feature
eventHistory.feature
fieldActionEscalations.feature
generalActionEscalations.feature
postCodeSearchAddressSelection.feature
reviewCaseInformation.feature
reviewCasesAndCaseGroups.feature
userAuthentication.feature
```

Tag: `@helplineUI`

# CTP_Cucumber_Sample_Scenarios

This tests the different sample paths confirming the data integrity. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Sample_Scenarios {environment}

Features:

```
initialSetUpC1SO331D4E.feature
initialSetUpC1SO331D4W.feature
initialSetUpC2EP331E.feature
initialSetUpC2EP331W.feature
initialSetUpHOTEL.feature
initialSetUpSHOUSING.feature
initialSetUpUNIVERSITY.feature
replacementIacSMSNoRespC2S0331E.feature
replacementIacSMSNoRespSHOUSING.feature
replacementIacSMSNoRespUNIVERSITY.feature
replacementIacSMSNoRespWelshC1EO331D4W.feature
replacementIacSMSNoRespWelshC1SO331D10W.feature
requestingIndividualFormPaperEnglandC1SO331D10E.feature
requestingIndividualFormPaperEnglandC2EP331E.feature
requestingIndividualFormPaperWalesEnglish.feature
requestingIndividualFormPaperWalesWelsh.feature
requestingIndividualFormSMSC2EO331ADE.feature
requestingIndividualFormSMSSHOUSING.feature
requestingIndividualFormSMSWelshC2EP331W.feature
requestingPaperFormEnglandNoResponse.feature
requestingPaperFormWalesInEnglish.feature
requestingPaperFormWalesInWelsh.feature
```

Tag: `@sampleScenarios`

# CTP_Cucumber_Report_MI

This tests the MI Report part of the UI. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Report_MI {environment}

Features:

```
correctReportContents.feature
listReportsForReportType.feature
ReportMITypeValidation.feature
```

Tag: `@reportMI`

# CTP_Cucumber_Helpline_UI_Test_Suite

This is not a Jenkins test it is a merely a script which can run all the UI tests above. It can be run as /testScripts/CTP_Cucumber_Helpline_UI_Test_Suite {environment}


# CTP_Cucumber_Other_Tests

This tests the other miscellaneous test which do not fit in above, e.g. Defect tests. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Other_Tests {environment}

Features:

```
createCEsamples.feature
CTPA1075IACReuseAfterRefusal.feature
CTPA909Inactionable.feature
CTPA979CancelPending.feature
```

Tag: `@other`

# CTP_Cucumber_Jmeter_Stability

This tests the system stability using Jmeter and cucumber by stimulating online and paper responses while the UI creates case events. This means clearing the database of previous test runs and is run on the Jenkins server or by the script /testScripts/CTP_Cucumber_Jmeter_Stability {environment}

Features:

```
stabilityLoadTest.feature
```

Tag: `@jmeterStability`

# CTP_Cucumber_Other_Tests_Test_Suite

This is not a Jenkins test it is a merely a script which can run all the other tests above. It can be run as /testScripts/CTP_Cucumber_Other_Tests_Test_Suite {environment}

# Other Tests

Currently there is also a test for the Respondent Home UI which is not run as part of any test suites. This is because it is not part of the usual environment setup. Should these tests want to be run they can be run using:

mvn clean install -Dcucumber.options="--tags @respondentHomeUiIacTest"

Note : Currently the IP address for the respondent home is hard coded for this test. This will need to moved to the properties files.

# Running Tests Using Command Line

All test be run from the command line:

mvn clean install -Dcucumber.options="--tags @{tagName}" -Dcuc.env={environment}

Any valid tag can be run from this command line not just the feature tag name.

# World

Currently, we have a BaseSteps class which statically loads some properties at startup. The idiomatic Cucumber standard is to have an object called a 'World' which maintains such state. Such a class has been created for this purpose, called, naturally, World. Further, we are leveraging cucumber-picocontainer to inject instances of this World class into steps. Why Picocontainer? Cucumber-JVM supports a number of dependency injection containers (Spring, Guice, Picocontainer, something called 'Weld') but Picocontainer support is the most mature, and the lightest touch in terms of transitive dependencies.

Ultimately, the intent is that anything that is not a Cucumber step definition will not live in any steps classes. This may seem a little unusual to a Java developer but a quirk of Cucumber-JVM is that you cannot extend any class which has @Before or @After hooks, so should we wish to provide such hooks, a BaseSteps class is not the way to achieve that. (Note that those annotations are from the package cucumber.api.java not org.junit).

# Debugging Cucumber tests in IntelliJ

1. Open the feature file of the scenario that you want to debug and locate the scenario
2. Right click on the scenario and select "Debug: 'Scenario: Test...'"
3. Wait for it to fail
4. Go to Run -> Edit Configurations... and select the scenario you used previously
5. Set VM options: -Dcuc.env=local
6. Set Working directory: <full path to rm-integration-tests directory>
7. Add breakpoints to the step file(s) as required
8. Running/debugging this configuration should now give the same result as running from the command line
