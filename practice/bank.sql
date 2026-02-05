USE Bank
GO

DROP FUNCTION IF EXISTS transactionSum
GO
DROP VIEW IF EXISTS showCardNumbers
GO
DROP PROCEDURE IF EXISTS deleteTransactions
GO
DROP TABLE IF EXISTS Transactions;
GO
DROP TABLE IF EXISTS Cards;
GO
DROP TABLE IF EXISTS ATM;
GO
DROP TABLE IF EXISTS Accounts;
GO
DROP TABLE IF EXISTS Customers;
GO

-- Create a database for tracking operations within a bank. You will manage customers, bank accounts, cards, ATMs and transactions.
-- Each customer has a name, the date of birth and may have multiple bank accounts.
-- For each bank account consider the following: the IBAN code, the current balance, the holder and the cards associated with that bank account.
-- Each card has a number, a CVV code (last 3 digits of the card number) and is associated with a bank account.
-- An ATM has an address. A transaction involves withdrawing, from an ATM, a sum of money using a card at a certain time (consider both date and time).
-- Of course, a card can be used in several transactions at the same ATM or at different ATMs and at an ATM multiple transactions can be done with multiple cards.

-- 1) Write an SQL script that creates the corresponding relational data model.
CREATE TABLE Customers (
	Cid INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(50),
	Birthdate DATE
);

CREATE TABLE Accounts (
	Aid INT PRIMARY KEY IDENTITY(1,1),
	IBAN VARCHAR(34) UNIQUE,
	Balance INT, 
	CustomerID INT FOREIGN KEY REFERENCES Customers(Cid)
);

CREATE TABLE Cards (
	Number CHAR(16) PRIMARY KEY,
	CVV CHAR(3),
	AccountID INT FOREIGN KEY REFERENCES Accounts(Aid)
);

CREATE TABLE ATM (
	ATMid INT PRIMARY KEY IDENTITY(1,1),
	Addr VARCHAR(50)
);

CREATE TABLE Transactions (
	Tid INT PRIMARY KEY IDENTITY(1,1),
	CardID CHAR(16) FOREIGN KEY REFERENCES Cards(Number),
	ATMid INT FOREIGN KEY REFERENCES ATM(ATMid),
	DateAndTime DATETIME,
	Amount INT
);

INSERT INTO Customers (Name, Birthdate) VALUES
('Popescu Ion', '1990-05-10'),
('Ionescu Maria', '1988-11-22'),
('Georgescu Andrei', '1995-03-15');

INSERT INTO Accounts (IBAN, Balance, CustomerID) VALUES
('IBAN1', 1500.50, 1),
('IBAN2', 3000.00, 1),
('IBAN3', 2500.75, 2),
('IBAN4', 500.00, 3);


INSERT INTO Cards (Number, CVV, AccountID) VALUES
('1111222233334444', '123', 1),
('5555666677778888', '456', 2),
('9999000011112222', '789', 3),
('3333444455556666', '321', 4);


INSERT INTO ATM (Addr) VALUES
('Str. Independentei 10'),
('Bd. Stefan cel Mare 25'),
('Str. Copou 3');


INSERT INTO Transactions (CardID, ATMid, DateAndTime, Amount) VALUES
('1111222233334444', 1, '2024-01-10 10:00', 500.00),
('1111222233334444', 2, '2024-01-11 12:30', 800.00),
('1111222233334444', 3, '2024-01-12 15:45', 900.00),

('5555666677778888', 1, '2024-01-10 09:00', 1000.00),
('5555666677778888', 2, '2024-01-11 14:00', 1200.00),

('9999000011112222', 1, '2024-01-12 16:00', 700.00),
('9999000011112222', 3, '2024-01-13 17:00', 900.00),

('3333444455556666', 2, '2024-01-14 18:00', 300.00);


-- 2) Implement a stored procedure that receives a card and deletes all the transactions related to that card.
CREATE PROCEDURE deleteTransactions (@card CHAR(16))
AS
BEGIN
    DELETE FROM Transactions
    WHERE CardID = @card;
END
GO

SELECT * FROM Transactions;
GO

EXEC deleteTransactions '9999000011112222';
GO

-- 3) Create a view that shows the card numbers which were used in transactions at all the ATMs.
CREATE VIEW showCardNumbers 
AS
	SELECT T.CardID
	FROM Transactions T 
	HAVING COUNT(T.ATMid) = (
		SELECT COUNT(*)
		FROM ATM
	);
GO
SELECT * FROM showCardNumbers
GO
-- 4) Implement a function that lists the cards (number and CVV code) that have the total transactions sum greater than 2000 lei.
CREATE FUNCTION transactionSum()
RETURNS TABLE
AS
RETURN (
	SELECT C.Number, C.CVV
	FROM Cards C INNER JOIN Transactions T ON C.Number = T.CardID
	GROUP BY C.Number, C.CVV
	HAVING SUM(T.Amount) > 2000
)
GO
SELECT * FROM transactionSum()
GO