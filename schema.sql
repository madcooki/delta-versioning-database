-- Entity History: Retrieve all versions of a specific entity
-- Point-in-Time Snapshot: Show what the dataset looked like at a specific version
-- Change Detection: Identify what changed between two versions
-- Current State: Extract the latest version of each entity




-- MySQL script to create and populate the versioned project management database

-- Refresh the database every time the script is run
DROP DATABASE conventional;
CREATE DATABASE conventional;
USE conventional;

-- Create the Version_History table
CREATE TABLE Version_History (
    version_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(255) NOT NULL,
    record_id INT NOT NULL,
    operation_type ENUM('ADD', 'EDIT', 'ARCHIVE', 'UNARCHIVE') NOT NULL,
    changed_data JSON,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create the Users table
CREATE TABLE Users (
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Create the Projects table
CREATE TABLE Projects (
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

-- Create the Task_Statuses table
CREATE TABLE Task_Statuses (
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    task_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(255) NOT NULL
);

-- Create the Tasks table
CREATE TABLE Tasks (
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    task_status_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (task_status_id) REFERENCES Task_Statuses(task_status_id)
);

-- Create the Task_Assignments table
CREATE TABLE Task_Assignments (
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    task_assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create views to optimize querying
CREATE VIEW Users_History AS
SELECT * FROM Version_History WHERE table_name = "Users";

CREATE VIEW Projects_History AS
SELECT * FROM Version_History WHERE table_name = "Projects";

CREATE VIEW Task_Statuses_History AS
SELECT * FROM Version_History WHERE table_name = "Task_Statuses";

CREATE VIEW Tasks_History AS
SELECT * FROM Version_History WHERE table_name = "Tasks";

CREATE VIEW Task_Assignments_History AS
SELECT * FROM Version_History WHERE table_name = "Task_Assignments";


-- Add users
INSERT INTO Users (name, email)
VALUES ('Alice Johnson', 'alice@example.com');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Users', LAST_INSERT_ID(), 'ADD', NULL);

INSERT INTO Users (name, email)
VALUES ('Bob Smith', 'bob@example.com');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Users', LAST_INSERT_ID(), 'ADD', NULL);

INSERT INTO Users (name, email)
VALUES ('Charlie Brown', 'charlie@example.com');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Users', LAST_INSERT_ID(), 'ADD', NULL);


-- Add projects
INSERT INTO Projects (name, description)
VALUES ('Project Alpha', 'First test project');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Projects', LAST_INSERT_ID(), 'ADD', NULL);

INSERT INTO Projects (name, description)
VALUES ('Project Beta', 'Second test project');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Projects', LAST_INSERT_ID(), 'ADD', NULL);

INSERT INTO Projects (name, description)
VALUES ('Project Gamma', 'Third test project');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Projects', LAST_INSERT_ID(), 'ADD', NULL);


-- Add task statuses
INSERT INTO Task_Statuses (status_name) VALUES ('Open');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Task_Statuses', LAST_INSERT_ID(), 'ADD', NULL);

INSERT INTO Task_Statuses (status_name) VALUES ('In Progress');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Task_Statuses', LAST_INSERT_ID(), 'ADD', NULL);

INSERT INTO Task_Statuses (status_name) VALUES ('Completed');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Task_Statuses', LAST_INSERT_ID(), 'ADD', NULL);


-- Add tasks
INSERT INTO Tasks (project_id, task_status_id, title, description)
VALUES (1, 1, 'Task 1', 'Initial task for Alpha');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Tasks', LAST_INSERT_ID(), 'ADD', NULL);

INSERT INTO Tasks (project_id, task_status_id, title, description)
VALUES (1, 2, 'Task 2', 'Second task for Alpha');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Tasks', LAST_INSERT_ID(), 'ADD', NULL);

INSERT INTO Tasks (project_id, task_status_id, title, description)
VALUES (2, 1,  'Task 3', 'First task for Beta');
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Tasks', LAST_INSERT_ID(), 'ADD', NULL);


-- Assign tasks to users
INSERT INTO Task_Assignments (task_id, user_id) VALUES (1, 1);
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Task_Assignments', LAST_INSERT_ID(), 'ADD', NULL);

INSERT INTO Task_Assignments (task_id, user_id) VALUES (2, 2);
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Task_Assignments', LAST_INSERT_ID(), 'ADD', NULL);

INSERT INTO Task_Assignments (task_id, user_id) VALUES (3, 3);
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Task_Assignments', LAST_INSERT_ID(), 'ADD', NULL);


-- Demonstrate EDIT, ADD, ARCHIVE, and UNARCHIVE operations

-- ADD
INSERT INTO Tasks (project_id, title, description, task_status_id)
VALUES (3, 'Task 4', 'First task for Gamma', 1);
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Tasks', LAST_INSERT_ID(), 'ADD', NULL);

-- EDIT
UPDATE Tasks SET description = 'Initial task for Alpha (edited)' WHERE task_id = 1;
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Tasks', 1, 'EDIT', JSON_OBJECT('description', 'Initial task for Alpha'));

-- ARCHIVE
UPDATE Users SET is_active = FALSE WHERE user_id = 2;
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Users', 2, 'ARCHIVE', NULL);

-- UNARCHIVE (ARCHIVE --> then UNARCHIVE)
UPDATE Users SET is_active = FALSE WHERE user_id = 3;
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Users', 3, 'ARCHIVE', NULL);

UPDATE Users SET is_active = TRUE WHERE user_id = 3;
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Users', 3, 'UNARCHIVE', NULL);


-- Testing Tasks table snapshots
UPDATE Tasks SET project_id = 3, description = 'Second task for Gamma' WHERE task_id = 2;
INSERT INTO Version_History (table_name, record_id, operation_type, changed_data)
VALUES ('Tasks', 2, 'EDIT', JSON_OBJECT('project_id', '1', 'description', 'Second task for Alpha'));