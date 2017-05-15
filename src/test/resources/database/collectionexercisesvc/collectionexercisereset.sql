/* Clean Collection Exercise DB */

TRUNCATE collectionexercise.sampleunit CASCADE;
TRUNCATE collectionexercise.sampleunitgroup CASCADE;
TRUNCATE collectionexercise.collectionexercise CASCADE;
TRUNCATE collectionexercise.survey CASCADE;

ALTER SEQUENCE collectionexercise.exerciseidseq RESTART WITH 1;
ALTER SEQUENCE collectionexercise.sampleunitgroupidseq RESTART WITH 1;
