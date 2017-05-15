/* Seed Collection Exercise DB to known state */

INSERT INTO collectionexercise.survey (surveyid, surveyref) VALUES (1, 'BRES');
INSERT INTO collectionexercise.survey (surveyid, surveyref) VALUES (2, 'CENSUS');
INSERT INTO collectionexercise.survey (surveyid, surveyref) VALUES (3, 'SOCIAL');

INSERT INTO collectionexercise.collectionexercise (exerciseid, surveyid, scheduledstartdatetime, scheduledexecutiondatetime, scheduledreturndatetime, scheduledenddatetime, scheduledsurveydate, state) VALUES (1, 1, '2017-08-31 23:00:00', '2017-08-31 23:00:00', '2017-08-31 23:00:00', '2017-08-31 23:00:00', '2017-08-31 23:00:00', 'INIT');
INSERT INTO collectionexercise.collectionexercise (exerciseid, surveyid, scheduledstartdatetime, scheduledexecutiondatetime, scheduledreturndatetime, scheduledenddatetime, scheduledsurveydate, state) VALUES (2, 2, '2001-12-31 12:00:00', '2001-12-31 12:00:00', '2001-12-31 12:00:00', '2001-12-31 12:00:00', '2001-12-31 12:00:00', 'INIT');
INSERT INTO collectionexercise.collectionexercise (exerciseid, surveyid, scheduledstartdatetime, scheduledexecutiondatetime, scheduledreturndatetime, scheduledenddatetime, scheduledsurveydate, state) VALUES (3, 3, '2001-12-31 12:00:00', '2001-12-31 12:00:00', '2001-12-31 12:00:00', '2001-12-31 12:00:00', '2001-12-31 12:00:00', 'INIT');