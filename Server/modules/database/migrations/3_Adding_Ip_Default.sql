ALTER TABLE `vs_users`
	CHANGE COLUMN `ip` `ip` CHAR(15) NOT NULL DEFAULT 'Undefined' COLLATE 'utf8mb4_general_ci' AFTER `username`;