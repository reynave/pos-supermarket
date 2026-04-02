CREATE TABLE `balance` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`resetId` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`cashIn` INT(11) NOT NULL DEFAULT '0',
	`cashOut` INT(11) NOT NULL DEFAULT '0',
	`transactionId` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`kioskUuid` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`cashierId` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`terminalId` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`settlementId` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`close` INT(1) NOT NULL DEFAULT '0',
	`input_date` DATETIME NOT NULL DEFAULT '2023-01-01 00:00:00',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=33
;
