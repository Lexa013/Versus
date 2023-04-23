ALTER TABLE `vs_users`
	ADD COLUMN `username` CHAR(32) NOT NULL DEFAULT 'Undefined' AFTER `steamid`;