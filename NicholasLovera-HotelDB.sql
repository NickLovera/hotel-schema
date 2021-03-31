DROP DATABASE IF EXISTS hoteldb;
create schema hoteldb;
use hoteldb;

CREATE TABLE IF NOT EXISTS Room (
	RoomNum SMALLINT NOT NULL,
	TypeID INT NOT NULL,
	ADA_Accessible SMALLINT NOT NULL,
	Standard_Occupancy SMALLINT NOT NULL,
	Max_Occupancy SMALLINT NOT NULL,
    PRIMARY KEY (RoomNum)
);

CREATE TABLE IF NOT EXISTS `RoomType` (
	`roomTypeID` INT NOT NULL,
	`roomType` VARCHAR(10) NOT NULL,
	`BasePrice` DECIMAL(10,2) NOT NULL,
	`ExtraPerson` DECIMAL(2) NOT NULL,
    PRIMARY KEY (`roomTypeID`)
);

CREATE TABLE IF NOT EXISTS `RoomAmenity` (
	`RoomNum` SMALLINT NOT NULL,
	`AmenityID` SMALLINT NOT NULL
);

CREATE TABLE IF NOT EXISTS `Amenity` (
	`AmenityID` SMALLINT NOT NULL,
	`AmenityType` VARCHAR(25) NOT NULL,
	`AdditionalPrice` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`AmenityID`)
);

CREATE TABLE `Guest`(
	`GuestID` int NOT NULL AUTO_INCREMENT,
    `FirstName` varchar(25),
    `LastName` varchar(25),
    `AddressID` int not null,
    `Email` varchar(50),
    `Phone_Number` varchar(20),
    PRIMARY KEY (`GuestId`)
);

CREATE TABLE  `Address`(
	`AddressID` int not null AUTO_INCREMENT,
    `StreetNo` varchar(25),
    `StreetName` varchar(50),
    `City` varchar(50),
    `Province_State` varchar(5),
    `Postal_Zip_Code` varchar(10),
    `Country` varchar(25),
    PRIMARY KEY (`AddressID`)
);

CREATE TABLE `Reservation` (
    `ReservationId` INT primary key,
	`RoomNum` SMALLINT not null,
	`GuestID` INT not null,
   `Adults` SMALLINT not null,
	`Children` SMALLINT,
	`StartDate` DATE not null,
	`EndDate` DATE not null
);


ALTER TABLE Room
 ADD CONSTRAINT FK_RoomTypeID FOREIGN KEY (TypeID) REFERENCES RoomType(RoomTypeID);
 
ALTER TABLE RoomAmenity
ADD CONSTRAINT FK_RoomNum FOREIGN KEY (RoomNum) REFERENCES Room(RoomNum);
 
 ALTER TABLE RoomAmenity
 ADD CONSTRAINT FK_AmenityID FOREIGN KEY (AmenityID) REFERENCES Amenity(AmenityID);

ALTER TABLE `Reservation`
ADD CONSTRAINT `FK_Reservation_1` FOREIGN KEY (`RoomNum`) REFERENCES `Room`(`RoomNum`),
ADD CONSTRAINT `FK_Reservation_2` FOREIGN KEY (`GuestID`) REFERENCES `Guest`(`GuestId`);

ALTER TABLE `Guest`
ADD  CONSTRAINT `guest_ibfk_1` FOREIGN KEY (`AddressID`) REFERENCES `Address` (`AddressID`);
