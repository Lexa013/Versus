-- Create the users table

CREATE TABLE `vs_users` (
	`steamid` BIGINT(64) NOT NULL,
	`ip` CHAR(15) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`joined_at` DATETIME NOT NULL DEFAULT current_timestamp(),
	`last_seen` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`steamid`) USING BTREE
);