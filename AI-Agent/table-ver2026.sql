-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               10.4.28-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.12.0.7122
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table pos_supermarket.account
CREATE TABLE IF NOT EXISTS `account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` longtext DEFAULT NULL,
  `value` longtext DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.account: ~32 rows (approximately)
INSERT INTO `account` (`id`, `name`, `value`, `updateDate`, `updateBy`) VALUES
	(1, 'companyId', '01', 1654258394, 1),
	(2, 'keyLisence', 'Update 2022-11-07 10:32:55', 1667813575, 1),
	(3, 'keygen', 'account', 1654258548, 1),
	(4, 'kioskEnable', '1', 1686535691, 1),
	(10, 'companyName', 'Osella', 1742287639, 1),
	(11, 'companyAddress', 'Jakarta', 1742287639, 1),
	(12, 'companyPhone', '021 5000XXXX', 1742287639, 1),
	(14, 'Logo Images Terminal (option)', '', 1742287639, 0),
	(21, 'Outlet ID', 'OT99', 1742287639, NULL),
	(22, 'Brand ID', 'BD52', 1742287639, NULL),
	(51, 'Digit Prefix Position', '1', 1742287639, NULL),
	(52, 'Digit Item', '6', 1742287640, 1),
	(53, 'Digit Weight', '5', 1742287640, 1),
	(54, 'Digit Float', '3', 1742287640, 1),
	(99, 'Member Discount', '10', 1742287640, NULL),
	(100, 'Round Method', '10', 1742287640, 1),
	(101, 'Tax Id', 'NPWP', 1742287640, 1),
	(201, 'Customer Photo', '1', 1742287640, NULL),
	(300, 'getMember', NULL, 1742287640, NULL),
	(301, 'getItem', NULL, 1742287640, NULL),
	(302, 'getPromotion', NULL, 1742287640, NULL),
	(350, 'sendTransaction', NULL, 1742287640, NULL),
	(400, 'Printer Name', 'POS80', 1742287640, NULL),
	(1001, 'Welcome Screen', 'Selamat Datang di Osella.<br>Semoga anda nyaman dengan pengalaman baru berbelanja di Osella.', 1742287640, 1),
	(1003, 'Customer Statement Display', 'Saya bersedia untuk scan dengan apa yang telah saya beli. ', 1742287640, 1),
	(1004, 'Thank You Display', 'Thank You for shopping on our store, and we hope you have enjoyable shopping experience. <br><br><br><br><br>Please Come Again', 1742287640, 1),
	(1005, 'Member not found Display', 'Member anda tidak ditemukan.', 1742287640, 1),
	(1006, 'Visitor Login Display', 'Selamat datang Pelanggan yang kami hormati. <br>Hubungi SPG kami jika anda membutuhkan bantuan.', 1742287640, 1),
	(1007, 'Print out Message on Receipt', 'Terima Kasih atas kunjungan anda.<br>Belanja Nyaman Belanja Hemat.', 1742287640, 1),
	(1009, 'Promotion free Item', 'barang Promotion Item label', 1742287640, 1),
	(1101, 'tnc1', 'Saya bersedia dalam penggunaan system akan memasukan data  dengan benar & tepat', 1742287640, NULL),
	(1102, 'tnc2', 'Saya bersedia jika ada kekurangan tepatan untuk menerima pihak toko melakukan penyesuaian', 1742287640, NULL);

-- Dumping structure for table pos_supermarket.auto_number
CREATE TABLE IF NOT EXISTS `auto_number` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `prefix` varchar(50) DEFAULT NULL,
  `digit` int(11) NOT NULL DEFAULT 6,
  `runningNumber` int(11) NOT NULL DEFAULT 0,
  `updateDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=305 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.auto_number: ~18 rows (approximately)
INSERT INTO `auto_number` (`id`, `name`, `prefix`, `digit`, `runningNumber`, `updateDate`) VALUES
	(1, 'brand', 'BND', 4, 26, 1657258458),
	(2, 'terminal', 'T', 4, 19, 1668759062),
	(3, 'taxCode', 'TAX', 4, 9, 1657280513),
	(4, 'branched', 'BN', 4, 9, 1657267586),
	(5, 'outlet', 'OD', 4, 36, 1657790756),
	(6, 'idPayment', 'ID', 4, 10, 1681281223),
	(7, 'uom', 'UOM', 4, 11, 1657281222),
	(10, 'item', 'TM', 9, 3, 1657781787),
	(11, 'user', 'S', 6, 1, 1657258458),
	(100, 'promotion', 'PR', 6, 11, 1658813889),
	(200, 'transaction', '', 4, 156, 1775640829),
	(201, 'kiosk', NULL, 9, 48869, 1701431691),
	(220, 'reset', 'RST', 6, 258, 1775642219),
	(300, 'kioskUuid', 'BILL', 9, 11902, 1692178227),
	(301, 'settlement', 'SET', 6, 39, 1753687185),
	(302, 'pos', NULL, 4, 295, 1775641649),
	(303, 'refund', 'REF', 6, 49, 1701431691),
	(304, 'exchange', 'EXC', 6, 34, 1697626014);

-- Dumping structure for table pos_supermarket.balance
CREATE TABLE IF NOT EXISTS `balance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resetId` varchar(50) NOT NULL DEFAULT '',
  `cashIn` int(11) NOT NULL DEFAULT 0,
  `cashOut` int(11) NOT NULL DEFAULT 0,
  `transactionId` varchar(50) NOT NULL DEFAULT '',
  `kioskUuid` varchar(50) NOT NULL DEFAULT '',
  `cashierId` varchar(50) NOT NULL,
  `terminalId` varchar(50) NOT NULL,
  `settlementId` varchar(50) NOT NULL,
  `close` int(1) NOT NULL DEFAULT 0,
  `input_date` datetime NOT NULL DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.balance: ~24 rows (approximately)
INSERT INTO `balance` (`id`, `resetId`, `cashIn`, `cashOut`, `transactionId`, `kioskUuid`, `cashierId`, `terminalId`, `settlementId`, `close`, `input_date`) VALUES
	(29, 'RST000252', 500000, -75000, '123123.0141', 'T01.260402.0263', '123123', 'T01', '', 1, '2026-04-02 08:51:57'),
	(30, 'RST000252', 200000, 0, '', '', '123123', 'T01', '', 0, '2026-04-02 15:52:41'),
	(31, 'RST000252', 2541, 0, '', '', '123123', 'T01', '', 0, '2026-04-02 15:53:52'),
	(32, 'RST000252', 21, 0, '', '', '123123', 'T01', '', 0, '2026-04-02 15:58:14'),
	(33, 'RST000252', 211, 0, '', '', 'dev-user', 'T01', '', 0, '2026-04-02 16:24:22'),
	(34, 'RST000253', 0, 0, 'RST000253', '', '123123', 'T01', '', 1, '2026-04-02 17:37:49'),
	(35, 'RST000254', 123, 0, 'RST000254', '', '123123', 'T01', '', 1, '2026-04-06 16:40:18'),
	(36, 'RST000254', 780000, 0, '123123.0144', 'T01.260406.0266', '123123', 'T01', '', 1, '2026-04-06 10:43:47'),
	(37, 'RST000254', 1435000, -80000, '123123.0145', 'T01.260406.0267', '123123', 'T01', '', 1, '2026-04-06 11:25:18'),
	(38, 'RST000254', 487899, 0, '123123.0146', 'T01.260406.0269', '123123', 'T01', '', 1, '2026-04-06 12:06:57'),
	(39, 'RST000254', 130000, -130000, '123123.0147', 'T01.260407.0276', '123123', 'T01', '', 1, '2026-04-07 09:15:00'),
	(40, 'RST000254', 473600, -586400, '123123.0148', 'T01.260407.0281', '123123', 'T01', '', 1, '2026-04-07 09:46:10'),
	(41, 'RST000254', 35000, -315000, '123123.0149', 'T01.260407.0282', '123123', 'T01', '', 1, '2026-04-07 10:01:30'),
	(42, 'RST000254', 855000, -100000, '123123.0150', 'T01.260407.0283', '123123', 'T01', '', 1, '2026-04-07 10:35:45'),
	(43, 'RST000254', 230000, -80000, '123123.0151', 'T01.260407.0284', '123123', 'T01', '', 1, '2026-04-07 10:47:10'),
	(44, 'RST000254', 1492200, -272800, '123123.0152', 'T01.260408.0289', '123123', 'T01', '', 1, '2026-04-08 05:49:24'),
	(45, 'RST000254', 480000, 0, '123123.0153', 'T01.260408.0290', '123123', 'T01', '', 1, '2026-04-08 07:03:46'),
	(46, 'RST000254', 640000, 0, '123123.0154', 'T01.260408.0291', '123123', 'T01', '', 1, '2026-04-08 09:13:28'),
	(47, 'RST000254', 640000, 0, '123123.0155', 'T01.260408.0292', '123123', 'T01', '', 1, '2026-04-08 09:20:50'),
	(48, 'RST000254', 458600, -136400, '123123.0156', 'T01.260408.0293', '123123', 'T01', '', 1, '2026-04-08 09:33:49'),
	(49, 'RST000255', 123, 0, 'RST000255', '', 'dev-user', 'T01', '', 1, '2026-04-08 16:47:12'),
	(50, 'RST000256', 333, 0, 'RST000256', '', 'dev-user', 'T01', '', 1, '2026-04-08 16:50:10'),
	(51, 'RST000257', 444, 0, 'RST000257', '', 'dev-user', 'T01', '', 1, '2026-04-08 16:51:19'),
	(52, 'RST000258', 111, 0, 'RST000258', '', 'dev-user', 'T01', '', 0, '2026-04-08 16:56:59');

-- Dumping structure for table pos_supermarket.cash_declaration
CREATE TABLE IF NOT EXISTS `cash_declaration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resetId` varchar(250) DEFAULT NULL,
  `userId` varchar(50) DEFAULT NULL,
  `denom_100k` int(11) NOT NULL DEFAULT 0,
  `denom_50k` int(11) NOT NULL DEFAULT 0,
  `denom_20k` int(11) NOT NULL DEFAULT 0,
  `denom_10k` int(11) NOT NULL DEFAULT 0,
  `denom_5k` int(11) NOT NULL DEFAULT 0,
  `denom_2k` int(11) NOT NULL DEFAULT 0,
  `denom_1k` int(11) NOT NULL DEFAULT 0,
  `coins_other` int(11) NOT NULL DEFAULT 0,
  `note` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `presence` int(11) NOT NULL DEFAULT 1,
  `inputBy` int(11) DEFAULT NULL,
  `inputDate` datetime DEFAULT NULL,
  `updateDate` datetime DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.cash_declaration: ~8 rows (approximately)
INSERT INTO `cash_declaration` (`id`, `resetId`, `userId`, `denom_100k`, `denom_50k`, `denom_20k`, `denom_10k`, `denom_5k`, `denom_2k`, `denom_1k`, `coins_other`, `note`, `status`, `presence`, `inputBy`, `inputDate`, `updateDate`, `updateBy`) VALUES
	(1, 'RST000250', 'dev-user', 1, 2, 0, 0, 0, 0, 0, 0, '', 1, 1, NULL, '0000-00-00 00:00:00', NULL, NULL),
	(2, 'RST000251', 'dev-user', 9, 0, 0, 9, 0, 0, 0, 0, '', 1, 1, NULL, '2026-04-02 15:02:19', NULL, NULL),
	(3, 'RST000252', '123123', 8, 0, 0, 0, 0, 0, 0, 0, 'lancar', 1, 1, 123123, '2026-04-02 17:10:34', NULL, NULL),
	(4, 'RST000253', '123123', 0, 0, 0, 0, 0, 10, 0, 0, '', 1, 1, 123123, '2026-04-06 16:36:39', NULL, NULL),
	(5, 'RST000254', 'dev-user', 80, 10, 64, 5, 1, 0, 3, 0, 'kekurang koin', 1, 1, NULL, '2026-04-08 16:41:23', NULL, NULL),
	(6, 'RST000255', 'dev-user', 0, 0, 0, 0, 0, 0, 0, 0, '', 1, 1, NULL, '2026-04-08 16:49:05', NULL, NULL),
	(7, 'RST000256', 'dev-user', 0, 0, 0, 0, 0, 0, 0, 0, '', 1, 1, NULL, '2026-04-08 16:51:14', NULL, NULL),
	(8, 'RST000257', 'dev-user', 0, 0, 0, 0, 0, 0, 0, 0, '', 1, 1, NULL, '2026-04-08 16:56:53', NULL, NULL);

-- Dumping structure for table pos_supermarket.exchange
CREATE TABLE IF NOT EXISTS `exchange` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kioskUuid` varchar(50) NOT NULL DEFAULT '',
  `exchange` varchar(50) NOT NULL DEFAULT '',
  `transactionId` varchar(50) NOT NULL DEFAULT '',
  `transactionDetailId` varchar(50) NOT NULL DEFAULT '',
  `itemId` varchar(50) NOT NULL DEFAULT '',
  `refundAmount` int(9) NOT NULL DEFAULT 0,
  `exchangeItemId` varchar(50) NOT NULL DEFAULT '',
  `exchangeAmount` int(9) NOT NULL DEFAULT 0,
  `input_date` datetime NOT NULL DEFAULT '2024-01-01 00:00:00',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.exchange: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.greeting
