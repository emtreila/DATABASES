USE Food_delivery
GO

-- Create a database to manage a food delivery platform (Customers, Accounts, FoodItems, Orders, Statistics).
-- Each customer has one account. An account can include multiple food types and many orders (ORDER/REFUND).
-- Statistics include number of ORDER/REFUND, total operations, and money left (initial deposit minus net spent).

-- 1) Write a SQL script that creates the corresponding relational data model.

CREATE TABLE Accounts (
	Aid INT PRIMARY KEY IDENTITY(1,1),

);

CREATE TABLE Customers (
	Cid INT PRIMARY KEY IDENTITY(1,1),
	AccountID INT FOREIGN KEY REFERENCES Accounts(Aid)
);