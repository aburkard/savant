CREATE DATABASE  IF NOT EXISTS `CollegeHoops` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `CollegeHoops`;
-- MySQL dump 10.13  Distrib 5.6.13, for osx10.6 (i386)
--
-- Host: 127.0.0.1    Database: CollegeHoops
-- ------------------------------------------------------
-- Server version	5.6.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AssistEvent`
--

DROP TABLE IF EXISTS `AssistEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AssistEvent` (
  `idAssist` varchar(40) NOT NULL,
  `shot_type` varchar(30) DEFAULT NULL,
  `scoring_player` varchar(40) DEFAULT NULL,
  `pass_location` varchar(40) DEFAULT NULL COMMENT 'To be filled in later with video data',
  `shot_location` varchar(40) DEFAULT NULL COMMENT 'To be filled in later with video data',
  PRIMARY KEY (`idAssist`),
  CONSTRAINT `AssistKey` FOREIGN KEY (`idAssist`) REFERENCES `GameEvent` (`idEvent`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AssistEvent`
--

LOCK TABLES `AssistEvent` WRITE;
/*!40000 ALTER TABLE `AssistEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `AssistEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BlockEvent`
--

DROP TABLE IF EXISTS `BlockEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BlockEvent` (
  `idBlock` varchar(40) NOT NULL,
  `shot` varchar(40) DEFAULT NULL,
  `rebound` varchar(40) DEFAULT NULL,
  `guarding_shooter` varchar(40) DEFAULT NULL COMMENT 'This is the player that **should** be guarding the shooter, need to incorporate defensive assignments before this can be filled in',
  PRIMARY KEY (`idBlock`),
  KEY `BlockRebKey_idx` (`rebound`),
  KEY `BlockShotKey_idx` (`shot`),
  CONSTRAINT `BlockKey` FOREIGN KEY (`idBlock`) REFERENCES `GameEvent` (`idEvent`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BlockRebKey` FOREIGN KEY (`rebound`) REFERENCES `ReboundEvent` (`idRebound`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BlockShotKey` FOREIGN KEY (`shot`) REFERENCES `ShotEvent` (`idShot`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BlockEvent`
--

LOCK TABLES `BlockEvent` WRITE;
/*!40000 ALTER TABLE `BlockEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `BlockEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Coach`
--

DROP TABLE IF EXISTS `Coach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Coach` (
  `idCoach` varchar(40) NOT NULL COMMENT 'Note: What''s really being described here is a CoachTenure, should separate these out eventually but likely not to matter',
  `first_name` varchar(40) DEFAULT NULL,
  `last_name` varchar(40) DEFAULT NULL,
  `start_year` smallint(6) DEFAULT NULL,
  `end_year` smallint(6) DEFAULT NULL,
  `wins` smallint(6) DEFAULT NULL,
  `losses` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`idCoach`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Coach`
--

LOCK TABLES `Coach` WRITE;
/*!40000 ALTER TABLE `Coach` DISABLE KEYS */;
INSERT INTO `Coach` VALUES ('010905b16fb479d8caa5ea9c7df5b18f','Larry','Anderson',1995,NULL,NULL,NULL),('f9b0c07f9a256d409eb84fe9dac1b535','Tommy','Amaker',2007,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Coach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CoachTenure`
--

DROP TABLE IF EXISTS `CoachTenure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CoachTenure` (
  `idCoachTenure` varchar(40) NOT NULL,
  `coach_id` varchar(40) DEFAULT NULL,
  `team_id` varchar(40) DEFAULT NULL,
  `start_year` smallint(6) DEFAULT NULL,
  `end_year` smallint(6) DEFAULT NULL,
  `wins` smallint(6) DEFAULT NULL,
  `losses` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`idCoachTenure`),
  KEY `CoachTenure_idx` (`coach_id`),
  KEY `TeamTenure_idx` (`team_id`),
  CONSTRAINT `CoachTenure` FOREIGN KEY (`coach_id`) REFERENCES `Coach` (`idCoach`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `TeamTenure` FOREIGN KEY (`team_id`) REFERENCES `Team` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CoachTenure`
--

LOCK TABLES `CoachTenure` WRITE;
/*!40000 ALTER TABLE `CoachTenure` DISABLE KEYS */;
/*!40000 ALTER TABLE `CoachTenure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Conference`
--

DROP TABLE IF EXISTS `Conference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Conference` (
  `idConference` varchar(40) NOT NULL,
  `name` text,
  `abbrev` varchar(40) DEFAULT NULL,
  `region` varchar(40) DEFAULT NULL,
  `division` tinyint(4) DEFAULT '3',
  PRIMARY KEY (`idConference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Conference`
--

LOCK TABLES `Conference` WRITE;
/*!40000 ALTER TABLE `Conference` DISABLE KEYS */;
INSERT INTO `Conference` VALUES ('144ecd5ab39453f4a31b7f162b49384f','Ivy League','Ivy','Northeast',1),('bc0f06646b0e785c99589d761b2d795c','New England Women\'s and Men\'s Athletics Conference','NEWMAC','Northeast',3);
/*!40000 ALTER TABLE `Conference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FoulEvent`
--

DROP TABLE IF EXISTS `FoulEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FoulEvent` (
  `idFoul` varchar(40) NOT NULL,
  `foul_type` varchar(40) DEFAULT NULL,
  `shot` varchar(40) DEFAULT NULL,
  `player_foul_number` tinyint(4) DEFAULT NULL,
  `team_foul_number` tinyint(4) DEFAULT NULL,
  `fouled_player` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idFoul`),
  KEY `FoulShotKey_idx` (`shot`),
  KEY `FouledPlayer_idx` (`fouled_player`),
  CONSTRAINT `FoulKey` FOREIGN KEY (`idFoul`) REFERENCES `GameEvent` (`idEvent`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FoulShotKey` FOREIGN KEY (`shot`) REFERENCES `ShotEvent` (`idShot`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FouledPlayer` FOREIGN KEY (`fouled_player`) REFERENCES `Player` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FoulEvent`
--

LOCK TABLES `FoulEvent` WRITE;
/*!40000 ALTER TABLE `FoulEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `FoulEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FreeThrowEvent`
--

DROP TABLE IF EXISTS `FreeThrowEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FreeThrowEvent` (
  `idFreeThrow` varchar(40) NOT NULL,
  `ft_number` tinyint(4) DEFAULT NULL,
  `make` bit(1) DEFAULT NULL,
  `and_one` bit(1) DEFAULT NULL,
  `foul` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idFreeThrow`),
  KEY `FTFoulKey_idx` (`foul`),
  CONSTRAINT `FTFoulKey` FOREIGN KEY (`foul`) REFERENCES `FoulEvent` (`idFoul`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FreeThrowKey` FOREIGN KEY (`idFreeThrow`) REFERENCES `GameEvent` (`idEvent`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FreeThrowEvent`
--

LOCK TABLES `FreeThrowEvent` WRITE;
/*!40000 ALTER TABLE `FreeThrowEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `FreeThrowEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Game`
--

DROP TABLE IF EXISTS `Game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Game` (
  `idGame` varchar(40) NOT NULL,
  `away_team` varchar(40) DEFAULT NULL,
  `home_team` varchar(40) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `day_of_week` smallint(6) DEFAULT NULL,
  `game_location` varchar(40) DEFAULT NULL,
  `conference` bit(1) DEFAULT NULL,
  `away_score` smallint(6) DEFAULT NULL,
  `home_score` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`idGame`),
  KEY `GameAwayTeam_idx` (`away_team`),
  KEY `GameHomeTeam_idx` (`home_team`),
  KEY `GameLocation_idx` (`game_location`),
  CONSTRAINT `GameAwayTeam` FOREIGN KEY (`away_team`) REFERENCES `Team` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `GameHomeTeam` FOREIGN KEY (`home_team`) REFERENCES `Team` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `GameLocation` FOREIGN KEY (`game_location`) REFERENCES `Location` (`idLocation`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Game`
--

LOCK TABLES `Game` WRITE;
/*!40000 ALTER TABLE `Game` DISABLE KEYS */;
INSERT INTO `Game` VALUES ('635ab86114f170b8c67ae0b1e696f856','74d317a5495d432038df0af09dd2aa63','c9b2591a181114ae6c232496cb4afa9f','2014-11-14 00:00:00',NULL,'8c21bbab54791f62d410ac30443debd1','\0',52,73);
/*!40000 ALTER TABLE `Game` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GameEvent`
--

DROP TABLE IF EXISTS `GameEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GameEvent` (
  `idEvent` varchar(40) NOT NULL,
  `event_team` varchar(40) DEFAULT NULL,
  `event_play` varchar(40) DEFAULT NULL,
  `event_possession` varchar(40) DEFAULT NULL,
  `away_score` smallint(6) DEFAULT NULL,
  `home_score` smallint(6) DEFAULT NULL,
  `event_type` enum('assist','block','foul','ft','rebound','shot','steal','timeout','to') DEFAULT NULL,
  `period` tinyint(4) DEFAULT NULL,
  `game_clock` smallint(6) DEFAULT NULL,
  `shot_clock` tinyint(4) DEFAULT NULL,
  `away_lineup` varchar(40) DEFAULT NULL,
  `home_lineup` varchar(40) DEFAULT NULL,
  `home_event` bit(1) DEFAULT NULL,
  PRIMARY KEY (`idEvent`),
  KEY `TeamKey_idx` (`event_team`),
  KEY `AwayLineupKey_idx` (`away_lineup`),
  KEY `HomeLineupKey_idx` (`home_lineup`),
  KEY `PossessionKey_idx` (`event_possession`),
  KEY `PlayKey_idx` (`event_play`),
  CONSTRAINT `AwayLineupKey` FOREIGN KEY (`away_lineup`) REFERENCES `Lineup` (`lineup_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `HomeLineupKey` FOREIGN KEY (`home_lineup`) REFERENCES `Lineup` (`lineup_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PlayKey` FOREIGN KEY (`event_play`) REFERENCES `Play` (`idPlay`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PossessionKey` FOREIGN KEY (`event_possession`) REFERENCES `Possession` (`idPossession`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `TeamKey` FOREIGN KEY (`event_team`) REFERENCES `Team` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GameEvent`
--

LOCK TABLES `GameEvent` WRITE;
/*!40000 ALTER TABLE `GameEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `GameEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Lineup`
--

DROP TABLE IF EXISTS `Lineup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Lineup` (
  `lineup_id` varchar(40) NOT NULL COMMENT 'An MD5 hash of the participating players'' IDs',
  `lineup_type` int(11) DEFAULT NULL,
  `player_1` varchar(40) NOT NULL,
  `player_2` varchar(40) NOT NULL,
  `player_3` varchar(40) DEFAULT NULL,
  `player_4` varchar(40) DEFAULT NULL,
  `player_5` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`lineup_id`),
  KEY `Player1Key_idx` (`player_1`),
  KEY `Player2Key_idx` (`player_2`),
  KEY `Player3Key_idx` (`player_3`),
  KEY `Player4Key_idx` (`player_4`),
  KEY `Player5Key_idx` (`player_5`),
  CONSTRAINT `Player1Key` FOREIGN KEY (`player_1`) REFERENCES `Player` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Player2Key` FOREIGN KEY (`player_2`) REFERENCES `Player` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Player3Key` FOREIGN KEY (`player_3`) REFERENCES `Player` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Player4Key` FOREIGN KEY (`player_4`) REFERENCES `Player` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Player5Key` FOREIGN KEY (`player_5`) REFERENCES `Player` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Lineup`
--

LOCK TABLES `Lineup` WRITE;
/*!40000 ALTER TABLE `Lineup` DISABLE KEYS */;
/*!40000 ALTER TABLE `Lineup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Location`
--

DROP TABLE IF EXISTS `Location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Location` (
  `idLocation` varchar(40) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  `city` varchar(40) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `home_team` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idLocation`),
  KEY `TeamLocation_idx` (`home_team`),
  CONSTRAINT `TeamLocation` FOREIGN KEY (`home_team`) REFERENCES `Team` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Location`
--

LOCK TABLES `Location` WRITE;
/*!40000 ALTER TABLE `Location` DISABLE KEYS */;
INSERT INTO `Location` VALUES ('8c21bbab54791f62d410ac30443debd1','Lavietes Pavilion','Cambridge','MA','c9b2591a181114ae6c232496cb4afa9f'),('a713c22299ddd0d12d79cf7ad088126f','Rockwell Cage','Cambridge','MA','74d317a5495d432038df0af09dd2aa63');
/*!40000 ALTER TABLE `Location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Period`
--

DROP TABLE IF EXISTS `Period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Period` (
  `idPeriod` varchar(40) NOT NULL,
  `period_number` tinyint(4) DEFAULT NULL,
  `game_id` varchar(40) DEFAULT NULL,
  `away_beg_score` smallint(6) DEFAULT NULL,
  `home_beg_score` smallint(6) DEFAULT NULL,
  `away_end_score` smallint(6) DEFAULT NULL,
  `home_end_score` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`idPeriod`),
  KEY `GamePeriod_idx` (`game_id`),
  CONSTRAINT `GamePeriod` FOREIGN KEY (`game_id`) REFERENCES `Game` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Period`
--

LOCK TABLES `Period` WRITE;
/*!40000 ALTER TABLE `Period` DISABLE KEYS */;
/*!40000 ALTER TABLE `Period` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Play`
--

DROP TABLE IF EXISTS `Play`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Play` (
  `idPlay` varchar(40) NOT NULL,
  `play_possession` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idPlay`),
  KEY `PlayPossession_idx` (`play_possession`),
  CONSTRAINT `PlayPossession` FOREIGN KEY (`play_possession`) REFERENCES `Possession` (`idPossession`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Play`
--

LOCK TABLES `Play` WRITE;
/*!40000 ALTER TABLE `Play` DISABLE KEYS */;
/*!40000 ALTER TABLE `Play` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Player`
--

DROP TABLE IF EXISTS `Player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Player` (
  `idPlayer` varchar(40) NOT NULL,
  `first_name` varchar(40) DEFAULT NULL,
  `last_name` varchar(40) DEFAULT NULL,
  `number` tinyint(4) DEFAULT NULL,
  `year` tinyint(4) DEFAULT NULL,
  `position` tinyint(4) DEFAULT NULL,
  `right_handed` bit(1) DEFAULT NULL,
  `height` tinyint(4) DEFAULT NULL,
  `weight` smallint(6) DEFAULT NULL,
  `home_town` varchar(40) DEFAULT NULL,
  `home_state` varchar(40) DEFAULT NULL,
  `player_team` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idPlayer`),
  KEY `PlayerTeam_idx` (`player_team`),
  CONSTRAINT `PlayerTeam` FOREIGN KEY (`player_team`) REFERENCES `Team` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Player`
--

LOCK TABLES `Player` WRITE;
/*!40000 ALTER TABLE `Player` DISABLE KEYS */;
INSERT INTO `Player` VALUES ('cdd16461ab27f5bce52a8d94f86322921','Siyani','Chambers',1,3,1,'',72,170,'Golden Valley','MN','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229210','Patrick','Steeves',10,3,3,'',79,220,'Montreal','Quebec','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229211','Chris','Egi',11,1,3,'',81,215,'Markham','Ontario','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229212','Matt','Fraschilla',12,2,1,'',71,165,'Dallas','TX','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229213','Andre','Chatfield',13,1,2,'',76,185,'Lilburn','GA','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229214','Steve','Moundou-Missi',14,4,3,'',79,225,'Yaounde','Cameroon','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229215','Corbin','Miller',15,2,1,'',74,180,'Sandy','UT','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f86322922','Alex','Nesbitt',2,4,1,'',73,175,'Chicago','IL','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229221','Zach','Yoshor',21,1,2,'',78,205,'Houston','TX','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229223','Wesley','Saunders',23,4,3,'',77,215,'Los Angeles','CA','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229224','Jonah','Travis',24,4,4,'',78,225,'Minneapolis','MN','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229225','Kenyatta','Smith',25,4,5,'',80,245,'Sun Valley','CA','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f86322923','Matt','Brown',3,4,2,'',75,205,'Barrington','RI','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229232','Charlie','Anastasi',32,4,3,'',78,225,'Washington Crossing','PA','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229233','Evan','Cummins',33,3,4,'',80,215,'Westborough','MA','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f863229235','Agunwa','Okolie',35,3,3,'',80,205,'Ajax','Ontario','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f86322924','Zena','Edosomwan',4,2,4,'',81,245,'Los Angeles','CA','c9b2591a181114ae6c232496cb4afa9f'),('cdd16461ab27f5bce52a8d94f86322925','Hunter','Myers',5,2,3,'',79,225,'Minden','NV','c9b2591a181114ae6c232496cb4afa9f'),('e450c3134c698d02fe01fff6bfe8cd3210','Samson','Donick',10,1,2,'',73,195,'Tiburon','CA','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3211','David','Bender',11,2,2,'',77,190,'The Woodlands','TX','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3213','Ryan','Frankel',13,3,1,'',71,170,'New York','NY','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3220','Justin','Pedley',20,3,2,'',78,210,'Kennewick','WA','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3221','Tim','Butala',21,2,3,'',80,230,'Monroe','CT','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3223','Nicholas','Prus',23,4,2,'',75,185,'Arlington Heights','IL','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3224','Matt','Redfield',24,4,3,'',80,220,'Los Altos','CA','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3225','Dennis','Levene',25,4,3,'',80,225,'Weston','CT','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3231','Russell','Johnson',31,3,3,'',78,205,'New York','NY','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3232','Spencer','Rust',32,1,3,'',81,190,'Alamo','CA','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3245','Andrew','Acker',45,4,4,'',80,235,'Merion Station','PA','74d317a5495d432038df0af09dd2aa63'),('e450c3134c698d02fe01fff6bfe8cd3252','Lampros','Tsontzos',52,3,5,'',82,235,'Amarousion','Greece','74d317a5495d432038df0af09dd2aa63');
/*!40000 ALTER TABLE `Player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Possession`
--

DROP TABLE IF EXISTS `Possession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Possession` (
  `idPossession` varchar(40) NOT NULL,
  `possession_game` varchar(40) DEFAULT NULL,
  `possession_period` varchar(40) DEFAULT NULL,
  `start_time` smallint(6) DEFAULT NULL,
  `end_time` smallint(6) DEFAULT NULL,
  `total_points` tinyint(4) DEFAULT NULL,
  `offensive_team` varchar(40) DEFAULT NULL,
  `defensive_team` varchar(40) DEFAULT NULL,
  `terminating_event` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idPossession`),
  KEY `PossessionGame_idx` (`possession_game`),
  KEY `PossessionPeriod_idx` (`possession_period`),
  KEY `PossessionOTeam_idx` (`offensive_team`),
  KEY `PossessionDTeam_idx` (`defensive_team`),
  KEY `PossessionEnd_idx` (`terminating_event`),
  CONSTRAINT `PossessionDTeam` FOREIGN KEY (`defensive_team`) REFERENCES `Team` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PossessionEnd` FOREIGN KEY (`terminating_event`) REFERENCES `GameEvent` (`idEvent`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PossessionGame` FOREIGN KEY (`possession_game`) REFERENCES `Game` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PossessionOTeam` FOREIGN KEY (`offensive_team`) REFERENCES `Team` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PossessionPeriod` FOREIGN KEY (`possession_period`) REFERENCES `Period` (`idPeriod`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Possession`
--

LOCK TABLES `Possession` WRITE;
/*!40000 ALTER TABLE `Possession` DISABLE KEYS */;
/*!40000 ALTER TABLE `Possession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReboundEvent`
--

DROP TABLE IF EXISTS `ReboundEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ReboundEvent` (
  `idRebound` varchar(40) NOT NULL,
  `defensive` bit(1) DEFAULT NULL,
  `shot` varchar(40) DEFAULT NULL,
  `rebound_location` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idRebound`),
  KEY `ReboundShot_idx` (`shot`),
  CONSTRAINT `ReboundEventKey` FOREIGN KEY (`idRebound`) REFERENCES `GameEvent` (`idEvent`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ReboundShot` FOREIGN KEY (`shot`) REFERENCES `ShotEvent` (`idShot`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReboundEvent`
--

LOCK TABLES `ReboundEvent` WRITE;
/*!40000 ALTER TABLE `ReboundEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReboundEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Season`
--

DROP TABLE IF EXISTS `Season`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Season` (
  `idSeason` varchar(40) NOT NULL,
  `season_team` varchar(40) DEFAULT NULL,
  `season_coach` varchar(40) DEFAULT NULL,
  `year` smallint(6) DEFAULT NULL,
  `wins` tinyint(4) DEFAULT NULL,
  `losses` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`idSeason`),
  KEY `SeasonTeam_idx` (`season_team`),
  KEY `SeasonCoach_idx` (`season_coach`),
  CONSTRAINT `SeasonCoach` FOREIGN KEY (`season_coach`) REFERENCES `Coach` (`idCoach`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `SeasonTeam` FOREIGN KEY (`season_team`) REFERENCES `Team` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Season`
--

LOCK TABLES `Season` WRITE;
/*!40000 ALTER TABLE `Season` DISABLE KEYS */;
/*!40000 ALTER TABLE `Season` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ShotEvent`
--

DROP TABLE IF EXISTS `ShotEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ShotEvent` (
  `idShot` varchar(40) NOT NULL,
  `shooter` varchar(40) DEFAULT NULL,
  `contested` tinyint(4) DEFAULT NULL,
  `shot_location` varchar(40) DEFAULT NULL,
  `shot_type` tinyint(4) DEFAULT NULL,
  `make` bit(1) DEFAULT NULL,
  `points` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`idShot`),
  KEY `ShotShooter_idx` (`shooter`),
  CONSTRAINT `ShotEvent` FOREIGN KEY (`idShot`) REFERENCES `GameEvent` (`idEvent`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ShotShooter` FOREIGN KEY (`shooter`) REFERENCES `Player` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ShotEvent`
--

LOCK TABLES `ShotEvent` WRITE;
/*!40000 ALTER TABLE `ShotEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `ShotEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StealEvent`
--

DROP TABLE IF EXISTS `StealEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StealEvent` (
  `idSteal` varchar(40) NOT NULL,
  `turnover` varchar(40) DEFAULT NULL,
  `steal_location` varchar(40) DEFAULT NULL,
  `points` tinyint(4) DEFAULT NULL,
  `time_for_points` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`idSteal`),
  KEY `StealTO_idx` (`turnover`),
  CONSTRAINT `StealEvent` FOREIGN KEY (`idSteal`) REFERENCES `GameEvent` (`idEvent`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `StealTO` FOREIGN KEY (`turnover`) REFERENCES `TurnoverEvent` (`idTurnover`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StealEvent`
--

LOCK TABLES `StealEvent` WRITE;
/*!40000 ALTER TABLE `StealEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `StealEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SubstitutionEvent`
--

DROP TABLE IF EXISTS `SubstitutionEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SubstitutionEvent` (
  `idSubstitution` varchar(40) NOT NULL,
  `player_in` varchar(40) DEFAULT NULL,
  `player_out` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idSubstitution`),
  KEY `SubPlayerOut_idx` (`player_out`),
  KEY `SubPlayerIn_idx` (`player_in`),
  CONSTRAINT `SubEvent` FOREIGN KEY (`idSubstitution`) REFERENCES `GameEvent` (`idEvent`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `SubPlayerIn` FOREIGN KEY (`player_in`) REFERENCES `Player` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `SubPlayerOut` FOREIGN KEY (`player_out`) REFERENCES `Player` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SubstitutionEvent`
--

LOCK TABLES `SubstitutionEvent` WRITE;
/*!40000 ALTER TABLE `SubstitutionEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `SubstitutionEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Team`
--

DROP TABLE IF EXISTS `Team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Team` (
  `idTeam` varchar(40) NOT NULL,
  `common_name` varchar(40) DEFAULT NULL,
  `mascot` varchar(40) DEFAULT NULL,
  `full_name` text,
  `abbrev` varchar(10) DEFAULT NULL,
  `current_coach` varchar(40) DEFAULT NULL,
  `team_conference` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idTeam`),
  KEY `TeamCoach_idx` (`current_coach`),
  KEY `TeamConference_idx` (`team_conference`),
  CONSTRAINT `TeamCoach` FOREIGN KEY (`current_coach`) REFERENCES `Coach` (`idCoach`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `TeamConference` FOREIGN KEY (`team_conference`) REFERENCES `Conference` (`idConference`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Team`
--

LOCK TABLES `Team` WRITE;
/*!40000 ALTER TABLE `Team` DISABLE KEYS */;
INSERT INTO `Team` VALUES ('74d317a5495d432038df0af09dd2aa63','MIT','Engineers','Massachusetts Institute of Technology','MIT','010905b16fb479d8caa5ea9c7df5b18f','bc0f06646b0e785c99589d761b2d795c'),('c9b2591a181114ae6c232496cb4afa9f','Harvard','Crimson','Harvard University','HARV','f9b0c07f9a256d409eb84fe9dac1b535','144ecd5ab39453f4a31b7f162b49384f');
/*!40000 ALTER TABLE `Team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TimeoutEvent`
--

DROP TABLE IF EXISTS `TimeoutEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TimeoutEvent` (
  `idTimeout` varchar(40) NOT NULL,
  `type` tinyint(4) DEFAULT NULL,
  `timeouts_remaining` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`idTimeout`),
  CONSTRAINT `TimeoutEvent` FOREIGN KEY (`idTimeout`) REFERENCES `GameEvent` (`idEvent`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TimeoutEvent`
--

LOCK TABLES `TimeoutEvent` WRITE;
/*!40000 ALTER TABLE `TimeoutEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `TimeoutEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tournament`
--

DROP TABLE IF EXISTS `Tournament`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Tournament` (
  `idTournament` varchar(40) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idTournament`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tournament`
--

LOCK TABLES `Tournament` WRITE;
/*!40000 ALTER TABLE `Tournament` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tournament` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TournamentGame`
--

DROP TABLE IF EXISTS `TournamentGame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TournamentGame` (
  `idTournamentGame` varchar(40) NOT NULL,
  `tournament_id` varchar(40) DEFAULT NULL,
  `round_from_final` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`idTournamentGame`),
  KEY `Tournament_idx` (`tournament_id`),
  CONSTRAINT `Tournament` FOREIGN KEY (`tournament_id`) REFERENCES `Tournament` (`idTournament`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `TournamentGame` FOREIGN KEY (`idTournamentGame`) REFERENCES `Game` (`idGame`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TournamentGame`
--

LOCK TABLES `TournamentGame` WRITE;
/*!40000 ALTER TABLE `TournamentGame` DISABLE KEYS */;
/*!40000 ALTER TABLE `TournamentGame` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TurnoverEvent`
--

DROP TABLE IF EXISTS `TurnoverEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TurnoverEvent` (
  `idTurnover` varchar(40) NOT NULL,
  `points` tinyint(4) DEFAULT NULL,
  `time_for_points` tinyint(4) DEFAULT NULL,
  `steal` varchar(40) DEFAULT NULL,
  `type` tinyint(4) DEFAULT NULL,
  `turnover_location` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idTurnover`),
  KEY `TurnoverSteal_idx` (`steal`),
  CONSTRAINT `TurnoverEvent` FOREIGN KEY (`idTurnover`) REFERENCES `GameEvent` (`idEvent`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `TurnoverSteal` FOREIGN KEY (`steal`) REFERENCES `StealEvent` (`idSteal`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TurnoverEvent`
--

LOCK TABLES `TurnoverEvent` WRITE;
/*!40000 ALTER TABLE `TurnoverEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `TurnoverEvent` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-01-25 21:01:03