CREATE TABLE IF NOT EXISTS `greeting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(250) DEFAULT NULL,
  `publishDate` date DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `presence` int(11) NOT NULL DEFAULT 1,
  `inputBy` int(11) DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.greeting: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.item
CREATE TABLE IF NOT EXISTS `item` (
  `id` varchar(50) NOT NULL,
  `description` varchar(250) DEFAULT NULL,
  `shortDesc` varchar(250) DEFAULT NULL,
  `priceFlag` int(11) DEFAULT NULL,
  `ppnFlag` int(11) DEFAULT NULL,
  `price1` double DEFAULT NULL,
  `price2` double DEFAULT NULL,
  `price3` double DEFAULT NULL,
  `price4` double DEFAULT NULL,
  `price5` double DEFAULT NULL,
  `price6` double DEFAULT NULL,
  `price7` double DEFAULT NULL,
  `price8` double DEFAULT NULL,
  `price9` double DEFAULT NULL,
  `price10` double DEFAULT NULL,
  `itemUomId` varchar(50) DEFAULT NULL,
  `itemCategoryId` varchar(50) DEFAULT NULL,
  `itemTaxId` varchar(50) DEFAULT NULL,
  `images` longtext DEFAULT NULL,
  `presence` int(1) NOT NULL DEFAULT 1,
  `status` int(11) NOT NULL DEFAULT 1,
  `inputBy` int(11) DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.item: ~157 rows (approximately)
INSERT INTO `item` (`id`, `description`, `shortDesc`, `priceFlag`, `ppnFlag`, `price1`, `price2`, `price3`, `price4`, `price5`, `price6`, `price7`, `price8`, `price9`, `price10`, `itemUomId`, `itemCategoryId`, `itemTaxId`, `images`, `presence`, `status`, `inputBy`, `inputDate`, `updateBy`, `updateDate`) VALUES
	('1', 'Kaos Kuning XL', 'Kaos Kuning XL', NULL, NULL, 100000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('10197201', 'ACE Hardware Lamp', 'ACE Hardware Lamp', NULL, NULL, 120000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('1571384', 'headset OXL', 'headset OXL', NULL, NULL, 1000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('3', 'Philip XL otomatic', 'Philip XL otomatic', NULL, NULL, 1860000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('4', 'Vanilla Bean Noel', 'Vanilla Bean Noel', NULL, NULL, 242000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456701', 'Kaos Nike Hitam XL', 'Kaos Nike Hitam XL', NULL, NULL, 125000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456702', 'Jaket Adidas Biru L', 'Jaket Adidas Biru L', NULL, NULL, 210000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456703', 'Kemeja Flanel Uniqlo M', 'Kemeja Flanel Uniqlo M', NULL, NULL, 175000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456704', 'Celana Jeans Levis 32', 'Celana Jeans Levis 32', NULL, NULL, 320000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456705', 'Hoodie Puma Abu XXL', 'Hoodie Puma Abu XXL', NULL, NULL, 275000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456706', 'Sweater HnM Navy M', 'Sweater H&M Navy M', NULL, NULL, 150000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456707', 'Kaos Polo Lacoste Putih L', 'Kaos Polo Lacoste Putih L', NULL, NULL, 185000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456708', 'Jaket Kulit Zara Hitam XL', 'Jaket Kulit Zara Hitam XL', NULL, NULL, 480000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456709', 'Celana Chino Wrangler Coklat 34', 'Celana Chino Wrangler Coklat 34', NULL, NULL, 210000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456710', 'Hoodie Champion Merah L', 'Hoodie Champion Merah L', NULL, NULL, 300000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456711', 'Kemeja Batik Danar Hadi XL', 'Kemeja Batik Danar Hadi XL', NULL, NULL, 195000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456712', 'Celana Cargo Eiger Hijau 36', 'Celana Cargo Eiger Hijau 36', NULL, NULL, 350000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456713', 'Kaos Vans Off The Wall M', 'Kaos Vans Off The Wall M', NULL, NULL, 140000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456714', 'Jaket Gunung The North Face L', 'Jaket Gunung The North Face L', NULL, NULL, 375000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456715', 'Sweater Cardigan H&M Abu L', 'Sweater Cardigan H&M Abu L', NULL, NULL, 220000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456716', 'Celana Jogger Adidas Hitam M', 'Celana Jogger Adidas Hitam M', NULL, NULL, 180000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456717', 'Kemeja Oxford Cotton On M', 'Kemeja Oxford Cotton On M', NULL, NULL, 165000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456718', 'Hoodie Oversize Uniqlo XL', 'Hoodie Oversize Uniqlo XL', NULL, NULL, 290000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456719', 'Jaket Bomber Alpha Industries L', 'Jaket Bomber Alpha Industries L', NULL, NULL, 450000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456720', 'Celana Pendek Dickies Coklat 32', 'Celana Pendek Dickies Coklat 32', NULL, NULL, 160000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456721', 'Kaos Supreme Box Logo Merah L', 'Kaos Supreme Box Logo Merah L', NULL, NULL, 350000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456722', 'Jaket Jeans Levis Trucker M', 'Jaket Jeans Levis Trucker M', NULL, NULL, 400000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456723', 'Kemeja Flanel H&M Biru M', 'Kemeja Flanel H&M Biru M', NULL, NULL, 175000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456724', 'Celana Jeans Nudie Thin Finn 31', 'Celana Jeans Nudie Thin Finn 31', NULL, NULL, 370000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456725', 'Hoodie Converse Basic Hitam L', 'Hoodie Converse Basic Hitam L', NULL, NULL, 250000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456726', 'Sweater Nike Crewneck Abu XL', 'Sweater Nike Crewneck Abu XL', NULL, NULL, 270000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456727', 'Jaket Parka Pull & Bear Hijau M', 'Jaket Parka Pull & Bear Hijau M', NULL, NULL, 320000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456728', 'Kaos Stüssy Basic Logo XL', 'Kaos Stüssy Basic Logo XL', NULL, NULL, 180000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456729', 'Celana Training Puma Hitam M', 'Celana Training Puma Hitam M', NULL, NULL, 190000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456730', 'Jaket Windbreaker Adidas Biru L', 'Jaket Windbreaker Adidas Biru L', NULL, NULL, 310000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456731', 'Kemeja Linen ZARA Putih XL', 'Kemeja Linen ZARA Putih XL', NULL, NULL, 285000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456732', 'Celana Boxer Calvin Klein 3pcs', 'Celana Boxer Calvin Klein 3pcs', NULL, NULL, 200000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456733', 'Hoodie Thrasher Flame Logo L', 'Hoodie Thrasher Flame Logo L', NULL, NULL, 275000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456734', 'Jaket Harrington Fred Perry M', 'Jaket Harrington Fred Perry M', NULL, NULL, 390000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456735', 'Celana Jogger H&M Abu M', 'Celana Jogger H&M Abu M', NULL, NULL, 180000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456736', 'Kaos Oversize Cotton On Putih L', 'Kaos Oversize Cotton On Putih L', NULL, NULL, 160000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456737', 'Kemeja Denim Levis Biru L', 'Kemeja Denim Levis Biru L', NULL, NULL, 310000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456738', 'Celana Jogger Nike Tech Fleece L', 'Celana Jogger Nike Tech Fleece L', NULL, NULL, 220000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456739', 'Jaket Hoodie Balenciaga Oversized', 'Jaket Hoodie Balenciaga Oversized', NULL, NULL, 500000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456740', 'Kaos Basic Uniqlo Putih M', 'Kaos Basic Uniqlo Putih M', NULL, NULL, 130000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456741', 'Kemeja Slim Fit H&M Navy L', 'Kemeja Slim Fit H&M Navy L', NULL, NULL, 195000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456742', 'Celana Chino Cotton On Hitam 34', 'Celana Chino Cotton On Hitam 34', NULL, NULL, 210000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456743', 'Jaket Oversized Bershka Abu L', 'Jaket Oversized Bershka Abu L', NULL, NULL, 280000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456744', 'Kaos Metallica Vintage Black M', 'Kaos Metallica Vintage Black M', NULL, NULL, 270000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456745', 'Celana Kargo Zara Coklat 32', 'Celana Kargo Zara Coklat 32', NULL, NULL, 300000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456746', 'Sweater Wool Pull & Bear Hitam M', 'Sweater Wool Pull & Bear Hitam M', NULL, NULL, 250000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456747', 'Kaos Adidas Trefoil Logo Putih XL', 'Kaos Adidas Trefoil Logo Putih XL', NULL, NULL, 180000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456748', 'Hoodie Oversize Fear of God Beige', 'Hoodie Oversize Fear of God Beige', NULL, NULL, 450000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456749', 'Kemeja Hawaii Uniqlo Floral L', 'Kemeja Hawaii Uniqlo Floral L', NULL, NULL, 230000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('899123456750', 'Jaket Varsity Supreme Merah L', 'Jaket Varsity Supreme Merah L', NULL, NULL, 400000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('8997208072477', 'Serum Sunscreen BT21', 'Serum Sunscreen BT21', NULL, NULL, 70000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('8997236390260', 'Pascoy facial Tissue', 'Pascoy facial Tissue', NULL, NULL, 20000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000001', 'Zara Jacket XXL', 'Zara Jacket XXL', NULL, NULL, 100000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000002', 'Puma Cap M', 'Puma Cap M', NULL, NULL, 299775, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000003', 'Reebok Shorts S', 'Reebok Shorts S', NULL, NULL, 196093, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000004', 'Zara Jacket XL', 'Zara Jacket XL', NULL, NULL, 61601, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000005', 'Zara Hoodie S', 'Zara Hoodie S', NULL, NULL, 62423, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000006', 'Zara Sneakers XL', 'Zara Sneakers XL', NULL, NULL, 327539, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000007', 'Zara Shorts S', 'Zara Shorts S', NULL, NULL, 455374, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000008', 'Reebok Cap S', 'Reebok Cap S', NULL, NULL, 432298, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000009', 'Champion Jacket XL', 'Champion Jacket XL', NULL, NULL, 466389, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000010', 'Reebok Gloves XXL', 'Reebok Gloves XXL', NULL, NULL, 484763, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000011', 'H&M Sneakers S', 'H&M Sneakers S', NULL, NULL, 241785, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000012', 'Zara Sweatpants M', 'Zara Sweatpants M', NULL, NULL, 438776, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000013', 'Reebok T-Shirt M', 'Reebok T-Shirt M', NULL, NULL, 334750, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000014', 'New Balance Gloves M', 'New Balance Gloves M', NULL, NULL, 492457, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000015', 'New Balance T-Shirt XXL', 'New Balance T-Shirt XXL', NULL, NULL, 123057, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000016', 'Adidas Gloves L', 'Adidas Gloves L', NULL, NULL, 437282, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000017', 'Champion Socks S', 'Champion Socks S', NULL, NULL, 118263, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000018', 'Puma Jacket S', 'Puma Jacket S', NULL, NULL, 404438, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000019', 'Under Armour Jacket XL', 'Under Armour Jacket XL', NULL, NULL, 203716, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000020', 'H&M Jacket M', 'H&M Jacket M', NULL, NULL, 301549, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000021', 'Reebok Gloves M', 'Reebok Gloves M', NULL, NULL, 447227, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000022', 'New Balance Cap XL', 'New Balance Cap XL', NULL, NULL, 207728, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000023', 'Puma Backpack M', 'Puma Backpack M', NULL, NULL, 51413, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000024', 'New Balance Gloves L', 'New Balance Gloves L', NULL, NULL, 234360, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000025', 'Nike Sneakers S', 'Nike Sneakers S', NULL, NULL, 415674, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000026', 'H&M Shorts M', 'H&M Shorts M', NULL, NULL, 120108, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000027', 'Fila Socks M', 'Fila Socks M', NULL, NULL, 484587, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000028', 'Champion Gloves M', 'Champion Gloves M', NULL, NULL, 120380, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000029', 'Nike Gloves XXL', 'Nike Gloves XXL', NULL, NULL, 337013, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000030', 'Nike Gloves L', 'Nike Gloves L', NULL, NULL, 214733, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000031', 'Fila Gloves XL', 'Fila Gloves XL', NULL, NULL, 250995, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000032', 'Adidas Gloves XL', 'Adidas Gloves XL', NULL, NULL, 180603, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000033', 'New Balance Sneakers XL', 'New Balance Sneakers XL', NULL, NULL, 421891, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000034', 'Reebok Sneakers XXL', 'Reebok Sneakers XXL', NULL, NULL, 374690, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000035', 'Puma Hoodie XL', 'Puma Hoodie XL', NULL, NULL, 102985, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000036', 'Puma Sweatpants S', 'Puma Sweatpants S', NULL, NULL, 140208, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000037', 'Adidas Shorts M', 'Adidas Shorts M', NULL, NULL, 495227, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000038', 'Nike Shorts S', 'Nike Shorts S', NULL, NULL, 172959, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000039', 'Nike Socks XL', 'Nike Socks XL', NULL, NULL, 83368, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000040', 'New Balance Sneakers M', 'New Balance Sneakers M', NULL, NULL, 163334, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000041', 'Reebok T-Shirt L', 'Reebok T-Shirt L', NULL, NULL, 154272, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000042', 'Under Armour Gloves XL', 'Under Armour Gloves XL', NULL, NULL, 107391, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000043', 'Zara Sneakers S', 'Zara Sneakers S', NULL, NULL, 436377, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000044', 'H&M Sweatpants S', 'H&M Sweatpants S', NULL, NULL, 361310, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000045', 'Zara Socks XL', 'Zara Socks XL', NULL, NULL, 220350, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000046', 'Nike Gloves XL', 'Nike Gloves XL', NULL, NULL, 230450, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000047', 'Nike Gloves S', 'Nike Gloves S', NULL, NULL, 257650, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000048', 'Fila Hoodie M', 'Fila Hoodie M', NULL, NULL, 380313, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000049', 'Nike Sweatpants M', 'Nike Sweatpants M', NULL, NULL, 391285, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000050', 'Nike Socks M', 'Nike Socks M', NULL, NULL, 258075, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000051', 'Champion Shorts M', 'Champion Shorts M', NULL, NULL, 169623, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000052', 'Under Armour Shorts S', 'Under Armour Shorts S', NULL, NULL, 151132, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000053', 'Fila T-Shirt S', 'Fila T-Shirt S', NULL, NULL, 58398, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000054', 'Nike Sneakers L', 'Nike Sneakers L', NULL, NULL, 150643, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000055', 'Champion T-Shirt XXL', 'Champion T-Shirt XXL', NULL, NULL, 56040, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000056', 'Under Armour Gloves XXL', 'Under Armour Gloves XXL', NULL, NULL, 200877, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000057', 'Adidas T-Shirt S', 'Adidas T-Shirt S', NULL, NULL, 390249, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000058', 'New Balance Jacket XXL', 'New Balance Jacket XXL', NULL, NULL, 400729, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000059', 'Zara Socks L', 'Zara Socks L', NULL, NULL, 152422, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000060', 'Adidas Jacket M', 'Adidas Jacket M', NULL, NULL, 280154, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000061', 'Under Armour Jacket S', 'Under Armour Jacket S', NULL, NULL, 482278, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000062', 'Champion Gloves XXL', 'Champion Gloves XXL', NULL, NULL, 376259, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000063', 'Adidas Backpack S', 'Adidas Backpack S', NULL, NULL, 328508, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000064', 'Zara Shorts XL', 'Zara Shorts XL', NULL, NULL, 422665, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000065', 'Reebok T-Shirt M', 'Reebok T-Shirt M', NULL, NULL, 261167, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000066', 'H&M Shorts L', 'H&M Shorts L', NULL, NULL, 223396, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000067', 'H&M Gloves XL', 'H&M Gloves XL', NULL, NULL, 300351, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000068', 'New Balance Jacket XL', 'New Balance Jacket XL', NULL, NULL, 269423, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000069', 'Reebok Sweatpants XXL', 'Reebok Sweatpants XXL', NULL, NULL, 263343, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000070', 'Nike Gloves XXL', 'Nike Gloves XXL', NULL, NULL, 347605, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000071', 'Fila Hoodie S', 'Fila Hoodie S', NULL, NULL, 230640, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000072', 'H&M T-Shirt XXL', 'H&M T-Shirt XXL', NULL, NULL, 262315, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000073', 'H&M Shorts S', 'H&M Shorts S', NULL, NULL, 361186, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000074', 'Reebok Sweatpants M', 'Reebok Sweatpants M', NULL, NULL, 234195, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000075', 'Champion Jacket S', 'Champion Jacket S', NULL, NULL, 418172, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000076', 'Zara Gloves M', 'Zara Gloves M', NULL, NULL, 75126, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000077', 'Under Armour Shorts M', 'Under Armour Shorts M', NULL, NULL, 397853, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000078', 'Champion T-Shirt XXL', 'Champion T-Shirt XXL', NULL, NULL, 183804, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000079', 'Reebok Shorts L', 'Reebok Shorts L', NULL, NULL, 161715, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000080', 'Puma Gloves S', 'Puma Gloves S', NULL, NULL, 175903, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000081', 'New Balance Cap M', 'New Balance Cap M', NULL, NULL, 436966, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000082', 'H&M Hoodie M', 'H&M Hoodie M', NULL, NULL, 131455, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000083', 'Fila Socks XXL', 'Fila Socks XXL', NULL, NULL, 166071, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000084', 'Puma Socks XL', 'Puma Socks XL', NULL, NULL, 74936, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000085', 'New Balance Sweatpants M', 'New Balance Sweatpants M', NULL, NULL, 51583, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000086', 'Puma T-Shirt S', 'Puma T-Shirt S', NULL, NULL, 424807, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000087', 'H&M Hoodie XL', 'H&M Hoodie XL', NULL, NULL, 140394, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000088', 'Under Armour Shorts XXL', 'Under Armour Shorts XXL', NULL, NULL, 252999, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000089', 'Zara Jacket XL', 'Zara Jacket XL', NULL, NULL, 482161, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000090', 'H&M Sweatpants L', 'H&M Sweatpants L', NULL, NULL, 64867, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000091', 'Fila Jacket L', 'Fila Jacket L', NULL, NULL, 405926, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000092', 'Zara Sneakers S', 'Zara Sneakers S', NULL, NULL, 219161, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000093', 'Puma Hoodie M', 'Puma Hoodie M', NULL, NULL, 54035, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000094', 'Nike Sneakers M', 'Nike Sneakers M', NULL, NULL, 372098, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000095', 'H&M Backpack XL', 'H&M Backpack XL', NULL, NULL, 364493, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000096', 'New Balance Sneakers XXL', 'New Balance Sneakers XXL', NULL, NULL, 133928, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000097', 'Champion T-Shirt M', 'Champion T-Shirt M', NULL, NULL, 180026, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000098', 'Reebok Jacket XL', 'Reebok Jacket XL', NULL, NULL, 232456, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000099', 'Puma Socks M', 'Puma Socks M', NULL, NULL, 488824, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
	('9900000100', 'Puma Gloves M', 'Puma Gloves M', NULL, NULL, 97488, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL);

-- Dumping structure for table pos_supermarket.item_barcode
CREATE TABLE IF NOT EXISTS `item_barcode` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemId` varchar(50) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `inputBy` varchar(250) DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  `updateBy` varchar(250) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18446744073709551615 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.item_barcode: ~157 rows (approximately)
INSERT INTO `item_barcode` (`id`, `itemId`, `barcode`, `status`, `presence`, `inputBy`, `inputDate`, `updateBy`, `updateDate`) VALUES
	(1, '1', '8999999596972', 1, 1, NULL, NULL, NULL, NULL),
	(2, '1571384', '1571384', 1, 1, NULL, NULL, NULL, NULL),
	(3, '3', '1569723', 1, 1, NULL, NULL, NULL, NULL),
	(4, '4', '667558701829', 1, 1, NULL, NULL, NULL, NULL),
	(5, '8997236390260', '8997236390260', 1, 1, NULL, NULL, NULL, NULL),
	(6, '10197201', '10197201', 1, 1, NULL, NULL, NULL, NULL),
	(7, '8997208072477', '8997208072477', 1, 1, NULL, NULL, NULL, NULL),
	(100, '899123456701', '899123456701', 1, 1, NULL, NULL, NULL, NULL),
	(101, '899123456702', '899123456702', 1, 1, NULL, NULL, NULL, NULL),
	(102, '899123456703', '899123456703', 1, 1, NULL, NULL, NULL, NULL),
	(103, '899123456704', '899123456704', 1, 1, NULL, NULL, NULL, NULL),
	(104, '899123456705', '899123456705', 1, 1, NULL, NULL, NULL, NULL),
	(105, '899123456706', '899123456706', 1, 1, NULL, NULL, NULL, NULL),
	(106, '899123456707', '899123456707', 1, 1, NULL, NULL, NULL, NULL),
	(107, '899123456708', '899123456708', 1, 1, NULL, NULL, NULL, NULL),
	(108, '899123456709', '899123456709', 1, 1, NULL, NULL, NULL, NULL),
	(109, '899123456710', '899123456710', 1, 1, NULL, NULL, NULL, NULL),
	(110, '899123456711', '899123456711', 1, 1, NULL, NULL, NULL, NULL),
	(111, '899123456712', '899123456712', 1, 1, NULL, NULL, NULL, NULL),
	(112, '899123456713', '899123456713', 1, 1, NULL, NULL, NULL, NULL),
	(113, '899123456714', '899123456714', 1, 1, NULL, NULL, NULL, NULL),
	(114, '899123456715', '899123456715', 1, 1, NULL, NULL, NULL, NULL),
	(115, '899123456716', '899123456716', 1, 1, NULL, NULL, NULL, NULL),
	(116, '899123456717', '899123456717', 1, 1, NULL, NULL, NULL, NULL),
	(117, '899123456718', '899123456718', 1, 1, NULL, NULL, NULL, NULL),
	(118, '899123456719', '899123456719', 1, 1, NULL, NULL, NULL, NULL),
	(119, '899123456720', '899123456720', 1, 1, NULL, NULL, NULL, NULL),
	(120, '899123456721', '899123456721', 1, 1, NULL, NULL, NULL, NULL),
	(121, '899123456722', '899123456722', 1, 1, NULL, NULL, NULL, NULL),
	(122, '899123456723', '899123456723', 1, 1, NULL, NULL, NULL, NULL),
	(123, '899123456724', '899123456724', 1, 1, NULL, NULL, NULL, NULL),
	(124, '899123456725', '899123456725', 1, 1, NULL, NULL, NULL, NULL),
	(125, '899123456726', '899123456726', 1, 1, NULL, NULL, NULL, NULL),
	(126, '899123456727', '899123456727', 1, 1, NULL, NULL, NULL, NULL),
	(127, '899123456728', '899123456728', 1, 1, NULL, NULL, NULL, NULL),
	(128, '899123456729', '899123456729', 1, 1, NULL, NULL, NULL, NULL),
	(129, '899123456730', '899123456730', 1, 1, NULL, NULL, NULL, NULL),
	(130, '899123456731', '899123456731', 1, 1, NULL, NULL, NULL, NULL),
	(131, '899123456732', '899123456732', 1, 1, NULL, NULL, NULL, NULL),
	(132, '899123456733', '899123456733', 1, 1, NULL, NULL, NULL, NULL),
	(133, '899123456734', '899123456734', 1, 1, NULL, NULL, NULL, NULL),
	(134, '899123456735', '899123456735', 1, 1, NULL, NULL, NULL, NULL),
	(135, '899123456736', '899123456736', 1, 1, NULL, NULL, NULL, NULL),
	(136, '899123456737', '899123456737', 1, 1, NULL, NULL, NULL, NULL),
	(137, '899123456738', '899123456738', 1, 1, NULL, NULL, NULL, NULL),
	(138, '899123456739', '899123456739', 1, 1, NULL, NULL, NULL, NULL),
	(139, '899123456740', '899123456740', 1, 1, NULL, NULL, NULL, NULL),
	(140, '899123456741', '899123456741', 1, 1, NULL, NULL, NULL, NULL),
	(141, '899123456742', '899123456742', 1, 1, NULL, NULL, NULL, NULL),
	(142, '899123456743', '899123456743', 1, 1, NULL, NULL, NULL, NULL),
	(143, '899123456744', '899123456744', 1, 1, NULL, NULL, NULL, NULL),
	(144, '899123456745', '899123456745', 1, 1, NULL, NULL, NULL, NULL),
	(145, '899123456746', '899123456746', 1, 1, NULL, NULL, NULL, NULL),
	(146, '899123456747', '899123456747', 1, 1, NULL, NULL, NULL, NULL),
	(147, '899123456748', '899123456748', 1, 1, NULL, NULL, NULL, NULL),
	(148, '899123456749', '899123456749', 1, 1, NULL, NULL, NULL, NULL),
	(149, '899123456750', '899123456750', 1, 1, NULL, NULL, NULL, NULL),
	(2100, '9900000001', '9900000001', 1, 1, NULL, NULL, NULL, NULL),
	(2101, '9900000002', '9900000002', 1, 1, NULL, NULL, NULL, NULL),
	(2102, '9900000003', '9900000003', 1, 1, NULL, NULL, NULL, NULL),
	(2103, '9900000004', '9900000004', 1, 1, NULL, NULL, NULL, NULL),
	(2104, '9900000005', '9900000005', 1, 1, NULL, NULL, NULL, NULL),
	(2105, '9900000006', '9900000006', 1, 1, NULL, NULL, NULL, NULL),
	(2106, '9900000007', '9900000007', 1, 1, NULL, NULL, NULL, NULL),
	(2107, '9900000008', '9900000008', 1, 1, NULL, NULL, NULL, NULL),
	(2108, '9900000009', '9900000009', 1, 1, NULL, NULL, NULL, NULL),
	(2109, '9900000010', '9900000010', 1, 1, NULL, NULL, NULL, NULL),
	(2110, '9900000011', '9900000011', 1, 1, NULL, NULL, NULL, NULL),
	(2111, '9900000012', '9900000012', 1, 1, NULL, NULL, NULL, NULL),
	(2112, '9900000013', '9900000013', 1, 1, NULL, NULL, NULL, NULL),
	(2113, '9900000014', '9900000014', 1, 1, NULL, NULL, NULL, NULL),
	(2114, '9900000015', '9900000015', 1, 1, NULL, NULL, NULL, NULL),
	(2115, '9900000016', '9900000016', 1, 1, NULL, NULL, NULL, NULL),
	(2116, '9900000017', '9900000017', 1, 1, NULL, NULL, NULL, NULL),
	(2117, '9900000018', '9900000018', 1, 1, NULL, NULL, NULL, NULL),
	(2118, '9900000019', '9900000019', 1, 1, NULL, NULL, NULL, NULL),
	(2119, '9900000020', '9900000020', 1, 1, NULL, NULL, NULL, NULL),
	(2120, '9900000021', '9900000021', 1, 1, NULL, NULL, NULL, NULL),
	(2121, '9900000022', '9900000022', 1, 1, NULL, NULL, NULL, NULL),
	(2122, '9900000023', '9900000023', 1, 1, NULL, NULL, NULL, NULL),
	(2123, '9900000024', '9900000024', 1, 1, NULL, NULL, NULL, NULL),
	(2124, '9900000025', '9900000025', 1, 1, NULL, NULL, NULL, NULL),
	(2125, '9900000026', '9900000026', 1, 1, NULL, NULL, NULL, NULL),
	(2126, '9900000027', '9900000027', 1, 1, NULL, NULL, NULL, NULL),
	(2127, '9900000028', '9900000028', 1, 1, NULL, NULL, NULL, NULL),
	(2128, '9900000029', '9900000029', 1, 1, NULL, NULL, NULL, NULL),
	(2129, '9900000030', '9900000030', 1, 1, NULL, NULL, NULL, NULL),
	(2130, '9900000031', '9900000031', 1, 1, NULL, NULL, NULL, NULL),
	(2131, '9900000032', '9900000032', 1, 1, NULL, NULL, NULL, NULL),
	(2132, '9900000033', '9900000033', 1, 1, NULL, NULL, NULL, NULL),
	(2133, '9900000034', '9900000034', 1, 1, NULL, NULL, NULL, NULL),
	(2134, '9900000035', '9900000035', 1, 1, NULL, NULL, NULL, NULL),
	(2135, '9900000036', '9900000036', 1, 1, NULL, NULL, NULL, NULL),
	(2136, '9900000037', '9900000037', 1, 1, NULL, NULL, NULL, NULL),
	(2137, '9900000038', '9900000038', 1, 1, NULL, NULL, NULL, NULL),
	(2138, '9900000039', '9900000039', 1, 1, NULL, NULL, NULL, NULL),
	(2139, '9900000040', '9900000040', 1, 1, NULL, NULL, NULL, NULL),
	(2140, '9900000041', '9900000041', 1, 1, NULL, NULL, NULL, NULL),
	(2141, '9900000042', '9900000042', 1, 1, NULL, NULL, NULL, NULL),
	(2142, '9900000043', '9900000043', 1, 1, NULL, NULL, NULL, NULL),
	(2143, '9900000044', '9900000044', 1, 1, NULL, NULL, NULL, NULL),
	(2144, '9900000045', '9900000045', 1, 1, NULL, NULL, NULL, NULL),
	(2145, '9900000046', '9900000046', 1, 1, NULL, NULL, NULL, NULL),
	(2146, '9900000047', '9900000047', 1, 1, NULL, NULL, NULL, NULL),
	(2147, '9900000048', '9900000048', 1, 1, NULL, NULL, NULL, NULL),
	(2148, '9900000049', '9900000049', 1, 1, NULL, NULL, NULL, NULL),
	(2149, '9900000050', '9900000050', 1, 1, NULL, NULL, NULL, NULL),
	(2150, '9900000051', '9900000051', 1, 1, NULL, NULL, NULL, NULL),
	(2151, '9900000052', '9900000052', 1, 1, NULL, NULL, NULL, NULL),
	(2152, '9900000053', '9900000053', 1, 1, NULL, NULL, NULL, NULL),
	(2153, '9900000054', '9900000054', 1, 1, NULL, NULL, NULL, NULL),
	(2154, '9900000055', '9900000055', 1, 1, NULL, NULL, NULL, NULL),
	(2155, '9900000056', '9900000056', 1, 1, NULL, NULL, NULL, NULL),
	(2156, '9900000057', '9900000057', 1, 1, NULL, NULL, NULL, NULL),
	(2157, '9900000058', '9900000058', 1, 1, NULL, NULL, NULL, NULL),
	(2158, '9900000059', '9900000059', 1, 1, NULL, NULL, NULL, NULL),
	(2159, '9900000060', '9900000060', 1, 1, NULL, NULL, NULL, NULL),
	(2160, '9900000061', '9900000061', 1, 1, NULL, NULL, NULL, NULL),
	(2161, '9900000062', '9900000062', 1, 1, NULL, NULL, NULL, NULL),
	(2162, '9900000063', '9900000063', 1, 1, NULL, NULL, NULL, NULL),
	(2163, '9900000064', '9900000064', 1, 1, NULL, NULL, NULL, NULL),
	(2164, '9900000065', '9900000065', 1, 1, NULL, NULL, NULL, NULL),
	(2165, '9900000066', '9900000066', 1, 1, NULL, NULL, NULL, NULL),
	(2166, '9900000067', '9900000067', 1, 1, NULL, NULL, NULL, NULL),
	(2167, '9900000068', '9900000068', 1, 1, NULL, NULL, NULL, NULL),
	(2168, '9900000069', '9900000069', 1, 1, NULL, NULL, NULL, NULL),
	(2169, '9900000070', '9900000070', 1, 1, NULL, NULL, NULL, NULL),
	(2170, '9900000071', '9900000071', 1, 1, NULL, NULL, NULL, NULL),
	(2171, '9900000072', '9900000072', 1, 1, NULL, NULL, NULL, NULL),
	(2172, '9900000073', '9900000073', 1, 1, NULL, NULL, NULL, NULL),
	(2173, '9900000074', '9900000074', 1, 1, NULL, NULL, NULL, NULL),
	(2174, '9900000075', '9900000075', 1, 1, NULL, NULL, NULL, NULL),
	(2175, '9900000076', '9900000076', 1, 1, NULL, NULL, NULL, NULL),
	(2176, '9900000077', '9900000077', 1, 1, NULL, NULL, NULL, NULL),
	(2177, '9900000078', '9900000078', 1, 1, NULL, NULL, NULL, NULL),
	(2178, '9900000079', '9900000079', 1, 1, NULL, NULL, NULL, NULL),
	(2179, '9900000080', '9900000080', 1, 1, NULL, NULL, NULL, NULL),
	(2180, '9900000081', '9900000081', 1, 1, NULL, NULL, NULL, NULL),
	(2181, '9900000082', '9900000082', 1, 1, NULL, NULL, NULL, NULL),
	(2182, '9900000083', '9900000083', 1, 1, NULL, NULL, NULL, NULL),
	(2183, '9900000084', '9900000084', 1, 1, NULL, NULL, NULL, NULL),
	(2184, '9900000085', '9900000085', 1, 1, NULL, NULL, NULL, NULL),
	(2185, '9900000086', '9900000086', 1, 1, NULL, NULL, NULL, NULL),
	(2186, '9900000087', '9900000087', 1, 1, NULL, NULL, NULL, NULL),
	(2187, '9900000088', '9900000088', 1, 1, NULL, NULL, NULL, NULL),
	(2188, '9900000089', '9900000089', 1, 1, NULL, NULL, NULL, NULL),
	(2189, '9900000090', '9900000090', 1, 1, NULL, NULL, NULL, NULL),
	(2190, '9900000091', '9900000091', 1, 1, NULL, NULL, NULL, NULL),
	(2191, '9900000092', '9900000092', 1, 1, NULL, NULL, NULL, NULL),
	(2192, '9900000093', '9900000093', 1, 1, NULL, NULL, NULL, NULL),
	(2193, '9900000094', '9900000094', 1, 1, NULL, NULL, NULL, NULL),
	(2194, '9900000095', '9900000095', 1, 1, NULL, NULL, NULL, NULL),
	(2195, '9900000096', '9900000096', 1, 1, NULL, NULL, NULL, NULL),
	(2196, '9900000097', '9900000097', 1, 1, NULL, NULL, NULL, NULL),
	(2197, '9900000098', '9900000098', 1, 1, NULL, NULL, NULL, NULL),
	(2198, '9900000099', '9900000099', 1, 1, NULL, NULL, NULL, NULL),
	(2199, '9900000100', '9900000100', 1, 1, NULL, NULL, NULL, NULL);

