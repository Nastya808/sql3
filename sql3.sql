CREATE DATABASE CarManagement;
USE CarManagement;

CREATE TABLE Owners (
    OwnerID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL
);

CREATE TABLE Cars (
    CarID INT PRIMARY KEY,
    Model NVARCHAR(50) NOT NULL,
    Year INT NOT NULL,
    Mileage INT NOT NULL,
    OwnerID INT FOREIGN KEY REFERENCES Owners(OwnerID)
);


CREATE TABLE CarTechnicalDetails (
    CarID INT PRIMARY KEY,
    EngineType NVARCHAR(50) NOT NULL,
    Horsepower INT NOT NULL,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID)
);


CREATE TABLE OwnershipHistory (
    OwnershipID INT PRIMARY KEY,
    CarID INT FOREIGN KEY REFERENCES Cars(CarID),
    OwnerID INT FOREIGN KEY REFERENCES Owners(OwnerID),
    StartDate DATE NOT NULL,
    EndDate DATE,
    FOREIGN KEY (CarID, OwnerID) REFERENCES Cars(CarID, OwnerID)
);

INSERT INTO Owners (OwnerID, FirstName, LastName) VALUES
(4, 'Alice', 'Johnson'),
(5, 'Charlie', 'Brown');

INSERT INTO Cars (CarID, Model, Year, Mileage, OwnerID) VALUES
(4, 'Chevrolet Malibu', 2018, 35000, 4),
(5, 'Nissan Altima', 2022, 5000, 5);

INSERT INTO CarTechnicalDetails (CarID, EngineType, Horsepower) VALUES
(4, 'Inline-4', 200),
(5, 'V6', 250);

INSERT INTO OwnershipHistory (OwnershipID, CarID, OwnerID, StartDate, EndDate) VALUES
(4, 4, 4, '2018-01-01', '2021-01-01'),
(5, 5, 5, '2022-01-01', NULL);




--доп.задание
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Specialization NVARCHAR(50),
    Salary DECIMAL(10, 2),
    OnVacation BIT
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50),
    SponsorCompany NVARCHAR(50)
);

CREATE TABLE Wards (
    WardID INT PRIMARY KEY,
    WardName NVARCHAR(50),
    DepartmentID INT REFERENCES Departments(DepartmentID)
);

CREATE TABLE Examinations (
    ExaminationID INT PRIMARY KEY,
    DoctorID INT REFERENCES Doctors(DoctorID),
    WardID INT REFERENCES Wards(WardID),
    ExaminationDate DATE,
    Weekday NVARCHAR(10),
    DiseaseID INT REFERENCES Diseases(DiseaseID),
    Severity INT
);

CREATE TABLE Donations (
    DonationID INT PRIMARY KEY,
    DepartmentID INT REFERENCES Departments(DepartmentID),
    SponsorID INT REFERENCES Sponsors(SponsorID),
    Amount DECIMAL(10, 2),
    DonationDate DATE
);

CREATE TABLE Sponsors (
    SponsorID INT PRIMARY KEY,
    SponsorName NVARCHAR(50)
);

CREATE TABLE Diseases (
    DiseaseID INT PRIMARY KEY,
    DiseaseName NVARCHAR(50),
    SeverityThreshold INT
);

INSERT INTO Doctors VALUES (1, 'John', 'Smith', 'Cardiology', 8000.00, 0);
INSERT INTO Doctors VALUES (2, 'Jane', 'Doe', 'Neurology', 9000.00, 1);

INSERT INTO Departments VALUES (1, 'Cardiology Department', 'Umbrella Corporation');
INSERT INTO Departments VALUES (2, 'Neurology Department', 'Umbrella Corporation');

INSERT INTO Wards VALUES (1, 'Ward1', 1);
INSERT INTO Wards VALUES (2, 'Ward2', 2);

INSERT INTO Examinations VALUES (1, 1, '2023-01-01', 'Monday', 1, 4);
INSERT INTO Examinations VALUES (2, 2, '2023-01-02', 'Tuesday', 2, 5);

INSERT INTO Donations VALUES (1, 1, 100000.00, '2023-01-15');
INSERT INTO Donations VALUES (2, 2, 120000.00, '2023-02-20');

INSERT INTO Sponsors VALUES (1, 'Umbrella Corporation');
INSERT INTO Sponsors VALUES (2, 'Other Sponsor');

INSERT INTO Diseases VALUES (1, 'Common Cold', 2);
INSERT INTO Diseases VALUES (2, 'Heart Disease', 4);


--1
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, Specialization
FROM Doctors;

--2
SELECT LastName, Salary
FROM Doctors
WHERE OnVacation = 0;

--3
SELECT WardName
FROM Wards
WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'Intensive Treatment');

--4
SELECT DISTINCT DepartmentName
FROM Departments
WHERE SponsorCompany = 'Umbrella Corporation';

--5
SELECT D.DepartmentName, S.SponsorName, Amount, DonationDate
FROM Donations D
JOIN Sponsors S ON D.SponsorID = S.SponsorID
WHERE DonationDate >= DATEADD(MONTH, -1, GETDATE());

--6
SELECT D.LastName, E.Weekday, W.WardName
FROM Doctors D
JOIN Examinations E ON D.DoctorID = E.DoctorID
JOIN Wards W ON E.WardID = W.WardID
WHERE E.Weekday IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday');

--7
SELECT W.WardName, D.DepartmentName
FROM Examinations E
JOIN Doctors Doc ON E.DoctorID = Doc.DoctorID
JOIN Wards W ON E.WardID = W.WardID
JOIN Departments D ON W.DepartmentID = D.DepartmentID
WHERE Doc.FirstName = 'Helen' AND Doc.LastName = 'Williams';

--8
SELECT D.DepartmentName, Doc.FirstName, Doc.LastName
FROM Donations DN
JOIN Departments D ON DN.DepartmentID = D.DepartmentID
JOIN Doctors Doc ON D.DepartmentID = Doc.DepartmentID
WHERE Amount > 100000;

--9
SELECT DISTINCT D.DepartmentName
FROM Doctors Doc
JOIN Departments D ON Doc.DepartmentID = D.DepartmentID
WHERE Doc.Salary = Doc.BaseSalary; 

--10
SELECT DISTINCT Doc.Specialization
FROM Doctors Doc
JOIN Examinations E ON Doc.DoctorID = E.DoctorID
JOIN Diseases Dis ON E.DiseaseID = Dis.DiseaseID
WHERE Dis.SeverityThreshold > 3;

--11
SELECT D.DepartmentName, Dis.DiseaseName
FROM Examinations E
JOIN Wards W ON E.WardID = W.WardID
JOIN Departments D ON W.DepartmentID = D.DepartmentID
JOIN Diseases Dis ON E.DiseaseID = Dis.DiseaseID
WHERE E.ExaminationDate >= DATEADD(MONTH, -6, GETDATE());

--12
SELECT D.DepartmentName, W.WardName
FROM Examinations E
JOIN Wards W ON E.WardID = W.WardID
JOIN Departments D ON W.DepartmentID = D.DepartmentID
JOIN Diseases Dis ON E.DiseaseID = Dis.DiseaseID
WHERE Dis.Infectious = 1;