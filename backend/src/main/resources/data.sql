-- Create tables
CREATE TABLE Cinemas (
    CinemaID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Rooms (
    RoomID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    CinemaID INT UNSIGNED NOT NULL,
    RoomName VARCHAR(50),
    TotalSeats INT NOT NULL,
    FOREIGN KEY (CinemaID) REFERENCES Cinemas(CinemaID) ON DELETE CASCADE
);

CREATE TABLE Seats (
    SeatID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    RoomID INT UNSIGNED NOT NULL,
    RowNumber INT NOT NULL,
    ColumnNumber INT NOT NULL,
    SeatType VARCHAR(20) NOT NULL CHECK (SeatType IN ('POJEDYNCZE', 'PODWÓJNE', 'DLA_NIEPEŁNOSPRAWNYCH', 'INNE')),
    PriceMultiplier DECIMAL(3, 2) NOT NULL,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE CASCADE
);

CREATE TABLE Movies (
    MovieID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200) UNIQUE NOT NULL,
    DurationMinutes INT NOT NULL,
    AgeRestriction INT,
    PremiereDate DATE
);

CREATE TABLE Shows (
    ShowID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    MovieID INT UNSIGNED NOT NULL,
    RoomID INT UNSIGNED NOT NULL,
    StartTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP NOT NULL,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID) ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE CASCADE
);

CREATE TABLE Users (
    UserID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('GOŚĆ', 'KLIENT', 'BILETER', 'ADMINISTRATOR')),
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PasswordHash VARCHAR(255),
    LoyaltyPoints INT DEFAULT 0
);

CREATE TABLE Tickets (
    TicketID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    ShowID INT UNSIGNED NOT NULL,
    SeatID INT UNSIGNED NOT NULL,
    UserID INT UNSIGNED,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('WAŻNY', 'NIEWAŻNY', 'SKASOWANY')),
    TicketCode CHAR(9) UNIQUE NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES Shows(ShowID) ON DELETE CASCADE,
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Payments (
    PaymentID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    UserID INT UNSIGNED NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('ZREALIZOWANA', 'NIEZREALIZOWANA', 'ANULOWANA')),
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentDate TIMESTAMP,
    TicketID INT UNSIGNED NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID)
);

-- Insert sample data
INSERT INTO Cinemas (Name) 
VALUES ('Cinema City Wrocław');

INSERT INTO Rooms (CinemaID, RoomName, TotalSeats) 
VALUES 
(1, 'Sala 1', 100), 
(1, 'Sala 2', 150);

INSERT INTO Seats (RoomID, RowNumber, ColumnNumber, SeatType, PriceMultiplier) 
VALUES 
(1, 1, 1, 'POJEDYNCZE', 1.0),
(1, 1, 2, 'PODWÓJNE', 1.5);

INSERT INTO Movies (Title, DurationMinutes, AgeRestriction, PremiereDate) 
VALUES 
('Incepcja', 148, 13, '2010-07-16');

INSERT INTO Shows (MovieID, RoomID, StartTime, EndTime) 
VALUES 
(1, 1, '2024-12-15 18:00:00', '2024-12-15 20:30:00');

INSERT INTO Users (Role, Name, Email, PasswordHash, LoyaltyPoints) 
VALUES 
('KLIENT', 'Jan Kowalski', 'jan.kowalski@example.com', 'hashedpassword', 50),
('ADMINISTRATOR', 'Anna Nowak', 'anna.nowak@example.com', 'hashedpassword', 0);

INSERT INTO Tickets (ShowID, SeatID, UserID, Status, TicketCode, Price) 
VALUES 
(1, 1, 1, 'WAŻNY', '123456789', 30.00);

INSERT INTO Payments (UserID, Status, Amount, PaymentDate, TicketID) 
VALUES 
(1, 'ZREALIZOWANA', 30.00, '2024-12-10 15:00:00', 1);