-- Dumping structure for table pos_supermarket.item_category
CREATE TABLE IF NOT EXISTS `item_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_parent` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `presence` int(11) NOT NULL DEFAULT 1,
  `inputBy` int(11) DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.item_category: ~46 rows (approximately)
INSERT INTO `item_category` (`id`, `id_parent`, `name`, `status`, `presence`, `inputBy`, `inputDate`, `updateBy`, `updateDate`) VALUES
	(1, 0, 'Food', 1, 1, 1, 1653024459, 1, 1654232884),
	(2, 1, 'Fish Market', 1, 1, 1, 1653024459, 1, 1654664752),
	(3, 2, 'Udang', 1, 1, 1, NULL, 1, 1654665802),
	(4, 2, 'Ikan', 1, 1, 1, 1654233826, 1, 1654665812),
	(5, 0, 'Cleaning', 1, 1, 1, 1654236577, 1, 1654664748),
	(6, 0, 'Non Food', 1, 1, 1, 1654236689, 1, 1654565401),
	(7, 6, 'Perawatan Kendaraan', 1, 1, 1, 1654236701, 1, 1654565944),
	(8, 1, 'Snacks', 1, 1, 1, 1654565193, 1, 1654565193),
	(9, 1, 'Minuman', 1, 1, 1, 1654565205, 1, 1654565513),
	(10, 1, 'Fresh Product', 1, 1, 1, 1654565212, 1, 1654565792),
	(11, 1, 'Bahan Pokok', 1, 1, 1, 1654565224, 1, 1654565462),
	(12, 11, 'Beras', 1, 1, 1, 1654565472, 1, 1654565472),
	(13, 11, 'Minyak Goreng', 1, 1, 1, 1654565478, 1, 1654565478),
	(14, 11, 'Tepung', 1, 1, 1, 1654565485, 1, 1654565485),
	(15, 11, 'Telur', 1, 1, 1, 1654565554, 1, 1654565554),
	(16, 9, 'Susu', 1, 1, 1, 1654565578, 1, 1654565578),
	(17, 9, 'Soda', 1, 1, 1, 1654565583, 1, 1654565583),
	(18, 9, 'Juice', 1, 1, 1, 1654565606, 1, 1654565606),
	(19, 9, 'Energi / Suplemen', 1, 1, 1, 1654565617, 1, 1654566218),
	(20, 9, 'Air Mineral', 1, 1, 1, 1654565626, 1, 1654565626),
	(21, 8, 'Snack Pabrik', 1, 1, 1, 1654565691, 1, 1654565691),
	(22, 8, 'Snack Repacking', 1, 1, 1, 1654565702, 1, 1654565702),
	(23, 8, 'Snack Curah', 1, 1, 1, 1654565729, 1, 1654565729),
	(24, 10, 'Sayuran', 1, 1, 1, 1654565799, 1, 1654565799),
	(25, 10, 'Buah', 1, 1, 1, 1654565803, 1, 1654565803),
	(26, 6, 'Perawatan Tubuh', 1, 1, 1, 1654565838, 1, 1654565838),
	(27, 6, 'Bahan dan Peralatan Cuci', 1, 1, 1, 1654565855, 1, 1656502020),
	(28, 6, 'Perawatan Rumah', 1, 1, 1, 1654565870, 1, 1654565870),
	(29, 6, 'Alat Tulis dan Kantor', 1, 1, 1, 1654565889, 1, 1654565889),
	(30, 26, 'Shampoo', 1, 1, 1, 1654565958, 1, 1654565958),
	(31, 26, 'Sabun Mandi', 1, 1, 1, 1654565963, 1, 1654565963),
	(32, 26, 'Pasta Gigi', 1, 1, 1, 1654565974, 1, 1654565974),
	(33, 26, 'Kosmetik', 1, 1, 1, 1654565980, 1, 1654565980),
	(34, 28, 'Pembersih Kamar Mandi', 1, 1, 1, 1654566002, 1, 1654566002),
	(35, 28, 'Pembersih Kaca', 1, 1, 1, 1654566012, 1, 1654566012),
	(36, 28, 'Pembersih Lantai', 1, 1, 1, 1654566022, 1, 1654566022),
	(37, 28, 'Alat Kebersihan', 1, 1, 1, 1654566034, 1, 1654566034),
	(38, 27, 'Deterjen', 1, 1, 1, 1654566051, 1, 1654566051),
	(39, 27, 'Pelembut dan Pewangi', 1, 1, 1, 1654566058, 1, 1654566058),
	(40, 27, 'Sabun Cuci Piring', 1, 1, 1, 1654566075, 1, 1654566075),
	(41, 27, 'Pemutih Pakaian', 1, 1, 1, 1654566087, 1, 1654566087),
	(42, 29, 'Buku', 1, 1, 1, 1654566099, 1, 1654566099),
	(43, 29, 'Alat Tulis', 1, 1, 1, 1654566106, 1, 1654566106),
	(44, 7, 'Sabun Mobil', 1, 1, 1, 1654566125, 1, 1654566125),
	(45, 7, 'Peralatan pembersih kendaraan', 1, 1, 1, 1654566138, 1, 1654566138),
	(46, 14, 'Sagu', 1, 1, 1, 1656497534, 1, 1656497534);

-- Dumping structure for table pos_supermarket.item_discount
CREATE TABLE IF NOT EXISTS `item_discount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `presence` int(11) NOT NULL,
  `inputBy` int(11) DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.item_discount: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.item_tax
CREATE TABLE IF NOT EXISTS `item_tax` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `presence` int(11) NOT NULL DEFAULT 1,
  `inputBy` int(11) DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.item_tax: ~2 rows (approximately)
INSERT INTO `item_tax` (`id`, `description`, `status`, `presence`, `inputBy`, `inputDate`, `updateBy`, `updateDate`) VALUES
	(2, 'Enable', 1, 1, NULL, NULL, NULL, NULL),
	(3, 'Disable', 1, 1, NULL, NULL, NULL, NULL);

-- Dumping structure for table pos_supermarket.item_uom
CREATE TABLE IF NOT EXISTS `item_uom` (
  `id` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `presence` int(11) NOT NULL DEFAULT 1,
  `inputBy` int(11) DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.item_uom: ~4 rows (approximately)
INSERT INTO `item_uom` (`id`, `name`, `description`, `status`, `presence`, `inputBy`, `inputDate`, `updateBy`, `updateDate`) VALUES
	('UOM0001', 'Bag', 'Kilogram ', 1, 1, 1, 1652960737, 1, 1656501138),
	('UOM0002', 'Pcs', 'Piece', 1, 1, 1, 1653024577, 1, 1654567712),
	('UOM0003', 'Box', 'Box ', 1, 1, 1, 1653024577, 1, 1654567720),
	('UOM0004', 'Btl', 'Bottle', 1, 1, 1, 1654567814, 1, 1656501301);

-- Dumping structure for table pos_supermarket.kiosk_cart
CREATE TABLE IF NOT EXISTS `kiosk_cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kioskUuid` varchar(50) DEFAULT NULL,
  `promotionId` varchar(50) DEFAULT NULL,
  `promotionItemId` int(11) DEFAULT NULL,
  `promotionFreeId` int(11) DEFAULT NULL,
  `promotionDiscountId` varchar(50) DEFAULT NULL,
  `itemId` varchar(50) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `originPrice` double DEFAULT 0,
  `discount` double DEFAULT 0,
  `price` double DEFAULT 0,
  `memberDiscountPercent` double DEFAULT 0,
  `memberDiscountAmount` double DEFAULT 0,
  `validationNota` int(1) DEFAULT 0,
  `isPriceEdit` int(1) DEFAULT 0,
  `isFreeItem` varchar(50) NOT NULL DEFAULT '',
  `isSpecialPrice` int(1) NOT NULL DEFAULT 0,
  `isPrintOnBill` int(1) NOT NULL DEFAULT 1,
  `photo` longtext DEFAULT NULL,
  `void` int(11) NOT NULL DEFAULT 0,
  `note` varchar(250) DEFAULT NULL,
  `presence` int(1) NOT NULL DEFAULT 1,
  `updateBy` varchar(50) DEFAULT NULL,
  `inputDate` datetime NOT NULL DEFAULT '2023-01-01 00:00:00',
  `updateDate` datetime NOT NULL DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=658 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.kiosk_cart: ~39 rows (approximately)
INSERT INTO `kiosk_cart` (`id`, `kioskUuid`, `promotionId`, `promotionItemId`, `promotionFreeId`, `promotionDiscountId`, `itemId`, `barcode`, `originPrice`, `discount`, `price`, `memberDiscountPercent`, `memberDiscountAmount`, `validationNota`, `isPriceEdit`, `isFreeItem`, `isSpecialPrice`, `isPrintOnBill`, `photo`, `void`, `note`, `presence`, `updateBy`, `inputDate`, `updateDate`) VALUES
	(476, 'T01.260407.0276', 'occella5', 8, NULL, NULL, '899123456740', '899123456740', 130000, 65000, 65000, 0, 0, 0, 0, '', 0, 1, NULL, 1, '[void] manual void item', 1, NULL, '2026-04-07 08:07:45', '2026-04-07 08:07:45'),
	(477, 'T01.260407.0276', 'occella5', 8, NULL, NULL, '899123456740', '899123456740', 130000, 65000, 65000, 0, 0, 0, 0, '', 0, 1, NULL, 1, '[void] manual void item', 1, NULL, '2026-04-07 08:09:11', '2026-04-07 08:09:11'),
	(478, 'T01.260407.0279', 'occella5', 8, NULL, NULL, '899123456740', '899123456740', 130000, 65000, 65000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 08:13:25', '2026-04-07 08:13:25'),
	(479, 'T01.260407.0276', 'occella5', 8, NULL, NULL, '899123456740', '899123456740', 130000, 65000, 65000, 0, 0, 0, 0, '', 0, 1, NULL, 1, '[void] manual void item', 1, NULL, '2026-04-07 08:20:10', '2026-04-07 08:20:10'),
	(480, 'T01.260407.0280', 'occella5', 8, NULL, NULL, '899123456740', '899123456740', 130000, 65000, 65000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 08:23:26', '2026-04-07 08:23:26'),
	(481, 'T01.260407.0276', 'occella5', 8, NULL, NULL, '899123456740', '899123456740', 130000, 65000, 65000, 0, 0, 0, 0, '', 0, 1, NULL, 1, '[void] manual void item', 1, NULL, '2026-04-07 08:39:00', '2026-04-07 08:39:00'),
	(482, 'T01.260407.0276', 'occella5', 8, NULL, NULL, '899123456740', '899123456740', 130000, 65000, 65000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 08:39:24', '2026-04-07 08:39:24'),
	(483, 'T01.260407.0276', 'occella5', 8, NULL, NULL, '899123456740', '899123456740', 130000, 65000, 65000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 09:14:47', '2026-04-07 09:14:47'),
	(484, 'T01.260407.0281', 'occella7', 9, NULL, NULL, '899123456750', '899123456750', 400000, 350001, 49999, 0, 0, 0, 0, '', 0, 1, NULL, 1, '[void] manual void item', 1, NULL, '2026-04-07 09:25:38', '2026-04-07 09:25:38'),
	(485, 'T01.260407.0281', 'occella7', 9, NULL, NULL, '899123456750', '899123456750', 400000, 350001, 49999, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 09:26:15', '2026-04-07 09:26:15'),
	(486, 'T01.260407.0281', 'occella4', 7, NULL, NULL, '899123456730', '899123456730', 310000, 136400, 173600, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 09:26:34', '2026-04-07 09:26:34'),
	(487, 'T01.260407.0281', 'occella3', 6, NULL, NULL, '899123456721', '899123456721', 350000, 99999, 250001, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 09:31:46', '2026-04-07 09:31:46'),
	(488, 'T01.260407.0282', 'occella3', 6, NULL, NULL, '899123456721', '899123456721', 350000, 315000, 35000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 09:46:12', '2026-04-07 09:46:12'),
	(489, 'T01.260407.0283', NULL, NULL, NULL, NULL, '899123456706', '899123456706', 150000, 0, 150000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 10:32:39', '2026-04-07 10:32:39'),
	(490, 'T01.260407.0283', NULL, NULL, NULL, NULL, '899123456706', '899123456706', 150000, 0, 150000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 10:32:41', '2026-04-07 10:32:41'),
	(491, 'T01.260407.0283', NULL, NULL, NULL, NULL, '899123456705', '899123456705', 275000, 0, 275000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 10:32:45', '2026-04-07 10:32:45'),
	(492, 'T01.260407.0283', NULL, NULL, NULL, NULL, '899123456716', '899123456716', 180000, 0, 180000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 10:32:48', '2026-04-07 10:32:48'),
	(493, 'T01.260407.0284', NULL, NULL, NULL, NULL, '899123456706', '899123456706', 150000, 0, 150000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-07 10:38:21', '2026-04-07 10:38:21'),
	(632, 'T01.260408.0289', 'occella4', 7, NULL, NULL, '899123456730', '899123456730', 310000, 136400, 173600, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 05:48:57', '2026-04-08 05:48:57'),
	(633, 'T01.260408.0289', 'occella4', 7, NULL, NULL, '899123456730', '899123456730', 310000, 136400, 173600, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 05:48:57', '2026-04-08 05:48:57'),
	(634, 'T01.260408.0289', 'occella1', NULL, 9913, NULL, '899123456704', '899123456704', 320000, 0, 320000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 05:48:58', '2026-04-08 05:48:58'),
	(635, 'T01.260408.0289', 'occella1', NULL, 9913, NULL, '899123456706', NULL, 150000, 0, 0, 0, 0, 0, 0, '1', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 05:48:58', '2026-04-08 05:48:58'),
	(636, 'T01.260408.0289', 'occella1', NULL, 9914, NULL, '899123456705', '899123456705', 275000, 0, 275000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 05:49:07', '2026-04-08 05:49:07'),
	(637, 'T01.260408.0289', 'occella1', NULL, 9914, NULL, '899123456705', '899123456705', 275000, 0, 275000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 05:49:10', '2026-04-08 05:49:10'),
	(638, 'T01.260408.0289', 'occella1', NULL, 9914, NULL, '899123456705', '899123456705', 275000, 0, 275000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 05:49:10', '2026-04-08 05:49:10'),
	(639, 'T01.260408.0289', 'occella1', NULL, 9914, NULL, '899123456706', NULL, 150000, 0, 0, 0, 0, 0, 0, '1', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 05:49:10', '2026-04-08 05:49:10'),
	(642, 'T01.260408.0290', NULL, NULL, NULL, NULL, '899123456708', '899123456708', 480000, 0, 480000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 07:03:37', '2026-04-08 07:03:37'),
	(643, 'T01.260408.0291', 'occella1', NULL, 9913, NULL, '899123456704', '899123456704', 320000, 0, 320000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 09:13:13', '2026-04-08 09:13:13'),
	(644, 'T01.260408.0291', 'occella1', NULL, 9913, NULL, '899123456706', NULL, 150000, 0, 0, 0, 0, 0, 0, '1', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 09:13:13', '2026-04-08 09:13:13'),
	(645, 'T01.260408.0291', 'occella1', NULL, 9913, NULL, '899123456704', '899123456704', 320000, 0, 320000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 09:13:14', '2026-04-08 09:13:14'),
	(646, 'T01.260408.0291', 'occella1', NULL, 9913, NULL, '899123456706', NULL, 150000, 0, 0, 0, 0, 0, 0, '1', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 09:13:14', '2026-04-08 09:13:14'),
	(647, 'T01.260408.0292', 'occella1', NULL, 9913, NULL, '899123456704', '899123456704', 320000, 0, 320000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 09:18:03', '2026-04-08 09:18:03'),
	(648, 'T01.260408.0292', 'occella1', NULL, 9913, NULL, '899123456706', NULL, 150000, 0, 0, 0, 0, 0, 0, '1', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 09:18:03', '2026-04-08 09:18:03'),
	(649, 'T01.260408.0292', 'occella1', NULL, 9913, NULL, '899123456704', '899123456704', 320000, 0, 320000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 09:18:29', '2026-04-08 09:18:29'),
	(650, 'T01.260408.0292', 'occella1', NULL, 9913, NULL, '899123456706', NULL, 150000, 0, 0, 0, 0, 0, 0, '1', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 09:18:29', '2026-04-08 09:18:29'),
	(654, 'T01.260408.0293', NULL, NULL, NULL, NULL, '899123456731', '899123456731', 285000, 0, 285000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 09:30:28', '2026-04-08 09:30:28'),
	(655, 'T01.260408.0293', 'occella4', 7, NULL, NULL, '899123456730', '899123456730', 310000, 136400, 173600, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 09:30:33', '2026-04-08 09:30:33'),
	(656, 'T01.260408.0295', 'occella1', NULL, 9912, NULL, '899123456703', '899123456703', 175000, 0, 175000, 0, 0, 0, 0, '', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 10:07:24', '2026-04-08 10:07:24'),
	(657, 'T01.260408.0295', 'occella1', NULL, 9912, NULL, '899123456703', NULL, 175000, 0, 0, 0, 0, 0, 0, '1', 0, 1, NULL, 0, NULL, 1, NULL, '2026-04-08 10:07:24', '2026-04-08 10:07:24');

-- Dumping structure for table pos_supermarket.kiosk_cart_free_item
CREATE TABLE IF NOT EXISTS `kiosk_cart_free_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kioskUuid` varchar(50) DEFAULT NULL,
  `promotionId` varchar(50) DEFAULT NULL,
  `promotionFreeId` int(11) DEFAULT NULL,
  `itemId` varchar(50) DEFAULT NULL,
  `freeItemId` varchar(50) DEFAULT NULL,
  `kioskCartId` varchar(50) DEFAULT NULL,
  `useBykioskUuidId` varchar(50) DEFAULT NULL,
  `originPrice` int(11) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `scanFree` tinyint(4) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `printOnBill` tinyint(4) DEFAULT NULL,
  `void` tinyint(4) DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `presence` tinyint(4) DEFAULT NULL,
  `inputDate` varchar(50) DEFAULT NULL,
  `updateDate` varchar(50) DEFAULT NULL,
  `updateBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.kiosk_cart_free_item: ~7 rows (approximately)
