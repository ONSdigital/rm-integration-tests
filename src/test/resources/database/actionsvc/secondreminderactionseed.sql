SET SCHEMA 'action';

INSERT INTO action.actionrule (actionrulepk, actionplanfk, actiontypefk, name, description, daysoffset, priority)
VALUES (3, 1, 2, 'BSREM+45', 'Enrolment Reminder Letter(+45 days)', 45, 3);

INSERT INTO action.actionrule (actionrulepk, actionplanfk, actiontypefk, name, description, daysoffset, priority)
VALUES (5, 2, 3, 'BSSNE+45', 'Survey Reminder Notification(+45 days)', 45, 3);