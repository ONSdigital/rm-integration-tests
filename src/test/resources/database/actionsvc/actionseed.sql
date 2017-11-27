SET SCHEMA 'action';

INSERT INTO action.actionrule (actionrulepk, actionplanfk, actiontypefk, name, description, daysoffset, priority)
VALUES (1, 1, 1, 'BSNOT+0', 'Enrolment Invitation Letter(+0 days)', 0, 3);

INSERT INTO action.actionrule (actionrulepk, actionplanfk, actiontypefk, name, description, daysoffset, priority)
VALUES (2, 1, 2, 'BSREM+45', 'Enrolment Reminder Letter(+45 days)', 45, 3);

INSERT INTO action.actionrule (actionrulepk, actionplanfk, actiontypefk, name, description, daysoffset, priority)
VALUES (4, 2, 3, 'BSSNE+45', 'Survey Reminder Notification(+45 days)', 45, 3);