INSERT INTO `kiosk_cart_free_item` (`id`, `kioskUuid`, `promotionId`, `promotionFreeId`, `itemId`, `freeItemId`, `kioskCartId`, `useBykioskUuidId`, `originPrice`, `barcode`, `scanFree`, `price`, `printOnBill`, `void`, `status`, `presence`, `inputDate`, `updateDate`, `updateBy`) VALUES
	(206, 'T01.260408.0289', 'occella1', 9913, '899123456704', '899123456706', '635', NULL, 150000, NULL, 0, 0, 0, 0, 1, 1, '2026-04-08 05:48:58', '2026-04-08 05:48:58', NULL),
	(207, 'T01.260408.0289', 'occella1', 9914, '899123456705', '899123456706', '639', NULL, 150000, NULL, 0, 0, 0, 0, 1, 1, '2026-04-08 05:49:10', '2026-04-08 05:49:10', NULL),
	(208, 'T01.260408.0291', 'occella1', 9913, '899123456704', '899123456706', '644', NULL, 150000, NULL, 0, 0, 0, 0, 1, 1, '2026-04-08 09:13:13', '2026-04-08 09:13:13', NULL),
	(209, 'T01.260408.0291', 'occella1', 9913, '899123456704', '899123456706', '646', NULL, 150000, NULL, 0, 0, 0, 0, 1, 1, '2026-04-08 09:13:14', '2026-04-08 09:13:14', NULL),
	(210, 'T01.260408.0292', 'occella1', 9913, '899123456704', '899123456706', '648', NULL, 150000, NULL, 0, 0, 0, 0, 1, 1, '2026-04-08 09:18:03', '2026-04-08 09:18:03', NULL),
	(211, 'T01.260408.0292', 'occella1', 9913, '899123456704', '899123456706', '650', NULL, 150000, NULL, 0, 0, 0, 0, 1, 1, '2026-04-08 09:18:29', '2026-04-08 09:18:29', NULL),
	(213, 'T01.260408.0295', 'occella1', 9912, '899123456703', '899123456703', '657', NULL, 175000, NULL, 0, 0, 0, 0, 1, 1, '2026-04-08 10:07:24', '2026-04-08 10:07:24', NULL);

-- Dumping structure for table pos_supermarket.kiosk_paid_pos
CREATE TABLE IF NOT EXISTS `kiosk_paid_pos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kioskUuid` varchar(50) NOT NULL,
  `paymentTypeId` varchar(50) DEFAULT NULL,
  `paymentNameId` varchar(50) DEFAULT NULL,
  `approvedCode` varchar(50) DEFAULT NULL,
  `refCode` varchar(50) DEFAULT NULL,
  `paid` int(11) DEFAULT 0,
  `deviceId` varchar(50) DEFAULT NULL,
  `cardId` varchar(50) DEFAULT NULL,
  `voucherNumber` varchar(50) DEFAULT NULL,
  `note` varchar(250) DEFAULT NULL,
  `externalTransId` varchar(50) DEFAULT NULL,
  `startDate` datetime DEFAULT '2023-01-01 00:00:00',
  `input_date` datetime DEFAULT '2023-01-01 00:00:00',
  `update_date` datetime DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.kiosk_paid_pos: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.kiosk_uuid
