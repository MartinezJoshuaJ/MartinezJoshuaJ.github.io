----------------------------------------
 Create employee_account table
----------------------------------------
DROP TABLE IF EXISTS employee_account ;

CREATE TABLE IF NOT EXISTS employee_account (
  empAcct_empID INT NOT NULL AUTO_INCREMENT,
  empAcct_empEmail VARCHAR(255) NOT NULL,
  empAcct_empFirstName VARCHAR(50) NOT NULL,
  empAcct_empLastName VARCHAR(50) NOT NULL,
  empAcct_empPhone VARCHAR(12) NOT NULL,
  empAcct_empUserName VARCHAR(20) NOT NULL,
  empAcct_empPassword VARCHAR (12) NOT NULL,
  PRIMARY KEY (empAcct_empID));
----------------------------------------
 Create customer_account table
----------------------------------------
DROP TABLE IF EXISTS customer_account ;

CREATE TABLE IF NOT EXISTS customer_account (
  custAcct_custID INT NOT NULL AUTO_INCREMENT,
  custAcct_custFirstName VARCHAR(50) NOT NULL,
  custAcct_custLastName VARCHAR(50) NOT NULL,
  custAcct_custEmailAddr VARCHAR(255) NOT NULL,
  custAcct_custStreet VARCHAR(50) NOT NULL,
  custAcct_custCity VARCHAR(30) NOT NULL,
  custAcct_custState VARCHAR(2) NOT NULL,
  custAcct_custPostalCode INT(5) NOT NULL,
  custAcct_custPhone VARCHAR(12) NOT NULL,
  custAcct_custUserName VARCHAR(20) NOT NULL,
  custAcct_custPassword VARCHAR(15) NOT NULL,
  empAcct_empID INT,
  PRIMARY KEY (custAcct_custID),
  INDEX FK_empAcct_empID (empAcct_empID ASC) VISIBLE,
  CONSTRAINT FK_empAcct_empID
    FOREIGN KEY (empAcct_empID)
    REFERENCES employee_account (empAcct_empID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
SELECT * FROM customer_account;
----------------------------------------
 Create shirt_types table
----------------------------------------
DROP TABLE IF EXISTS shirt_types ;
CREATE TABLE IF NOT EXISTS shirt_types( 
	shirtType_ID INT NOT NULL AUTO_INCREMENT,
    shirtType_Type VARCHAR(20) NOT NULL);
SELECT * FROM shirt_types;
----------------------------------------
 Create customer_billing table
----------------------------------------
DROP TABLE IF EXISTS customer_billing;
CREATE TABLE IF NOT EXISTS customer_billing (
	custBill_ID INT AUTO_INCREMENT,
    custBill_cardName VARCHAR(35) NOT NULL,
    custBill_cardNumber VARCHAR(19) NOT NULL,
    custBill_cardExpiration VARCHAR(6) NOT NULL,
    custBill_cardCvv VARCHAR(3) NOT NULL,
    custBill_cardCompany VARCHAR(30) NOT NULL,
    custAcct_custID INT,
    PRIMARY KEY (custBill_ID),
    CONSTRAINT FK_custAcct_custID FOREIGN KEY (custAcct_custID) REFERENCES customer_account(custAcct_custID));
SELECT * FROM customer_billing;
----------------------------------------
 Create shirt_orders table
----------------------------------------
DROP TABLE IF EXISTS shirt_orders ;

CREATE TABLE IF NOT EXISTS shirt_orders (
  shirtOrder_ID INT NOT NULL AUTO_INCREMENT,
  shopCart_ID INT ,
  custBill_ID INT,
  custAcct_custID INT,
  shirtOrder_createdAt TIMESTAMP,
  shirtOrder_modifiedAt TIMESTAMP,
  PRIMARY KEY (shirtOrder_ID),
  INDEX FK2_custAcct_custID (custAcct_custID),
  INDEX FK2_shopCart_ID (shopCart_ID),
  INDEX FK_custBill_ID (custBill_ID),
  CONSTRAINT FK2_custAcct_custID
    FOREIGN KEY (custAcct_custID)
    REFERENCES customer_account (custAcct_custID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FK2_shopCart_ID
    FOREIGN KEY (shopCart_ID)
    REFERENCES shopping_cart (shopCart_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FK_custBill_ID
    FOREIGN KEY (custBill_ID)
    REFERENCES customer_billing (custBill_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
SELECT * FROM shirt_orders;
----------------------------------------
 Create shirt_specifics table
----------------------------------------
DROP TABLE IF EXISTS shirt_specifics;
CREATE TABLE IF NOT EXISTS shirt_specifics (
	shirtSpec_ID INT AUTO_INCREMENT,
    shirtSpec_price DECIMAL (5,2),
    shirtSpec_discountedPrice DECIMAL (5,2),
    shirtSpec_material VARCHAR(20),
    shirtSpec_mensSizes VARCHAR (15),
    shirtSpec_womensSizes VARCHAR (15),
    shirtSpec_toddlerSizes VARCHAR (15),
    shirtSpec_youthSizes VARCHAR (15),
    shirtSpec_availability VARCHAR (3),
	empAcct_empID INT,
	shopCart_ID INT,
	custAcct_custID,
	shirtType_ID INT,
	PRIMARY KEY (shirtSpec_ID)
	CONSTRAINT FK3_empAcct_empID FOREIGN KEY (empAcct_empID) REFERENCES employee_account(empAcct_empID),
    CONSTRAINT FK_shopCart_ID FOREIGN KEY (shopCart_ID) REFERENCES shopping_cart(shopCart_ID),
    CONSTRAINT FK_custAcct_custID FOREIGN KEY (custAcct_custID) REFERENCES customer_account (custAcct_custID),
    CONSTRAINT FK_shirtType_ID FOREIGN KEY(shirtType_ID) REFERENCES shirt_types (shirtType_ID));
----------------------------------------
 Create shopping_cart table
----------------------------------------
DROP TABLE IF EXISTS shopping_cart ;

CREATE TABLE IF NOT EXISTS shopping_cart (
  shopCart_ID INT AUTO_INCREMENT,
  shopCart_qty INT(2),
  shopCart_createdAt TIMESTAMP,
  shopCart_modifiedAt TIMESTAMP,
  PRIMARY KEY (shopCart_ID));
 
 SELECT * FROM shopping_cart;
 

----------------------------------------
ALTER Tables to switch to InnoDB engine
----------------------------------------
ALTER TABLE `ecommerce_db`.`customer_account` 
ENGINE = InnoDB ;

ALTER TABLE `ecommerce_db`.`customer_billing` 
ENGINE = InnoDB ;

ALTER TABLE `ecommerce_db`.`employee_account` 
ENGINE = InnoDB ;

ALTER TABLE `ecommerce_db`.`shirt_orders` 
ENGINE = InnoDB ;

ALTER TABLE `ecommerce_db`.`shirt_specifics` 
ENGINE = InnoDB ;

ALTER TABLE `ecommerce_db`.`shirt_types` 
ENGINE = InnoDB ;

ALTER TABLE `ecommerce_db`.`shopping_cart` 
ENGINE = InnoDB ;
----------------------------------------
ADDED FOREIGN KEYS TO tables
----------------------------------------
ALTER TABLE `ecommerce_db`.`customer_account` 
ADD CONSTRAINT `fk_empAcct_custID`
  FOREIGN KEY (empAcct_empID)
  REFERENCES `ecommerce_db`.`employee_account` (`empAcct_empID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
ALTER TABLE `ecommerce_db`.`customer_account` 
ADD CONSTRAINT `fk_empAcct_empID`
  FOREIGN KEY (`custAcct_custID`)
  REFERENCES `ecommerce_db`.`employee_account` (`empAcct_empID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
ALTER TABLE `ecommerce_db`.`customer_billing` 
ADD CONSTRAINT `fk_custAcct_cusID`
  FOREIGN KEY (`custBill_ID`)
  REFERENCES `ecommerce_db`.`customer_account` (`custAcct_custID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
ALTER TABLE `ecommerce_db`.`shirt_specifics` 
ADD CONSTRAINT `fk2_empAcct_empID`
  FOREIGN KEY (`shirtSpec_ID`)
  REFERENCES `ecommerce_db`.`employee_account` (`empAcct_empID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk2_shopCart_ID`
  FOREIGN KEY (`shirtSpec_ID`)
  REFERENCES `ecommerce_db`.`shopping_cart` (`shopCart_ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk2_custAcct_custID`
  FOREIGN KEY (`shirtSpec_ID`)
  REFERENCES `ecommerce_db`.`customer_account` (`custAcct_custID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk2_shirtType_ID`
  FOREIGN KEY (`shirtSpec_ID`)
  REFERENCES `ecommerce_db`.`shirt_types` (`shirtType_ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

----------------------------------------
Alter starting values of auto_increments 
----------------------------------------
ALTER TABLE `ecommerce_db`.`customer_account` 
AUTO_INCREMENT = 100 ;

ALTER TABLE `ecommerce_db`.`customer_billing` 
AUTO_INCREMENT = 200 ;

ALTER TABLE `ecommerce_db`.`shirt_orders` 
AUTO_INCREMENT = 500 ;

ALTER TABLE `ecommerce_db`.`shirt_specifics` 
AUTO_INCREMENT = 300 ;

ALTER TABLE `ecommerce_db`.`shopping_cart` 
AUTO_INCREMENT = 001 ;

ALTER TABLE `ecommerce_db`.`shopping_cart` 
CHANGE COLUMN `shopCart_createdAt` `shopCart_createdAt` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ,
CHANGE COLUMN `shopCart_modifiedAt` `shopCart_modifiedAt` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ;


ALTER TABLE `ecommerce_db`.`shirt_orders` 
ADD CONSTRAINT `fk_shopCart_ID`
  FOREIGN KEY (`shopCart_ID`)
  REFERENCES `ecommerce_db`.`shopping_cart` (`shopCart_ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_custBill_ID`
  FOREIGN KEY (`custBill_ID`)
  REFERENCES `ecommerce_db`.`customer_billing` (`custBill_ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_custAcct_custID`
  FOREIGN KEY (`custAcct_custID`)
  REFERENCES `ecommerce_db`.`customer_account` (`custAcct_custID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `ecommerce_db`.`shirt_specifics` 
DROP FOREIGN KEY `fk2_shopCart_ID`,
DROP FOREIGN KEY `fk2_shirtType_ID`,
DROP FOREIGN KEY `fk2_empAcct_empID`,
DROP FOREIGN KEY `fk2_custAcct_custID`;

ALTER TABLE `ecommerce_db`.`shirt_specifics` 
ADD CONSTRAINT `fk2_empAcct_empID`
  FOREIGN KEY (`empAcct_empID`)
  REFERENCES `ecommerce_db`.`employee_account` (`empAcct_empID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk2_shopCart_ID`
  FOREIGN KEY (`shopCart_ID`)
  REFERENCES `ecommerce_db`.`shopping_cart` (`shopCart_ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk2_custAcct_custID`
  FOREIGN KEY (`custAcct_custID`)
  REFERENCES `ecommerce_db`.`customer_account` (`custAcct_custID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_shirtType_ID`
  FOREIGN KEY (`shirtType_ID`)
  REFERENCES `ecommerce_db`.`shirt_types` (`shirtType_ID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
----------------------------------------
Inserting data into employee_account
----------------------------------------
INSERT INTO employee_account (empAcct_empEmail,empAcct_empFirstName,empAcct_empLastName,empAcct_empPhone, 
			empAcct_empUserName, empAcct_empPassword)
VALUES 
	('martinezj@yahoo.com','Joshua', 'Martinez','970-324-0032','jmartinez','database1'),
	('austinsneddon@gmail.com', 'Austin', 'Sneddon', '720-400-4520','asneddon','database'),
    ('taylorslinkard@gmail.com', 'Taylor', 'Slinkard','303-200-1234','tslinkard','databse'),
    ('connerjohn@gmail.com', 'Conner', 'John','970-497-4500','cjohn','database'),
    ('ianpoegstra@gmail.com', 'Ian', 'Poegstra','303-500-3842','ipoegstra','database');

INSERT INTO `ecommerce_db`.`shirt_types` (`shirtType_Type`) VALUES ('plain');
INSERT INTO `ecommerce_db`.`shirt_types` (`shirtType_Type`) VALUES ('active ');
INSERT INTO `
ecommerce_db`.`shirt_types` (`shirtType_Type`) VALUES ('graphic');

ALTER TABLE shirt_specifics
ADD shirtSpec_image BLOB;
