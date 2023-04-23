-- Creating the usergroups table

CREATE TABLE `vs_usergroups` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` CHAR(50) NOT NULL DEFAULT 'Undefined' COLLATE 'utf8mb4_general_ci',
	`power` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `name` (`name`) USING BTREE
);
