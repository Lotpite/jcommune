CREATE TABLE `SIMPLE_PAGES` (
  `PAGE_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `UUID` varchar(255) COLLATE utf8_bin NOT NULL,
  `NAME` varchar(64) COLLATE utf8_bin NOT NULL UNIQUE,
  `PATH_NAME` varchar(64) COLLATE utf8_bin NOT NULL UNIQUE,
  `CONTENT` longtext COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`PAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `jtalks`.`simple_pages` (`PAGE_ID`, `UUID`, `NAME`, `PATH_NAME`, `CONTENT`) VALUES (1, 'qwe', 'F.A.Q.', 'faq', 'empty');
