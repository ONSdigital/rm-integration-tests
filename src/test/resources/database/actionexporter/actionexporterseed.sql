SET SCHEMA 'actionexporter';

INSERT INTO actionexporter.contact (contactpk, forename, surname, phonenumber, emailaddress, title)
VALUES (1, 'TESTNAME', 'TESTSUR', 08008432345, 'EMAIL@OK.COM', 'MR');

INSERT INTO actionexporter.address (sampleunitrefpk, addresstype, estabtype, category, organisation_name, address_line1, address_line2, locality, town_name, postcode, lad, latitude, longitude)
VALUES (1, 'ADDRES', 'ESTAB', 'CATEGORY', 'ORGANISATION', 'ADDRESS_LINE_1', 'ADDRESS_LINE_2', 'LOCALITY', 'TOWN_NAME', 'POSTCODE', 'LAD', 0.0, 0.0);

INSERT INTO actionexporter.actionrequest (actionrequestpk, actionid, responserequired, actionplanname, actiontypename, questionset, contactfk, sampleunitreffk, caseid, priority, caseref, iac, datestored, datesent)
VALUES (1, '7bc5d41b-0549-40b3-ba76-42f6d4cf3fd1', true, 'BRES', 'BRESEL', 'QUESTONSET', 1, 1, '7bc5d41b-0549-40b3-ba76-42f6d4cf3fd1', 'HIGHEST', 'CASEREF', 'IAC', '2017-04-18 00:00:00+00', '2017-04-18 00:00:00+00');