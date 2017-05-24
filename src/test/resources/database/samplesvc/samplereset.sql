/* Clean Sample DB */

TRUNCATE sample.samplesummary CASCADE;
TRUNCATE sample.sampleunit CASCADE;
TRUNCATE sample.collectionexercisejob CASCADE;

ALTER SEQUENCE sample.samplesummaryseq RESTART WITH 1;
ALTER SEQUENCE sample.sampleunitseq RESTART WITH 1;
ALTER SEQUENCE sample.collectionexercisejobseq RESTART WITH 1;
