USE Test_baze;
GO

-- I)  1) e  2) c  3) e


-- II)
-- 1)
DROP PROCEDURE IF EXISTS spMemberInfo;
GO
DROP VIEW IF EXISTS vMemberDetails;
GO
DROP FUNCTION IF EXISTS fGymStats;
GO


DROP TABLE IF EXISTS MemberClasses;
DROP TABLE IF EXISTS Memberships;
DROP TABLE IF EXISTS Classes;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Trainers;
DROP TABLE IF EXISTS Gym;
GO



CREATE TABLE Gym (
    GymID INT PRIMARY KEY
);
GO

CREATE TABLE Trainers (
    TrainerID INT PRIMARY KEY,
    TrainerName VARCHAR(50),
    Speciality VARCHAR(50),
    GymID INT,
    FOREIGN KEY (GymID) REFERENCES Gym(GymID)
);
GO

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    NationalID CHAR(13),
    Wallet INT,
    GymID INT,
    TrainerID INT,
    FOREIGN KEY (GymID) REFERENCES Gym(GymID),
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID)
);
GO

CREATE TABLE Memberships (
    MembershipID INT PRIMARY KEY,
    MemberID INT,
    MonthlyPrice INT,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
GO

CREATE TABLE Classes (
    ClassID INT PRIMARY KEY,
    ClassName VARCHAR(50),
    GymID INT,
    FOREIGN KEY (GymID) REFERENCES Gym(GymID)
);
GO

CREATE TABLE MemberClasses (
    MemberID INT,
    ClassID INT,
    PRIMARY KEY (MemberID, ClassID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);
GO


-- 2)
CREATE PROCEDURE spMemberInfo (@MemberID INT, @NoClasses INT OUTPUT, @TotalPrice INT OUTPUT)
AS
BEGIN
    SELECT @NoClasses = COUNT(*)
    FROM MemberClasses
    WHERE MemberID = @MemberID;

    SELECT @TotalPrice = SUM(MonthlyPrice)
    FROM Memberships
    WHERE MemberID = @MemberID;
END;
GO


-- 3)
CREATE VIEW vMemberDetails
AS
SELECT M.NationalID, M.Wallet, C.ClassName, T.TrainerName
FROM Members M
    JOIN MemberClasses MC ON M.MemberID = MC.MemberID
    JOIN Classes C ON MC.ClassID = C.ClassID
    JOIN Trainers T ON M.TrainerID = T.TrainerID;
GO


-- 4)
CREATE FUNCTION fGymStats (@GymID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT M.NationalID, T.Speciality, COUNT(MC.ClassID) AS NoClasses
    FROM Members M
        JOIN Trainers T ON M.TrainerID = T.TrainerID
        JOIN MemberClasses MC ON M.MemberID = MC.MemberID
        JOIN Classes C ON MC.ClassID = C.ClassID
    WHERE M.GymID = @GymID
    GROUP BY M.NationalID, T.Speciality
);
GO



INSERT INTO Gym VALUES (1);

INSERT INTO Trainers VALUES (1, 'Trainer A', 'Fitness', 1);
INSERT INTO Trainers VALUES (2, 'Trainer B', 'Yoga', 1);

INSERT INTO Members VALUES (1, '1234567890123', 100, 1, 1);
INSERT INTO Members VALUES (2, '9876543210987', 150, 1, 2);

INSERT INTO Memberships VALUES (1, 1, 50);
INSERT INTO Memberships VALUES (2, 1, 30);
INSERT INTO Memberships VALUES (3, 2, 70);

INSERT INTO Classes VALUES (1, 'Heavy lifting', 1);
INSERT INTO Classes VALUES (2, 'Cardio', 1);

INSERT INTO MemberClasses VALUES (1, 1);
INSERT INTO MemberClasses VALUES (1, 2);
INSERT INTO MemberClasses VALUES (2, 2);
GO



DECLARE @C INT, @P INT;
EXEC spMemberInfo 1, @C OUTPUT, @P OUTPUT;
SELECT @C AS NoClasses, @P AS TotalMonthlyPrice;

SELECT * FROM vMemberDetails;

SELECT * FROM fGymStats(1);
GO
