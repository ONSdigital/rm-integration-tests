/* Clean Collection Exercise DB */

TRUNCATE collectionexercise.sampleunit CASCADE;
TRUNCATE collectionexercise.sampleunitgroup CASCADE;
TRUNCATE collectionexercise.collectionexercise CASCADE;

ALTER SEQUENCE collectionexercise.exercisepkseq RESTART WITH 1;
ALTER SEQUENCE collectionexercise.sampleunitgrouppkseq RESTART WITH 1;
ALTER SEQUENCE collectionexercise.sampleunitpkseq RESTART WITH 1;
