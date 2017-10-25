/* Clean Notify Gateway DB */

TRUNCATE notifygatewaysvc.message CASCADE;

ALTER SEQUENCE notifygatewaysvc.messageseq RESTART WITH 1;
