/* Clean Action Exporter DB */

TRUNCATE actionexporter.actionrequest CASCADE;
TRUNCATE actionexporter.address CASCADE;
TRUNCATE actionexporter.contact CASCADE;
TRUNCATE actionexporter.filerowcount CASCADE;

ALTER SEQUENCE actionexporter.actionrequestpkseq RESTART WITH 1;
ALTER SEQUENCE actionexporter.contactpkseq RESTART WITH 1;

/* Delete potential data from previous test runs  */

DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'TEST';

DELETE FROM actionexporter.template WHERE templatenamepk = 'action_exporter_template_test';