CREATE TABLE IF NOT EXISTS `kiosk_uuid` (
  `kioskUuid` varchar(50) NOT NULL,
  `exchange` varchar(50) NOT NULL,
  `cashierId` varchar(50) NOT NULL,
  `terminalId` varchar(50) DEFAULT NULL,
  `storeOutlesId` varchar(50) DEFAULT NULL,
  `memberId` varchar(50) DEFAULT NULL,
  `photo` longtext DEFAULT NULL,
  `ilock` int(1) DEFAULT 0,
  `presence` int(1) DEFAULT 1,
  `status` int(1) DEFAULT 1,
  `inputDate` int(11) DEFAULT NULL,
  `startDate` datetime DEFAULT '2023-01-01 00:00:00',
  `input_date` datetime DEFAULT '2023-01-01 00:00:00',
  `update_date` datetime DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`kioskUuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.kiosk_uuid: ~15 rows (approximately)
INSERT INTO `kiosk_uuid` (`kioskUuid`, `exchange`, `cashierId`, `terminalId`, `storeOutlesId`, `memberId`, `photo`, `ilock`, `presence`, `status`, `inputDate`, `startDate`, `input_date`, `update_date`) VALUES
	('T01.260407.0276', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 0, 1775548269, '2023-01-01 00:00:00', '2026-04-07 07:51:09', '2026-04-07 09:15:00'),
	('T01.260407.0277', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 1, 1775548729, '2023-01-01 00:00:00', '2026-04-07 07:58:49', '2026-04-07 07:58:49'),
	('T01.260407.0278', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 1, 1775549190, '2023-01-01 00:00:00', '2026-04-07 08:06:30', '2026-04-07 08:06:30'),
	('T01.260407.0279', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 1, 1775549605, '2023-01-01 00:00:00', '2026-04-07 08:13:25', '2026-04-07 08:13:25'),
	('T01.260407.0280', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 1, 1775550206, '2023-01-01 00:00:00', '2026-04-07 08:23:26', '2026-04-07 08:23:26'),
	('T01.260407.0281', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 0, 1775553331, '2023-01-01 00:00:00', '2026-04-07 09:15:31', '2026-04-07 09:46:10'),
	('T01.260407.0282', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 0, 1775555171, '2023-01-01 00:00:00', '2026-04-07 09:46:11', '2026-04-07 10:01:30'),
	('T01.260407.0283', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 0, 1775556165, '2023-01-01 00:00:00', '2026-04-07 10:02:45', '2026-04-07 10:35:45'),
	('T01.260407.0284', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 0, 1775558157, '2023-01-01 00:00:00', '2026-04-07 10:35:57', '2026-04-07 10:47:10'),
	('T01.260408.0289', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 0, 1775627235, '2023-01-01 00:00:00', '2026-04-08 05:47:15', '2026-04-08 05:49:24'),
	('T01.260408.0290', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 0, 1775627475, '2023-01-01 00:00:00', '2026-04-08 05:51:15', '2026-04-08 07:03:46'),
	('T01.260408.0291', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 0, 1775633305, '2023-01-01 00:00:00', '2026-04-08 07:28:25', '2026-04-08 09:13:28'),
	('T01.260408.0292', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 0, 1775639629, '2023-01-01 00:00:00', '2026-04-08 09:13:49', '2026-04-08 09:20:50'),
	('T01.260408.0293', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 0, 1775640219, '2023-01-01 00:00:00', '2026-04-08 09:23:39', '2026-04-08 09:33:49'),
	('T01.260408.0295', '', '123123', 'T01', 'OT99', NULL, NULL, 0, 1, 1, 1775641649, '2023-01-01 00:00:00', '2026-04-08 09:47:29', '2026-04-08 09:47:29');

-- Dumping structure for table pos_supermarket.member
CREATE TABLE IF NOT EXISTS `member` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(250) NOT NULL DEFAULT 'no name',
  `status` varchar(50) NOT NULL DEFAULT '1',
  `expDate` varchar(50) NOT NULL DEFAULT '2024-01-01',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.member: ~2 rows (approximately)
INSERT INTO `member` (`id`, `name`, `status`, `expDate`) VALUES
	('000001', 'Maria', '1', '2036-01-01'),
	('000002', 'John Wo', '1', '2036-01-01');

-- Dumping structure for table pos_supermarket.payment_bca_ecr
CREATE TABLE IF NOT EXISTS `payment_bca_ecr` (
  `transactionId` varchar(50) NOT NULL,
  `kioskUuid` varchar(50) DEFAULT NULL,
  `paymentTypeId` varchar(250) DEFAULT NULL,
  `respCode` varchar(250) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `pan` varchar(50) DEFAULT NULL,
  `expiryDate` varchar(4) DEFAULT NULL,
  `rrn` varchar(50) DEFAULT NULL,
  `approvalCode` varchar(50) DEFAULT NULL,
  `dateTime` varchar(50) DEFAULT NULL,
  `merchantId` varchar(50) DEFAULT NULL,
  `terminalId` varchar(50) DEFAULT NULL,
  `cardHolderName` varchar(50) DEFAULT NULL,
  `invoiceNumber` varchar(50) DEFAULT NULL,
  `hex` longtext DEFAULT NULL,
  `asciiString` longtext DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`transactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.payment_bca_ecr: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.payment_bca_qris
CREATE TABLE IF NOT EXISTS `payment_bca_qris` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kioskUuid` varchar(50) NOT NULL,
  `reffNo` varchar(50) DEFAULT NULL,
  `hex` longtext DEFAULT NULL,
  `asciiString` longtext DEFAULT NULL,
  `respAscii` longtext DEFAULT NULL,
  `respHex` longtext DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `presence` int(11) NOT NULL DEFAULT 1,
  `inputDate` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.payment_bca_qris: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.payment_method
CREATE TABLE IF NOT EXISTS `payment_method` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `paymentTypeId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.payment_method: ~5 rows (approximately)
INSERT INTO `payment_method` (`id`, `paymentTypeId`) VALUES
	(1, 'BCA01'),
	(2, 'BCA31'),
	(3, 'ID0007'),
	(4, 'QRT001'),
	(5, 'CASH');

-- Dumping structure for table pos_supermarket.payment_name
CREATE TABLE IF NOT EXISTS `payment_name` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `status` int(2) NOT NULL DEFAULT 1,
  `img` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.payment_name: ~13 rows (approximately)
INSERT INTO `payment_name` (`id`, `name`, `status`, `img`) VALUES
	(10, 'BCA DEBIT', 1, ''),
	(11, 'BCA VISA', 1, ''),
	(12, 'BCA MASTERCARD', 1, ''),
	(20, 'MANDIRI DEBIT', 1, ''),
	(21, 'MANDIRI VISA', 1, ''),
	(22, 'MANDIRI MASTERCARD', 1, ''),
	(30, 'BRI DEBIT', 1, ''),
	(31, 'BRI VISA', 1, ''),
	(32, 'BRI MASTERCARD', 1, ''),
	(40, 'BNI DEBIT', 1, ''),
	(41, 'BNI VISA', 1, ''),
	(42, 'BNI MASTERCARD', 1, ''),
	(101, 'DIGITAL MONEY', 1, '');

-- Dumping structure for table pos_supermarket.payment_qris_telkom
CREATE TABLE IF NOT EXISTS `payment_qris_telkom` (
  `kioskUuid` varchar(50) NOT NULL,
  `cliTrxNumber` varchar(50) DEFAULT NULL,
  `cliTrxAmount` int(11) DEFAULT NULL,
  `qris_status` varchar(50) DEFAULT NULL,
  `qris_payment_customername` varchar(50) DEFAULT NULL,
  `qris_payment_methodby` varchar(50) DEFAULT NULL,
  `transactionId` varchar(50) DEFAULT NULL,
  `status` int(11) DEFAULT 0,
  `presence` int(11) DEFAULT 1,
  `qris_content` longtext DEFAULT NULL,
  `qris_invoiceid` varchar(50) DEFAULT NULL,
  `qris_api_version_code` varchar(50) DEFAULT NULL,
  `qris_request_date` datetime(3) DEFAULT NULL,
  `qris_nmid` varchar(50) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`kioskUuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.payment_qris_telkom: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.payment_type
CREATE TABLE IF NOT EXISTS `payment_type` (
  `id` varchar(50) NOT NULL,
  `openCashDrawer` tinyint(4) NOT NULL DEFAULT 0,
  `edc` int(1) NOT NULL DEFAULT 0,
  `label` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '',
  `connectionType` varchar(50) NOT NULL DEFAULT '',
  `com` varchar(9) NOT NULL DEFAULT '',
  `ip` varchar(20) NOT NULL DEFAULT '',
  `port` varchar(9) NOT NULL DEFAULT '',
  `apikey` varchar(50) NOT NULL DEFAULT '',
  `mId` varchar(50) NOT NULL DEFAULT '',
  `nmId` varchar(50) NOT NULL DEFAULT '',
  `merchant` varchar(50) NOT NULL DEFAULT '',
  `timeout` int(11) NOT NULL,
  `image` varchar(250) NOT NULL DEFAULT '',
  `apiUrl` varchar(250) NOT NULL DEFAULT '',
  `apiUrlStatus` varchar(250) NOT NULL DEFAULT '',
  `isLock` tinyint(4) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `presence` tinyint(4) NOT NULL DEFAULT 1,
  `inputBy` varchar(50) NOT NULL DEFAULT '',
  `inputDate` datetime NOT NULL DEFAULT '2026-01-01 00:00:00',
  `updateBy` varchar(50) NOT NULL DEFAULT '',
  `updateDate` datetime NOT NULL DEFAULT '2026-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.payment_type: ~10 rows (approximately)
INSERT INTO `payment_type` (`id`, `openCashDrawer`, `edc`, `label`, `name`, `connectionType`, `com`, `ip`, `port`, `apikey`, `mId`, `nmId`, `merchant`, `timeout`, `image`, `apiUrl`, `apiUrlStatus`, `isLock`, `status`, `presence`, `inputBy`, `inputDate`, `updateBy`, `updateDate`) VALUES
	('BCA01', 0, 0, 'BCA CARD ERC', 'BCA Debit', '', '', '', '', '', '', '', '', 0, 'http://192.168.202.72/imgs/debit-card.jpg', '', '', 1, 1, 1, '', '0000-00-00 00:00:00', '1', '0000-00-00 00:00:00'),
	('BCA31', 0, 0, 'BCA QRIS', 'BCA QRIS', '', '', '', '', '', '', '', '', 0, 'http://192.168.202.72/imgs/QRIS-BCA.jpg', '', '', 1, 1, 1, '', '0000-00-00 00:00:00', '1', '0000-00-00 00:00:00'),
	('CASH', 1, 0, 'CASH', 'CASH', '', '', '', '', '', '', '', '', 0, '', '', '', 1, 1, 1, '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	('DEBITCC', 0, 0, 'MANUAL DEBIT CARD', 'DEBIT, VISA, MASTERCARD', '', '', '', '', '', '', '', '', 0, '', '', '', 1, 1, 1, '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	('DISC.BILL', 0, 0, 'DISCOUNT BILL', 'DISCOUNT BILL', '', '', '', '', '', '', '', '', 0, '', '', '', 1, 0, 1, '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	('EDC_BCA', 0, 1, 'BCA EDC', 'BCA EDC', '', 'COM5', '', '', '', '', '', '', 0, './assets/logo/bca.png', '', '', 1, 1, 1, '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	('EDC_BRI', 0, 1, 'BRI EDC', 'BRI EDC', '', '', '', '', '', '', '', '', 0, './assets/logo/bri.png', '', '', 1, 1, 1, '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	('EDC_MANDIRI', 0, 1, 'Mandiri EDC', 'Mandiri EDC', '', 'COM8', '', '', '', '', '', '', 0, './assets/logo/mandiri.png', '', '', 1, 1, 1, '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	('QRISTELKOM', 0, 0, 'QRIS TELKOM', 'CHANDRA SUPERSTORE', '', '', '', '', '139139211206273', '195268799679', 'ID2022218237529', 'MITRALINK SOLUSI', 30, './assets/logo/qrisTelkom.png', 'https://qris.id/restapi/qris/show_qris.php', 'https://qris.id/restapi/qris/checkpaid_qris.php', 1, 0, 1, '1', '0000-00-00 00:00:00', '1', '0000-00-00 00:00:00'),
	('VOUCHER', 0, 0, 'VOUCHER', 'VOUCHER', '', '', '', '', '', '', '', '', 0, '', '', '', 1, 0, 1, '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00');

-- Dumping structure for table pos_supermarket.promotion
CREATE TABLE IF NOT EXISTS `promotion` (
  `id` varchar(50) NOT NULL,
  `typeOfPromotion` varchar(50) NOT NULL DEFAULT '',
  `storeOutlesId` varchar(50) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `description` varchar(250) DEFAULT NULL,
  `startDate` datetime DEFAULT '2026-01-01 00:00:00',
  `endDate` datetime DEFAULT '2026-01-01 00:00:00',
  `discountPercent` double DEFAULT NULL,
  `discountAmount` double DEFAULT NULL,
  `requiredVoucherMinAmount` double NOT NULL DEFAULT 0,
  `requiredVoucherAllowMultyple` tinyint(4) NOT NULL DEFAULT 1,
  `voucherMinAmount` double NOT NULL DEFAULT 0,
  `voucherAllowMultyple` tinyint(4) NOT NULL DEFAULT 0,
  `voucherGiftAmount` double NOT NULL DEFAULT 0,
  `voucherExpDate` date NOT NULL DEFAULT '2029-01-01',
  `Mon` int(1) DEFAULT 1,
  `Tue` int(1) DEFAULT 1,
  `Wed` int(1) DEFAULT 1,
  `Thu` int(1) DEFAULT 1,
  `Fri` int(1) DEFAULT 1,
  `Sat` int(1) DEFAULT 1,
  `Sun` int(1) DEFAULT 1,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `inputDate` int(1) DEFAULT 1,
  `inputBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.promotion: ~13 rows (approximately)
INSERT INTO `promotion` (`id`, `typeOfPromotion`, `storeOutlesId`, `code`, `description`, `startDate`, `endDate`, `discountPercent`, `discountAmount`, `requiredVoucherMinAmount`, `requiredVoucherAllowMultyple`, `voucherMinAmount`, `voucherAllowMultyple`, `voucherGiftAmount`, `voucherExpDate`, `Mon`, `Tue`, `Wed`, `Thu`, `Fri`, `Sat`, `Sun`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('buy2get1', 'promotion_discount', NULL, NULL, 'Buy 2 Get 1', '2026-01-01 00:00:00', '2026-12-23 23:55:55', NULL, NULL, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('occella1', 'promotion_free', NULL, NULL, 'Promo Buy 1 Get 1', '2026-01-01 00:00:00', '2026-12-23 23:55:55', NULL, NULL, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('occella2', 'promotion_free', NULL, NULL, 'Promo Buy 2 Get 1', '2026-01-01 00:00:00', '2026-12-23 23:55:55', NULL, NULL, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('occella3', 'promotion_discount', NULL, NULL, 'Promo Disc Selected Item', '2026-01-01 00:00:00', '2026-12-23 23:55:55', 90, NULL, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('occella4', 'promotion_discount', NULL, NULL, 'Promo Percentage Disc by Item (20% + 30%)', '2026-01-01 00:00:00', '2026-12-23 23:55:55', NULL, NULL, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('occella5', 'promotion_discount', NULL, NULL, 'Promo Fixed Price by Item', '2026-01-01 00:00:00', '2026-12-23 23:55:55', NULL, NULL, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('occella6', 'promotion_discount', NULL, NULL, 'Promo Level Buy 1 Percentage and Disc Buy 1 Get 1 dengan article yang sama', '2026-01-01 00:00:00', '2026-12-23 23:55:55', NULL, NULL, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('occella7', 'promotion_discount', NULL, NULL, 'Promo Special Price', '2026-01-01 00:00:00', '2026-12-23 23:55:55', NULL, NULL, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('occella8', 'promotion_discount', NULL, NULL, 'Promo Member Percentage Discount', '2026-01-01 00:00:00', '2026-12-23 23:55:55', NULL, NULL, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('Promo1', 'promotion_discount', '20101', '00000002', 'DISCOUNT 20% + 30% (A) Diskon tidak bersyarat.', '2026-01-01 00:00:00', '2026-12-23 23:55:55', 0, 0, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('Promo2', 'promotion_discount', '20101', '00000001', 'DISCOUNT 20% + 30% Item ke 2', '2026-01-01 00:00:00', '2026-12-23 23:55:55', 0, 0, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('Promo3', 'promotion_free', '20101', '00000003', 'Buy 3 Get 1', '2026-01-01 00:00:00', '2026-12-23 23:55:55', 0, 0, 0, 1, 0, 0, 0, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NULL, NULL, NULL),
	('v1', 'voucher', NULL, NULL, 'Voucher April 2026 min 300k get 50k', '2026-01-01 00:00:00', '2026-05-01 00:00:00', NULL, NULL, 300000, 1, 100000, 1, 50000, '2029-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, NULL, NULL);

-- Dumping structure for table pos_supermarket.promotion_discount
CREATE TABLE IF NOT EXISTS `promotion_discount` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `promotionId` varchar(50) DEFAULT NULL,
  `itemId` varchar(50) DEFAULT NULL,
  `disc1` double DEFAULT NULL,
  `disc2` double DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `inputDate` int(11) DEFAULT NULL,
  `inputBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.promotion_discount: ~3 rows (approximately)
INSERT INTO `promotion_discount` (`id`, `promotionId`, `itemId`, `disc1`, `disc2`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('00001', 'Promo2', '9900000001', 20, 30, 1, 1, NULL, NULL, NULL, NULL),
	('00002', 'Promo2', '9900000002', 20, 30, 1, 1, NULL, NULL, NULL, NULL),
	('00003', 'Promo2', '9900000003', 20, 30, 1, 1, NULL, NULL, NULL, NULL);

-- Dumping structure for table pos_supermarket.promotion_free
CREATE TABLE IF NOT EXISTS `promotion_free` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotionId` varchar(50) DEFAULT NULL,
  `itemId` varchar(50) DEFAULT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `freeItemId` varchar(50) DEFAULT NULL,
  `freeQty` int(11) NOT NULL DEFAULT 0,
  `applyMultiply` tinyint(4) NOT NULL DEFAULT 0,
  `scanFree` tinyint(4) NOT NULL DEFAULT 0,
  `printOnBill` tinyint(4) NOT NULL DEFAULT 0,
  `status` int(11) DEFAULT 1,
  `presence` int(1) NOT NULL DEFAULT 1,
  `inputDate` int(11) DEFAULT NULL,
  `inputBy` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9916 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.promotion_free: ~8 rows (approximately)
INSERT INTO `promotion_free` (`id`, `promotionId`, `itemId`, `qty`, `freeItemId`, `freeQty`, `applyMultiply`, `scanFree`, `printOnBill`, `status`, `presence`, `inputDate`, `inputBy`, `updateBy`, `updateDate`) VALUES
	(1, 'occella1', '899123456701', 1, '899123456701', 1, 0, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(9909, 'Promo3', '8997208072477', 3, '8997208072477', 1, 0, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(9910, 'buy2get1', '10197201', 2, '10197201', 1, 0, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(9911, 'occella1', '899123456702', 1, '899123456702', 1, 0, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(9912, 'occella1', '899123456703', 1, '899123456703', 1, 0, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(9913, 'occella1', '899123456704', 1, '899123456706', 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(9914, 'occella1', '899123456705', 3, '899123456706', 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(9915, 'occella2', '899123456710', 2, '899123456710', 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL);

-- Dumping structure for table pos_supermarket.promotion_item
CREATE TABLE IF NOT EXISTS `promotion_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotionId` varchar(50) NOT NULL DEFAULT '',
  `itemId` varchar(50) NOT NULL DEFAULT '',
  `qtyFrom` int(11) NOT NULL DEFAULT 1,
  `qtyTo` int(11) NOT NULL DEFAULT 99999,
  `specialPrice` double NOT NULL DEFAULT 0,
  `disc1` double NOT NULL DEFAULT 0,
  `disc2` double NOT NULL DEFAULT 0,
  `disc3` double NOT NULL DEFAULT 0,
  `discountPrice` double NOT NULL DEFAULT 0,
  `presence` int(1) NOT NULL DEFAULT 1,
  `status` int(11) NOT NULL DEFAULT 1,
  `inputDate` int(11) DEFAULT NULL,
  `inputBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.promotion_item: ~8 rows (approximately)
INSERT INTO `promotion_item` (`id`, `promotionId`, `itemId`, `qtyFrom`, `qtyTo`, `specialPrice`, `disc1`, `disc2`, `disc3`, `discountPrice`, `presence`, `status`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	(1, 'Promo1', '899123456715', 1, 9999, 0, 20, 30, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(2, 'Promo1', '1571384', 1, 9999, 0, 20, 30, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(5, 'occella3', '899123456720', 1, 9999, 0, 0, 0, 0, 99999, 1, 1, NULL, NULL, NULL, NULL),
	(6, 'occella3', '899123456721', 1, 9999, 0, 0, 0, 0, 99999, 1, 1, NULL, NULL, NULL, NULL),
	(7, 'occella4', '899123456730', 1, 9999, 0, 20, 30, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(8, 'occella5', '899123456740', 1, 99999, 0, 50, 0, 0, 0, 1, 1, NULL, NULL, NULL, NULL),
	(9, 'occella7', '899123456750', 1, 99, 49999, 0, 0, 0, 0, 1, 1, NULL, NULL, NULL, NULL);

-- Dumping structure for table pos_supermarket.promo_fixed
CREATE TABLE IF NOT EXISTS `promo_fixed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `icon` varchar(50) DEFAULT '<i class="bi bi-check"></i>',
  `description` varchar(150) DEFAULT NULL,
  `shortDesc` varchar(150) DEFAULT NULL,
  `targetAmount` int(11) DEFAULT NULL,
  `isMultiple` int(1) DEFAULT 1,
  `voucherAmount` float(11,2) DEFAULT NULL,
  `ifAmountNearTarget` float(4,2) DEFAULT NULL,
  `status` int(11) DEFAULT 0,
  `expDate` date DEFAULT '2023-01-01',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.promo_fixed: ~8 rows (approximately)
INSERT INTO `promo_fixed` (`id`, `name`, `icon`, `description`, `shortDesc`, `targetAmount`, `isMultiple`, `voucherAmount`, `ifAmountNearTarget`, `status`, `expDate`) VALUES
	(1, 'Free Packing', '<i class="bi bi-check"></i>', 'Belanja di atas Rp 100.000, Anda dapat parkir gratis', 'Gratis Parkir', 100000, 0, NULL, 50.00, 1, '2025-01-01'),
	(10, 'Lucky dip', '<i class="bi bi-check"></i>', 'Anda berhak mendapatkan  nomor lucky dip', 'Lucky dip', 100000, 1, NULL, 70.00, 0, '2025-09-25'),
	(20, 'voucher', '<i class="bi bi-check"></i>', 'Anda mendapakan Voucher kelipatan Rp 100.000, sebesar', 'Get Voucher', 100000, 1, 100000.00, 70.00, 1, '2023-11-01'),
	(21, 'voucher Discount', '<i class="bi bi-check"></i>', 'Anda mendapakan Discount', 'Get Voucher Discount', 100000, 0, 0.05, 70.00, 1, '2023-11-01'),
	(100, 'extra point', '<i class="bi bi-check"></i>', 'Dapat extra point yang bisa di redeem di customer service untuk masuk ke membership', 'Extra Point', 100000, 0, NULL, 70.00, 1, '2024-01-01'),
	(101, 'Free Gift', '<i class="bi bi-check"></i>', 'Promo gratis barang tertentu untuk pembelian sejumlah barang', 'Free Gift', 100000, 0, NULL, 70.00, 1, '2024-01-01'),
	(102, 'Get Voucher', '<i class="bi bi-check"></i>', 'Setting nilai maximum voucher', 'Get Voucher', 100000, 0, 1.00, 80.00, 1, '2024-01-01'),
	(103, 'Cashback Brands', '<i class="bi bi-check"></i>', 'Belanja dengan nilai tertentu dapat discount untuk brand tertentu untuk pembelanjaan berikutnya', 'Cashback Brands', 100000, 0, 4.00, 42.00, 1, '2024-01-01');

-- Dumping structure for table pos_supermarket.refund
CREATE TABLE IF NOT EXISTS `refund` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `transactionId` varchar(50) NOT NULL DEFAULT '',
  `refundTotalAmount` int(9) NOT NULL DEFAULT 0,
  `terminalId` varchar(50) NOT NULL DEFAULT '',
  `inputDate` int(9) NOT NULL DEFAULT 0,
  `input_date` datetime NOT NULL DEFAULT '2024-01-01 00:00:00',
  `input_by` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.refund: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.reset
CREATE TABLE IF NOT EXISTS `reset` (
  `id` varchar(50) NOT NULL,
  `userIdStart` varchar(50) NOT NULL,
  `userIdClose` varchar(50) NOT NULL,
  `storeOutlesId` varchar(50) DEFAULT NULL,
  `startDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `totalTransaction` int(11) DEFAULT NULL,
  `summaryTotalVoid` double DEFAULT NULL,
  `summaryTotalTransaction` double DEFAULT NULL,
  `summaryTotalCart` double DEFAULT NULL,
  `overalitemSales` double DEFAULT NULL,
  `overalDiscount` double DEFAULT NULL,
  `overalNetSales` double DEFAULT NULL,
  `overalFinalPrice` double DEFAULT NULL,
  `overalTax` double DEFAULT NULL,
  `note` varchar(250) DEFAULT NULL,
  `presence` int(11) NOT NULL,
  `inputDate` datetime DEFAULT '2026-01-01 00:00:00',
  `inputBy` varchar(50) DEFAULT NULL,
  `updateDate` datetime DEFAULT '2026-01-01 00:00:00',
  `updateBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.reset: ~10 rows (approximately)
INSERT INTO `reset` (`id`, `userIdStart`, `userIdClose`, `storeOutlesId`, `startDate`, `endDate`, `totalTransaction`, `summaryTotalVoid`, `summaryTotalTransaction`, `summaryTotalCart`, `overalitemSales`, `overalDiscount`, `overalNetSales`, `overalFinalPrice`, `overalTax`, `note`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('RST000249', '123123', '123123', 'OT99', '2026-04-02 14:00:47', '2026-04-02 14:17:17', 1, 0, 125000, 125000, 125000, 0, 125000, 125000, 0, NULL, 1, '2026-04-02 14:00:47', 'dev-user', '2026-04-02 14:17:17', 'dev-user'),
	('RST000250', '123123', '123213', 'OT99', '2026-04-02 14:24:01', '2026-04-02 14:46:33', 1, 0, 420000, 420000, 420000, 0, 420000, 420000, 0, NULL, 1, '2026-04-02 14:24:01', 'dev-user', '2026-04-02 14:46:33', 'dev-user'),
	('RST000251', '123123', '123123', 'OT99', '2026-04-02 14:49:21', '2026-04-02 15:02:19', 1, 0, 125000, 125000, 125000, 0, 125000, 125000, 0, NULL, 1, '2026-04-02 14:49:21', 'dev-user', '2026-04-02 15:02:19', 'dev-user'),
	('RST000252', '123213', '123123', 'OT99', '2026-04-02 15:02:36', '2026-04-02 17:10:34', 2, 0, 2975000, 2975000, 2975000, 0, 2975000, 2975000, 0, 'lancar', 1, '2026-04-02 15:02:36', 'dev-user', '2026-04-02 17:10:34', '123123'),
	('RST000253', '123123', '123123', 'OT99', '2026-04-02 17:37:49', '2026-04-06 16:36:39', 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 1, '2026-04-02 17:37:49', '123123', '2026-04-06 16:36:39', '123123'),
	('RST000254', '123123', 'dev-user', 'OT99', '2026-04-06 16:40:18', '2026-04-08 16:41:23', 14, 2, 6711699, 8152299, 8152299, 1440600, 6711699, 6711699, 0, 'kekurang koin', 1, '2026-04-06 16:40:18', '123123', '2026-04-08 16:41:23', 'dev-user'),
	('RST000255', 'dev-user', 'dev-user', 'OT99', '2026-04-08 16:47:12', '2026-04-08 16:49:05', 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 1, '2026-04-08 16:47:12', 'dev-user', '2026-04-08 16:49:05', 'dev-user'),
	('RST000256', 'dev-user', 'dev-user', 'OT99', '2026-04-08 16:50:10', '2026-04-08 16:51:14', 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 1, '2026-04-08 16:50:10', 'dev-user', '2026-04-08 16:51:14', 'dev-user'),
	('RST000257', 'dev-user', 'dev-user', 'OT99', '2026-04-08 16:51:19', '2026-04-08 16:56:53', 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 1, '2026-04-08 16:51:19', 'dev-user', '2026-04-08 16:56:53', 'dev-user'),
	('RST000258', 'dev-user', '', 'OT99', '2026-04-08 16:56:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-04-08 16:56:59', 'dev-user', '2026-04-08 16:56:59', 'dev-user');

-- Dumping structure for table pos_supermarket.reset_payment
CREATE TABLE IF NOT EXISTS `reset_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resetId` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `paymentTypeId` varchar(50) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `paidAmount` double DEFAULT NULL,
  `presence` int(11) NOT NULL DEFAULT 1,
  `inputDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.reset_payment: ~12 rows (approximately)
INSERT INTO `reset_payment` (`id`, `resetId`, `paymentTypeId`, `qty`, `paidAmount`, `presence`, `inputDate`) VALUES
	(1, 'RST000249', 'CASH', 1, 125000, 1, 1775114237),
	(2, 'RST000250', 'CASH', 1, 100000, 1, 1775115993),
	(3, 'RST000250', 'EDC_BCA', 1, 320000, 1, 1775115993),
	(5, 'RST000251', 'CASH', 1, 125000, 1, 1775116939),
	(6, 'RST000252', 'BCA31', 1, 2550000, 1, 1775124634),
	(7, 'RST000252', 'CASH', 1, 500000, 1, 1775124634),
	(8, 'RST000254', 'BCA01', 2, 896899, 1, 1775641283),
	(9, 'RST000254', 'BCA31', 1, 80000, 1, 1775641283),
	(10, 'RST000254', 'CASH', 14, 6225400, 1, 1775641283),
	(11, 'RST000254', 'EDC_BCA', 1, 755000, 1, 1775641283),
	(12, 'RST000254', 'EDC_BRI', 1, 275000, 1, 1775641283),
	(13, 'RST000254', 'EDC_MANDIRI', 1, 180000, 1, 1775641283);

-- Dumping structure for table pos_supermarket.settlement
CREATE TABLE IF NOT EXISTS `settlement` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `total` int(4) NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `inputDate` datetime NOT NULL DEFAULT '2023-01-01 00:00:00',
  `upload` int(1) NOT NULL DEFAULT 0,
  `uploadDate` datetime NOT NULL DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.settlement: ~0 rows (approximately)
INSERT INTO `settlement` (`id`, `total`, `amount`, `inputDate`, `upload`, `uploadDate`) VALUES
	('T01SET000039', 10, 8095684, '2025-07-28 14:19:45', 0, '2023-01-01 00:00:00');

-- Dumping structure for table pos_supermarket.sync
CREATE TABLE IF NOT EXISTS `sync` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path` varchar(250) NOT NULL DEFAULT '0',
  `fileName` varchar(250) DEFAULT NULL,
  `totalInsert` int(11) DEFAULT NULL,
  `totalTime` int(11) DEFAULT NULL,
  `result` varchar(250) DEFAULT NULL,
  `lastSycn` datetime(3) DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.sync: ~6 rows (approximately)
INSERT INTO `sync` (`id`, `path`, `fileName`, `totalInsert`, `totalTime`, `result`, `lastSycn`, `inputDate`) VALUES
	(1, 'C:/xampp8240/htdocs/app/clients/chandra/sync/item.txt', 'item.txt', 0, 68, 'Success!', '2024-01-15 17:52:50.000', 1705315970),
	(2, 'C:/xampp8240/htdocs/app/clients/chandra/sync/barcode.txt', 'barcode.txt', 0, 13, 'Success!', '2024-01-15 17:55:57.000', 1705316157),
	(3, 'C:/xampp8240/htdocs/app/clients/chandra/sync/promo_header.txt', 'promo_header.txt', 0, 17, 'Success!', '2024-01-15 17:57:33.000', 1705316253),
	(4, 'C:/xampp8240/htdocs/app/clients/chandra/sync/promo_detail.txt', 'promo_detail.txt', 0, 17, 'Success!', '2024-01-15 17:57:50.000', 1705316270),
	(5, 'C:/xampp8240/htdocs/app/clients/chandra/sync/promo_free.txt', 'promo_free.txt', 0, 17, 'Success!', '2024-01-15 17:57:50.000', 1705316270),
	(6, 'C:/xampp8240/htdocs/app/clients/chandra/sync/KMEMBER.txt', 'KMEMBER.txt', 0, 2, 'Success!', '2024-01-15 17:59:05.000', 1705316345);

-- Dumping structure for table pos_supermarket.sync_log
CREATE TABLE IF NOT EXISTS `sync_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module` varchar(50) DEFAULT NULL,
  `fileName` varchar(250) DEFAULT NULL,
  `fileSize` double DEFAULT 0,
  `syncDate` datetime(3) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `presence` int(11) NOT NULL DEFAULT 0,
  `inputDate` int(11) DEFAULT NULL,
  `inputBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.sync_log: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.taxcode
CREATE TABLE IF NOT EXISTS `taxcode` (
  `id` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `taxType` int(11) DEFAULT NULL COMMENT 'Inclusive or Exclusive',
  `percentage` double DEFAULT 0,
  `status` int(11) DEFAULT 0,
  `presence` int(11) DEFAULT 1,
  `inputDate` int(11) DEFAULT NULL,
  `inputBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.taxcode: ~3 rows (approximately)
INSERT INTO `taxcode` (`id`, `name`, `taxType`, `percentage`, `status`, `presence`, `inputDate`, `inputBy`, `updateDate`, `updateBy`) VALUES
	('0', 'Non PPN', 0, 0, 1, 1, 1654663251, 1, 1659435264, 1),
	('1', 'PPN 11% Inc', 1, 11, 1, 1, 1654490568, 1, 1661746470, 1),
	('2', 'PPN 11% Excl', 0, 11, 1, 1, NULL, NULL, 1659435264, 1);

-- Dumping structure for table pos_supermarket.tebus_murah
CREATE TABLE IF NOT EXISTS `tebus_murah` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(250) DEFAULT NULL,
  `expDate` int(11) DEFAULT 0,
  `exp_date` date DEFAULT '2023-12-12',
  `minTransaction` int(11) DEFAULT 0,
  `maxItem` int(3) DEFAULT 0,
  `status` int(1) DEFAULT 1,
  `presence` int(1) DEFAULT 1,
  `inputDate` int(11) DEFAULT 0,
  `input_date` datetime DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.tebus_murah: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.tebus_murah_items
CREATE TABLE IF NOT EXISTS `tebus_murah_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tembusMurahId` int(11) NOT NULL DEFAULT 0,
  `itemId` varchar(50) NOT NULL DEFAULT '',
  `price` int(11) NOT NULL DEFAULT 0,
  `inputDate` int(11) NOT NULL DEFAULT 0,
  `input_date` datetime NOT NULL DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.tebus_murah_items: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.transaction
CREATE TABLE IF NOT EXISTS `transaction` (
  `id` varchar(50) NOT NULL,
  `transactionDate` int(11) DEFAULT NULL,
  `transaction_date` datetime DEFAULT '2023-01-01 00:00:00',
  `kioskUuid` varchar(50) DEFAULT NULL,
  `resetId` varchar(50) DEFAULT NULL,
  `settlementId` varchar(50) NOT NULL DEFAULT '',
  `memberId` varchar(50) DEFAULT NULL,
  `paymentTypeId` varchar(50) DEFAULT NULL,
  `storeOutlesId` varchar(50) DEFAULT NULL,
  `terminalId` varchar(50) DEFAULT NULL,
  `struk` varchar(50) DEFAULT NULL,
  `total` double DEFAULT NULL,
  `locked` tinyint(4) NOT NULL DEFAULT 0,
  `startDate` datetime(3) DEFAULT NULL,
  `endDate` datetime(3) DEFAULT NULL,
  `cashierId` varchar(50) DEFAULT NULL,
  `pthType` int(11) DEFAULT NULL,
  `subTotal` double DEFAULT 0,
  `discount` double DEFAULT 0,
  `discountMember` double DEFAULT 0,
  `voucher` double DEFAULT 0,
  `bkp` double DEFAULT 0,
  `dpp` double DEFAULT 0,
  `ppn` double DEFAULT 0,
  `nonBkp` double DEFAULT NULL,
  `finalPrice` double DEFAULT NULL,
  `photo` varchar(250) DEFAULT NULL,
  `userId` varchar(50) DEFAULT NULL,
  `cashDrawer` int(1) DEFAULT 0,
  `printing` int(1) DEFAULT 0,
  `presence` int(11) NOT NULL DEFAULT 1,
  `inputDate` int(11) DEFAULT NULL,
  `input_date` datetime DEFAULT '2023-01-01 00:00:00',
  `updateDate` int(11) DEFAULT NULL,
  `update_date` datetime DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.transaction: ~36 rows (approximately)
INSERT INTO `transaction` (`id`, `transactionDate`, `transaction_date`, `kioskUuid`, `resetId`, `settlementId`, `memberId`, `paymentTypeId`, `storeOutlesId`, `terminalId`, `struk`, `total`, `locked`, `startDate`, `endDate`, `cashierId`, `pthType`, `subTotal`, `discount`, `discountMember`, `voucher`, `bkp`, `dpp`, `ppn`, `nonBkp`, `finalPrice`, `photo`, `userId`, `cashDrawer`, `printing`, `presence`, `inputDate`, `input_date`, `updateDate`, `update_date`) VALUES
	('123123.0121', 1705316417, '2024-01-15 18:00:17', 'UATx1.240115.0217', NULL, 'T01SET000039', NULL, '', 'Comingsoon', 'UATx1', '123123.0121', 157500, 1, '2023-01-01 00:00:00.000', '2024-01-15 18:00:17.000', '123123', 1, 0, 0, 0, 0, 141892, 157500, 15608, 0, 157500, NULL, NULL, 1, 1, 1, 1705316417, '2024-01-15 18:00:17', 1705316417, '2024-01-15 18:00:17'),
	('123123.0122', 1705568554, '2024-01-18 16:02:34', 'UATx1.240117.0218', NULL, 'T01SET000039', NULL, '', 'Comingsoon', 'UATx1', '123123.0122', 22500, 1, '2023-01-01 00:00:00.000', '2024-01-18 16:02:34.000', '123123', 1, 0, 0, 0, 0, 20271, 22500, 2229, 0, 22500, NULL, NULL, 1, 1, 1, 1705568554, '2024-01-18 16:02:34', 1705568554, '2024-01-18 16:02:34'),
	('123123.0123', 1705925210, '2024-01-22 19:06:50', 'UATx1.240118.0219', NULL, 'T01SET000039', NULL, '', 'Comingsoon', 'UATx1', '123123.0123', 213180, 1, '2023-01-01 00:00:00.000', '2024-01-22 19:06:50.000', '123123', 1, 0, 52420, 0, 0, 144829, 213180, 68351, 0, 160760, NULL, NULL, 1, 1, 1, 1705925210, '2024-01-22 19:06:50', 1705925210, '2024-01-22 19:06:50'),
	('123123.0124', 1741765756, '2025-03-12 14:49:16', 'T01.250312.0221', NULL, 'T01SET000039', NULL, '', 'Comingsoon', 'T01', '123123.0124', 300000, 1, '2023-01-01 00:00:00.000', '2025-03-12 14:49:16.000', '123123', 1, 0, 0, 0, 0, 0, 0, 0, 0, 300000, NULL, NULL, 1, 1, 1, 1741765756, '2025-03-12 14:49:16', 1741765756, '2025-03-12 14:49:16'),
	('123123.0125', 1741856725, '2025-03-13 16:05:25', 'T01.250312.0223', NULL, 'T01SET000039', NULL, '', 'Comingsoon', 'T01', '123123.0125', 482000, 1, '2023-01-01 00:00:00.000', '2025-03-13 16:05:25.000', '123123', 1, 0, 60000, 0, 0, 0, 0, 0, 0, 422000, NULL, NULL, 1, 1, 1, 1741856725, '2025-03-13 16:05:25', 1741856725, '2025-03-13 16:05:25'),
	('123123.0126', 1742280855, '2025-03-18 13:54:15', 'T01.250312.0222', NULL, 'T01SET000039', '000001', '', 'Comingsoon', 'T01', '123123.0126', 1320504, 1, '2023-01-01 00:00:00.000', '2025-03-18 13:54:15.000', '123123', 1, 0, 531996, 0, 0, 0, 0, 0, 0, 788508, NULL, NULL, 1, 1, 1, 1742280855, '2025-03-18 13:54:15', 1742280855, '2025-03-18 13:54:15'),
	('123123.0127', 1742287880, '2025-03-18 15:51:20', 'T01.250318.0226', NULL, 'T01SET000039', '000001', '', 'Comingsoon', 'T01', '123123.0127', 189000, 1, '2023-01-01 00:00:00.000', '2025-03-18 15:51:20.000', '123123', 1, 0, 0, 0, 0, 0, 0, 0, 0, 189000, NULL, NULL, 1, 1, 1, 1742287880, '2025-03-18 15:51:20', 1742287880, '2025-03-18 15:51:20'),
	('123123.0128', 1742373284, '2025-03-19 15:34:44', 'T01.250319.0228', NULL, 'T01SET000039', '000001', '', 'Comingsoon', 'T01', '123123.0128', 325000, 1, '2023-01-01 00:00:00.000', '2025-03-19 15:34:44.000', '123123', 1, 0, 64000, 0, 0, 0, 0, 0, 0, 261000, NULL, NULL, 1, 1, 1, 1742373284, '2025-03-19 15:34:44', 1742373284, '2025-03-19 15:34:44'),
	('123123.0129', 1753685813, '2025-07-28 13:56:53', 'T01.250728.0230', NULL, 'T01SET000039', NULL, '', 'Comingsoon', 'T01', '123123.0129', 2762000, 1, '2023-01-01 00:00:00.000', '2025-07-28 13:56:53.000', '123123', 1, 0, 440000, 0, 0, 0, 0, 0, 0, 2322000, NULL, NULL, 1, 1, 1, 1753685813, '2025-07-28 13:56:53', 1753685813, '2025-07-28 13:56:53'),
	('123123.0130', 1753686997, '2025-07-28 14:16:37', 'T01.250728.0231', NULL, 'T01SET000039', '000001', '', 'Comingsoon', 'T01', '123123.0130', 2324000, 1, '2023-01-01 00:00:00.000', '2025-07-28 14:16:37.000', '123123', 1, 0, 440000, 0, 0, 0, 0, 0, 0, 1884000, NULL, NULL, 1, 1, 1, 1753686997, '2025-07-28 14:16:37', 1753686997, '2025-07-28 14:16:37'),
	('123123.0131', 1775041324, '2026-04-01 11:02:04', 'T01.260401.0252', NULL, '456456', NULL, NULL, 'OT99', 'T01', '123123.0131', 825000, 1, '2023-01-01 00:00:00.000', '2026-04-01 11:02:04.000', '123123', 1, 825000, 0, 0, 0, 0, 0, 0, 0, 825000, NULL, NULL, 1, 1, 1, 1775041324, '2026-04-01 11:02:04', 1775041324, '2026-04-01 11:02:04'),
	('123123.0132', 1775041754, '2026-04-01 11:09:14', 'T01.260401.0253', NULL, '456456', NULL, NULL, 'OT99', 'T01', '123123.0132', 690000, 1, '2023-01-01 00:00:00.000', '2026-04-01 11:09:14.000', '123123', 1, 690000, 0, 0, 0, 0, 0, 0, 0, 690000, NULL, NULL, 1, 1, 1, 1775041754, '2026-04-01 11:09:14', 1775041754, '2026-04-01 11:09:14'),
	('123123.0133', 1775042143, '2026-04-01 11:15:43', 'T01.260401.0254', NULL, '456456', NULL, NULL, 'OT99', 'T01', '123123.0133', 640000, 1, '2023-01-01 00:00:00.000', '2026-04-01 11:15:43.000', '123123', 1, 640000, 0, 0, 0, 0, 0, 0, 0, 640000, NULL, NULL, 1, 1, 1, 1775042143, '2026-04-01 11:15:43', 1775042143, '2026-04-01 11:15:43'),
	('123123.0134', 1775042815, '2026-04-01 11:26:55', 'T01.260401.0255', NULL, '456456', NULL, NULL, 'OT99', 'T01', '123123.0134', 550000, 1, '2023-01-01 00:00:00.000', '2026-04-01 11:26:55.000', '123123', 1, 550000, 0, 0, 0, 0, 0, 0, 0, 550000, NULL, NULL, 1, 1, 1, 1775042815, '2026-04-01 11:26:55', 1775042815, '2026-04-01 11:26:55'),
	('123123.0135', 1775042935, '2026-04-01 11:28:55', 'T01.260401.0256', NULL, '456456', NULL, NULL, 'OT99', 'T01', '123123.0135', 175000, 1, '2023-01-01 00:00:00.000', '2026-04-01 11:28:55.000', '123123', 1, 175000, 0, 0, 0, 0, 0, 0, 0, 175000, NULL, NULL, 1, 1, 1, 1775042935, '2026-04-01 11:28:55', 1775042935, '2026-04-01 11:28:55'),
	('123123.0136', 1775043114, '2026-04-01 11:31:54', 'T01.260401.0257', NULL, '456456', NULL, NULL, 'OT99', 'T01', '123123.0136', 320000, 1, '2023-01-01 00:00:00.000', '2026-04-01 11:31:54.000', '123123', 1, 320000, 0, 0, 0, 0, 0, 0, 0, 320000, NULL, NULL, 1, 1, 1, 1775043114, '2026-04-01 11:31:54', 1775043114, '2026-04-01 11:31:54'),
	('123123.0137', 1775043725, '2026-04-01 11:42:05', 'T01.260401.0258', NULL, '456456', NULL, NULL, 'OT99', 'T01', '123123.0137', 370000, 1, '2023-01-01 00:00:00.000', '2026-04-01 11:42:05.000', '123123', 1, 370000, 0, 0, 0, 0, 0, 0, 0, 370000, NULL, NULL, 1, 1, 1, 1775043725, '2026-04-01 11:42:05', 1775043725, '2026-04-01 11:42:05'),
	('123123.0138', 1775113273, '2026-04-02 07:01:13', 'T01.260402.0260', 'RST000249', '', NULL, NULL, 'OT99', 'T01', '123123.0138', 125000, 1, '2023-01-01 00:00:00.000', '2026-04-02 07:01:13.000', '123123', 1, 125000, 0, 0, 0, 0, 0, 0, 0, 125000, NULL, NULL, 1, 1, 1, 1775113273, '2026-04-02 07:01:13', 1775113273, '2026-04-02 07:01:13'),
	('123123.0139', 1775115256, '2026-04-02 07:34:16', 'T01.260402.0261', 'RST000250', '', NULL, NULL, 'OT99', 'T01', '123123.0139', 420000, 1, '2023-01-01 00:00:00.000', '2026-04-02 07:34:16.000', '123123', 1, 420000, 0, 0, 0, 0, 0, 0, 0, 420000, NULL, NULL, 1, 1, 1, 1775115256, '2026-04-02 07:34:16', 1775115256, '2026-04-02 07:34:16'),
	('123123.0140', 1775116178, '2026-04-02 07:49:38', 'T01.260402.0262', 'RST000251', '', NULL, NULL, 'OT99', 'T01', '123123.0140', 125000, 1, '2023-01-01 00:00:00.000', '2026-04-02 07:49:38.000', '123123', 1, 125000, 0, 0, 0, 0, 0, 0, 0, 125000, NULL, NULL, 1, 1, 1, 1775116178, '2026-04-02 07:49:38', 1775116178, '2026-04-02 07:49:38'),
	('123123.0141', 1775119917, '2026-04-02 08:51:57', 'T01.260402.0263', 'RST000252', '', NULL, NULL, 'OT99', 'T01', '123123.0141', 425000, 1, '2023-01-01 00:00:00.000', '2026-04-02 08:51:57.000', '123123', 1, 425000, 0, 0, 0, 0, 0, 0, 0, 425000, NULL, NULL, 1, 1, 1, 1775119917, '2026-04-02 08:51:57', 1775119917, '2026-04-02 08:51:57'),
	('123123.0142', 1775124607, '2026-04-02 10:10:07', 'T01.260402.0264', 'RST000252', '', NULL, NULL, 'OT99', 'T01', '123123.0142', 2550000, 1, '2023-01-01 00:00:00.000', '2026-04-02 10:10:07.000', '123123', 1, 2550000, 0, 0, 0, 0, 0, 0, 0, 2550000, NULL, NULL, 0, 1, 1, 1775124607, '2026-04-02 10:10:07', 1775124607, '2026-04-02 10:10:07'),
	('123123.0143', 1775470683, '2026-04-06 10:18:03', 'T01.260402.0265', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0143', 275000, 1, '2023-01-01 00:00:00.000', '2026-04-06 10:18:03.000', '123123', 1, 275000, 0, 0, 0, 0, 0, 0, 0, 275000, NULL, NULL, 0, 1, 1, 1775470683, '2026-04-06 10:18:03', 1775470683, '2026-04-06 10:18:03'),
	('123123.0144', 1775472227, '2026-04-06 10:43:47', 'T01.260406.0266', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0144', 780000, 1, '2023-01-01 00:00:00.000', '2026-04-06 10:43:47.000', '123123', 1, 780000, 0, 0, 0, 0, 0, 0, 0, 780000, NULL, NULL, 1, 1, 1, 1775472227, '2026-04-06 10:43:47', 1775472227, '2026-04-06 10:43:47'),
	('123123.0145', 1775474718, '2026-04-06 11:25:18', 'T01.260406.0267', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0145', 1355000, 1, '2023-01-01 00:00:00.000', '2026-04-06 11:25:18.000', '123123', 1, 1355000, 0, 0, 0, 0, 0, 0, 0, 1355000, NULL, NULL, 1, 1, 1, 1775474718, '2026-04-06 11:25:18', 1775474718, '2026-04-06 11:25:18'),
	('123123.0146', 1775477217, '2026-04-06 12:06:57', 'T01.260406.0269', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0146', 487899, 1, '2023-01-01 00:00:00.000', '2026-04-06 12:06:57.000', '123123', 1, 487899, 0, 0, 0, 0, 0, 0, 0, 487899, NULL, NULL, 1, 1, 1, 1775477217, '2026-04-06 12:06:57', 1775477217, '2026-04-06 12:06:57'),
	('123123.0147', 1775553300, '2026-04-07 09:15:00', 'T01.260407.0276', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0147', 0, 1, '2023-01-01 00:00:00.000', '2026-04-07 09:15:00.000', '123123', 1, 130000, 130000, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, 1, 1, 1, 1775553300, '2026-04-07 09:15:00', 1775553300, '2026-04-07 09:15:00'),
	('123123.0148', 1775555170, '2026-04-07 09:46:10', 'T01.260407.0281', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0148', -112800, 1, '2023-01-01 00:00:00.000', '2026-04-07 09:46:10.000', '123123', 1, 473600, 586400, 0, 0, 0, 0, 0, 0, -112800, NULL, NULL, 1, 1, 1, 1775555170, '2026-04-07 09:46:10', 1775555170, '2026-04-07 09:46:10'),
	('123123.0149', 1775556090, '2026-04-07 10:01:30', 'T01.260407.0282', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0149', -280000, 1, '2023-01-01 00:00:00.000', '2026-04-07 10:01:30.000', '123123', 1, 35000, 315000, 0, 0, 0, 0, 0, 0, -280000, NULL, NULL, 1, 1, 1, 1775556090, '2026-04-07 10:01:30', 1775556090, '2026-04-07 10:01:30'),
	('123123.0150', 1775558145, '2026-04-07 10:35:45', 'T01.260407.0283', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0150', 755000, 1, '2023-01-01 00:00:00.000', '2026-04-07 10:35:45.000', '123123', 1, 755000, 0, 0, 0, 0, 0, 0, 0, 755000, NULL, NULL, 1, 1, 1, 1775558145, '2026-04-07 10:35:45', 1775558145, '2026-04-07 10:35:45'),
	('123123.0151', 1775558830, '2026-04-07 10:47:10', 'T01.260407.0284', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0151', 150000, 1, '2023-01-01 00:00:00.000', '2026-04-07 10:47:10.000', '123123', 1, 150000, 0, 0, 0, 0, 0, 0, 0, 150000, NULL, NULL, 1, 1, 1, 1775558830, '2026-04-07 10:47:10', 1775558830, '2026-04-07 10:47:10'),
	('123123.0152', 1775627364, '2026-04-08 05:49:24', 'T01.260408.0289', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0152', 1219400, 1, '2023-01-01 00:00:00.000', '2026-04-08 05:49:24.000', '123123', 1, 1492200, 272800, 0, 0, 0, 0, 0, 0, 1219400, NULL, NULL, 1, 1, 1, 1775627364, '2026-04-08 05:49:24', 1775627364, '2026-04-08 05:49:24'),
	('123123.0153', 1775631826, '2026-04-08 07:03:46', 'T01.260408.0290', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0153', 480000, 1, '2023-01-01 00:00:00.000', '2026-04-08 07:03:46.000', '123123', 1, 480000, 0, 0, 0, 0, 0, 0, 0, 480000, NULL, NULL, 1, 1, 1, 1775631826, '2026-04-08 07:03:46', 1775631826, '2026-04-08 07:03:46'),
	('123123.0154', 1775639608, '2026-04-08 09:13:28', 'T01.260408.0291', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0154', 640000, 1, '2023-01-01 00:00:00.000', '2026-04-08 09:13:28.000', '123123', 1, 640000, 0, 0, 0, 0, 0, 0, 0, 640000, NULL, NULL, 1, 1, 1, 1775639608, '2026-04-08 09:13:28', 1775639608, '2026-04-08 09:13:28'),
	('123123.0155', 1775640050, '2026-04-08 09:20:50', 'T01.260408.0292', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0155', 640000, 1, '2023-01-01 00:00:00.000', '2026-04-08 09:20:50.000', '123123', 1, 640000, 0, 0, 0, 0, 0, 0, 0, 640000, NULL, NULL, 1, 1, 1, 1775640050, '2026-04-08 09:20:50', 1775640050, '2026-04-08 09:20:50'),
	('123123.0156', 1775640829, '2026-04-08 09:33:49', 'T01.260408.0293', 'RST000254', '', NULL, NULL, 'OT99', 'T01', '123123.0156', 322200, 1, '2023-01-01 00:00:00.000', '2026-04-08 09:33:49.000', '123123', 1, 458600, 136400, 0, 0, 0, 0, 0, 0, 322200, NULL, NULL, 1, 1, 1, 1775640829, '2026-04-08 09:33:49', 1775640829, '2026-04-08 09:33:49');

-- Dumping structure for table pos_supermarket.transaction_detail
CREATE TABLE IF NOT EXISTS `transaction_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transactionId` varchar(50) DEFAULT NULL,
  `promotionId` varchar(50) DEFAULT NULL,
  `promotionFreeId` int(11) DEFAULT NULL,
  `promotionItemId` int(11) DEFAULT NULL,
  `promotionDiscountId` int(11) DEFAULT NULL,
  `itemId` varchar(50) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `originPrice` double DEFAULT 0,
  `price` double DEFAULT 0,
  `discount` double DEFAULT 0,
  `memberDiscountAmount` double DEFAULT 0,
  `memberDiscountPercent` double DEFAULT 0,
  `validationNota` int(1) DEFAULT 0,
  `isPriceEdit` int(11) DEFAULT 0,
  `isFreeItem` varchar(50) NOT NULL DEFAULT '',
  `isSpecialPrice` int(11) NOT NULL DEFAULT 0,
  `isPrintOnBill` int(11) NOT NULL DEFAULT 1,
  `note` varchar(250) DEFAULT '',
  `void` int(11) NOT NULL DEFAULT 0,
  `refund` varchar(50) NOT NULL DEFAULT '',
  `exchange` varchar(50) NOT NULL DEFAULT '',
  `presence` int(11) NOT NULL DEFAULT 1,
  `inputDate` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `updateBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.transaction_detail: ~119 rows (approximately)
INSERT INTO `transaction_detail` (`id`, `transactionId`, `promotionId`, `promotionFreeId`, `promotionItemId`, `promotionDiscountId`, `itemId`, `barcode`, `originPrice`, `price`, `discount`, `memberDiscountAmount`, `memberDiscountPercent`, `validationNota`, `isPriceEdit`, `isFreeItem`, `isSpecialPrice`, `isPrintOnBill`, `note`, `void`, `refund`, `exchange`, `presence`, `inputDate`, `updateDate`, `updateBy`) VALUES
	(1, '123123.0121', '0', NULL, 0, NULL, '0070024', '0070024', 22500, 22500, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705316376, 1705316417, NULL),
	(2, '123123.0121', '0', NULL, NULL, NULL, '0070024', '0070024', 22500, 22500, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705316385, 1705316417, NULL),
	(3, '123123.0121', '0', NULL, 0, NULL, '0070024', '0070024', 22500, 22500, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705316394, 1705316417, NULL),
	(4, '123123.0121', '0', NULL, 0, NULL, '0070025', '0070025', 22500, 22500, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705316400, 1705316417, NULL),
	(5, '123123.0121', '0', NULL, NULL, NULL, '0070025', '0070025', 22500, 22500, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705316406, 1705316417, NULL),
	(6, '123123.0121', '0', NULL, NULL, NULL, '0070025', '0070025', 22500, 22500, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705316406, 1705316417, NULL),
	(7, '123123.0121', '0', NULL, NULL, NULL, '0070025', '0070025', 22500, 22500, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705316406, 1705316417, NULL),
	(16, '123123.0122', '0', NULL, 0, NULL, '0070025', '0070025', 22500, 22500, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705469237, 1705568554, NULL),
	(17, '123123.0123', '0', NULL, 0, NULL, '0000521', '0000521', 69900, 62910, 6990, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705569975, 1705925210, NULL),
	(18, '123123.0123', '0', NULL, 0, NULL, '0000521', '0000521', 69900, 55920, 13980, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705570707, 1705925210, NULL),
	(19, '123123.0123', 'C1', NULL, 0, 1, '0000642', '0000642', 62900, 50320, 12580, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705571026, 1705925210, NULL),
	(20, '123123.0123', 'C1', NULL, 0, 1, '0000642', '0000642', 62900, 44030, 18870, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1705571126, 1705925210, NULL),
	(21, '123123.0124', '0', NULL, 0, NULL, '8999999596972', '8999999596972', 100000, 100000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1741763164, 1741765756, NULL),
	(22, '123123.0124', '0', NULL, 0, NULL, '8999999596972', '8999999596972', 100000, 100000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1741763167, 1741765756, NULL),
	(23, '123123.0124', '0', NULL, 0, NULL, '8999999596972', '8999999596972', 100000, 100000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1741763364, 1741765756, NULL),
	(24, '123123.0125', 'C1', NULL, 0, 1, '1', '8999999596972', 100000, 80000, 20000, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1741856600, 1741856725, NULL),
	(25, '123123.0125', '0', NULL, 0, NULL, '4', '667558701829', 242000, 242000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1741856603, 1741856725, NULL),
	(26, '123123.0125', 'C1', NULL, NULL, NULL, '1', '8999999596972', 100000, 80000, 20000, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1741856623, 1741856725, NULL),
	(27, '123123.0125', 'C1', NULL, NULL, NULL, '1', '8999999596972', 100000, 80000, 20000, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1741856623, 1741856725, NULL),
	(28, '123123.0126', 'occella3', NULL, 5, NULL, '899123456720', '899123456720', 160000, 60001, 99999, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1742279245, 1742280855, NULL),
	(29, '123123.0126', 'occella3', NULL, 5, NULL, '899123456720', '899123456720', 160000, 60001, 99999, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1742279251, 1742280855, NULL),
	(30, '123123.0126', 'occella3', NULL, 6, NULL, '899123456721', '899123456721', 350000, 250001, 99999, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1742279258, 1742280855, NULL),
	(31, '123123.0126', 'occella5', NULL, 8, NULL, '899123456740', '899123456740', 130000, 99001, 30999, 0, 0, 0, 0, '', 1, 1, '', 0, '', '', 1, 1742279330, 1742280855, NULL),
	(32, '123123.0126', 'occella7', NULL, 9, NULL, '899123456750', '899123456750', 400000, 199000, 201000, 0, 0, 0, 0, '', 1, 1, '', 0, '', '', 1, 1742279436, 1742280855, NULL),
	(33, '123123.0126', 'occella1', NULL, 1, NULL, '899123456701', '899123456701', 125000, 112500, 0, 12500, 10, 0, 0, '', 0, 1, '', 0, '', '', 1, 1742280542, 1742280855, NULL),
	(34, '123123.0126', 'occella2', NULL, 9915, NULL, '899123456710', '899123456710', 300000, 270000, 0, 30000, 10, 0, 0, '', 0, 1, '', 0, '', '', 1, 1742280548, 1742280855, NULL),
	(35, '123123.0126', 'occella2', NULL, 9915, NULL, '899123456710', '899123456710', 300000, 270000, 0, 30000, 10, 0, 0, '', 0, 1, '', 0, '', '', 1, 1742280549, 1742280855, NULL),
	(36, '123123.0127', 'occella1', NULL, 9911, NULL, '899123456702', '899123456702', 210000, 189000, 0, 21000, 10, 0, 0, '', 0, 1, '', 0, '', '', 1, 1742287296, 1742287880, NULL),
	(37, '123123.0128', 'Promo2', NULL, NULL, 1, '9900000001', '9900000001', 100000, 80000, 20000, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1742371937, 1742373284, NULL),
	(38, '123123.0128', 'Promo2', NULL, NULL, 1, '9900000001', '9900000001', 100000, 56000, 44000, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1742371939, 1742373284, NULL),
	(39, '123123.0128', 'occella1', NULL, 9911, NULL, '899123456702', '899123456702', 210000, 189000, 0, 21000, 10, 0, 0, '', 0, 1, '', 0, '', '', 1, 1742372355, 1742373284, NULL),
	(40, '123123.0129', NULL, NULL, NULL, NULL, '1', '8999999596972', 100000, 100000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1753684968, 1753685813, NULL),
	(41, '123123.0129', 'Promo1', NULL, 2, NULL, '1571384', '1571384', 1000000, 560000, 440000, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1753684971, 1753685813, NULL),
	(42, '123123.0129', NULL, NULL, NULL, NULL, '3', '1569723', 1860000, 1860000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1753684974, 1753685813, NULL),
	(43, '123123.0129', NULL, NULL, NULL, NULL, '4', '667558701829', 242000, 242000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1753685104, 1753685813, NULL),
	(44, '123123.0130', NULL, NULL, NULL, NULL, '1', '8999999596972', 100000, 90000, 0, 10000, 10, 0, 0, '', 0, 1, '', 0, '', '', 1, 1753686749, 1753686997, NULL),
	(45, '123123.0130', 'Promo1', NULL, 2, NULL, '1571384', '1571384', 1000000, 560000, 440000, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1753686755, 1753686997, NULL),
	(46, '123123.0130', NULL, NULL, NULL, NULL, '3', '1569723', 1860000, 1674000, 0, 186000, 10, 0, 0, '', 0, 1, '', 0, '', '', 1, 1753686821, 1753686997, NULL),
	(47, '123123.0131', '0', NULL, NULL, NULL, '899123456701', '899123456701', 125000, 125000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775041324, 1775041324, NULL),
	(48, '123123.0131', '0', NULL, NULL, NULL, '899123456701', '899123456701', 125000, 125000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775041324, 1775041324, NULL),
	(49, '123123.0131', '0', NULL, NULL, NULL, '899123456705', '899123456705', 275000, 275000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775041324, 1775041324, NULL),
	(50, '123123.0131', '0', NULL, NULL, NULL, '899123456710', '899123456710', 300000, 300000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775041324, 1775041324, NULL),
	(51, '123123.0132', '0', NULL, NULL, NULL, '899123456707', '899123456707', 185000, 185000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775041754, 1775041754, NULL),
	(52, '123123.0132', '0', NULL, NULL, NULL, '899123456707', '899123456707', 185000, 185000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775041754, 1775041754, NULL),
	(53, '123123.0132', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775041754, 1775041754, NULL),
	(54, '123123.0133', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775042143, 1775042143, NULL),
	(55, '123123.0133', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775042143, 1775042143, NULL),
	(56, '123123.0134', '0', NULL, NULL, NULL, '899123456705', '899123456705', 275000, 275000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775042815, 1775042815, NULL),
	(57, '123123.0134', '0', NULL, NULL, NULL, '899123456705', '899123456705', 275000, 275000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775042815, 1775042815, NULL),
	(58, '123123.0135', '0', NULL, NULL, NULL, '899123456703', '899123456703', 175000, 175000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775042935, 1775042935, NULL),
	(59, '123123.0136', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775043114, 1775043114, NULL),
	(60, '123123.0137', '0', NULL, NULL, NULL, '899123456707', '899123456707', 185000, 185000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775043725, 1775043725, NULL),
	(61, '123123.0137', '0', NULL, NULL, NULL, '899123456707', '899123456707', 185000, 185000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775043725, 1775043725, NULL),
	(62, '123123.0138', '0', NULL, NULL, NULL, '899123456701', '899123456701', 125000, 125000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775113273, 1775113273, NULL),
	(63, '123123.0139', '0', NULL, NULL, NULL, '899123456702', '899123456702', 210000, 210000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775115256, 1775115256, NULL),
	(64, '123123.0139', '0', NULL, NULL, NULL, '899123456702', '899123456702', 210000, 210000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775115256, 1775115256, NULL),
	(65, '123123.0140', '0', NULL, NULL, NULL, '899123456701', '899123456701', 125000, 125000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775116178, 1775116178, NULL),
	(66, '123123.0141', '0', NULL, NULL, NULL, '899123456701', '899123456701', 125000, 125000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775119917, 1775119917, NULL),
	(67, '123123.0141', '0', NULL, NULL, NULL, '899123456701', '899123456701', 125000, 125000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775119917, 1775119917, NULL),
	(68, '123123.0141', '0', NULL, NULL, NULL, '899123456703', '899123456703', 175000, 175000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775119917, 1775119917, NULL),
	(69, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(70, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(71, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(72, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(73, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(74, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(75, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(76, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(77, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(78, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(79, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(80, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(81, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(82, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(83, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(84, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(85, '123123.0142', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775124607, 1775124607, NULL),
	(86, '123123.0143', '0', NULL, NULL, NULL, '899123456705', '899123456705', 275000, 275000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775470683, 1775470683, NULL),
	(87, '123123.0144', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775472227, 1775472227, NULL),
	(88, '123123.0144', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775472227, 1775472227, NULL),
	(89, '123123.0144', '0', NULL, NULL, NULL, '899123456708', '899123456708', 480000, 480000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775472227, 1775472227, NULL),
	(90, '123123.0145', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775474718, 1775474718, NULL),
	(91, '123123.0145', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775474718, 1775474718, NULL),
	(92, '123123.0145', '0', NULL, NULL, NULL, '899123456709', '899123456709', 210000, 210000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775474718, 1775474718, NULL),
	(93, '123123.0145', '0', NULL, NULL, NULL, '899123456707', '899123456707', 185000, 185000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775474718, 1775474718, NULL),
	(94, '123123.0145', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775474718, 1775474718, NULL),
	(95, '123123.0146', '0', NULL, NULL, NULL, '9900000011', '9900000011', 241785, 241785, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775477217, 1775477217, NULL),
	(96, '123123.0146', '0', NULL, NULL, NULL, '9900000015', '9900000015', 123057, 123057, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775477217, 1775477217, NULL),
	(97, '123123.0146', '0', NULL, NULL, NULL, '9900000015', '9900000015', 123057, 123057, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775477217, 1775477217, NULL),
	(98, '123123.0147', '0', NULL, NULL, NULL, '899123456740', '899123456740', 130000, 65000, 65000, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775553300, 1775553300, NULL),
	(99, '123123.0147', '0', NULL, NULL, NULL, '899123456740', '899123456740', 130000, 65000, 65000, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775553300, 1775553300, NULL),
	(100, '123123.0148', '0', NULL, NULL, NULL, '899123456750', '899123456750', 400000, 49999, 350001, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775555170, 1775555170, NULL),
	(101, '123123.0148', '0', NULL, NULL, NULL, '899123456730', '899123456730', 310000, 173600, 136400, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775555170, 1775555170, NULL),
	(102, '123123.0148', '0', NULL, NULL, NULL, '899123456721', '899123456721', 350000, 250001, 99999, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775555170, 1775555170, NULL),
	(103, '123123.0149', '0', NULL, NULL, NULL, '899123456721', '899123456721', 350000, 35000, 315000, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775556090, 1775556090, NULL),
	(104, '123123.0150', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775558145, 1775558145, NULL),
	(105, '123123.0150', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775558145, 1775558145, NULL),
	(106, '123123.0150', '0', NULL, NULL, NULL, '899123456705', '899123456705', 275000, 275000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775558145, 1775558145, NULL),
	(107, '123123.0150', '0', NULL, NULL, NULL, '899123456716', '899123456716', 180000, 180000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775558145, 1775558145, NULL),
	(108, '123123.0151', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 150000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775558830, 1775558830, NULL),
	(109, '123123.0152', '0', NULL, NULL, NULL, '899123456730', '899123456730', 310000, 173600, 136400, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775627364, 1775627364, NULL),
	(110, '123123.0152', '0', NULL, NULL, NULL, '899123456730', '899123456730', 310000, 173600, 136400, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775627364, 1775627364, NULL),
	(111, '123123.0152', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775627364, 1775627364, NULL),
	(112, '123123.0152', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 0, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775627364, 1775627364, NULL),
	(113, '123123.0152', '0', NULL, NULL, NULL, '899123456705', '899123456705', 275000, 275000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775627364, 1775627364, NULL),
	(114, '123123.0152', '0', NULL, NULL, NULL, '899123456705', '899123456705', 275000, 275000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775627364, 1775627364, NULL),
	(115, '123123.0152', '0', NULL, NULL, NULL, '899123456705', '899123456705', 275000, 275000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775627364, 1775627364, NULL),
	(116, '123123.0152', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 0, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775627364, 1775627364, NULL),
	(117, '123123.0153', '0', NULL, NULL, NULL, '899123456708', '899123456708', 480000, 480000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775631826, 1775631826, NULL),
	(118, '123123.0154', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775639608, 1775639608, NULL),
	(119, '123123.0154', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 0, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775639608, 1775639608, NULL),
	(120, '123123.0154', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775639608, 1775639608, NULL),
	(121, '123123.0154', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 0, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775639608, 1775639608, NULL),
	(122, '123123.0155', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775640050, 1775640050, NULL),
	(123, '123123.0155', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 0, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775640050, 1775640050, NULL),
	(124, '123123.0155', '0', NULL, NULL, NULL, '899123456704', '899123456704', 320000, 320000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775640050, 1775640050, NULL),
	(125, '123123.0155', '0', NULL, NULL, NULL, '899123456706', '899123456706', 150000, 0, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775640050, 1775640050, NULL),
	(126, '123123.0156', '0', NULL, NULL, NULL, '899123456731', '899123456731', 285000, 285000, 0, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775640829, 1775640829, NULL),
	(127, '123123.0156', '0', NULL, NULL, NULL, '899123456730', '899123456730', 310000, 173600, 136400, 0, 0, 0, 0, '', 0, 1, '', 0, '', '', 1, 1775640829, 1775640829, NULL);

-- Dumping structure for table pos_supermarket.transaction_payment
CREATE TABLE IF NOT EXISTS `transaction_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transactionId` varchar(50) NOT NULL DEFAULT '',
  `paymentTypeId` varchar(50) NOT NULL DEFAULT '',
  `paymentNameId` varchar(50) NOT NULL DEFAULT '',
  `amount` double DEFAULT NULL,
  `rounding` double DEFAULT NULL,
  `voucherNumber` varchar(50) DEFAULT '',
  `approvedCode` varchar(50) DEFAULT '',
  `refCode` varchar(50) DEFAULT '',
  `presence` int(11) NOT NULL DEFAULT 0,
  `inputDate` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `input_date` datetime DEFAULT '2023-01-01 00:00:00',
  `update_date` datetime DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=188 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.transaction_payment: ~67 rows (approximately)
INSERT INTO `transaction_payment` (`id`, `transactionId`, `paymentTypeId`, `paymentNameId`, `amount`, `rounding`, `voucherNumber`, `approvedCode`, `refCode`, `presence`, `inputDate`, `updateDate`, `input_date`, `update_date`) VALUES
	(72, '123123.0112', 'CASH', '', 20000, NULL, NULL, '', '', 1, 1704970878, 1704970878, '2024-01-11 18:01:18', '2024-01-11 18:01:18'),
	(73, '123123.0112', 'CASH', '', 5000, NULL, NULL, '', '', 1, 1704970878, 1704970878, '2024-01-11 18:01:18', '2024-01-11 18:01:18'),
	(74, '123123.0112', 'CASH', '', 2, NULL, NULL, '', '', 1, 1704970878, 1704970878, '2024-01-11 18:01:18', '2024-01-11 18:01:18'),
	(75, '123123.0112', 'EDC_MANDIRI', '10', 13, NULL, NULL, '174901', '', 1, 1704970878, 1704970878, '2024-01-11 18:01:18', '2024-01-11 18:01:18'),
	(76, '123123.0112', 'EDC_MANDIRI', '12', 11, NULL, NULL, '175550', '', 1, 1704970878, 1704970878, '2024-01-11 18:01:18', '2024-01-11 18:01:18'),
	(77, '123123.0112', 'CASH', '', 500, NULL, NULL, '', '', 1, 1704970878, 1704970878, '2024-01-11 18:01:18', '2024-01-11 18:01:18'),
	(78, '123123.0112', 'DEBITCC', '10', 51, NULL, NULL, '555555', '', 1, 1704970878, 1704970878, '2024-01-11 18:01:18', '2024-01-11 18:01:18'),
	(79, '123123.0112', 'CASH', '', 171093, NULL, NULL, '', '', 1, 1704970878, 1704970878, '2024-01-11 18:01:18', '2024-01-11 18:01:18'),
	(95, '123123.0113', 'CASH', '', 104840, NULL, NULL, '', '', 1, 1704973809, 1704973809, '2024-01-11 18:50:09', '2024-01-11 18:50:09'),
	(96, '123123.0114', 'CASH', '', 50000, NULL, NULL, '', '', 1, 1704976028, 1704976028, '2024-01-11 19:27:08', '2024-01-11 19:27:08'),
	(97, '123123.0114', 'DEBITCC', '31', 80000, NULL, NULL, '0000001', '', 1, 1704976028, 1704976028, '2024-01-11 19:27:08', '2024-01-11 19:27:08'),
	(98, '123123.0114', 'CASH', '', 1272860, NULL, NULL, '', '', 1, 1704976028, 1704976028, '2024-01-11 19:27:08', '2024-01-11 19:27:08'),
	(99, '123123.0115', 'CASH', '', 188070, NULL, NULL, '', '', 1, 1705035225, 1705035225, '2024-01-12 11:53:45', '2024-01-12 11:53:45'),
	(100, '123123.0116', 'CASH', '', 87500, NULL, NULL, '', '', 1, 1705083708, 1705083708, '2024-01-13 01:21:48', '2024-01-13 01:21:48'),
	(101, '123123.0117', 'CASH', '', 122500, NULL, NULL, '', '', 1, 1705113618, 1705113618, '2024-01-13 09:40:18', '2024-01-13 09:40:18'),
	(104, '123123.0118', 'CASH', '', 87500, NULL, NULL, '', '', 1, 1705114312, 1705114312, '2024-01-13 09:51:52', '2024-01-13 09:51:52'),
	(106, '123123.0119', 'CASH', '', 68300, NULL, NULL, '', '', 1, 1705121075, 1705121075, '2024-01-13 11:44:35', '2024-01-13 11:44:35'),
	(107, '123123.0120', 'CASH', '', 599100, NULL, NULL, '', '', 1, 1705296353, 1705296353, '2024-01-15 12:25:53', '2024-01-15 12:25:53'),
	(108, '123123.0121', 'CASH', '', 157500, NULL, NULL, '', '', 1, 1705316417, 1705316417, '2024-01-15 18:00:17', '2024-01-15 18:00:17'),
	(133, '123123.0122', 'DISC.BILL', '', 22481, NULL, NULL, NULL, NULL, 1, 1705568554, 1705568554, '2024-01-18 16:02:34', '2024-01-18 16:02:34'),
	(134, '123123.0122', 'EDC_MANDIRI', '10', 22500, NULL, NULL, '123606', '401712639068', 1, 1705568554, 1705568554, '2024-01-18 16:02:34', '2024-01-18 16:02:34'),
	(135, '123123.0122', 'EDC_MANDIRI', '11', 19, NULL, NULL, '123606', '401712639068', 1, 1705568554, 1705568554, '2024-01-18 16:02:34', '2024-01-18 16:02:34'),
	(136, '123123.0122', 'EDC_MANDIRI', '10', 19, NULL, NULL, '123606', '401712639068', 1, 1705568554, 1705568554, '2024-01-18 16:02:34', '2024-01-18 16:02:34'),
	(137, '123123.0123', 'CASH', '', 8500, NULL, NULL, '', '', 1, 1705925210, 1705925210, '2024-01-22 19:06:50', '2024-01-22 19:06:50'),
	(138, '123123.0123', 'VOUCHER', '', 10000, NULL, '0449-a0d9-4d79', '12', NULL, 1, 1705925210, 1705925210, '2024-01-22 19:06:50', '2024-01-22 19:06:50'),
	(139, '123123.0123', 'VOUCHER', '', 10000, NULL, '044a-68c0-4cd6', '13', NULL, 1, 1705925210, 1705925210, '2024-01-22 19:06:50', '2024-01-22 19:06:50'),
	(140, '123123.0123', 'CASH', '', 184680, NULL, NULL, '', '', 1, 1705925210, 1705925210, '2024-01-22 19:06:50', '2024-01-22 19:06:50'),
	(141, '123123.0124', 'CASH', '', 300000, NULL, NULL, '', '', 1, 1741765756, 1741765756, '2025-03-12 14:49:16', '2025-03-12 14:49:16'),
	(142, '123123.0125', 'CASH', '', 482000, NULL, NULL, '', '', 1, 1741856725, 1741856725, '2025-03-13 16:05:25', '2025-03-13 16:05:25'),
	(143, '123123.0126', 'DISC.BILL', '', 10, NULL, NULL, NULL, NULL, 1, 1742280855, 1742280855, '2025-03-18 13:54:15', '2025-03-18 13:54:15'),
	(144, '123123.0126', 'CASH', '', 1320494, NULL, NULL, '', '', 1, 1742280855, 1742280855, '2025-03-18 13:54:15', '2025-03-18 13:54:15'),
	(145, '123123.0127', 'CASH', '', 189000, NULL, NULL, '', '', 1, 1742287880, 1742287880, '2025-03-18 15:51:20', '2025-03-18 15:51:20'),
	(146, '123123.0128', 'CASH', '', 325000, NULL, NULL, '', '', 1, 1742373284, 1742373284, '2025-03-19 15:34:44', '2025-03-19 15:34:44'),
	(147, '123123.0129', 'CASH', '', 2762000, NULL, NULL, '', '', 1, 1753685813, 1753685813, '2025-07-28 13:56:53', '2025-07-28 13:56:53'),
	(148, '123123.0130', 'CASH', '', 200000, NULL, NULL, '', '', 1, 1753686997, 1753686997, '2025-07-28 14:16:37', '2025-07-28 14:16:37'),
	(149, '123123.0130', 'CASH', '', 130000, NULL, NULL, '', '', 1, 1753686997, 1753686997, '2025-07-28 14:16:37', '2025-07-28 14:16:37'),
	(150, '123123.0130', 'CASH', '', 1994000, NULL, NULL, '', '', 1, 1753686997, 1753686997, '2025-07-28 14:16:37', '2025-07-28 14:16:37'),
	(151, '123123.0131', 'CASH', '', 801, NULL, '', '', '', 1, 1775041324, 1775041324, '2026-04-01 11:02:04', '2026-04-01 11:02:04'),
	(152, '123123.0131', 'CASH', '', 999999, NULL, '', '', '', 1, 1775041324, 1775041324, '2026-04-01 11:02:04', '2026-04-01 11:02:04'),
	(153, '123123.0132', 'CASH', '', 690000, NULL, '', '', '', 1, 1775041754, 1775041754, '2026-04-01 11:09:14', '2026-04-01 11:09:14'),
	(154, '123123.0132', 'CASH', '', 6000, NULL, '', '', '', 1, 1775041754, 1775041754, '2026-04-01 11:09:14', '2026-04-01 11:09:14'),
	(155, '123123.0132', 'CASH', '', 12, NULL, '', '', '', 1, 1775041754, 1775041754, '2026-04-01 11:09:14', '2026-04-01 11:09:14'),
	(156, '123123.0133', 'CASH', '', 640000, NULL, '', '', '', 1, 1775042143, 1775042143, '2026-04-01 11:15:43', '2026-04-01 11:15:43'),
	(157, '123123.0134', 'CASH', '', 80000, NULL, '', '', '', 1, 1775042815, 1775042815, '2026-04-01 11:26:55', '2026-04-01 11:26:55'),
	(158, '123123.0134', 'CASH', '', 550000, NULL, '', '', '', 1, 1775042815, 1775042815, '2026-04-01 11:26:55', '2026-04-01 11:26:55'),
	(159, '123123.0135', 'CASH', '', 175000, NULL, '', '', '', 1, 1775042935, 1775042935, '2026-04-01 11:28:55', '2026-04-01 11:28:55'),
	(160, '123123.0136', 'CASH', '', 320000, NULL, '', '', '', 1, 1775043114, 1775043114, '2026-04-01 11:31:54', '2026-04-01 11:31:54'),
	(161, '123123.0137', 'CASH', '', 370000, NULL, '', '', '', 1, 1775043725, 1775043725, '2026-04-01 11:42:05', '2026-04-01 11:42:05'),
	(162, '123123.0138', 'CASH', '', 125000, NULL, '', '', '', 1, 1775113273, 1775113273, '2026-04-02 07:01:13', '2026-04-02 07:01:13'),
	(163, '123123.0139', 'CASH', '', 100000, NULL, '', '', '', 1, 1775115256, 1775115256, '2026-04-02 07:34:16', '2026-04-02 07:34:16'),
	(164, '123123.0139', 'EDC_BCA', '', 320000, NULL, '', '', '', 1, 1775115256, 1775115256, '2026-04-02 07:34:16', '2026-04-02 07:34:16'),
	(165, '123123.0140', 'CASH', '', 125000, NULL, '', '', '', 1, 1775116178, 1775116178, '2026-04-02 07:49:38', '2026-04-02 07:49:38'),
	(166, '123123.0141', 'CASH', '', 500000, NULL, '', '', '', 1, 1775119917, 1775119917, '2026-04-02 08:51:57', '2026-04-02 08:51:57'),
	(167, '123123.0142', 'BCA31', '', 2550000, NULL, '', '', '', 1, 1775124607, 1775124607, '2026-04-02 10:10:07', '2026-04-02 10:10:07'),
	(168, '123123.0143', 'EDC_BRI', '', 275000, NULL, '', '', '', 1, 1775470683, 1775470683, '2026-04-06 10:18:03', '2026-04-06 10:18:03'),
	(169, '123123.0144', 'CASH', '', 100000, NULL, '', '', '', 1, 1775472227, 1775472227, '2026-04-06 10:43:47', '2026-04-06 10:43:47'),
	(170, '123123.0144', 'BCA01', '', 500000, NULL, '', '', '', 1, 1775472227, 1775472227, '2026-04-06 10:43:47', '2026-04-06 10:43:47'),
	(171, '123123.0144', 'EDC_MANDIRI', '', 180000, NULL, '', '', '', 1, 1775472227, 1775472227, '2026-04-06 10:43:47', '2026-04-06 10:43:47'),
	(172, '123123.0145', 'CASH', '', 80000, NULL, '', '', '', 1, 1775474718, 1775474718, '2026-04-06 11:25:18', '2026-04-06 11:25:18'),
	(173, '123123.0145', 'CASH', '', 1355000, NULL, '', '', '', 1, 1775474718, 1775474718, '2026-04-06 11:25:18', '2026-04-06 11:25:18'),
	(174, '123123.0146', 'CASH', '', 91000, NULL, '', '', '', 1, 1775477217, 1775477217, '2026-04-06 12:06:57', '2026-04-06 12:06:57'),
	(175, '123123.0146', 'BCA01', '', 396899, NULL, '', '', '', 1, 1775477217, 1775477217, '2026-04-06 12:06:57', '2026-04-06 12:06:57'),
	(176, '123123.0147', 'CASH', '', 130000, NULL, '', '', '', 1, 1775553300, 1775553300, '2026-04-07 09:15:00', '2026-04-07 09:15:00'),
	(177, '123123.0148', 'CASH', '', 473600, NULL, '', '', '', 1, 1775555170, 1775555170, '2026-04-07 09:46:10', '2026-04-07 09:46:10'),
	(178, '123123.0149', 'CASH', '', 35000, NULL, '', '', '', 1, 1775556090, 1775556090, '2026-04-07 10:01:30', '2026-04-07 10:01:30'),
	(179, '123123.0150', 'CASH', '', 100000, NULL, '', '', '', 1, 1775558145, 1775558145, '2026-04-07 10:35:45', '2026-04-07 10:35:45'),
	(180, '123123.0150', 'EDC_BCA', '', 755000, NULL, '', '', '', 1, 1775558145, 1775558145, '2026-04-07 10:35:45', '2026-04-07 10:35:45'),
	(181, '123123.0151', 'BCA31', '', 80000, NULL, '', '', '', 1, 1775558830, 1775558830, '2026-04-07 10:47:10', '2026-04-07 10:47:10'),
	(182, '123123.0151', 'CASH', '', 150000, NULL, '', '', '', 1, 1775558830, 1775558830, '2026-04-07 10:47:10', '2026-04-07 10:47:10'),
	(183, '123123.0152', 'CASH', '', 1492200, NULL, '', '', '', 1, 1775627364, 1775627364, '2026-04-08 05:49:24', '2026-04-08 05:49:24'),
	(184, '123123.0153', 'CASH', '', 480000, NULL, '', '', '', 1, 1775631826, 1775631826, '2026-04-08 07:03:46', '2026-04-08 07:03:46'),
	(185, '123123.0154', 'CASH', '', 640000, NULL, '', '', '', 1, 1775639608, 1775639608, '2026-04-08 09:13:28', '2026-04-08 09:13:28'),
	(186, '123123.0155', 'CASH', '', 640000, NULL, '', '', '', 1, 1775640050, 1775640050, '2026-04-08 09:20:50', '2026-04-08 09:20:50'),
	(187, '123123.0156', 'CASH', '', 458600, NULL, '', '', '', 1, 1775640829, 1775640829, '2026-04-08 09:33:49', '2026-04-08 09:33:49');

-- Dumping structure for table pos_supermarket.transaction_printlog
CREATE TABLE IF NOT EXISTS `transaction_printlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transactionId` varchar(50) DEFAULT NULL,
  `inputDate` datetime DEFAULT '2023-01-01 00:00:00',
  `inputBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.transaction_printlog: ~13 rows (approximately)
INSERT INTO `transaction_printlog` (`id`, `transactionId`, `inputDate`, `inputBy`) VALUES
	(2, '123123.0153', '2026-04-08 08:56:57', 'dev-user'),
	(3, '123123.0153', '2026-04-08 09:00:31', 'dev-user'),
	(4, '123123.0153', '2026-04-08 09:00:44', 'dev-user'),
	(5, '123123.0153', '2026-04-08 09:03:55', '123123'),
	(6, '123123.0153', '2026-04-08 09:04:23', '123123'),
	(7, '123123.0153', '2026-04-08 09:06:23', '123123'),
	(8, '123123.0153', '2026-04-08 09:12:48', '123123'),
	(9, '123123.0154', '2026-04-08 09:13:30', '123123'),
	(10, '123123.0154', '2026-04-08 09:13:33', '123123'),
	(11, '123123.0155', '2026-04-08 09:22:36', '123123'),
	(12, '123123.0155', '2026-04-08 09:22:40', '123123'),
	(13, '123123.0156', '2026-04-08 09:33:53', '123123'),
	(14, '123123.0156', '2026-04-08 09:34:00', '123123');

-- Dumping structure for table pos_supermarket.transaction_voucher
CREATE TABLE IF NOT EXISTS `transaction_voucher` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transactionId` varchar(50) DEFAULT NULL,
  `voucherMinAmount` double NOT NULL DEFAULT 0,
  `voucherAllowMultyple` double NOT NULL DEFAULT 0,
  `voucherGiftAmount` double NOT NULL DEFAULT 0,
  `voucherExpDate` datetime NOT NULL DEFAULT '2029-01-01 00:00:00',
  `inputDate` datetime DEFAULT '2023-01-01 00:00:00',
  `inputBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.transaction_voucher: ~4 rows (approximately)
INSERT INTO `transaction_voucher` (`id`, `transactionId`, `voucherMinAmount`, `voucherAllowMultyple`, `voucherGiftAmount`, `voucherExpDate`, `inputDate`, `inputBy`) VALUES
	(2, '123123.0153', 100000, 1, 50000, '2029-10-10 00:00:00', '2026-04-08 07:03:46', '123123'),
	(3, '123123.0154', 100000, 1, 100000, '2029-01-01 00:00:00', '2026-04-08 09:13:28', '123123'),
	(4, '123123.0155', 100000, 1, 100000, '2029-01-01 00:00:00', '2026-04-08 09:20:50', '123123'),
	(5, '123123.0156', 100000, 1, 50000, '2029-01-01 00:00:00', '2026-04-08 09:33:49', '123123');

-- Dumping structure for table pos_supermarket.user
CREATE TABLE IF NOT EXISTS `user` (
  `id` varchar(50) NOT NULL,
  `name` varchar(250) DEFAULT NULL,
  `userAccessId` int(11) DEFAULT NULL,
  `storeOutlesId` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `presence` int(11) NOT NULL DEFAULT 1,
  `saveFunc` varchar(250) DEFAULT NULL,
  `saveShortCut` varchar(250) DEFAULT NULL,
  `inputBy` int(11) DEFAULT NULL,
  `inputDate` int(11) DEFAULT NULL,
  `updateBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `update_date` datetime DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.user: ~2 rows (approximately)
INSERT INTO `user` (`id`, `name`, `userAccessId`, `storeOutlesId`, `password`, `status`, `presence`, `saveFunc`, `saveShortCut`, `inputBy`, `inputDate`, `updateBy`, `updateDate`, `update_date`) VALUES
	('123123', 'Cashier', 10, NULL, '4297f44b13955235245b2497399d7a93', 1, 1, '[1,2,3,4,5,6,7,12,0,0,0,0]', NULL, NULL, NULL, NULL, 1698052381, '2023-10-23 09:13:01'),
	('123456789', 'Supervisor', 1, NULL, '4297f44b13955235245b2497399d7a93', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01 00:00:00');

-- Dumping structure for table pos_supermarket.user_access
CREATE TABLE IF NOT EXISTS `user_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.user_access: ~4 rows (approximately)
INSERT INTO `user_access` (`id`, `name`) VALUES
	(1, 'Supervisor'),
	(2, 'IT'),
	(3, 'Management'),
	(10, 'Cashier');

-- Dumping structure for table pos_supermarket.user_auth
CREATE TABLE IF NOT EXISTS `user_auth` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `userId` varchar(50) NOT NULL DEFAULT '',
  `agent` varchar(50) NOT NULL DEFAULT '',
  `client_ip` varchar(50) NOT NULL DEFAULT '',
  `terminalId` varchar(50) NOT NULL DEFAULT '',
  `inputDate` datetime NOT NULL DEFAULT '2024-01-01 00:00:00',
  `updateDate` datetime NOT NULL DEFAULT '2024-01-01 00:00:00',
  `status` tinyint(1) DEFAULT 1,
  `token` varchar(50) DEFAULT NULL,
  `inputBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.user_auth: ~14 rows (approximately)
INSERT INTO `user_auth` (`id`, `userId`, `agent`, `client_ip`, `terminalId`, `inputDate`, `updateDate`, `status`, `token`, `inputBy`) VALUES
	('', '123456789', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'TT-112c248d4eb08b97c400ba671f18e76a', '123456789'),
	('65a7667f8cf7c', '65a7667f8cf7c', '', '', 'UATx1', '2024-01-17 12:32:47', '2024-01-01 00:00:00', 1, NULL, NULL),
	('65ae42980788a', '65ae42980788a', '', '', 'UATx1', '2024-01-22 17:25:28', '2024-01-01 00:00:00', 1, NULL, NULL),
	('67d918495aea2', '67d918495aea2', '', '', 'T01', '2025-03-18 13:52:57', '2024-01-01 00:00:00', 1, NULL, NULL),
	('69ca36e3cc832695', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-03-30 15:40:03', '2026-03-30 15:40:51', 0, 'TT-Q7Oy29OoYpaBGrooCFrNLakNdIjYKjHo', '123123'),
	('69ca37138fde55b2', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-03-30 15:40:51', '2026-03-30 17:37:11', 0, 'TT-S1Psp_a7VM7yFLiG8iwBU1IjMwtJ4K80', '123123'),
	('69ca5260482d1bc6', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-03-30 17:37:20', '2026-03-30 17:49:32', 0, 'TT-rdiedeJAVOihx_80oJw3VInwZrtDBjtE', '123123'),
	('69ca5555b4339d5e', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-03-30 17:49:57', '2026-04-01 16:47:41', 0, 'TT-lnzYi2JnSkz6xkpXatONufIza_diMHpk', '123123'),
	('69cce9bdc643e424', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-04-01 16:47:41', '2026-04-01 19:25:07', 0, 'TT-WT9QMACouo7KkB8PtIq0iaH_AZuqUwbQ', '123123'),
	('69cd0ea3e07bc92e', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-04-01 19:25:07', '2026-04-01 19:36:04', 0, 'TT-YpaAdi4A5rTpSSigZBQtk_HkxeH72x3Q', '123123'),
	('69cd113489aff08e', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-04-01 19:36:04', '2026-04-01 19:38:17', 0, 'TT-E_12EqHRSdJnF4vlQ9n45dush6FsyHZg', '123123'),
	('69cd11b9e6ed14b4', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-04-01 19:38:17', '2026-04-02 13:11:17', 0, 'TT-RsQ1dBlVzT2ujbooGQupKSkRPHnHO5U0', '123123'),
	('69ce088598d5c9f5', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-04-02 13:11:17', '2026-04-02 14:23:41', 0, 'TT-bntnrdUDDhBaLXG_UBtakMr5rcf51yOw', '123123'),
	('69ce197da03ffbcd', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-04-02 14:23:41', '2026-04-02 17:10:36', 0, 'TT-ttdy983uea_wcOjDI6e-ft0yDgsrIuFI', '123123'),
	('69ce46e4135c28a2', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-04-02 17:37:24', '2026-04-02 17:37:54', 0, 'TT-sULyNmRLJEToUTCl0WkLkeKO2y_ATyjI', '123123'),
	('69d368bcd433e18a', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-04-06 15:03:08', '2026-04-06 16:36:41', 0, 'TT-Wq5pI0AvmI5144bzZoTOnY-b6014MQeg', '123123'),
	('69d37eac5fcc009d', '123123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb', '::1', 'T01', '2026-04-06 16:36:44', '2026-04-06 16:36:44', 1, 'TT-tYihRvPitn6nT4HewcuqLtoWZu7-cKSA', '123123');

-- Dumping structure for table pos_supermarket.user_func
CREATE TABLE IF NOT EXISTS `user_func` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` varchar(50) NOT NULL DEFAULT '',
  `number` int(2) NOT NULL DEFAULT 0,
  `color` varchar(50) NOT NULL DEFAULT '',
  `sorting` int(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table pos_supermarket.user_func: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.user_pin
CREATE TABLE IF NOT EXISTS `user_pin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` varchar(250) DEFAULT NULL,
  `pin` varchar(250) NOT NULL,
  `updateBy` int(11) DEFAULT NULL,
  `updateDate` int(11) DEFAULT NULL,
  `update_date` datetime DEFAULT '2023-01-01 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pin` (`pin`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table pos_supermarket.user_pin: ~1 rows (approximately)
INSERT INTO `user_pin` (`id`, `userId`, `pin`, `updateBy`, `updateDate`, `update_date`) VALUES
	(1, '123456789', '4297f44b13955235245b2497399d7a93', NULL, NULL, '2023-01-01 00:00:00');

-- Dumping structure for table pos_supermarket.voucher
CREATE TABLE IF NOT EXISTS `voucher` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `voucherMasterId` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_general_ci NOT NULL DEFAULT '0',
  `number` varchar(50) NOT NULL DEFAULT '0',
  `amount` int(9) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 0,
  `kioskUuid` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_general_ci NOT NULL DEFAULT '',
  `transactionId` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_general_ci NOT NULL DEFAULT '',
  `update_date` datetime NOT NULL DEFAULT '2024-01-01 00:00:00',
  `input_date` datetime NOT NULL DEFAULT '2024-01-01 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `number` (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table pos_supermarket.voucher: ~0 rows (approximately)

-- Dumping structure for table pos_supermarket.voucher_master
CREATE TABLE IF NOT EXISTS `voucher_master` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_general_ci NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `donwload` int(3) NOT NULL DEFAULT 0,
  `expDate` date DEFAULT '2026-01-01',
  `filename` varchar(50) DEFAULT NULL,
  `input_date` datetime NOT NULL DEFAULT '2024-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table pos_supermarket.voucher_master: ~0 rows (approximately)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
