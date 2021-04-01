Use HotelDB;

INSERT INTO Amenity (AmenityID, AmenityType, AdditionalPrice)
VALUES
	(1, 'Microwave', 0),
	(2, 'Refrigerator', 0),
	(3, 'Jacuzzi', 25),
	(4, 'Oven' , 0);

    
INSERT INTO RoomType (RoomTypeID, RoomType, BasePrice, ExtraPerson)
VALUES
	(1, 'Single', 149.99, 0),
	(2, 'Double', 174.99, 10),
	(3, 'Suite', 399.99, 20);

INSERT INTO Room (RoomNum, TypeID, ADA_Accessible, Standard_Occupancy, Max_Occupancy)
VALUES
	(201, 2, 0, 2, 4),
	(202, 2, 1, 2, 4),
	(203, 2, 0, 2, 4),
	(204, 2, 1, 2, 4),
	(205, 1, 0, 2, 2),
	(206, 1, 1, 2, 2),
	(207, 1, 0, 2, 2),
	(208, 1, 1, 2, 2),
	(301, 2, 0, 2, 4),
	(302, 2, 1, 2, 4),
	(303, 2, 0, 2, 4),
	(304, 2, 1, 2, 4),
	(305, 1, 0, 2, 2),
	(306, 1, 1, 2, 2),
	(307, 1, 0, 2, 2),
	(308, 1, 1, 2, 2),
	(401, 3, 1, 3, 8),
	(402, 3, 1, 3, 8);

INSERT INTO RoomAmenity(`RoomNum`, `AmenityID`)
Values
	(201, 1),
	(201, 3),
	(202, 2),
	(203, 1),
	(203, 3),
	(204, 1),
	(205, 1),
	(205, 2),
	(205, 3),
	(206, 1),
	(206, 2),
	(207, 1),
	(207, 2),
	(207, 3),
	(208, 1),
	(208, 2),
	(301, 1),
	(301, 3),
	(302, 2),
	(303, 1),
	(303, 3),
	(304, 2),
	(305, 1),
	(305, 2),
	(305, 3),
	(306,1),
	(306,2),
	(307,1),
	(307,2),
	(307,3),
	(308,1),
	(308,2),
	(401,1),
	(401,2),
	(401,4),
	(402,1),
   	(402,2),
	(402,4);

INSERT INTO Address(`StreetNo`,`StreetName`,`City`,`Province_State`,`Postal_Zip_Code`, `Country`)
VALUES
('379','Old Shore Street','Council Bluffs','IA','51501', NULL),
('750','Wintergreen Dr.','Wasilla','A','99654', NULL),
('9662','Foxrun Lane','Harlingen','TX','78552', NULL),
('9378','W. Augusta Ave.','West Deptford','NJ','08096', NULL),
('123','N. Street Dr.','Heart Of','TX','08096', NULL),
('762','Wild Rose Street','Saginaw','MI','48601', NULL),
('7','Poplar Dr.','Arvada','CO','80003', NULL),
('70','Oakwood St.','Zion','IL','60099', NULL),
('7556','Arrowhead St.','Cumberland','RI','02864', NULL),
('77','West Surrey Street','Oswego','NY','13126', NULL),
('939','Linda Rd.','Burke','VA','22015', NULL),
('87','Queen St.','Drexel Hill','PA','19026', NULL);


INSERT INTO GUEST (FirstName, LastName, Phone_Number, AddressID)
VALUES
('Nicholas','Lovera','(123) 456-7890',(Select addressID from address where streetNo = '123' AND streetname = 'N. Street Dr.')),
('Mack','Simmer','(291) 553-0508', (Select addressID from address where streetNo = '379' AND streetname = 'Old Shore Street')),
('Bettyann','Seery','(478) 277-9632',(Select addressID from address where streetNo = '750' AND streetname = 'Wintergreen Dr.')),
('Duane','Cullison','(308) 494-0198',(Select addressID from address where streetNo = '9662' AND streetname = 'Foxrun Lane')),
('Karie','Yang','(214) 730-0298',(Select addressID from address where streetNo = '9378' AND streetname = 'W. Augusta Ave.')),
('Aurore','Lipton','(308) 494-0198',(Select addressID from address where streetNo = '762' AND streetname = 'Wild Rose Street')),
('Zachery','Luechtefeld','(814) 485-2615',(Select addressID from address where streetNo = '7' AND streetname = 'Poplar Dr.')),
('Jeremiah','Pendergrass','(279) 491-0960',(Select addressID from address where streetNo = '70' AND streetname = 'Oakwood St.')),
('Walter','Holaway','(446) 396-6785',(Select addressID from address where streetNo = '7556' AND streetname = 'Arrowhead St.')),
('Wilfred','Vise','(834) 727-1001',(Select addressID from address where streetNo = '77' AND streetname = 'West Surrey Street')),
('Maritza','Tilton','(446) 351-6860',(Select addressID from address where streetNo = '939' AND streetname = 'Linda Rd.')),
('Joleen','Tison','(231) 893-2755',(Select addressID from address where streetNo = '87' AND streetname = 'Queen St.'));

 DROP FUNCTION IF EXISTS funcRoomCost;
