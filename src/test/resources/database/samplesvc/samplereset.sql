/* Clean Sample DB */

TRUNCATE sample.samplesummary CASCADE;
TRUNCATE sample.sampleunit CASCADE;
TRUNCATE sample.collectionexercisejob CASCADE;

ALTER SEQUENCE sample.samplesummaryseq RESTART WITH 1;
ALTER SEQUENCE sample.sampleunitidseq RESTART WITH 1;
ALTER SEQUENCE sample.collectionexercisejobidseq RESTART WITH 1;
