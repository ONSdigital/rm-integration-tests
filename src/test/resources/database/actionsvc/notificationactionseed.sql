SET SCHEMA 'action';

INSERT INTO action.actionrule (actionrulepk, actionplanfk, actiontypefk, name, description, daysoffset, priority)
VALUES (1, 1, 1, 'BSNOT+0', 'Enrolment Invitation Letter(+0 days)', 0, 3);