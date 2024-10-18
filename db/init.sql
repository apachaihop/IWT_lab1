-- Drop existing tables if they exist to ensure a clean setup
DROP TABLE IF EXISTS CommentLikes;
DROP TABLE IF EXISTS RepositoryComments;
DROP TABLE IF EXISTS PullRequestReviews;
DROP TABLE IF EXISTS PullRequests;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS Issues;
DROP TABLE IF EXISTS Commits;
DROP TABLE IF EXISTS Branches;
DROP TABLE IF EXISTS RepositorySubscriptions;
DROP TABLE IF EXISTS Repositories;
DROP TABLE IF EXISTS UserPreferences;
DROP TABLE IF EXISTS Users;

-- Create Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_admin BOOLEAN DEFAULT FALSE
);

-- Create Repositories Table with 'language' Column
CREATE TABLE Repositories (
    repo_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    language VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create RepositoryComments Table
CREATE TABLE RepositoryComments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    repo_id INT,
    user_id INT,
    comment TEXT NOT NULL,
    stars INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (repo_id) REFERENCES Repositories(repo_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create CommentLikes Table
CREATE TABLE CommentLikes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    comment_id INT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (comment_id) REFERENCES RepositoryComments(comment_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_like (comment_id, user_id)
);

-- Create RepositorySubscriptions Table
CREATE TABLE RepositorySubscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    repo_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (repo_id) REFERENCES Repositories(repo_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    UNIQUE KEY (repo_id, user_id)
);

-- Create Branches Table
CREATE TABLE Branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    repo_id INT,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (repo_id) REFERENCES Repositories(repo_id)
);

-- Create Commits Table
CREATE TABLE Commits (
    commit_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_id INT,
    user_id INT,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Issues Table
CREATE TABLE Issues (
    issue_id INT AUTO_INCREMENT PRIMARY KEY,
    repo_id INT,
    user_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('open', 'closed') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (repo_id) REFERENCES Repositories(repo_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Comments Table
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    issue_id INT,
    user_id INT,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES Issues(issue_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create PullRequests Table
CREATE TABLE PullRequests (
    pr_id INT AUTO_INCREMENT PRIMARY KEY,
    repo_id INT,
    user_id INT,
    branch_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('open', 'closed', 'merged') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (repo_id) REFERENCES Repositories(repo_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- Create PullRequestReviews Table
CREATE TABLE PullRequestReviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    pr_id INT,
    user_id INT,
    review TEXT NOT NULL,
    status ENUM('approved', 'changes_requested', 'commented') DEFAULT 'commented',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pr_id) REFERENCES PullRequests(pr_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Reviews Table
CREATE TABLE Reviews(
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    review TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create UserPreferences Table
CREATE TABLE IF NOT EXISTS UserPreferences (
    user_id INT NOT NULL,
    language VARCHAR(50) NOT NULL,
    preference_count INT DEFAULT 0,
    PRIMARY KEY (user_id, language),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- -----------------------------------
-- Insert Sample Data into Users Table
-- -----------------------------------

INSERT INTO Users (username, email, password_hash, is_admin) VALUES
('alice', 'alice@example.com', SHA2('password123', 256), TRUE),
('bob', 'bob@example.com', SHA2('securepass', 256), FALSE),
('carol', 'carol@example.com', SHA2('mysecret', 256), FALSE),
('dave', 'dave@example.com', SHA2('davepass', 256), FALSE);

-- -----------------------------------
-- Insert Sample Data into Repositories Table
-- -----------------------------------

INSERT INTO Repositories (user_id, name, description, language) VALUES
(1, 'Awesome-Python-Project', 'A Python project that does awesome things.', 'Python'),
(1, 'JavaScript-Toolbox', 'A collection of useful JavaScript tools.', 'JavaScript'),
(2, 'Java-Enterprise', 'Enterprise-level Java applications.', 'Java'),
(3, 'CSharp-Core', 'Core functionalities in C#.', 'C#'),
(4, 'Ruby-On-Rails-App', 'A web application built with Ruby on Rails.', 'Ruby'),
(2, 'Go-Concurrency', 'Experiments with Go concurrency patterns.', 'Go'),
(3, 'TypeScript-Utilities', 'Utility functions written in TypeScript.', 'TypeScript'),
(4, 'Swift-Mobile', 'Mobile applications developed in Swift.', 'Swift');

-- -----------------------------------
-- Insert Sample Data into UserPreferences Table
-- -----------------------------------

INSERT INTO UserPreferences (user_id, language, preference_count) VALUES
(2, 'Java', 5),
(2, 'Go', 3),
(3, 'C#', 4),
(3, 'TypeScript', 2),
(4, 'Ruby', 6),
(4, 'Swift', 3),
(1, 'Python', 10),
(1, 'JavaScript', 7);

-- -----------------------------------
-- Insert Sample Data into RepositoryComments Table
-- -----------------------------------

INSERT INTO RepositoryComments (repo_id, user_id, comment, stars) VALUES
(1, 2, 'Great project! Really helped me learn Python.', 10),
(1, 3, 'Needs better documentation.', 2),
(2, 4, 'JavaScript tools are essential for web development.', 5),
(3, 1, 'Impressive Java enterprise solutions.', 8),
(4, 2, 'C# core functionalities are well implemented.', 4),
(5, 3, 'Rails app is very user-friendly.', 6),
(6, 1, 'Go concurrency patterns are powerful!', 7),
(7, 4, 'TypeScript utilities make coding easier.', 3),
(8, 2, 'Swift is perfect for mobile development.', 9);

-- -----------------------------------
-- Insert Sample Data into RepositorySubscriptions Table
-- -----------------------------------

INSERT INTO RepositorySubscriptions (repo_id, user_id) VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 4),
(4, 2),
(5, 1),
(6, 3),
(7, 4),
(8, 1);

-- -----------------------------------
-- Insert Sample Data into Branches Table
-- -----------------------------------

INSERT INTO Branches (repo_id, name) VALUES
(1, 'main'),
(1, 'dev'),
(2, 'main'),
(3, 'release'),
(4, 'main'),
(5, 'development'),
(6, 'main'),
(7, 'feature'),
(8, 'main');

-- -----------------------------------
-- Insert Sample Data into Commits Table
-- -----------------------------------

INSERT INTO Commits (branch_id, user_id, message) VALUES
(1, 1, 'Initial commit'),
(2, 2, 'Add new feature'),
(3, 1, 'Fix bugs'),
(4, 4, 'Improve performance'),
(5, 1, 'Update README'),
(6, 3, 'Refactor codebase'),
(7, 2, 'Optimize functions'),
(8, 4, 'Enhance UI'),
(9, 1, 'Prepare for deployment');

-- -----------------------------------
-- Insert Sample Data into Issues Table
-- -----------------------------------

INSERT INTO Issues (repo_id, user_id, title, description, status) VALUES
(1, 2, 'Bug in authentication', 'Users cannot log in under certain conditions.', 'open'),
(2, 3, 'Add new tool', 'Request to add a new JavaScript tool to the toolbox.', 'closed'),
(3, 4, 'Performance optimization', 'Improve the performance of data processing.', 'open'),
(4, 2, 'C# compatibility', 'Ensure compatibility with the latest C# version.', 'closed'),
(5, 1, 'UI enhancements', 'Improve the user interface for better UX.', 'open');

-- -----------------------------------
-- Insert Sample Data into Comments Table
-- -----------------------------------

INSERT INTO Comments (issue_id, user_id, comment) VALUES
(1, 3, 'I can replicate this bug. Working on a fix.'),
(2, 4, 'The new tool has been integrated.'),
(3, 2, 'Performance improvements are in progress.'),
(4, 1, 'Compatibility issues have been resolved.'),
(5, 3, 'UI enhancements look great!');

-- -----------------------------------
-- Insert Sample Data into PullRequests Table
-- -----------------------------------

INSERT INTO PullRequests (repo_id, user_id, branch_id, title, description, status) VALUES
(1, 2, 1, 'Add user profile feature', 'Implemented user profiles with CRUD operations.', 'open'),
(2, 3, 3, 'Update JavaScript tools', 'Added new utilities for better development.', 'merged'),
(3, 4, 4, 'Optimize data processing', 'Enhanced performance and reduced memory usage.', 'closed'),
(4, 2, 5, 'Improve C# core', 'Refactored core modules for better maintainability.', 'open'),
(5, 1, 6, 'Enhance README', 'Added detailed instructions and examples.', 'merged');

-- -----------------------------------
-- Insert Sample Data into PullRequestReviews Table
-- -----------------------------------

INSERT INTO PullRequestReviews (pr_id, user_id, review, status) VALUES
(1, 3, 'Looks good to me!', 'approved'),
(2, 4, 'Great improvements!', 'approved'),
(3, 2, 'Needs some changes.', 'changes_requested'),
(4, 1, 'Code is clean and efficient.', 'approved'),
(5, 3, 'Excellent documentation updates.', 'commented');

-- -----------------------------------
-- Insert Sample Data into Reviews Table
-- -----------------------------------

INSERT INTO Reviews (review) VALUES
('This project is fantastic!'),
('Well-structured and easy to understand.'),
('Needs more comprehensive tests.'),
('Excellent work on the recent updates.'),
('Could use better error handling.');

CREATE TABLE IF NOT EXISTS WeatherData (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    temperature DECIMAL(5,2) NOT NULL,
    description VARCHAR(255) NOT NULL,
    humidity DECIMAL(5,2) NOT NULL,
    wind_speed DECIMAL(5,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);