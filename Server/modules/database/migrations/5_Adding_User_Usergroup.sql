ALTER TABLE `vs_users`
	ADD COLUMN `usergroup` INT NULL DEFAULT '1' AFTER `last_seen`,
	ADD CONSTRAINT `FK_vs_users_vs_usergroups` FOREIGN KEY (`usergroup`) REFERENCES `vs_usergroups` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION;

INSERT INTO `versus`.`vs_usergroups` (`id`, `name`) VALUES ('1', 'user');