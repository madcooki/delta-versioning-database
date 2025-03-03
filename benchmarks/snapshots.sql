-- Point-in-Time Snapshot: Show what the dataset looked like at a specific version

-- Set before running queries
SET @version = 8;

-- Users
SELECT
	COUNT(*) - 1 as total_revisions,
    IFNULL((SELECT operation_type = 'ARCHIVE' AS archived FROM Users AS U JOIN Users_History ON record_id = U.user_id WHERE (operation_type = 'ARCHIVE' OR operation_type = 'UNARCHIVE') AND U.user_id = Users.user_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), Users.is_active) as is_active,
	Users.user_id,
    COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Users_History WHERE record_id = Users.user_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.name')), Users.name) as name,
	COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Users_History WHERE record_id = Users.user_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.email')), Users.email) as email
FROM Users
JOIN Users_History ON Users_History.record_id = Users.user_id
WHERE version_id <= @version
GROUP BY Users.user_id;

-- Projects
SELECT
	COUNT(*) - 1 as total_revisions,
    IFNULL((SELECT operation_type = 'ARCHIVE' AS archived FROM Projects AS P JOIN Projects_History ON record_id = P.project_id WHERE (operation_type = 'ARCHIVE' OR operation_type = 'UNARCHIVE') AND P.project_id = Projects.project_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), Projects.is_active) as is_active,
	Projects.project_id,
    COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Projects_History WHERE record_id = Projects.project_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.name')), Projects.name) as name,
    COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Projects_History WHERE record_id = Projects.project_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.description')), Projects.description) as description
FROM Projects
JOIN Projects_History ON Projects_History.record_id = Projects.project_id
WHERE version_id <= @version
GROUP BY Projects.project_id;

-- Task_Statuses
SELECT
	COUNT(*) - 1 as total_revisions,
    IFNULL((SELECT operation_type = 'ARCHIVE' AS archived FROM Task_Statuses AS T JOIN Task_Statuses_History ON record_id = T.task_status_id WHERE (operation_type = 'ARCHIVE' OR operation_type = 'UNARCHIVE') AND T.task_status_id = Task_Statuses.task_status_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), Task_Statuses.is_active) as is_active,
	Task_Statuses.task_status_id,
    COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Task_Statuses_History WHERE record_id = Task_Statuses.task_status_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.status_name')), Task_Statuses.status_name) as status_name
FROM Task_Statuses
JOIN Task_Statuses_History ON Task_Statuses_History.record_id = Task_Statuses.task_status_id
WHERE version_id <= @version
GROUP BY Task_Statuses.task_status_id;

-- Tasks
SELECT
	COUNT(*) - 1 as total_revisions,
    IFNULL((SELECT operation_type = 'ARCHIVE' AS archived FROM Tasks AS T JOIN Tasks_History ON record_id = T.task_id WHERE (operation_type = 'ARCHIVE' OR operation_type = 'UNARCHIVE') AND T.task_id = Tasks.task_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), Tasks.is_active) as is_active,
	Tasks.task_id,
    COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Tasks_History WHERE record_id = Tasks.task_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.project_id')), Tasks.project_id) as project_id,
	COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Tasks_History WHERE record_id = Tasks.task_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.title')), Tasks.title) as title,
    COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Tasks_History WHERE record_id = Tasks.task_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.description')), Tasks.description) as description,
    COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Tasks_History WHERE record_id = Tasks.task_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.task_status_id')), Tasks.task_status_id) as task_status_id
FROM Tasks
JOIN Tasks_History ON Tasks_History.record_id = Tasks.task_id
WHERE version_id <= @version
GROUP BY Tasks.task_id;

-- Task_Assignments
SELECT
	COUNT(*) - 1 as total_revisions,
    IFNULL((SELECT operation_type = 'ARCHIVE' AS archived FROM Task_Assignments AS T JOIN Task_Assignments_History ON record_id = T.task_assignment_id WHERE (operation_type = 'ARCHIVE' OR operation_type = 'UNARCHIVE') AND T.task_assignment_id = Task_Assignments.task_assignment_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), Task_Assignments.is_active) as is_active,
	Task_Assignments.task_assignment_id,
    COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Task_Assignments_History WHERE record_id = Task_Assignments.task_assignment_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.task_id')), Task_Assignments.task_id) as task_id,
	COALESCE(JSON_UNQUOTE(JSON_EXTRACT((SELECT changed_data FROM Task_Assignments_History WHERE record_id = Task_Assignments.task_assignment_id AND version_id > @version ORDER BY version_id ASC LIMIT 1), '$.user_id')), Task_Assignments.user_id) as user_id
FROM Task_Assignments
JOIN Task_Assignments_History ON Task_Assignments_History.record_id = Task_Assignments.task_assignment_id
WHERE version_id <= @version
GROUP BY Task_Assignments.task_assignment_id;