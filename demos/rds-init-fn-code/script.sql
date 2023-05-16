-- Your SQL scripts for initialization goes here...

CREATE TABLE Persons (
    PersonID int NOT NULL AUTO_INCREMENT,
    FirstName varchar(255) NOT NULL,
    LastName varchar(255) NOT NULL,
    Address varchar(255) NOT NULL,
    PRIMARY KEY (PersonID)
); 

CREATE TABLE Orders (
    OrderID int NOT NULL AUTO_INCREMENT,
    OrderNumber int NOT NULL,
    PersonID int,
    Date timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)
); 

CREATE TABLE Books (
    BookID int NOT NULL AUTO_INCREMENT,
    Title varchar(255) NOT NULL,
    Author varchar(255) NOT NULL,
    Price decimal(6,2) NOT NULL,
    PRIMARY KEY (BookID)
);

CREATE TABLE OrderDetails (
    OrderID int NOT NULL,
    BookID int NOT NULL,
    Quantity int NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

INSERT INTO Books (Title, Author, Price) VALUES ("Hello World", "Jane Doe", 12.12);
INSERT INTO Books (Title, Author, Price) VALUES ("A little Story", "Jane Doe", 22.30);
INSERT INTO Books (Title, Author, Price) VALUES ("The LocalStack Guide", "LocalStack", 42.00);

INSERT INTO Persons (FirstName, LastName, Address) VALUES ("Peter", "Test", "Somelane 123");
INSERT INTO Persons (FirstName, LastName, Address) VALUES ("Kathrine", "Miller", "Anotherlane 123");
