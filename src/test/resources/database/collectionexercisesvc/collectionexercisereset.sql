/* Clean And Reset Collection Exercise DB */

TRUNCATE collectionexercise.sampleunit CASCADE;
TRUNCATE collectionexercise.sampleunitgroup CASCADE;

ALTER SEQUENCE collectionexercise.sampleunitgrouppkseq RESTART WITH 1;
ALTER SEQUENCE collectionexercise.sampleunitpkseq RESTART WITH 1;

/* Add Census and Social seed data for tests */

INSERT INTO collectionexercise.collectionexercise(id,survey_uuid,exercisePK,name,scheduledstartdatetime,scheduledexecutiondatetime,scheduledreturndatetime,scheduledenddatetime,periodstartdatetime,periodenddatetime,stateFK,exerciseref)
SELECT '14fb3e68-4dca-46db-bf49-04b84e07e87c','75b19ea0-69a4-4c58-8d7f-4458c8f43f5c',2,'CENSUS','2001-12-31 12:00:00',NULL,'2017-10-06','2099-01-01','2017-09-08','2017-09-08','INIT','CENSUS_201712'
WHERE NOT EXISTS (SELECT id FROM collectionexercise.collectionexercise WHERE id = '14fb3e68-4dca-46db-bf49-04b84e07e87c');

INSERT INTO collectionexercise.collectionexercise(id,survey_uuid,exercisePK,name,scheduledstartdatetime,scheduledexecutiondatetime,scheduledreturndatetime,scheduledenddatetime,periodstartdatetime,periodenddatetime,stateFK,exerciseref)
SELECT '14fb3e68-4dca-46db-bf49-04b84e07e97c','57a43c94-9f81-4f33-bad8-f94800a66503',3,'SOCIAL','2001-12-31 12:00:00',NULL,'2017-10-06','2099-01-01','2017-09-08','2017-09-08','INIT','SOCIAL_201712'
WHERE NOT EXISTS (SELECT id FROM collectionexercise.collectionexercise WHERE id = '14fb3e68-4dca-46db-bf49-04b84e07e97c');

UPDATE collectionexercise.collectionexercise SET statefk = 'INIT';
