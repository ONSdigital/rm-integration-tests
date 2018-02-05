/* Clean And Reset Collection Exercise DB */

TRUNCATE collectionexercise.sampleunit CASCADE;
TRUNCATE collectionexercise.sampleunitgroup CASCADE;
TRUNCATE collectionexercise.samplelink CASCADE;

ALTER SEQUENCE collectionexercise.sampleunitgrouppkseq RESTART WITH 1;
ALTER SEQUENCE collectionexercise.sampleunitpkseq RESTART WITH 1;
ALTER SEQUENCE collectionexercise.samplelinkpkseq RESTART WITH 1;

UPDATE collectionexercise.collectionexercise SET statefk = 'INIT';
