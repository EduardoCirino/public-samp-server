-- phpMyAdmin SQL Dump
-- version 4.8.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 16-Fev-2019 às 03:30
-- Versão do servidor: 10.1.33-MariaDB
-- PHP Version: 7.2.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `public`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `advertisements`
--

CREATE TABLE `advertisements` (
  `adID` int(11) NOT NULL,
  `adUID` int(11) NOT NULL,
  `adText` varchar(128) NOT NULL,
  `adTime` int(11) NOT NULL,
  `adInQueue` int(11) NOT NULL,
  `adSenderPhone` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `armazemcasa`
--

CREATE TABLE `armazemcasa` (
  `ID` int(11) NOT NULL DEFAULT '0',
  `itemID` int(11) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(11) NOT NULL DEFAULT '0',
  `itemQuantity` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `atm`
--

CREATE TABLE `atm` (
  `atmID` int(11) NOT NULL,
  `atmX` float NOT NULL,
  `atmY` float NOT NULL,
  `atmZ` float NOT NULL,
  `atmRX` float NOT NULL,
  `atmRY` float NOT NULL,
  `atmRZ` float NOT NULL,
  `atmInterior` int(11) NOT NULL,
  `atmWorld` int(11) NOT NULL,
  `atmMoney` int(11) NOT NULL,
  `atmRobbed` int(11) NOT NULL,
  `atmTime` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `attachments`
--

CREATE TABLE `attachments` (
  `ID` int(11) NOT NULL,
  `attachID` int(11) NOT NULL,
  `attachObject` int(11) NOT NULL,
  `attachIndex` int(11) NOT NULL,
  `attachBone` int(11) NOT NULL,
  `attachUsing` int(11) NOT NULL,
  `attachName` varchar(64) NOT NULL,
  `attachX` float NOT NULL,
  `attachY` float NOT NULL,
  `attachZ` float NOT NULL,
  `attachRX` float NOT NULL,
  `attachRY` float NOT NULL,
  `attachRZ` float NOT NULL,
  `attachSX` float NOT NULL,
  `attachSY` float NOT NULL,
  `attachSZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `bank_history`
--

CREATE TABLE `bank_history` (
  `player_id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `type` varchar(32) NOT NULL,
  `action` varchar(64) DEFAULT NULL,
  `value` int(11) NOT NULL,
  `date` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `bugreport`
--

CREATE TABLE `bugreport` (
  `uniqueid` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `reportdate` varchar(32) NOT NULL,
  `bug` varchar(144) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `doneby` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `business`
--

CREATE TABLE `business` (
  `businessID` int(11) NOT NULL,
  `businessOwnerID` int(11) NOT NULL,
  `businessOwnerName` varchar(24) NOT NULL,
  `businessName` varchar(128) NOT NULL,
  `businessType` int(11) NOT NULL,
  `businessPrice` int(11) NOT NULL,
  `businessVW` int(11) NOT NULL,
  `businessX` float NOT NULL,
  `businessY` float NOT NULL,
  `businessZ` float NOT NULL,
  `businessIntX` float NOT NULL,
  `businessIntY` float NOT NULL,
  `businessIntZ` float NOT NULL,
  `businessInterior` int(11) NOT NULL,
  `businessVault` int(11) NOT NULL,
  `businessProduct` varchar(128) NOT NULL,
  `businessProductPrice` varchar(128) NOT NULL,
  `businessStock` int(11) NOT NULL,
  `businessFuel` int(11) NOT NULL,
  `businessBuying` int(11) NOT NULL,
  `businessBuyingPrice` int(11) NOT NULL,
  `businessBuyingProduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `caixas`
--

CREATE TABLE `caixas` (
  `crateID` int(11) NOT NULL,
  `crateType` int(11) NOT NULL,
  `crateQuantity` int(11) NOT NULL,
  `crateX` float NOT NULL,
  `crateY` float NOT NULL,
  `crateZ` float NOT NULL,
  `crateA` float NOT NULL,
  `crateInterior` int(11) NOT NULL,
  `crateWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cameras`
--

CREATE TABLE `cameras` (
  `cameraID` int(11) NOT NULL,
  `cameraX` float NOT NULL,
  `cameraY` float NOT NULL,
  `cameraZ` float NOT NULL,
  `cameraRX` float NOT NULL,
  `cameraRY` float NOT NULL,
  `cameraRZ` float NOT NULL,
  `cameraInterior` int(11) NOT NULL,
  `cameraWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `carros`
--

CREATE TABLE `carros` (
  `vehicleID` int(11) NOT NULL,
  `vehicleOwnerName` varchar(24) NOT NULL,
  `ID` int(11) NOT NULL,
  `vehicleFaction` int(11) NOT NULL DEFAULT '-1',
  `vehicleJob` int(11) NOT NULL DEFAULT '-1',
  `vehiclePlate` varchar(15) NOT NULL,
  `vehicleLocked` int(11) NOT NULL,
  `vehicleLocator` int(11) NOT NULL,
  `vehicleSeguro` int(11) NOT NULL,
  `vehicleTrava` int(11) NOT NULL,
  `vehicleXMRadio` int(11) NOT NULL,
  `vehicleParked` int(11) NOT NULL,
  `vehicleParked_X` float NOT NULL,
  `vehicleParked_Y` float NOT NULL,
  `vehicleParked_Z` float NOT NULL,
  `vehicleParked_A` float NOT NULL,
  `vehicleParkedVW` int(11) NOT NULL,
  `vehicleModel` int(11) NOT NULL,
  `vehiclePrice` int(11) NOT NULL,
  `vehicleColor1` int(11) NOT NULL,
  `vehicleColor2` int(11) NOT NULL,
  `vehicleFuel` float NOT NULL,
  `vehicleMod` varchar(128) NOT NULL,
  `vehicleWeapon` varchar(256) NOT NULL DEFAULT '0',
  `vehicleInteriorWeapon` int(11) NOT NULL,
  `vehicleInteriorAmmo` int(11) NOT NULL,
  `vehicleHealth` float NOT NULL,
  `vehicleMaxHealth` float NOT NULL,
  `vehicleDamage1` int(11) NOT NULL,
  `vehicleDamage2` int(11) NOT NULL,
  `vehicleDamage3` int(11) NOT NULL,
  `vehicleDamage4` int(11) NOT NULL,
  `vehicleMileage` float NOT NULL,
  `vehicleEngine` float NOT NULL,
  `vehicleExpressWay` int(11) NOT NULL,
  `vehicleExpressMoney` int(11) NOT NULL,
  `vehicleSiren` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `carrosapreendidos`
--

CREATE TABLE `carrosapreendidos` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `officer` varchar(24) NOT NULL,
  `reason` varchar(64) NOT NULL,
  `price` int(11) NOT NULL,
  `model` varchar(32) NOT NULL,
  `plate` varchar(15) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `created_at` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `casas`
--

CREATE TABLE `casas` (
  `houseID` int(11) NOT NULL,
  `houseOwner` int(11) NOT NULL DEFAULT '0',
  `housePrice` int(11) NOT NULL DEFAULT '0',
  `houseOwnerName` varchar(24) NOT NULL,
  `houseAddress` varchar(32) NOT NULL,
  `housePosX` float NOT NULL DEFAULT '0',
  `housePosY` float NOT NULL DEFAULT '0',
  `housePosZ` float NOT NULL DEFAULT '0',
  `housePosA` float NOT NULL DEFAULT '0',
  `houseIntX` float NOT NULL DEFAULT '0',
  `houseIntY` float NOT NULL DEFAULT '0',
  `houseIntZ` float NOT NULL DEFAULT '0',
  `houseIntA` float NOT NULL DEFAULT '0',
  `houseInterior` int(11) NOT NULL DEFAULT '0',
  `houseVW` int(11) NOT NULL DEFAULT '0',
  `houseComplex` int(11) NOT NULL DEFAULT '-1',
  `houseExtVW` int(11) NOT NULL,
  `houseExtInterior` int(11) NOT NULL,
  `houseLocked` int(11) NOT NULL DEFAULT '0',
  `houseWeapon1` int(11) NOT NULL DEFAULT '0',
  `houseAmmo1` int(11) NOT NULL DEFAULT '0',
  `houseWeapon2` int(11) NOT NULL DEFAULT '0',
  `houseAmmo2` int(11) NOT NULL DEFAULT '0',
  `houseWeapon3` int(11) NOT NULL DEFAULT '0',
  `houseAmmo3` int(11) NOT NULL DEFAULT '0',
  `houseWeapon4` int(11) NOT NULL DEFAULT '0',
  `houseAmmo4` int(11) NOT NULL DEFAULT '0',
  `houseWeapon5` int(11) NOT NULL DEFAULT '0',
  `houseAmmo5` int(11) NOT NULL DEFAULT '0',
  `houseWeapon6` int(11) NOT NULL DEFAULT '0',
  `houseAmmo6` int(11) NOT NULL DEFAULT '0',
  `houseWeapon7` int(11) NOT NULL DEFAULT '0',
  `houseAmmo7` int(11) NOT NULL DEFAULT '0',
  `houseWeapon8` int(11) NOT NULL DEFAULT '0',
  `houseAmmo8` int(11) NOT NULL DEFAULT '0',
  `houseWeapon9` int(11) NOT NULL DEFAULT '0',
  `houseAmmo9` int(11) NOT NULL DEFAULT '0',
  `houseWeapon10` int(11) NOT NULL DEFAULT '0',
  `houseAmmo10` int(11) NOT NULL DEFAULT '0',
  `houseMoney` int(11) NOT NULL DEFAULT '0',
  `houseFurnitureA1` int(11) NOT NULL DEFAULT '-1',
  `houseFurnitureA2` int(11) NOT NULL DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cellphone_contacts`
--

CREATE TABLE `cellphone_contacts` (
  `uniqueid` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `contact_name` varchar(16) NOT NULL,
  `contact_number` int(11) NOT NULL,
  `contact_createdate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cellphone_messages`
--

CREATE TABLE `cellphone_messages` (
  `uniqueid` int(11) NOT NULL,
  `sender_number` int(11) NOT NULL,
  `receiver_number` int(11) NOT NULL,
  `message` varchar(100) NOT NULL,
  `date` int(11) NOT NULL,
  `stats` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cellphone_recents`
--

CREATE TABLE `cellphone_recents` (
  `uniqueid` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `call_number` int(11) NOT NULL,
  `call_stats` int(11) NOT NULL,
  `call_date` int(11) NOT NULL,
  `call_duration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cellphone_towers`
--

CREATE TABLE `cellphone_towers` (
  `towerID` int(11) NOT NULL,
  `towerSignal` float NOT NULL,
  `towerX` float NOT NULL,
  `towerY` float NOT NULL,
  `towerZ` float NOT NULL,
  `towerRX` float NOT NULL,
  `towerRY` float NOT NULL,
  `towerRZ` float NOT NULL,
  `towerName` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `chopshop`
--

CREATE TABLE `chopshop` (
  `chopshopID` int(11) NOT NULL,
  `chopshopX` float NOT NULL,
  `chopshopY` float NOT NULL,
  `chopshopZ` float NOT NULL,
  `chopshopRX` float NOT NULL,
  `chopshopRY` float NOT NULL,
  `chopshopRZ` float NOT NULL,
  `chopshopCarWanted` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cofreorg`
--

CREATE TABLE `cofreorg` (
  `ID` int(11) NOT NULL,
  `cofreID` int(11) NOT NULL,
  `cofreDinheiro` int(11) NOT NULL,
  `cofreArmas` varchar(200) NOT NULL,
  `cofreDrogas` varchar(50) NOT NULL,
  `cofreX` float NOT NULL,
  `cofreY` float NOT NULL,
  `cofreZ` float NOT NULL,
  `cofreRX` float NOT NULL,
  `cofreRY` float NOT NULL,
  `cofreRZ` float NOT NULL,
  `cofreInterior` int(11) NOT NULL,
  `cofreWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `complex`
--

CREATE TABLE `complex` (
  `complexID` int(11) NOT NULL,
  `complexName` varchar(64) NOT NULL,
  `complexX` float NOT NULL,
  `complexY` float NOT NULL,
  `complexZ` float NOT NULL,
  `complexIntX` float NOT NULL,
  `complexIntY` float NOT NULL,
  `complexIntZ` float NOT NULL,
  `complexLocked` int(11) NOT NULL,
  `complexInterior` int(11) NOT NULL,
  `complexVW` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `dailytasks`
--

CREATE TABLE `dailytasks` (
  `sequencial_number` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `accepted` int(11) NOT NULL,
  `concluded` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `entradas`
--

CREATE TABLE `entradas` (
  `entranceID` int(11) NOT NULL,
  `entranceType` int(11) NOT NULL,
  `entranceName` varchar(128) NOT NULL,
  `entranceX` float NOT NULL,
  `entranceY` float NOT NULL,
  `entranceZ` float NOT NULL,
  `entranceIntX` float NOT NULL,
  `entranceIntY` float NOT NULL,
  `entranceIntZ` float NOT NULL,
  `entranceInterior` int(11) NOT NULL,
  `entranceVW` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `events`
--

CREATE TABLE `events` (
  `uniqueid` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  `event` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `factions`
--

CREATE TABLE `factions` (
  `factionID` int(11) NOT NULL,
  `factionName` varchar(64) DEFAULT NULL,
  `factionColor` int(11) NOT NULL DEFAULT '0',
  `factionType` int(11) NOT NULL DEFAULT '0',
  `factionRanks` int(11) NOT NULL DEFAULT '0',
  `Locker` varchar(128) NOT NULL,
  `factionWeapon1` int(11) NOT NULL DEFAULT '0',
  `factionAmmo1` int(11) NOT NULL DEFAULT '0',
  `factionWeapon2` int(11) NOT NULL DEFAULT '0',
  `factionAmmo2` int(11) NOT NULL DEFAULT '0',
  `factionWeapon3` int(11) NOT NULL DEFAULT '0',
  `factionAmmo3` int(11) NOT NULL DEFAULT '0',
  `factionWeapon4` int(11) NOT NULL DEFAULT '0',
  `factionAmmo4` int(11) NOT NULL DEFAULT '0',
  `factionWeapon5` int(11) NOT NULL DEFAULT '0',
  `factionAmmo5` int(11) NOT NULL DEFAULT '0',
  `factionWeapon6` int(11) NOT NULL DEFAULT '0',
  `factionAmmo6` int(11) NOT NULL DEFAULT '0',
  `factionWeapon7` int(11) NOT NULL DEFAULT '0',
  `factionAmmo7` int(11) NOT NULL DEFAULT '0',
  `factionWeapon8` int(11) NOT NULL DEFAULT '0',
  `factionAmmo8` int(11) NOT NULL DEFAULT '0',
  `factionWeapon9` int(11) NOT NULL DEFAULT '0',
  `factionAmmo9` int(11) NOT NULL DEFAULT '0',
  `factionWeapon10` int(11) NOT NULL DEFAULT '0',
  `factionAmmo10` int(11) NOT NULL DEFAULT '0',
  `factionRank1` varchar(32) DEFAULT NULL,
  `factionRank2` varchar(32) NOT NULL,
  `factionRank3` varchar(32) NOT NULL,
  `factionRank4` varchar(32) DEFAULT NULL,
  `factionRank5` varchar(32) DEFAULT NULL,
  `factionRank6` varchar(32) DEFAULT NULL,
  `factionRank7` varchar(32) DEFAULT NULL,
  `factionRank8` varchar(32) DEFAULT NULL,
  `factionRank9` varchar(32) DEFAULT NULL,
  `factionRank10` varchar(32) DEFAULT NULL,
  `factionRank11` varchar(32) DEFAULT NULL,
  `factionRank12` varchar(32) DEFAULT NULL,
  `factionRank13` varchar(32) DEFAULT NULL,
  `factionRank14` varchar(32) DEFAULT NULL,
  `factionRank15` varchar(32) DEFAULT NULL,
  `factionSkin1` int(11) NOT NULL DEFAULT '0',
  `factionSkin2` int(11) NOT NULL DEFAULT '0',
  `factionSkin3` int(11) NOT NULL DEFAULT '0',
  `factionSkin4` int(11) NOT NULL DEFAULT '0',
  `factionSkin5` int(11) NOT NULL DEFAULT '0',
  `factionSkin6` int(11) NOT NULL DEFAULT '0',
  `factionSkin7` int(11) NOT NULL DEFAULT '0',
  `factionSkin8` int(11) NOT NULL DEFAULT '0',
  `factionSkin9` int(11) NOT NULL,
  `factionSkin10` int(11) NOT NULL,
  `factionSkin11` int(11) NOT NULL,
  `factionSkin12` int(11) NOT NULL,
  `factionSkin13` int(11) NOT NULL,
  `factionSkin14` int(11) NOT NULL,
  `factionSkin15` int(11) NOT NULL,
  `factionSkin16` int(11) NOT NULL,
  `factionSkin17` int(11) NOT NULL,
  `factionSkin18` int(11) NOT NULL,
  `factionSkin19` int(11) NOT NULL,
  `factionSkin20` int(11) NOT NULL,
  `factionSkin21` int(11) NOT NULL,
  `factionSkin22` int(11) NOT NULL,
  `factionSkin23` int(11) NOT NULL,
  `factionSkin24` int(11) NOT NULL,
  `factionSkin25` int(11) NOT NULL,
  `factionSkin26` int(11) NOT NULL,
  `factionSkin27` int(11) NOT NULL,
  `factionSkin28` int(11) NOT NULL,
  `Spawn` varchar(64) NOT NULL,
  `factionPaycheck1` int(11) NOT NULL,
  `factionPaycheck2` int(11) NOT NULL,
  `factionPaycheck3` int(11) NOT NULL,
  `factionPaycheck4` int(11) NOT NULL,
  `factionPaycheck5` int(11) NOT NULL,
  `factionPaycheck6` int(11) NOT NULL,
  `factionPaycheck7` int(11) NOT NULL,
  `factionPaycheck8` int(11) NOT NULL,
  `factionPaycheck9` int(11) NOT NULL,
  `factionPaycheck10` int(11) NOT NULL,
  `factionPaycheck11` int(11) NOT NULL,
  `factionPaycheck12` int(11) NOT NULL,
  `factionPaycheck13` int(11) NOT NULL,
  `factionPaycheck14` int(11) NOT NULL,
  `factionPaycheck15` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `families`
--

CREATE TABLE `families` (
  `familyID` int(11) NOT NULL,
  `familyName` varchar(64) NOT NULL,
  `familyTag` varchar(10) NOT NULL,
  `familyRanks` int(11) NOT NULL,
  `familyExpiresAt` int(11) NOT NULL,
  `familyPlusRenew` int(11) NOT NULL,
  `familyWarned` int(11) NOT NULL,
  `familyRank1` varchar(32) NOT NULL,
  `familyRank2` varchar(32) NOT NULL,
  `familyRank3` varchar(32) NOT NULL,
  `familyRank4` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `gps`
--

CREATE TABLE `gps` (
  `ID` int(11) NOT NULL,
  `locationID` int(11) NOT NULL,
  `locationName` varchar(32) NOT NULL,
  `locationX` float NOT NULL,
  `locationY` float NOT NULL,
  `locationZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `group_rob`
--

CREATE TABLE `group_rob` (
  `groupID` int(11) NOT NULL,
  `groupName` varchar(64) NOT NULL,
  `groupRanks` int(11) NOT NULL,
  `groupExpiresAt` int(11) NOT NULL,
  `groupRank1` varchar(32) NOT NULL,
  `groupRank2` varchar(32) NOT NULL,
  `groupRank3` varchar(32) NOT NULL,
  `groupRank4` varchar(32) NOT NULL,
  `groupRobPlace` int(11) NOT NULL,
  `groupRobStyle` int(11) NOT NULL,
  `groupRobOut` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `industry`
--

CREATE TABLE `industry` (
  `industryID` int(11) NOT NULL,
  `industryName` varchar(128) NOT NULL,
  `industryType` int(11) NOT NULL,
  `industrySection` int(11) NOT NULL,
  `industryX` float NOT NULL,
  `industryY` float NOT NULL,
  `industryZ` float NOT NULL,
  `industryProduct` varchar(128) NOT NULL,
  `industryProductPrice` varchar(128) NOT NULL,
  `industryProductStock` varchar(128) NOT NULL,
  `industryProductMaxStock` varchar(128) NOT NULL,
  `industryBuying` varchar(128) NOT NULL,
  `industryBuyingPrice` varchar(128) NOT NULL,
  `industryBuyingStock` varchar(128) NOT NULL,
  `industryBuyingMaxStock` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `inventario`
--

CREATE TABLE `inventario` (
  `ID` int(11) NOT NULL DEFAULT '0',
  `invID` int(11) NOT NULL,
  `invItem` varchar(32) DEFAULT NULL,
  `invModel` int(11) NOT NULL DEFAULT '0',
  `invQuantity` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `itensdropados`
--

CREATE TABLE `itensdropados` (
  `ID` int(11) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(11) NOT NULL DEFAULT '0',
  `itemX` float NOT NULL DEFAULT '0',
  `itemY` float NOT NULL DEFAULT '0',
  `itemZ` float NOT NULL DEFAULT '0',
  `itemInt` int(11) NOT NULL DEFAULT '0',
  `itemWorld` int(11) NOT NULL DEFAULT '0',
  `itemQuantity` int(11) NOT NULL DEFAULT '0',
  `itemWeapon` int(11) NOT NULL DEFAULT '0',
  `itemAmmo` int(11) NOT NULL DEFAULT '0',
  `itemPlayer` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `market`
--

CREATE TABLE `market` (
  `sql_id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `item_name` varchar(128) NOT NULL,
  `item_model` int(11) NOT NULL,
  `item_quantity` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  `expires` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `market_history`
--

CREATE TABLE `market_history` (
  `sql_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `log` varchar(128) NOT NULL,
  `date` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `market_mailbox`
--

CREATE TABLE `market_mailbox` (
  `sql_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `item_name` varchar(32) NOT NULL,
  `item_model` int(11) NOT NULL,
  `item_quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `mascaras_antigas`
--

CREATE TABLE `mascaras_antigas` (
  `maskID` int(11) NOT NULL,
  `maskLastOwner` varchar(24) NOT NULL,
  `maskChangedDate` varchar(32) NOT NULL,
  `maskNumber` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `mascaras_atuais`
--

CREATE TABLE `mascaras_atuais` (
  `maskID` int(11) NOT NULL,
  `maskOwner` varchar(24) NOT NULL,
  `maskBought` varchar(32) NOT NULL,
  `maskNumber` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `mobilias`
--

CREATE TABLE `mobilias` (
  `ID` int(11) NOT NULL,
  `furnitureID` int(11) NOT NULL,
  `furnitureX` double NOT NULL,
  `furnitureY` double NOT NULL,
  `furnitureZ` double NOT NULL,
  `furnitureRotX` double NOT NULL,
  `furnitureRotY` double NOT NULL,
  `furnitureRotZ` double NOT NULL,
  `furnitureDoorZ` double NOT NULL,
  `furnitureInterior` int(11) NOT NULL,
  `furnitureVW` int(11) NOT NULL,
  `furnitureName` varchar(128) NOT NULL,
  `furnitureOriginalName` varchar(128) NOT NULL,
  `furniturePrice` int(11) NOT NULL,
  `furnitureModel` int(11) NOT NULL,
  `furnitureObject` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `mobiliastextura`
--

CREATE TABLE `mobiliastextura` (
  `furnitureID` int(11) NOT NULL,
  `textureID` int(11) NOT NULL,
  `textureMaterial` int(11) NOT NULL DEFAULT '19341',
  `textureTXD` varchar(64) NOT NULL DEFAULT 'invalid',
  `textureName` varchar(64) NOT NULL DEFAULT 'invalid',
  `textureIndex` int(11) NOT NULL,
  `textureNickName` varchar(64) NOT NULL,
  `textureColor` int(11) NOT NULL,
  `textureColorName` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `multas`
--

CREATE TABLE `multas` (
  `ID` int(11) NOT NULL,
  `ticketID` int(11) NOT NULL,
  `ticketFee` int(11) NOT NULL,
  `ticketBy` varchar(24) DEFAULT NULL,
  `ticketDate` varchar(36) NOT NULL,
  `ticketReason` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `namechanges`
--

CREATE TABLE `namechanges` (
  `ncID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `OldName` varchar(24) NOT NULL,
  `NewName` varchar(24) NOT NULL,
  `Date` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `objetos`
--

CREATE TABLE `objetos` (
  `objectID` int(11) NOT NULL,
  `objectModel` int(11) NOT NULL,
  `objectX` double NOT NULL,
  `objectY` double NOT NULL,
  `objectZ` double NOT NULL,
  `objectRX` double NOT NULL,
  `objectRY` double NOT NULL,
  `objectRZ` double NOT NULL,
  `objectInterior` int(11) NOT NULL,
  `objectWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `objetostextura`
--

CREATE TABLE `objetostextura` (
  `objectID` int(11) NOT NULL,
  `textureID` int(11) NOT NULL,
  `textureMaterial` int(11) NOT NULL DEFAULT '19341',
  `textureTXD` varchar(64) NOT NULL DEFAULT 'invalid',
  `textureName` varchar(64) NOT NULL DEFAULT 'invalid',
  `textureIndex` int(11) NOT NULL,
  `textureColor` int(11) NOT NULL DEFAULT '0',
  `textureNickName` varchar(64) NOT NULL,
  `textureColorName` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `status` varchar(128) NOT NULL DEFAULT 'NOT_PAID',
  `payment_amount` float NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `reference` varchar(50) NOT NULL,
  `data` varchar(50) NOT NULL,
  `transaction_code` varchar(128) NOT NULL,
  `viptype` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `checkouturl` varchar(156) NOT NULL,
  `creditado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `players`
--

CREATE TABLE `players` (
  `Online` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `Name` varchar(24) NOT NULL,
  `Password` varchar(128) NOT NULL,
  `LastLogin` varchar(32) NOT NULL DEFAULT 'Nunca',
  `AdminLevel` int(11) NOT NULL DEFAULT '0',
  `Money` int(11) NOT NULL DEFAULT '0',
  `SkinID` int(11) NOT NULL DEFAULT '0',
  `Level` int(11) NOT NULL DEFAULT '0',
  `Respect` int(11) NOT NULL DEFAULT '0',
  `Sex` int(11) NOT NULL DEFAULT '0',
  `Tutorial` int(11) NOT NULL DEFAULT '0',
  `CarLicense` int(11) NOT NULL DEFAULT '0',
  `FlyLicense` int(11) NOT NULL DEFAULT '0',
  `BoatLicense` int(11) NOT NULL DEFAULT '0',
  `StyleFight` int(11) NOT NULL DEFAULT '0',
  `MoneyBank` int(11) NOT NULL DEFAULT '0',
  `Savings` int(11) NOT NULL DEFAULT '0',
  `Spawn` int(11) NOT NULL DEFAULT '0',
  `Cellphone` int(11) NOT NULL DEFAULT '0',
  `CellphoneBackground` int(11) NOT NULL,
  `CellphoneRingtone` int(11) NOT NULL,
  `CellphoneCallNotification` int(11) NOT NULL,
  `CellphoneSMSNotification` int(11) NOT NULL,
  `StatusCellphone` int(11) NOT NULL DEFAULT '0',
  `Arrested` int(11) NOT NULL DEFAULT '0',
  `ArrestTime` int(11) NOT NULL DEFAULT '0',
  `Warns` int(11) NOT NULL DEFAULT '0',
  `Job` int(11) NOT NULL DEFAULT '0',
  `Paycheck` int(11) NOT NULL DEFAULT '0',
  `TimePlayed` int(11) NOT NULL DEFAULT '0',
  `VipLevel` int(11) NOT NULL DEFAULT '0',
  `VipTime` int(11) NOT NULL DEFAULT '0',
  `Gun1` int(11) NOT NULL,
  `Ammo1` int(11) NOT NULL,
  `Gun2` int(11) NOT NULL,
  `Ammo2` int(11) NOT NULL,
  `Gun3` int(11) NOT NULL,
  `Ammo3` int(11) NOT NULL,
  `Gun4` int(11) NOT NULL,
  `Ammo4` int(11) NOT NULL,
  `Gun5` int(11) NOT NULL,
  `Ammo5` int(11) NOT NULL,
  `Gun6` int(11) NOT NULL,
  `Ammo6` int(11) NOT NULL,
  `Gun7` int(11) NOT NULL,
  `Ammo7` int(11) NOT NULL,
  `Gun8` int(11) NOT NULL,
  `Ammo8` int(11) NOT NULL,
  `Gun9` int(11) NOT NULL,
  `Ammo9` int(11) NOT NULL,
  `Gun10` int(11) NOT NULL,
  `Ammo10` int(11) NOT NULL,
  `Gun11` int(11) NOT NULL,
  `Ammo11` int(11) NOT NULL,
  `Gun12` int(11) NOT NULL,
  `Ammo12` int(11) NOT NULL,
  `Gun13` int(11) NOT NULL,
  `Ammo13` int(11) NOT NULL,
  `Faction` int(11) NOT NULL DEFAULT '-1',
  `FactionRank` int(11) NOT NULL DEFAULT '-1',
  `FactionMod` int(11) NOT NULL DEFAULT '-1',
  `State` int(11) NOT NULL DEFAULT '1',
  `DeathTime` int(11) NOT NULL,
  `DeathPosX` float NOT NULL,
  `DeathPosY` float NOT NULL,
  `DeathPosZ` float NOT NULL,
  `DeathInterior` int(11) NOT NULL,
  `DeathWorld` int(11) NOT NULL,
  `DutyBlock` int(11) NOT NULL,
  `Entrance` int(11) NOT NULL DEFAULT '-1',
  `House` int(11) NOT NULL DEFAULT '-1',
  `Business` int(11) NOT NULL DEFAULT '-1',
  `Complex` int(11) NOT NULL DEFAULT '-1',
  `RespawnTime` int(11) NOT NULL,
  `Hospital` int(11) NOT NULL,
  `HospitalTime` int(11) NOT NULL,
  `RadioSlot1` int(11) NOT NULL,
  `RadioSlot2` int(11) NOT NULL,
  `RadioSlot3` int(11) NOT NULL,
  `RadioSlot4` int(11) NOT NULL,
  `LastIP` varchar(16) DEFAULT NULL,
  `Mask` int(11) NOT NULL,
  `PMMuted` int(11) NOT NULL,
  `Health` float NOT NULL DEFAULT '100',
  `Armor` float NOT NULL DEFAULT '0',
  `Namechange` int(11) NOT NULL,
  `CustomPlate` int(11) NOT NULL,
  `BlockFurniture` int(11) NOT NULL,
  `BlockBuyVehicle` int(11) NOT NULL,
  `BlockMoney` int(11) NOT NULL,
  `BlockedMoney` int(11) NOT NULL,
  `Crashed` int(11) NOT NULL,
  `Grupo` int(11) NOT NULL DEFAULT '-1',
  `GrupoRank` int(11) NOT NULL DEFAULT '-1',
  `Family` int(11) NOT NULL DEFAULT '-1',
  `FamilyRank` int(11) NOT NULL DEFAULT '-1',
  `CreateFamily` int(11) NOT NULL,
  `AdminHide` int(11) NOT NULL,
  `LawyerBlock` int(11) NOT NULL,
  `LawyerTime` int(11) NOT NULL,
  `CellphoneItem` int(11) NOT NULL DEFAULT '330',
  `FishBait` int(11) NOT NULL,
  `Thirst` int(11) NOT NULL DEFAULT '100',
  `Hungry` int(11) NOT NULL DEFAULT '100',
  `WarnReason1` varchar(64) NOT NULL,
  `WarnReason2` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_banned`
--

CREATE TABLE `player_banned` (
  `ID` int(11) NOT NULL,
  `Name` varchar(24) NOT NULL,
  `Admin` varchar(24) NOT NULL,
  `Reason` varchar(128) NOT NULL,
  `Date` varchar(32) NOT NULL,
  `UnbanTime` int(11) NOT NULL,
  `IP` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_crashed`
--

CREATE TABLE `player_crashed` (
  `crashID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL,
  `OnDuty` int(11) NOT NULL,
  `dutyWeapons` varchar(128) NOT NULL,
  `dutySkin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_log`
--

CREATE TABLE `player_log` (
  `LogID` int(11) NOT NULL,
  `PlayerID` int(11) NOT NULL,
  `Log` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `police_apb`
--

CREATE TABLE `police_apb` (
  `apb` int(11) NOT NULL,
  `date` varchar(32) NOT NULL,
  `text` varchar(156) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `police_niners`
--

CREATE TABLE `police_niners` (
  `niner` int(11) NOT NULL,
  `callernumber` int(11) NOT NULL,
  `date` varchar(32) NOT NULL,
  `text` varchar(144) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pontosdeprisao`
--

CREATE TABLE `pontosdeprisao` (
  `arrestID` int(11) NOT NULL,
  `arrestX` float NOT NULL,
  `arrestY` float NOT NULL,
  `arrestZ` float NOT NULL,
  `arrestInterior` int(11) NOT NULL,
  `arrestWorld` int(11) NOT NULL,
  `arrestType` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `portamalas`
--

CREATE TABLE `portamalas` (
  `ID` int(11) NOT NULL,
  `itemID` int(11) NOT NULL,
  `itemName` varchar(32) NOT NULL,
  `itemModel` int(11) NOT NULL,
  `itemQuantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `portoes`
--

CREATE TABLE `portoes` (
  `gateID` int(11) NOT NULL,
  `gateModel` int(11) NOT NULL,
  `gateSpeed` float NOT NULL,
  `gateX` float NOT NULL,
  `gateY` float NOT NULL,
  `gateZ` float NOT NULL,
  `gateRX` float NOT NULL,
  `gateRY` float NOT NULL,
  `gateRZ` float NOT NULL,
  `gateAX` float NOT NULL,
  `gateAY` float NOT NULL,
  `gateAZ` float NOT NULL,
  `gateARX` int(11) NOT NULL,
  `gateARY` int(11) NOT NULL,
  `gateARZ` int(11) NOT NULL,
  `gateInterior` int(11) NOT NULL,
  `gateWorld` int(11) NOT NULL,
  `gatePassword` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pumps`
--

CREATE TABLE `pumps` (
  `pumpID` int(11) NOT NULL,
  `pumpBusinessID` int(11) NOT NULL,
  `pumpX` float NOT NULL,
  `pumpY` float NOT NULL,
  `pumpZ` float NOT NULL,
  `pumpRX` float NOT NULL,
  `pumpRY` float NOT NULL,
  `pumpRZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `radar`
--

CREATE TABLE `radar` (
  `speedID` int(11) NOT NULL,
  `speedX` float NOT NULL,
  `speedY` float NOT NULL,
  `speedZ` float NOT NULL,
  `speedAngle` float NOT NULL,
  `speedRange` float NOT NULL,
  `speedLimit` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `refunds`
--

CREATE TABLE `refunds` (
  `refundID` int(11) NOT NULL,
  `refundOwnerID` int(11) NOT NULL,
  `refundAdmin` varchar(24) NOT NULL,
  `refundType` int(11) NOT NULL,
  `refundQuantity` int(11) NOT NULL,
  `refundWeapon` int(11) NOT NULL,
  `refundAmmo` int(11) NOT NULL,
  `refundVehicleModel` int(11) NOT NULL,
  `refundVehicleColor1` int(11) NOT NULL,
  `refundVehicleColor2` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `server_config`
--

CREATE TABLE `server_config` (
  `entry_id` int(11) NOT NULL,
  `active` int(11) NOT NULL,
  `text` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `server_config`
--

INSERT INTO `server_config` (`entry_id`, `active`, `text`) VALUES
(1, 1, '/editarmotd'),
(2, 1, '2|2|0|2|2|2|2|2|1|2|2|2|2|2|'),
(3, 0, 'Dia do sistema de Daily Task'),
(4, 0, 'Cofre do Governo');

-- --------------------------------------------------------

--
-- Estrutura da tabela `sewers`
--

CREATE TABLE `sewers` (
  `sewerID` int(11) NOT NULL,
  `sewerName` varchar(32) NOT NULL,
  `sewerX` float NOT NULL,
  `sewerY` float NOT NULL,
  `sewerZ` float NOT NULL,
  `sewerRX` float NOT NULL,
  `sewerRY` float NOT NULL,
  `sewerRZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `teleportes`
--

CREATE TABLE `teleportes` (
  `teleportID` int(11) NOT NULL,
  `teleportDesc` varchar(128) NOT NULL,
  `teleportX` float NOT NULL,
  `teleportY` float NOT NULL,
  `teleportZ` float NOT NULL,
  `teleportInterior` int(11) NOT NULL,
  `teleportWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `trashcans`
--

CREATE TABLE `trashcans` (
  `trashID` int(11) NOT NULL,
  `trashX` float NOT NULL,
  `trashY` float NOT NULL,
  `trashZ` float NOT NULL,
  `trashRX` float NOT NULL,
  `trashRY` float NOT NULL,
  `trashRZ` float NOT NULL,
  `trashQuantity` int(11) NOT NULL,
  `trashType` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `turfmap`
--

CREATE TABLE `turfmap` (
  `turfID` int(11) NOT NULL,
  `turfOwner` int(11) NOT NULL DEFAULT '0',
  `turfCanDominate` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `whorg`
--

CREATE TABLE `whorg` (
  `ID` int(11) NOT NULL,
  `whID` int(11) NOT NULL,
  `whGunparts` int(11) NOT NULL,
  `whX` float NOT NULL,
  `whY` float NOT NULL,
  `whZ` float NOT NULL,
  `whInterior` int(11) NOT NULL,
  `whWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `advertisements`
--
ALTER TABLE `advertisements`
  ADD PRIMARY KEY (`adID`);

--
-- Indexes for table `armazemcasa`
--
ALTER TABLE `armazemcasa`
  ADD PRIMARY KEY (`itemID`);

--
-- Indexes for table `atm`
--
ALTER TABLE `atm`
  ADD PRIMARY KEY (`atmID`);

--
-- Indexes for table `attachments`
--
ALTER TABLE `attachments`
  ADD PRIMARY KEY (`attachID`);

--
-- Indexes for table `bank_history`
--
ALTER TABLE `bank_history`
  ADD PRIMARY KEY (`transaction_id`);

--
-- Indexes for table `bugreport`
--
ALTER TABLE `bugreport`
  ADD PRIMARY KEY (`uniqueid`);

--
-- Indexes for table `business`
--
ALTER TABLE `business`
  ADD PRIMARY KEY (`businessID`);

--
-- Indexes for table `caixas`
--
ALTER TABLE `caixas`
  ADD PRIMARY KEY (`crateID`);

--
-- Indexes for table `cameras`
--
ALTER TABLE `cameras`
  ADD PRIMARY KEY (`cameraID`);

--
-- Indexes for table `carros`
--
ALTER TABLE `carros`
  ADD PRIMARY KEY (`vehicleID`);

--
-- Indexes for table `carrosapreendidos`
--
ALTER TABLE `carrosapreendidos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `casas`
--
ALTER TABLE `casas`
  ADD PRIMARY KEY (`houseID`);

--
-- Indexes for table `cellphone_contacts`
--
ALTER TABLE `cellphone_contacts`
  ADD PRIMARY KEY (`uniqueid`);

--
-- Indexes for table `cellphone_messages`
--
ALTER TABLE `cellphone_messages`
  ADD PRIMARY KEY (`uniqueid`);

--
-- Indexes for table `cellphone_recents`
--
ALTER TABLE `cellphone_recents`
  ADD PRIMARY KEY (`uniqueid`);

--
-- Indexes for table `cellphone_towers`
--
ALTER TABLE `cellphone_towers`
  ADD PRIMARY KEY (`towerID`);

--
-- Indexes for table `chopshop`
--
ALTER TABLE `chopshop`
  ADD PRIMARY KEY (`chopshopID`);

--
-- Indexes for table `cofreorg`
--
ALTER TABLE `cofreorg`
  ADD PRIMARY KEY (`cofreID`);

--
-- Indexes for table `complex`
--
ALTER TABLE `complex`
  ADD PRIMARY KEY (`complexID`);

--
-- Indexes for table `dailytasks`
--
ALTER TABLE `dailytasks`
  ADD PRIMARY KEY (`sequencial_number`);

--
-- Indexes for table `entradas`
--
ALTER TABLE `entradas`
  ADD PRIMARY KEY (`entranceID`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`uniqueid`);

--
-- Indexes for table `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`factionID`);

--
-- Indexes for table `families`
--
ALTER TABLE `families`
  ADD PRIMARY KEY (`familyID`);

--
-- Indexes for table `gps`
--
ALTER TABLE `gps`
  ADD PRIMARY KEY (`locationID`);

--
-- Indexes for table `group_rob`
--
ALTER TABLE `group_rob`
  ADD PRIMARY KEY (`groupID`);

--
-- Indexes for table `industry`
--
ALTER TABLE `industry`
  ADD PRIMARY KEY (`industryID`);

--
-- Indexes for table `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`invID`);

--
-- Indexes for table `itensdropados`
--
ALTER TABLE `itensdropados`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `market`
--
ALTER TABLE `market`
  ADD PRIMARY KEY (`sql_id`);

--
-- Indexes for table `market_history`
--
ALTER TABLE `market_history`
  ADD PRIMARY KEY (`sql_id`);

--
-- Indexes for table `market_mailbox`
--
ALTER TABLE `market_mailbox`
  ADD PRIMARY KEY (`sql_id`);

--
-- Indexes for table `mascaras_antigas`
--
ALTER TABLE `mascaras_antigas`
  ADD PRIMARY KEY (`maskID`);

--
-- Indexes for table `mascaras_atuais`
--
ALTER TABLE `mascaras_atuais`
  ADD PRIMARY KEY (`maskID`);

--
-- Indexes for table `mobilias`
--
ALTER TABLE `mobilias`
  ADD PRIMARY KEY (`furnitureID`);

--
-- Indexes for table `mobiliastextura`
--
ALTER TABLE `mobiliastextura`
  ADD PRIMARY KEY (`textureID`);

--
-- Indexes for table `multas`
--
ALTER TABLE `multas`
  ADD PRIMARY KEY (`ticketID`);

--
-- Indexes for table `namechanges`
--
ALTER TABLE `namechanges`
  ADD PRIMARY KEY (`ncID`);

--
-- Indexes for table `objetos`
--
ALTER TABLE `objetos`
  ADD PRIMARY KEY (`objectID`);

--
-- Indexes for table `objetostextura`
--
ALTER TABLE `objetostextura`
  ADD PRIMARY KEY (`textureID`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`UserID`);

--
-- Indexes for table `player_banned`
--
ALTER TABLE `player_banned`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `player_crashed`
--
ALTER TABLE `player_crashed`
  ADD PRIMARY KEY (`crashID`);

--
-- Indexes for table `player_log`
--
ALTER TABLE `player_log`
  ADD PRIMARY KEY (`LogID`);

--
-- Indexes for table `police_apb`
--
ALTER TABLE `police_apb`
  ADD PRIMARY KEY (`apb`);

--
-- Indexes for table `police_niners`
--
ALTER TABLE `police_niners`
  ADD PRIMARY KEY (`niner`);

--
-- Indexes for table `pontosdeprisao`
--
ALTER TABLE `pontosdeprisao`
  ADD PRIMARY KEY (`arrestID`);

--
-- Indexes for table `portamalas`
--
ALTER TABLE `portamalas`
  ADD PRIMARY KEY (`itemID`);

--
-- Indexes for table `portoes`
--
ALTER TABLE `portoes`
  ADD PRIMARY KEY (`gateID`);

--
-- Indexes for table `pumps`
--
ALTER TABLE `pumps`
  ADD PRIMARY KEY (`pumpID`);

--
-- Indexes for table `radar`
--
ALTER TABLE `radar`
  ADD PRIMARY KEY (`speedID`);

--
-- Indexes for table `refunds`
--
ALTER TABLE `refunds`
  ADD PRIMARY KEY (`refundID`);

--
-- Indexes for table `server_config`
--
ALTER TABLE `server_config`
  ADD PRIMARY KEY (`entry_id`);

--
-- Indexes for table `sewers`
--
ALTER TABLE `sewers`
  ADD PRIMARY KEY (`sewerID`);

--
-- Indexes for table `teleportes`
--
ALTER TABLE `teleportes`
  ADD PRIMARY KEY (`teleportID`);

--
-- Indexes for table `trashcans`
--
ALTER TABLE `trashcans`
  ADD PRIMARY KEY (`trashID`);

--
-- Indexes for table `turfmap`
--
ALTER TABLE `turfmap`
  ADD PRIMARY KEY (`turfID`);

--
-- Indexes for table `whorg`
--
ALTER TABLE `whorg`
  ADD PRIMARY KEY (`whID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `advertisements`
--
ALTER TABLE `advertisements`
  MODIFY `adID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `armazemcasa`
--
ALTER TABLE `armazemcasa`
  MODIFY `itemID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `atm`
--
ALTER TABLE `atm`
  MODIFY `atmID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `attachments`
--
ALTER TABLE `attachments`
  MODIFY `attachID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bank_history`
--
ALTER TABLE `bank_history`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bugreport`
--
ALTER TABLE `bugreport`
  MODIFY `uniqueid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `business`
--
ALTER TABLE `business`
  MODIFY `businessID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `caixas`
--
ALTER TABLE `caixas`
  MODIFY `crateID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cameras`
--
ALTER TABLE `cameras`
  MODIFY `cameraID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `carros`
--
ALTER TABLE `carros`
  MODIFY `vehicleID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `carrosapreendidos`
--
ALTER TABLE `carrosapreendidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `casas`
--
ALTER TABLE `casas`
  MODIFY `houseID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cellphone_contacts`
--
ALTER TABLE `cellphone_contacts`
  MODIFY `uniqueid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cellphone_messages`
--
ALTER TABLE `cellphone_messages`
  MODIFY `uniqueid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cellphone_recents`
--
ALTER TABLE `cellphone_recents`
  MODIFY `uniqueid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cellphone_towers`
--
ALTER TABLE `cellphone_towers`
  MODIFY `towerID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chopshop`
--
ALTER TABLE `chopshop`
  MODIFY `chopshopID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cofreorg`
--
ALTER TABLE `cofreorg`
  MODIFY `cofreID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `complex`
--
ALTER TABLE `complex`
  MODIFY `complexID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dailytasks`
--
ALTER TABLE `dailytasks`
  MODIFY `sequencial_number` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `entradas`
--
ALTER TABLE `entradas`
  MODIFY `entranceID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `uniqueid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `factions`
--
ALTER TABLE `factions`
  MODIFY `factionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `families`
--
ALTER TABLE `families`
  MODIFY `familyID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gps`
--
ALTER TABLE `gps`
  MODIFY `locationID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `group_rob`
--
ALTER TABLE `group_rob`
  MODIFY `groupID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `industry`
--
ALTER TABLE `industry`
  MODIFY `industryID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventario`
--
ALTER TABLE `inventario`
  MODIFY `invID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `itensdropados`
--
ALTER TABLE `itensdropados`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `market`
--
ALTER TABLE `market`
  MODIFY `sql_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `market_history`
--
ALTER TABLE `market_history`
  MODIFY `sql_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `market_mailbox`
--
ALTER TABLE `market_mailbox`
  MODIFY `sql_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mascaras_antigas`
--
ALTER TABLE `mascaras_antigas`
  MODIFY `maskID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mascaras_atuais`
--
ALTER TABLE `mascaras_atuais`
  MODIFY `maskID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mobilias`
--
ALTER TABLE `mobilias`
  MODIFY `furnitureID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mobiliastextura`
--
ALTER TABLE `mobiliastextura`
  MODIFY `textureID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `multas`
--
ALTER TABLE `multas`
  MODIFY `ticketID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `namechanges`
--
ALTER TABLE `namechanges`
  MODIFY `ncID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `objetos`
--
ALTER TABLE `objetos`
  MODIFY `objectID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `objetostextura`
--
ALTER TABLE `objetostextura`
  MODIFY `textureID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_banned`
--
ALTER TABLE `player_banned`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_crashed`
--
ALTER TABLE `player_crashed`
  MODIFY `crashID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_log`
--
ALTER TABLE `player_log`
  MODIFY `LogID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `police_apb`
--
ALTER TABLE `police_apb`
  MODIFY `apb` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `police_niners`
--
ALTER TABLE `police_niners`
  MODIFY `niner` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pontosdeprisao`
--
ALTER TABLE `pontosdeprisao`
  MODIFY `arrestID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `portamalas`
--
ALTER TABLE `portamalas`
  MODIFY `itemID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `portoes`
--
ALTER TABLE `portoes`
  MODIFY `gateID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pumps`
--
ALTER TABLE `pumps`
  MODIFY `pumpID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radar`
--
ALTER TABLE `radar`
  MODIFY `speedID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `refunds`
--
ALTER TABLE `refunds`
  MODIFY `refundID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `server_config`
--
ALTER TABLE `server_config`
  MODIFY `entry_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `sewers`
--
ALTER TABLE `sewers`
  MODIFY `sewerID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `teleportes`
--
ALTER TABLE `teleportes`
  MODIFY `teleportID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trashcans`
--
ALTER TABLE `trashcans`
  MODIFY `trashID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `turfmap`
--
ALTER TABLE `turfmap`
  MODIFY `turfID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `whorg`
--
ALTER TABLE `whorg`
  MODIFY `whID` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
