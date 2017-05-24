/* Clean Case DB */

TRUNCATE casesvc.case CASCADE;
TRUNCATE casesvc.caseevent CASCADE;
TRUNCATE casesvc.casegroup CASCADE;
TRUNCATE casesvc.response CASCADE;

ALTER SEQUENCE casesvc.caseeventidseq RESTART WITH 1;
ALTER SEQUENCE casesvc.casegroupidseq RESTART WITH 1;
ALTER SEQUENCE casesvc.caseidseq RESTART WITH 1;
ALTER SEQUENCE casesvc.caserefseq RESTART WITH 1000000000000001;
ALTER SEQUENCE casesvc.responseidseq RESTART WITH 1;
