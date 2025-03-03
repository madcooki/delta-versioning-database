-- Current State: Extract the latest version of each entity
SELECT * FROM Users;
SELECT * FROM Projects;
SELECT * FROM Task_Statuses;
SELECT * FROM Tasks;
SELECT * FROM Task_Assignments;

-- Current State: Extract the latest version of each active entity
SELECT Users.* FROM Users WHERE is_active = TRUE;
SELECT Projects.* FROM Projects WHERE is_active = TRUE;
SELECT Task_Statuses.* FROM Task_Statuses WHERE is_active = TRUE;
SELECT Tasks.* FROM Tasks WHERE is_active = TRUE;
SELECT Task_Assignments.* FROM Task_Assignments WHERE is_active = TRUE;

-- Current State: Extract the latest version of each ARCHIVED entity
SELECT Users.* FROM Users WHERE is_active = FALSE;
SELECT Projects.* FROM Projects WHERE is_active = FALSE;
SELECT Task_Statuses.* FROM Task_Statuses WHERE is_active = FALSE;
SELECT Tasks.* FROM Tasks WHERE is_active = FALSE;
SELECT Task_Assignments.* FROM Task_Assignments WHERE is_active = FALSE;