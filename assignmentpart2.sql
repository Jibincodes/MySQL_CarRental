-- querying around
Use dbassignment;
SET @today = CURDATE();

SELECT v.Vehicle_id, v.Model, v.Year
FROM Vehicle v LEFT JOIN Chooses c 
ON v.Vehicle_id = c.FK_Vehicle
WHERE @today NOT BETWEEN r.startdate AND r.enddate OR r.Reservation_id IS NULL;
-- failed as we realized the table Reservation is needed
-- --------------------------------------------
-- right way one
SET @today = CURDATE();
SELECT v.Vehicle_id, v.Model, v.Year
FROM Vehicle v LEFT JOIN Chooses c ON v.Vehicle_id = c.FK_Vehicle
WHERE NOT EXISTS (
    SELECT 1
    FROM Reservation r
    WHERE c.FK_Reservation = r.Reservation_id
      AND @today BETWEEN r.startdate AND r.enddate
);
-- you can also use two left joins to do this
-- The CURDATE function returns the current date 
-- Query to find available vehicles on the current date/ certain date we say
SET @today = CURDATE();
SELECT v.Vehicle_id, v.Model
FROM Vehicle v
LEFT JOIN Chooses c ON v.Vehicle_id = c.FK_Vehicle
LEFT JOIN Reservation r ON c.FK_Reservation = r.Reservation_id
WHERE @today NOT BETWEEN r.startdate AND r.enddate OR r.Reservation_id IS NULL;
-- ------------------------------------------- 

-- now let us test the query using a date written down in the query
Select * from Reservation;
Select * from Chooses;

SELECT v.Vehicle_id, v.Model
FROM Vehicle v LEFT JOIN Chooses c 
ON v.Vehicle_id = c.FK_Vehicle
LEFT JOIN Reservation r 
ON c.FK_Reservation = r.Reservation_id
WHERE '2023-01-17' NOT BETWEEN r.startdate AND r.enddate OR r.Reservation_id IS NULL; -- from the test i am sure that the query is working

SELECT v.Vehicle_id, v.Model, v.Year
FROM Vehicle v LEFT JOIN Chooses c ON v.Vehicle_id = c.FK_Vehicle
WHERE NOT EXISTS (
    SELECT 1
    FROM Reservation r
    WHERE c.FK_Reservation = r.Reservation_id
      AND '2023-01-17' BETWEEN r.startdate AND r.enddate
); -- works as well
-- this query can also be modified in such a way that at certain date, you can check what cars are available

-- ----------------------
-- query number 2
-- To check how many customers have more than one vehicle reserved
-- if so display their names and email and phone number

SELECT c.Customer_id, c.FirstName, c.LastName, c.Email_id, c.PhoneNr, COUNT(DISTINCT ch.FK_Vehicle) AS NoofVehicles
FROM Customer c JOIN Reservation r 
ON c.Customer_id = r.FK_Customer
JOIN Chooses ch 
ON r.Reservation_id = ch.FK_Reservation
GROUP BY c.Customer_id, c.FirstName, c.LastName, c.Email_id, c.PhoneNr
HAVING COUNT(DISTINCT ch.FK_Vehicle) > 1;

-- ------------------------------
-- query number 3
-- is the same vehicle reserved under any reservation?
-- if so display their vehicle id, model, start date and end date
SELECT v.Vehicle_id, v.Model, r.startdate AS ReservationStartDate, r.enddate AS ReservationEndDate
FROM Vehicle v JOIN Chooses c 
ON v.Vehicle_id = c.FK_Vehicle
JOIN Reservation r 
ON c.FK_Reservation = r.Reservation_id
WHERE v.Vehicle_id IN (
	SELECT FK_Vehicle FROM Chooses
        GROUP BY FK_Vehicle
        HAVING COUNT(*) > 1
    )
ORDER BY v.Vehicle_id, r.startdate;

-- just for testing purpose 
Select * from vehicle;

-- We have tried to create a trigger function
-- This trigger to prevent from creating a new reservation if same vehicle is already under another reservation
-- The con of this is that , we have not created an excellent trigger function, as there's no check with dates
-- But it does let us stop using the same vehicle in any other reservation, and this can be seen an alert sign to check the dates 
DELIMITER //
CREATE TRIGGER Vehiclereservationchecks
BEFORE INSERT ON Chooses
FOR EACH ROW
BEGIN
    DECLARE ExtraReservationnumber INT;

    -- Checking
    SELECT COUNT(*)
    INTO Extrareservationnumber
    FROM Chooses
    WHERE FK_Vehicle = NEW.FK_Vehicle AND FK_Reservation != NEW.FK_Reservation;

    -- If the same vehicle is under a different reservation
    IF Extrareservationnumber > 0 THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Same vehicle is already under another reservation';
    END IF;
END //
DELIMITER ;
-- Just to create and play around with a conflicting pair
INSERT INTO Reservation (Reservation_id, insurance, startdate, enddate, payment, FK_Customer, FK_Category, FK_Branch, FK_Employee) VALUES
(1005, 'Yes', '2024-01-15', '2024-01-20', 'card', 101, 2, 10, 802);
INSERT INTO Chooses (FK_Vehicle, FK_Reservation) VALUES  
(61, 1005);

DELETE FROM Chooses
WHERE FK_Reservation = 1005;

-- Delete from Reservation table
DELETE FROM Reservation
WHERE Reservation_id = 1005;

DROP TRIGGER IF EXISTS Vehiclereservationchecks;