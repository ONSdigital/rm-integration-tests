/* Clean Action Exporter DB */

TRUNCATE actionexporter.actionrequest CASCADE;
TRUNCATE actionexporter.address CASCADE;
TRUNCATE actionexporter.contact CASCADE;
TRUNCATE actionexporter.filerowcount CASCADE;

ALTER SEQUENCE actionexporter.actionrequestpkseq RESTART WITH 1;
ALTER SEQUENCE actionexporter.contactpkseq RESTART WITH 1;

/* Delete potential data from previous test runs  */

DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'ICL1_2003';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'ICL2W_2003';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'ICL1_2703';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'ICLAD_2003';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'IRL1_0504';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'IRL2W_0504';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'IRLAD_0504';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = '2RL1_1804';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = '2RL2W_1804';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = '2RLAD_1804';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = '3RL1_2604';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = '3RL2W_2604';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = '3RLAD_2604';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'H1S_2003';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'H2S_2003';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'H1_2003';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'H2_2003';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'H1_2604Q4';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = '2RL1_1804';
DELETE FROM actionexporter.templatemapping WHERE actiontypenamepk = 'H1S_OR';

DELETE FROM actionexporter.template WHERE templatenamepk = 'action_exporter_template_test';
