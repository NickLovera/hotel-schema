
/* 1. Write a query that returns a list of reservations that end in July 2023, including the name of the guest, the room number(s), and the reservation dates.*/
SELECT CONCAT(g.FirstName, ' ', g.LastName) as 'Guest Name', ro. RoomNum as 'Room Number', re.StartDate as 'Check in Date', re.EndDate as 'Check out Date'
FROM Reservation re
INNER JOIN Guest g
	ON re.GuestID = g.GuestID
INNER JOIN Room ro
	ON re.RoomNum = ro.RoomNum
WHERE re.EndDate > '2023-06-30' AND re.EndDate < '2023-08-01';

/*1. Results
Nicholas Lovera	205	2023-06-28	2023-07-02
Walter Holaway	204	2023-07-13	2023-07-14
Wilfred Vise	401	2023-07-18	2023-07-21
Bettyann Seery	303	2023-07-28	2023-07-29
*/


/* 2. Write a query that returns a list of all reservations for rooms with a jacuzzi, displaying the guest's name, the room number, and the dates of the reservation.*/
SELECT CONCAT(g.FirstName, ' ', g.LastName) as 'Guest Name', ro. RoomNum as 'Room Number', re.StartDate as 'Check in Date', re.EndDate as 'Check out Date'
FROM Reservation re
INNER JOIN Guest g
	ON re.GuestID = g.GuestID
INNER JOIN Room ro
	ON re.RoomNum = ro.RoomNum
INNER JOIN RoomAmenity ra
	ON re.RoomNum = ra.RoomNum
WHERE ra.AmenityID = 3;

/* 2. Results
Karie Yang	201	2023-03-06	2023-03-07
Bettyann Seery	203	2023-02-05	2023-02-10
Karie Yang	203	2023-09-13	2023-09-15
Nicholas Lovera	205	2023-06-28	2023-07-02
Wilfred Vise	207	2023-04-23	2023-04-24
Walter Holaway	301	2023-04-09	2023-04-13
Mack Simmer	301	2023-11-22	2023-11-25
Bettyann Seery	303	2023-07-28	2023-07-29
Duane Cullison	305	2023-02-22	2023-02-24
Bettyann Seery	305	2023-08-30	2023-09-01
Nicholas Lovera	307	2023-03-17	2023-03-20
*/

/* 3. Write a query that returns all the rooms reserved for a specific guest, including the guest's name, the room(s) reserved, the starting date of the reservation, and how many people were included in the reservation. (Choose a guest's name from the existing data.)*/
SELECT CONCAT(g.FirstName, ' ', g.LastName) as 'Guest Name', ro. RoomNum as 'Room Number', re.StartDate as 'Check in Date', re.Adults + re.Children as 'People'
FROM Reservation re
INNER JOIN Guest g
	ON re.GuestID = g.GuestID
INNER JOIN Room ro
	ON re.RoomNum = ro.RoomNum
WHERE g.FirstName = 'Joleen' AND g.Lastname  = 'Tison';

/*3. Results
Joleen Tison	206	2023-06-10	2
Joleen Tison	208	2023-06-10	1
*/

/* 4. Write a query that returns a list of rooms, reservation ID, and per-room cost for each reservation. The results should include all rooms, whether or not there is a reservation associated with the room.*/
SELECT ro. RoomNum as 'Room Number', re.ReservationId as 'Reservation ID', re.Total_Room_Cost as 'Reservastion Total Cost'
FROM Reservation re
RIGHT OUTER JOIN Room ro
	ON re.RoomNum = ro.RoomNum;

/*4. Results
205	15	699.96
206	12	599.96
206	23	449.97
207	10	174.99
208	13	599.96
208	20	149.99
305	3	349.98
305	19	349.98
306		
307	5	524.97
308	1	299.98
201	4	199.99
202	7	349.98
203	2	999.95
203	21	399.98
204	16	184.99
301	9	799.96
301	24	599.97
302	6	924.95
302	25	699.96
303	18	199.99
304	14	184.99
401	11	1199.97
401	17	1259.97
401	22	1199.97
402		
*/

/* 5. Write a query that returns all the rooms accommodating at least three guests and that are reserved on any date in April 2023.*/
SELECT ro.RoomNum as 'Room Number'
FROM Reservation re
INNER JOIN Room ro
	ON re.RoomNum = ro.RoomNum
WHERE re.StartDate > '2023-03-31' AND 
     re.EndDate < '2023-05-01' AND
     re.Adults + re.Children >= 3;

/*5. Results
	null
*/

/* 6. Write a query that returns a list of all guest names and the number of reservations per guest, sorted starting with the guest with the most reservations and then by the guest's last name. */
SELECT CONCAT(g.FirstName, ' ', g.LastName) as 'Guest Name', COUNT(re. RoomNum) as 'The Number of Reserved Rooms'
FROM Reservation re
INNER JOIN Guest g
	ON re.GuestID = g.GuestID
GROUP BY g.FirstName, g.LastName
ORDER BY COUNT(re. RoomNum) DESC, g.Lastname;

/*6. Results
Mack Simmer	4
Bettyann Seery	3
Duane Cullison	2
Walter Holaway	2
Aurore Lipton	2
Nicholas Lovera	2
Maritza Tilton	2
Joleen Tison	2
Wilfred Vise	2
Karie Yang	2
Zachery Luechtefeld	1

/* 7. Write a query that displays the name, address, and phone number of a guest based on their phone number. (Choose a phone number from the existing data.)  */
SELECT CONCAT(g.FirstName, ' ', g.LastName) as 'Guest Name', CONCAT(a.StreetNo, ' ', a.StreetName, ', ', a.City, ', ', a.Province_State, ' ', a.Postal_Zip_Code) as 'Guest Address', g.Phone_Number as 'Guest Phone Number'
FROM  Guest g
INNER JOIN Address a
ON g.AddressID = a.AddressID
WHERE g.Phone_Number  = '(123) 456-7890';

/*7. Result
Nicholas Lovera	123 N. Street Dr., Heart Of, TX 08096	(123) 456-7890
*/
