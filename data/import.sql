-- Version 0.1.0 [2017-03-13]
--
--   Project     : Darkstar Vagrant Boilerplate
--   Markup      : import.sql
--   Author      : Rye Miller
--   Version     : v0.1.0 (beta)
--   License     : MIT
--   License URI : http://github.com/iods/vagrant/LICENSE
--
-- Any SQL added here will be executed as part of the provisioning of the Vagrant
-- box and is defined in the bootstrap.sh file.
--
-- Website:   http://github.com/iods/vagrant/data/import.sql (public)
-- Copyright: (c) 2017 Rye Miller, DRKSTR

DROP TABLE IF EXISTS `developers`;

CREATE TABLE `developers` (
    `id` int(10) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `handle` varchar(255),
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


LOCK TABLES `developers` WRITE;

INSERT INTO `developers` VALUES (1,'Rye Miller','@ryemiller');

UNLOCK TABLES;

