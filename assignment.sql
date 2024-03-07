CREATE database dbassignment;
SHOW databases;
USE dbassignment;

CREATE table CUSTOMER
(
 Customer_id INT Primary Key, 
 FirstName VARCHAR(225) NOT NULL, 
 LastName VARCHAR(225) NOT NULL,
 Email_id VARCHAR(255),
 PhoneNr VARCHAR(30)
 );
 
 CREATE table if not exists Category (
 Category_id INT Primary KEY,
 CategoryName VARCHAR(150) NOT NULL
 );
 
 CREATE table if not exists Branch (
 Branch_id INT Primary Key,
 BranchName VARCHAR(150) NOT NULL,
 Location VARCHAR(225)
 );
 
 CREATE table if not exists Vehicle (
 Vehicle_id INT Primary Key,
 Model VARCHAR(200),
 Year INT,
 FK_Branch INT,
 FK_Category INT,
 foreign key (FK_Branch) references Branch(Branch_id),
 foreign key (FK_Category) references Category(Category_id)
 );
 
 Create table if not exists Employee (
 Employee_id INT Primary Key,
 name VARCHAR(225),
 FK_Branch INT,
 foreign key (FK_Branch) references Branch(Branch_id)
 );
 
 Create table Automatic
 (
  App_Connect varchar(3), -- as it can be only yes or no
  FK_Vehicle int Primary Key,
  foreign key(FK_Vehicle) references Vehicle(Vehicle_id)
  );
  
  Create table Manual
  (
  Gearlevel int,
  FK_Vehicle int Primary Key,
  foreign key(FK_Vehicle) references Vehicle(Vehicle_id)
  );
  
  Create table Reservation
  (
  Reservation_id INT Primary Key,
  insurance VARCHAR(3), -- it is again yes or no
  startdate DATE,
  enddate DATE,
  payment ENUM('card', 'cash') NOT NULL, -- as we only accept only cash or card
  FK_Customer INT,
  FK_Category INT,
  FK_Branch INT,
  FK_Employee INT,
  FOREIGN KEY (FK_Customer) REFERENCES Customer(Customer_id),
  FOREIGN KEY (FK_Category) REFERENCES Category(Category_id),
  FOREIGN KEY (FK_Branch) REFERENCES Branch(Branch_id),
  FOREIGN KEY (FK_Employee) REFERENCES Employee(employee_id)
  );
  
  Create Table Chooses
  (
   FK_Vehicle INT,
   FK_Reservation INT,
   PRIMARY KEY (FK_Vehicle, FK_Reservation),
   foreign key (FK_Vehicle) references Vehicle(Vehicle_id),
   foreign key (FK_Reservation) references Reservation(Reservation_id)
   );
-- Let us enter some values now into the tables
INSERT INTO CUSTOMER (Customer_id, FirstName, LastName, Email_id, PhoneNr) VALUES
(101, 'Hans', 'Müller', 'hans.mueller@email.com', '+41 78 123 45 67'),
(102, 'Anna', 'Schmidt', 'anna.schmidt@email.com', '+41 79 234 56 78'),
(103, 'Markus', 'Fischer', 'markus.fischer@email.com', '+41 76 345 67 89'),
(104, 'Sabine', 'Weber', 'sabine.weber@email.com', '+41 79 456 78 90'),
(105, 'Thomas', 'Keller', 'thomas.keller@email.com', '+41 76 567 89 01'),
(106, 'Monika', 'Huber', 'monika.huber@email.com', '+41 79 678 90 12'),
(107, 'Matthias', 'Wagner', 'matthias.wagner@email.com', '+41 76 789 01 23'),
(108, 'Kathrin', 'Becker', 'kathrin.becker@email.com', '+41 79 890 12 34');

INSERT INTO Category (Category_id, CategoryName) VALUES
(1, 'Luxury'),
(2, 'Jeep'),
(3, 'Economic'),
(4, 'Mid-size');

INSERT INTO Branch (Branch_id, BranchName, Location) VALUES
(10, 'Branch A', 'Brugg'),
(20, 'Branch B', 'Zürich'),
(30, 'Branch C', 'Zug'),
(40, 'Branch D', 'Baden');


INSERT INTO Vehicle (Vehicle_id, Model, Year, FK_Branch, FK_Category) VALUES
(51, 'Toyota Camry', 2022, 10, 3),         -- Automatic - Economic
(52, 'Honda Accord', 2021, 20, 3),          -- Automatic - Economic
(53, 'BMW 3 Series', 2023, 30, 1),          -- Automatic - Luxury
(54, 'Mercedes-Benz C-Class', 2020, 40, 1),  -- Automatic- Luxury
(61, 'Jeep Wrangler', 2019, 10, 2),         -- Manual - Jeep
(62, 'Jeep Grand Cherokee', 2020, 20, 2),   -- Manual - Jeep
(63, 'Subaru WRX', 2021, 30, 4),            -- Manual - Mid-Size
(64, 'Audi A4', 2022, 40, 4);               -- Manual- MidSize

INSERT INTO Automatic (App_Connect, FK_Vehicle) VALUES
('Yes', 51),
('Yes', 52),
('Yes', 53),
('Yes', 54);

INSERT INTO Manual (Gearlevel, FK_Vehicle) VALUES
(6, 61),
(6, 62),
(6, 63),
(7, 64);

INSERT INTO Employee (Employee_id, name, FK_Branch) VALUES
(801, 'John Smith', 10),    -- Branch A
(802, 'Alice Johnson', 10), -- Branch A
(803, 'Robert Brown', 20),   -- Branch B
(804, 'Emily Davis', 20),    -- Branch B
(805, 'Michael Miller', 30), -- Branch C
(806, 'Sophia Wilson', 30),  -- Branch C
(807, 'Daniel Lee', 40),     -- Branch D
(808, 'Olivia Martin', 40);   -- Branch D

INSERT INTO Reservation (Reservation_id, insurance, startdate, enddate, payment, FK_Customer, FK_Category, FK_Branch, FK_Employee) VALUES
(1001, 'Yes', '2023-01-15', '2023-01-20', 'card', 101, 3, 10, 801),
(1002, 'No', '2023-02-10', '2023-02-15', 'cash', 102, 2, 20, 803),
(1003, 'Yes', '2023-03-05', '2023-03-10', 'card', 103, 1, 30, 805),
(1004, 'No', '2023-04-20', '2023-04-25', 'cash', 104, 4, 40, 807);

INSERT INTO Chooses (FK_Vehicle, FK_Reservation) VALUES
(51, 1001),  
(61, 1002), 
(53, 1003),  
(63, 1004),  
(52, 1001),  
(62, 1002),  
(64, 1004);  







  
  
  
  
 
 
 
 
 

