-- trigger

create database trigger;
use trigger;
CREATE TABLE Emp(
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Country VARCHAR(50),
    Age INT(2),
    Salary INT(10)
);


 delimiter \\
Create trigger Check_salary before INSERT on Emp
for each row
if new.Salary<'30000' then
set new.Salary='31000';
end if;\\


INSERT INTO Emp (EmpID, Name,Country, Age, Salary)
VALUES (1, 'John',  'India','23','20000'),
       (2, 'Steve',  'India','21','40000'),
       (3, 'Bruce', 'US','24','45000'),
       (4, 'Alice',  'Australia','21','20000'),
       (5, 'Nathen', 'Spain','22','25000');
Select * from Emp;

--cursor

CREATE TABLE CUSTOMERS 
(
   ID INT NOT NULL,
   NAME VARCHAR (20) NOT NULL,
   AGE INT NOT NULL,
   ADDRESS CHAR (25),
   SALARY DECIMAL (18, 2),       
   PRIMARY KEY (ID)
);

INSERT INTO CUSTOMERS VALUES 
(
  1, 
  'Ramesh', 
  32, 
  'Ahmedabad', 
  2000.00 
);
INSERT INTO CUSTOMERS VALUES
(
  2, 
  'Khilan', 
  25, 
  'Delhi', 
  1500.00 
);
INSERT INTO CUSTOMERS VALUES
(
  3, 
  'Kaushik', 
  23, 
  'Kota', 
  2000.00 
);
INSERT INTO CUSTOMERS VALUES 
(
  4, 
  'Chaitali', 
  25, 
  'Mumbai', 
  6500.00 
);

SELECT * FROM CUSTOMERS;

CREATE TABLE CUSTOMERS_BACKUP 
(
   ID INT NOT NULL,
   NAME VARCHAR (20) NOT NULL,
   PRIMARY KEY (ID)
);

DELIMITER //
CREATE PROCEDURE FetchCustomers()
BEGIN
   DECLARE done INT DEFAULT FALSE;
   DECLARE customer_id INT;
   DECLARE customer_name VARCHAR(255);
   DECLARE auto_id INT; 

   -- Declare cursor
   DECLARE MY_CURSOR CURSOR FOR
   SELECT id, name FROM CUSTOMERS;

   -- Declare exit handler
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

   -- Open cursor
   OPEN MY_CURSOR;

   -- Fetch and insert rows
   read_loop: LOOP
      FETCH MY_CURSOR INTO customer_id, customer_name;
      IF done = 1 THEN
         LEAVE read_loop;
      END IF;

      -- Insert the fetched data into the backup table
      INSERT INTO customers_backup VALUES
      (
        customer_id, 
        customer_name
      );
		        
      -- Get the last auto-generated ID used in the insertion
      SET auto_id = LAST_INSERT_ID();

   END LOOP;
	
    -- Close cursor
    CLOSE MY_CURSOR;
END //
DELIMITER ;

CALL FetchCustomers();

SELECT * FROM CUSTOMERS_BACKUP;