DELIMITER $$
CREATE FUNCTION funcRoomCost(RoomNum SMALLINT, StartDate Date, EndDate Date, Adults SMALLINT, Children SMALLINT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE RoomCost DECIMAL(10,2);
    DECLARE BaseCost DECIMAL(10,2);
    DECLARE AdditionalCost DECIMAL(10,2) DEFAULT(0);
    DECLARE AdditionalPersonCost DECIMAL(10,2);
    DECLARE MaxPerson SMALLINT;
    DECLARE StandardPerson SMALLINT;
    DECLARE AdditionalPerson SMALLINT;

    SELECT rt.BasePrice INTO BaseCost FROM Room r
    INNER JOIN RoomType rt
	ON r.TypeID = rt.RoomTypeID
    WHERE r.RoomNum = RoomNum;

	SET RoomCost = BaseCost;
    
    SELECT a.AdditionalPrice INTO AdditionalCost FROM RoomAmenity ra
    INNER JOIN Amenity a
	ON ra.AmenityID = a.AmenityID
    WHERE ra.RoomNum = RoomNum AND a.AmenityID = 3;
  
	SET RoomCost = RoomCost + AdditionalCost;
       
    SELECT rt.ExtraPerson INTO AdditionalPersonCost FROM Room r
    INNER JOIN RoomType rt
	ON r.TypeID = rt.RoomTypeID
    WHERE r.RoomNum = RoomNum;

    SELECT r.Max_Occupancy INTO MaxPerson FROM Room r
    INNER JOIN RoomType rt
	ON r.TypeID = rt.RoomTypeID
    WHERE r.RoomNum = RoomNum;

    SELECT r.Standard_Occupancy INTO StandardPerson FROM Room r
    INNER JOIN RoomType rt
	ON r.TypeID = rt.RoomTypeID
    WHERE r.RoomNum = RoomNum;

    SET AdditionalPerson = Adults - StandardPerson;
	IF (Children - Adults) > 0 AND (Children + Adults) > MaxPerson THEN
		SET AdditionalPerson = Children - StandardPerson;
	END IF;
	
	IF AdditionalPerson > 0 THEN
		SET RoomCost = (RoomCost + AdditionalPerson * AdditionalPersonCost) * DATEDIFF(EndDate, StartDate);
	ELSE
		SET RoomCost = RoomCost * DATEDIFF(EndDate, StartDate);
	END IF;
    
	RETURN (RoomCost);
END$$
DELIMITER ;


INSERT INTO Reservation (`RoomNum`, `GuestID`, `Adults`, `Children`, `StartDate`, `EndDate`, `Total_Room_Cost`)
VALUES
	((Select `RoomNum` from Room where Room.RoomNum = 308),(Select `GuestID` from Guest where Guest.FirstName = "Mack" and Guest.LastName = "Simmer"),1, 0, '2023-02-02', '2023-02-04',
	funcRoomCost(308,'2023-02-02','2023-02-04',1,0)),
	((Select `RoomNum` from Room where Room.RoomNum = 203),
    	(Select `GuestID` from Guest where Guest.FirstName = "Bettyann" and Guest.LastName = "Seery"),
        	2, 1, '2023-02-05', '2023-02-10', funcRoomCost(203, '2023-02-05', '2023-02-10', 2, 1)),
            
	((Select `RoomNum` from Room where Room.RoomNum = 305),
    	(Select `GuestID` from Guest where Guest.FirstName = "Duane" and Guest.LastName = "Cullison"),
        	2, 0, '2023-02-22', '2023-02-24', funcRoomCost(305, '2023-02-22', '2023-02-24', 2, 0)),
            
	((Select `RoomNum` from Room where Room.RoomNum = 201),
    	(Select `GuestID` from Guest where Guest.FirstName = "Karie" and Guest.LastName = "Yang"),
        	2, 2, '2023-03-06', '2023-03-07', funcRoomCost(201, '2023-03-06', '2023-03-07', 2, 2)),
            
	((Select `RoomNum` from Room where Room.RoomNum = 307),
    	(Select `GuestID` from Guest where Guest.FirstName = "Nicholas" and Guest.LastName = "Lovera"),
        	1, 1, '2023-03-17', '2023-03-20', funcRoomCost(307, '2023-03-17', '2023-03-20', 1, 1)),
            
	((Select `RoomNum` from Room where Room.RoomNum = 302),
    	(Select `GuestID` from Guest where Guest.FirstName = "Aurore" and Guest.LastName = "Lipton"),
        	3, 0, '2023-03-18', '2023-03-23', funcRoomCost(302, '2023-03-18', '2023-03-23', 3, 0)),
            
	((Select `RoomNum` from Room where Room.RoomNum = 202),
    	(Select `GuestID` from Guest where Guest.FirstName = "Zachery" and Guest.LastName = "Luechtefeld"),
        	2, 2, '2023-03-29', '2023-03-31', funcRoomCost(202, '2023-03-29', '2023-03-31', 2, 2)),
            
	((Select `RoomNum` from Room where Room.RoomNum = 304),
	(Select `GuestID` from Guest where Guest.FirstName = "Jeremiah" and Guest.LastName = "Pendergrass"),
        	2, 0, '2023-03-31', '2023-04-05', funcRoomCost(304, '2023-03-31', '2023-04-05', 2, 0)),
            
	((Select `RoomNum` from Room where Room.RoomNum = 301),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Walter" and Guest.LastName = "Holaway"),
   		 1, 0, '2023-04-09', '2023-04-13', funcRoomCost(301, '2023-04-09', '2023-04-13', 1, 0)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 207),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Wilfred" and Guest.LastName = "Vise"),
   		 1, 0, '2023-04-23', '2023-04-24', funcRoomCost(207, '2023-04-23', '2023-04-24', 1, 0)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 401),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Maritza" and Guest.LastName = "Tilton"),
   		 2, 4, '2023-05-30', '2023-06-02', funcRoomCost(401, '2023-05-30', '2023-06-02', 2, 4)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 206),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Joleen" and Guest.LastName = "Tison"),
   		 2, 0, '2023-06-10', '2023-06-14', funcRoomCost(206, '2023-06-10', '2023-06-14', 2, 0)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 208),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Joleen" and Guest.LastName = "Tison"),
   		 1, 0, '2023-06-10', '2023-06-14', funcRoomCost(208, '2023-06-10', '2023-06-14', 1, 0)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 304),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Aurore" and Guest.LastName = "Lipton"),
   		 3, 0, '2023-06-17', '2023-06-18', funcRoomCost(304, '2023-06-17', '2023-06-18', 3, 0)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 205),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Nicholas" and Guest.LastName = "Lovera"),
   		 2, 0, '2023-06-28', '2023-07-02', funcRoomCost(205, '2023-06-28', '2023-07-02', 2, 0)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 204),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Walter" and Guest.LastName = "Holaway"),
   		 3, 1, '2023-07-13', '2023-07-14', funcRoomCost(204, '2023-07-13', '2023-07-14', 3, 1)),
         
     ((Select `RoomNum` from Room where Room.RoomNum = 401),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Wilfred" and Guest.LastName = "Vise"),
   		 4, 2, '2023-07-18', '2023-07-21', funcRoomCost(401, '2023-07-18', '2023-07-21', 4, 2)),
         
    ((Select `RoomNum` from Room where Room.RoomNum = 303),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Bettyann" and Guest.LastName = "Seery"),
   		 2, 1, '2023-07-28', '2023-07-29', funcRoomCost(303, '2023-07-28', '2023-07-29', 2, 1)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 305),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Bettyann" and Guest.LastName = "Seery"),
   		 1, 0, '2023-08-30', '2023-09-01', funcRoomCost(305, '2023-08-30', '2023-09-01', 1, 0)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 208),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Mack" and Guest.LastName = "Simmer"),
   		 2, 0, '2023-09-16', '2023-09-17', funcRoomCost(208, '2023-09-16', '2023-09-17', 2, 0)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 203),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Karie" and Guest.LastName = "Yang"),
   		 2, 2, '2023-09-13', '2023-09-15', funcRoomCost(203, '2023-09-13', '2023-09-15', 2, 2)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 401),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Duane" and Guest.LastName = "Cullison"),
   		 2, 2, '2023-11-22', '2023-11-25', funcRoomCost(401, '2023-11-22', '2023-11-25', 2, 2)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 206),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Mack" and Guest.LastName = "Simmer"),
   		 2, 2, '2023-11-22', '2023-11-25', funcRoomCost(206, '2023-11-22', '2023-11-25', 2, 2)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 301),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Mack" and Guest.LastName = "Simmer"),
   		 2, 2, '2023-11-22', '2023-11-25', funcRoomCost(301, '2023-11-22', '2023-11-25', 2, 2)),
         
	((Select `RoomNum` from Room where Room.RoomNum = 302),
   	 (Select `GuestID` from Guest where Guest.FirstName = "Maritza" and Guest.LastName = "Tilton"),
   		 2, 0, '2023-12-24', '2023-12-28', funcRoomCost(302, '2023-12-24', '2023-12-28', 2, 0));

    


    
    

DELETE FROM Reservation WHERE GuestID = (Select GuestID FROM Guest where FirstName = 'Jeremiah' AND LastName='Pendergrass');
DELETE FROM Address WHERE AddressID = (Select AddressID FROM Guest where FirstName = 'Jeremiah' AND LastName='Pendergrass');
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Guest WHERE (Guest.FirstName = 'Jeremiah' AND Guest.LastName='Pendergrass');
SET SQL_SAFE_UPDATES = 1;

		





