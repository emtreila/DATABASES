USE Train_Schedule
GO

USE Train_Schedule;
GO
DROP FUNCTION IF EXISTS stationNames;
GO
DROP PROCEDURE IF EXISTS addRoute;
GO
DROP VIEW IF EXISTS routesPass;
GO
DROP TABLE IF EXISTS Stops;
GO
DROP TABLE IF EXISTS Routes;
GO
DROP TABLE IF EXISTS Trains;
GO
DROP TABLE IF EXISTS TrainTypes;
GO
DROP TABLE IF EXISTS Stations;
GO

-- II) Create a database to manage train schedules. The database will store data about the routes of all the trains. The 
-- entities of interest to the problem domain are: Trains, Train Types, Stations, and Routes. Each train has a name and 
-- belongs to a type. A train type has a name and a description. Each station has a name. Station names are unique. 
-- Each route has a name, an associated train, and a list of stations with arrival and departure times in each station. 
-- Route names are unique. The arrival and departure times are represented as hour:minute pairs, e.g., train arrives 
-- at 5 pm and leaves at 5:10 pm.

-- 1) Write an SQL script that creates the corresponding relational data model.
CREATE TABLE Stations (
	Sid INT PRIMARY KEY IDENTITY(1,1),
	Sname VARCHAR(50) UNIQUE
	);

CREATE TABLE TrainTypes (
	TTid INT PRIMARY KEY IDENTITY(1,1),
	Tname VARCHAR(50),
	Tdesc VARCHAR(50)
);

CREATE TABLE Trains (
	Tid INT PRIMARY KEY IDENTITY(1,1),
	Tname VARCHAR(50),
	Typeid INT FOREIGN KEY REFERENCES  TrainTypes(TTid)
);

CREATE TABLE Routes (
	Rid INT PRIMARY KEY IDENTITY(1,1),
	Rname VARCHAR(50) UNIQUE,
	Trainid INT FOREIGN KEY REFERENCES Trains(Tid)
);

CREATE TABLE Stops (
	Sid INT FOREIGN KEY REFERENCES Stations(Sid),
	Rid INT FOREIGN KEY REFERENCES Routes(Rid),
	PRIMARY KEY(Sid,Rid),
	Arrival TIME,
	Departure TIME
);
GO

INSERT INTO Stations VALUES ('Iasi'), ('Husi'), ('Brasov');
INSERT INTO TrainTypes VALUES ('type1', 'desc1'), ('type2', 'desc2'), ('type3', 'desc3');
INSERT INTO Trains VALUES ('train1', '1'), ('train2', '2'), ('train3', '1');
INSERT INTO Routes VALUES ('route1','1'),('route2','2'),('route3','3');
INSERT Stops VALUES(1,1,'12:00:00', '18:00:00'), (1,2,'15:30:00', '22:42:00'), (2,2,'08:05:00', '21:48:00');
GO

-- 2) Implement a stored procedure that receives a route, a station, arrival and departure times, and adds the station 
-- to the route. If the station is already on the route, the departure and arrival times are updated.
CREATE PROCEDURE addRoute (@route INT, @station INT, @arr TIME, @dep TIME)
AS 
	DECLARE @cnt INT
	SET @cnt = 0
	SELECT @cnt = COUNT(*) FROM Stops S WHERE @route = S.Rid AND @station = S.Sid 

	IF @cnt = 0
		INSERT INTO Stops VALUES(@route, @station, @arr, @dep)
	ELSE
	BEGIN
		UPDATE Stops
		SET Arrival = @arr, Departure = @dep
		WHERE Sid = @station AND Rid = @route
	END
GO
SELECT * FROM Stops
EXEC addRoute 1,1,'20:00','21:00'
EXEC addRoute 1,3,'12:00','14:00'


-- 3) Create a view that shows the names of the routes that pass through all the stations.
CREATE VIEW routesPass 
	AS
	SELECT R.Rname
	FROM Routes R INNER JOIN Stops S ON R.Rid = S.Rid
	GROUP BY R.Rname
	HAVING COUNT(DISTINCT S.Sid) = (
		SELECT COUNT(*)
		FROM Stations
		);
GO
SELECT * FROM routesPass

-- 4) Implement a function that lists the names of the stations with more than R routes, where R is a function 
-- parameter.
CREATE FUNCTION stationNames (@R INT)
RETURNS TABLE
AS
RETURN (
	SELECT S.Sname, COUNT(S.Sname) AS NoOfRoutes
	FROM Stations S INNER JOIN Stops ST ON S.Sid = ST.Sid
	GROUP BY S.Sname
	HAVING COUNT(S.Sname) > @R
	)
GO
SELECT * FROM stationNames(4)