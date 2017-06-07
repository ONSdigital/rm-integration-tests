/* Clean And Reset Collection Exercise DB */

TRUNCATE collectionexercise.sampleunit CASCADE;
TRUNCATE collectionexercise.sampleunitgroup CASCADE;

ALTER SEQUENCE collectionexercise.sampleunitgrouppkseq RESTART WITH 1;
ALTER SEQUENCE collectionexercise.sampleunitpkseq RESTART WITH 1;

UPDATE collectionexercise.collectionexercise SET statefk = 'INIT' WHERE surveyfk = 1;
UPDATE collectionexercise.collectionexercise SET statefk = 'INIT' WHERE surveyfk = 2;
UPDATE collectionexercise.collectionexercise SET statefk = 'INIT' WHERE surveyfk = 3;
