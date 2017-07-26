/* Clean And Reset Collection Exercise DB */

TRUNCATE collectionexercise.sampleunit CASCADE;
TRUNCATE collectionexercise.sampleunitgroup CASCADE;

ALTER SEQUENCE collectionexercise.sampleunitgrouppkseq RESTART WITH 1;
ALTER SEQUENCE collectionexercise.sampleunitpkseq RESTART WITH 1;

/* Add Census and Social seed data for tests */

INSERT INTO collectionexercise.survey (id, surveyPK, surveyref)
SELECT 'cb0711c3-0ac8-41d3-ae0e-567e5ea1ef77', 2, 'CENSUS'
WHERE NOT EXISTS (SELECT id FROM collectionexercise.survey WHERE id = 'cb0711c3-0ac8-41d3-ae0e-567e5ea1ef77');

INSERT INTO collectionexercise.survey (id, surveyPK, surveyref)
SELECT 'cb0711c3-0ac8-41d3-ae0e-567e5ea1ef67', 3, 'SOCIAL'
WHERE NOT EXISTS (SELECT id FROM collectionexercise.survey WHERE id = 'cb0711c3-0ac8-41d3-ae0e-567e5ea1ef67');

INSERT INTO collectionexercise.collectionexercise(id,surveyFK,exercisePK,name,scheduledstartdatetime,scheduledexecutiondatetime,scheduledreturndatetime,scheduledenddatetime,periodstartdatetime,periodenddatetime,stateFK,exerciseref)
SELECT '14fb3e68-4dca-46db-bf49-04b84e07e87c',2,2,'CENSUS','2001-12-31 12:00:00',NULL,'2017-10-06','2099-01-01','2017-09-08','2017-09-08','INIT','CENSUS_201712'
WHERE NOT EXISTS (SELECT id FROM collectionexercise.collectionexercise WHERE id = '14fb3e68-4dca-46db-bf49-04b84e07e87c');

INSERT INTO collectionexercise.collectionexercise(id,surveyFK,exercisePK,name,scheduledstartdatetime,scheduledexecutiondatetime,scheduledreturndatetime,scheduledenddatetime,periodstartdatetime,periodenddatetime,stateFK,exerciseref)
SELECT '14fb3e68-4dca-46db-bf49-04b84e07e97c',3,3,'SOCIAL','2001-12-31 12:00:00',NULL,'2017-10-06','2099-01-01','2017-09-08','2017-09-08','INIT','SOCIAL_201712'
WHERE NOT EXISTS (SELECT id FROM collectionexercise.collectionexercise WHERE id = '14fb3e68-4dca-46db-bf49-04b84e07e97c');

UPDATE collectionexercise.collectionexercise SET statefk = 'INIT' WHERE surveyfk = 1;
UPDATE collectionexercise.collectionexercise SET statefk = 'INIT' WHERE surveyfk = 2;
UPDATE collectionexercise.collectionexercise SET statefk = 'INIT' WHERE surveyfk = 3;