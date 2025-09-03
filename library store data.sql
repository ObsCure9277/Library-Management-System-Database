SET PAGESIZE 100
SET LINESIZE 200
SET SERVEROUTPUT ON;

DROP TABLE Attendance;
DROP TABLE Schedules;
DROP TABLE ReservationDetails;
DROP TABLE Reservations;
DROP TABLE Fines;
DROP TABLE BorrowDetails;
DROP TABLE Borrows;
DROP TABLE BookCopys;
DROP TABLE Books;
DROP TABLE Staffs;
DROP TABLE Payments;
DROP TABLE Publishers;
DROP TABLE Members;


CREATE TABLE Members (
  memberID           CHAR(5)      NOT NULL,
  memberName         VARCHAR(50)  NOT NULL,
  memberEmail        VARCHAR(50)  NOT NULL  UNIQUE,
  membershipStatus   VARCHAR(50)  NOT NULL  CHECK (membershipStatus IN ('Active', 'Disable')),
  expiryDate         DATE         NOT NULL,
  password           VARCHAR(50)  NOT NULL,
  PRIMARY KEY (memberID)
);

CREATE TABLE Publishers (
  publisherID        CHAR(5)     NOT NULL,
  publisherName      VARCHAR(50) NOT NULL,
  publisherEmail     VARCHAR(50) NOT NULL  UNIQUE,
  PRIMARY KEY (publisherID)
);

CREATE TABLE Payments (
  paymentID          CHAR(5)     NOT NULL,
  name               VARCHAR(50) NOT NULL,
  paymentMethod      VARCHAR(50) NOT NULL,
  PRIMARY KEY (paymentID)
);

CREATE TABLE Staffs (
  staffID            CHAR(5)     NOT NULL,
  staffName          VARCHAR(50) NOT NULL,
  staffEmail         VARCHAR(50) NOT NULL  UNIQUE,
  password           VARCHAR(50) NOT NULL,
  PRIMARY KEY (staffID)
);

CREATE TABLE Books (
  ISBN               CHAR(13)    NOT NULL,
  bookName           VARCHAR(50) NOT NULL,
  publicationDate    DATE,
  genre              VARCHAR(50),
  author             VARCHAR(50) NOT NULL,
  popularity         INTEGER,
  publisherID        CHAR(5)     NOT NULL,
  PRIMARY KEY (ISBN),
  FOREIGN KEY (publisherID) REFERENCES Publishers(publisherID)
);

CREATE TABLE BookCopys (
  bookCopyID         CHAR(5)     NOT NULL,
  bookCopyStatus     VARCHAR(50) NOT NULL  CHECK (bookCopyStatus IN ('Intact', 'Damage')),
  ISBN               CHAR(13)    NOT NULL,
  PRIMARY KEY (bookCopyID),
  FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
);

CREATE TABLE Borrows (
  borrowID           CHAR(5)     NOT NULL,
  borrowDate         DATE        NOT NULL,
  dueDate            DATE        NOT NULL,
  memberID           CHAR(5)     NOT NULL,
  staffID            CHAR(5)     NOT NULL,
  PRIMARY KEY (borrowID),
  FOREIGN KEY (memberID) REFERENCES Members(memberID), 
  FOREIGN KEY (staffID) REFERENCES Staffs(staffID)
);

CREATE TABLE BorrowDetails (
  borrowID           CHAR(5)     NOT NULL,
  bookCopyID         CHAR(5)    NOT NULL,
  quantity           INTEGER     NOT NULL,
  returnDate         DATE,
  PRIMARY KEY (borrowID, bookCopyID),
  FOREIGN KEY (borrowID) REFERENCES Borrows(borrowID), 
  FOREIGN KEY (bookCopyID) REFERENCES BookCopys(bookCopyID)
);

CREATE TABLE Fines (
  fineID             CHAR(5)     NOT NULL,
  amount             INTEGER      NOT NULL,
  fineStatus         VARCHAR(50) NOT NULL  CHECK (fineStatus IN ('Paid', 'Unpaid')),
  payFineDate        DATE,
  paymentID          CHAR(5),
  borrowID           CHAR(5)     NOT NULL,
  bookCopyID         CHAR(5)     NOT NULL,
  PRIMARY KEY (fineID),
  FOREIGN KEY (paymentID) REFERENCES Payments(paymentID), 
  FOREIGN KEY (borrowID, bookCopyId) REFERENCES BorrowDetails(borrowID, bookCopyID)
);

CREATE TABLE Reservations (
  reservationID      CHAR(5)     NOT NULL,
  reservationDate    DATE        NOT NULL,
  memberID           CHAR(5)     NOT NULL,
  PRIMARY KEY (reservationID),
  FOREIGN KEY (memberID) REFERENCES Members(memberID)
);

CREATE TABLE ReservationDetails (
  reservationID      CHAR(5)     NOT NULL,
  bookCopyID         CHAR(5)     NOT NULL,
  quantity           INTEGER     NOT NULL,
  PRIMARY KEY (reservationID, bookCopyID),
  FOREIGN KEY (reservationID) REFERENCES Reservations(reservationID),
  FOREIGN KEY (bookCopyID) REFERENCES BookCopys(bookCopyID)
);

CREATE TABLE Schedules (
  scheduleID         CHAR(5)     NOT NULL,
  startTime          TIMESTAMP    NOT NULL,
  endTime            TIMESTAMP    NOT NULL,
  staffID            CHAR(5)     NOT NULL,
  PRIMARY KEY (scheduleID),
  FOREIGN KEY (staffID) REFERENCES Staffs(staffID)
);

CREATE TABLE Attendance (
  attendanceID       CHAR(5)     NOT NULL,
  startTime          TIMESTAMP,
  endTime            TIMESTAMP,
  attendanceStatus   VARCHAR(50) NOT NULL CHECK (attendanceStatus IN ('Attend', 'Absence')),
  scheduleID         CHAR(5)     NOT NULL,
  PRIMARY KEY (attendanceID),
  FOREIGN KEY (scheduleID) REFERENCES Schedules(scheduleID)
);



INSERT INTO Members VALUES ('MEM01', 'John Smith', 'john.smith@email.com', 'Active', TO_DATE('31-12-2025', 'DD-MM-YYYY'), 'password123');
INSERT INTO Members VALUES ('MEM02', 'Emily Johnson', 'emily.j@email.com', 'Active', TO_DATE('15-11-2025', 'DD-MM-YYYY'), 'securepass1');
INSERT INTO Members VALUES ('MEM03', 'Michael Brown', 'michael.b@email.com', 'Active', TO_DATE('20-10-2025', 'DD-MM-YYYY'), 'mikepass99');
INSERT INTO Members VALUES ('MEM04', 'Sarah Williams', 'sarah.w@email.com', 'Active', TO_DATE('30-09-2025', 'DD-MM-YYYY'), 'sarahpass1');
INSERT INTO Members VALUES ('MEM05', 'David Jones', 'david.j@email.com', 'Active', TO_DATE('25-08-2025', 'DD-MM-YYYY'), 'david12345');
INSERT INTO Members VALUES ('MEM06', 'Jessica Davis', 'jessica.d@email.com', 'Active', TO_DATE('10-07-2025', 'DD-MM-YYYY'), 'jesspass22');
INSERT INTO Members VALUES ('MEM07', 'Robert Wilson', 'robert.w@email.com', 'Active', TO_DATE('05-06-2025', 'DD-MM-YYYY'), 'robertpass');
INSERT INTO Members VALUES ('MEM08', 'Lisa Miller', 'lisa.m@email.com', 'Active', TO_DATE('18-05-2025', 'DD-MM-YYYY'), 'lisapass12');
INSERT INTO Members VALUES ('MEM09', 'Daniel Taylor', 'daniel.t@email.com', 'Active', TO_DATE('30-05-2025', 'DD-MM-YYYY'), 'dantaylor1');
INSERT INTO Members VALUES ('MEM10', 'Amy Anderson', 'amy.a@email.com', 'Active', TO_DATE('15-05-2025', 'DD-MM-YYYY'), 'amyanderson');
INSERT INTO Members VALUES ('MEM11', 'Steph Iverson', 'iver.i@email.com', 'Disable', TO_DATE('02-04-2025', 'DD-MM-YYYY'), 'stephiverson');

INSERT INTO Publishers VALUES ('PUB01', 'Penguin Books', 'contact@penguin.com');
INSERT INTO Publishers VALUES ('PUB02', 'HarperCollins', 'info@harpercollins.com');
INSERT INTO Publishers VALUES ('PUB03', 'Simon Schuster', 'contact@simonandschuster.com');
INSERT INTO Publishers VALUES ('PUB04', 'Macmillan', 'support@macmillan.com');
INSERT INTO Publishers VALUES ('PUB05', 'Hachette', 'hello@hachette.com');
INSERT INTO Publishers VALUES ('PUB06', 'Random House', 'contact@randomhouse.com');
INSERT INTO Publishers VALUES ('PUB07', 'Scholastic', 'info@scholastic.com');
INSERT INTO Publishers VALUES ('PUB08', 'Oxford Press', 'contact@oxfordpress.com');
INSERT INTO Publishers VALUES ('PUB09', 'Cambridge Press', 'support@cambridgepress.com');
INSERT INTO Publishers VALUES ('PUB10', 'Wiley', 'hello@wiley.com');

INSERT INTO Payments VALUES ('PY001', 'Credit Card Payment', 'Credit Card');
INSERT INTO Payments VALUES ('PY002', 'PayPal Transfer', 'PayPal');
INSERT INTO Payments VALUES ('PY003', 'Bank Transfer', 'Bank Transfer');
INSERT INTO Payments VALUES ('PY004', 'Debit Card Payment', 'Debit Card');
INSERT INTO Payments VALUES ('PY005', 'Google Pay', 'Mobile Payment');
INSERT INTO Payments VALUES ('PY006', 'Apple Pay', 'Mobile Payment');
INSERT INTO Payments VALUES ('PY007', 'Cash Payment', 'Cash');
INSERT INTO Payments VALUES ('PY008', 'Check Payment', 'Check');
INSERT INTO Payments VALUES ('PY009', 'Venmo Transfer', 'Venmo');
INSERT INTO Payments VALUES ('PY010', 'Cryptocurrency', 'Crypto');

INSERT INTO Staffs VALUES ('STF01', 'Admin User', 'admin@library.com', 'adminpass123');
INSERT INTO Staffs VALUES ('STF02', 'Librarian One', 'librarian1@library.com', 'lib1pass456');
INSERT INTO Staffs VALUES ('STF03', 'Librarian Two', 'librarian2@library.com', 'lib2pass789');
INSERT INTO Staffs VALUES ('STF04', 'Manager One', 'manager1@library.com', 'mgr1pass123');
INSERT INTO Staffs VALUES ('STF05', 'Assistant One', 'assistant1@library.com', 'ast1pass456');
INSERT INTO Staffs VALUES ('STF06', 'IT Support', 'itsupport@library.com', 'itpass789');
INSERT INTO Staffs VALUES ('STF07', 'Catalog Specialist', 'catalog@library.com', 'catpass123');
INSERT INTO Staffs VALUES ('STF08', 'Front Desk One', 'frontdesk1@library.com', 'fd1pass456');
INSERT INTO Staffs VALUES ('STF09', 'Front Desk Two', 'frontdesk2@library.com', 'fd2pass789');
INSERT INTO Staffs VALUES ('STF10', 'Director', 'director@library.com', 'dirpass123');

INSERT INTO Books VALUES ('9781234567890', 'The Silent Echo', TO_DATE('15-03-2018', 'DD-MM-YYYY'), 'Mystery', 'James Patterson', 4, 'PUB01');
INSERT INTO Books VALUES ('9782345678901', 'Whispers in the Dark', TO_DATE('22-07-2019', 'DD-MM-YYYY'), 'Thriller', 'Stephen King', 4, 'PUB02');
INSERT INTO Books VALUES ('9783456789012', 'The Last Summer', TO_DATE('10-05-2020', 'DD-MM-YYYY'), 'Romance', 'Nicholas Sparks', 6, 'PUB03');
INSERT INTO Books VALUES ('9784567890123', 'Galactic Odyssey', TO_DATE('30-11-2021', 'DD-MM-YYYY'), 'Science Fiction', 'Andy Weir', 2, 'PUB04');
INSERT INTO Books VALUES ('9785678901234', 'The Forgotten Kingdom', TO_DATE('14-02-2017', 'DD-MM-YYYY'), 'Fantasy', 'Brandon Sanderson', 4, 'PUB05');
INSERT INTO Books VALUES ('9786789012345', 'Midnight Shadows', TO_DATE('08-09-2018', 'DD-MM-YYYY'), 'Horror', 'Dean Koontz', 2, 'PUB06');
INSERT INTO Books VALUES ('9787890123456', 'The Art of Deception', TO_DATE('25-04-2019', 'DD-MM-YYYY'), 'Crime', 'Agatha Christie', 4, 'PUB07');
INSERT INTO Books VALUES ('9788901234567', 'Eternal Bonds', TO_DATE('03-12-2020', 'DD-MM-YYYY'), 'Romance', 'Nora Roberts', 2, 'PUB08');
INSERT INTO Books VALUES ('9789012345678', 'Quantum Paradox', TO_DATE('19-06-2021', 'DD-MM-YYYY'), 'Science Fiction', 'Blake Crouch', 2, 'PUB09');
INSERT INTO Books VALUES ('9780123456789', 'The Hidden Truth', TO_DATE('27-01-2019', 'DD-MM-YYYY'), 'Mystery', 'Gillian Flynn', 2, 'PUB10');


INSERT INTO Books VALUES ('9781122334455', 'Sapiens: A Brief History', TO_DATE('10-02-2015', 'DD-MM-YYYY'), 'History', 'Yuval Noah Harari', 6, 'PUB01');
INSERT INTO Books VALUES ('9782233445566', 'Atomic Habits', TO_DATE('16-10-2018', 'DD-MM-YYYY'), 'Self-Help', 'James Clear', 4, 'PUB02');
INSERT INTO Books VALUES ('9783344556677', 'Becoming', TO_DATE('13-11-2018', 'DD-MM-YYYY'), 'Biography', 'Michelle Obama', 2, 'PUB03');
INSERT INTO Books VALUES ('9784455667788', 'Educated', TO_DATE('20-02-2018', 'DD-MM-YYYY'), 'Memoir', 'Tara Westover', 2, 'PUB04');
INSERT INTO Books VALUES ('9785566778899', 'The Body Keeps the Score', TO_DATE('08-09-2014', 'DD-MM-YYYY'), 'Psychology', 'Bessel van der Kolk', 4, 'PUB05');
INSERT INTO Books VALUES ('9786677889900', 'Thinking, Fast and Slow', TO_DATE('25-10-2011', 'DD-MM-YYYY'), 'Psychology', 'Daniel Kahneman', 2, 'PUB06');
INSERT INTO Books VALUES ('9787788990011', 'The Subtle Art of Not Giving a F*ck', TO_DATE('13-09-2016', 'DD-MM-YYYY'), 'Self-Help', 'Mark Manson', 4, 'PUB07');
INSERT INTO Books VALUES ('9788899001122', 'Born a Crime', TO_DATE('15-11-2016', 'DD-MM-YYYY'), 'Biography', 'Trevor Noah', 4, 'PUB08');
INSERT INTO Books VALUES ('9789900112233', 'The Power of Habit', TO_DATE('28-02-2012', 'DD-MM-YYYY'), 'Self-Help', 'Charles Duhigg', 2, 'PUB09');
INSERT INTO Books VALUES ('9780011223344', 'Quiet: The Power of Introverts', TO_DATE('24-01-2012', 'DD-MM-YYYY'), 'Psychology', 'Susan Cain', 2, 'PUB10');


INSERT INTO Books VALUES ('9781000000001', 'Pride and Prejudice', TO_DATE('28-01-1813', 'DD-MM-YYYY'), 'Classic', 'Jane Austen', 8, 'PUB01');
INSERT INTO Books VALUES ('9781000000002', '1984', TO_DATE('08-06-1949', 'DD-MM-YYYY'), 'Dystopian', 'George Orwell', 6, 'PUB02');
INSERT INTO Books VALUES ('9781000000003', 'To Kill a Mockingbird', TO_DATE('11-07-1960', 'DD-MM-YYYY'), 'Classic', 'Harper Lee', 4, 'PUB03');
INSERT INTO Books VALUES ('9781000000004', 'The Great Gatsby', TO_DATE('10-04-1925', 'DD-MM-YYYY'), 'Classic', 'F. Scott Fitzgerald', 2, 'PUB04');
INSERT INTO Books VALUES ('9781000000005', 'Moby-Dick', TO_DATE('18-10-1851', 'DD-MM-YYYY'), 'Adventure', 'Herman Melville', 2, 'PUB05');
INSERT INTO Books VALUES ('9781000000006', 'War and Peace', TO_DATE('01-01-1869', 'DD-MM-YYYY'), 'Historical', 'Leo Tolstoy', 4, 'PUB06');
INSERT INTO Books VALUES ('9781000000007', 'Crime and Punishment', TO_DATE('01-01-1866', 'DD-MM-YYYY'), 'Psychological', 'Fyodor Dostoevsky', 2, 'PUB07');
INSERT INTO Books VALUES ('9781000000008', 'The Catcher in the Rye', TO_DATE('16-07-1951', 'DD-MM-YYYY'), 'Coming-of-Age', 'J.D. Salinger', 2, 'PUB08');
INSERT INTO Books VALUES ('9781000000009', 'Jane Eyre', TO_DATE('16-10-1847', 'DD-MM-YYYY'), 'Gothic', 'Charlotte Brontë', 2, 'PUB09');
INSERT INTO Books VALUES ('9781000000010', 'Wuthering Heights', TO_DATE('01-12-1847', 'DD-MM-YYYY'), 'Gothic', 'Emily Brontë', 2, 'PUB10');


INSERT INTO Books VALUES ('9782000000001', 'The Midnight Library', TO_DATE('13-08-2020', 'DD-MM-YYYY'), 'Fantasy', 'Matt Haig', 6, 'PUB01');
INSERT INTO Books VALUES ('9782000000002', 'Where the Crawdads Sing', TO_DATE('14-08-2018', 'DD-MM-YYYY'), 'Mystery', 'Delia Owens', 6, 'PUB02');
INSERT INTO Books VALUES ('9782000000003', 'Normal People', TO_DATE('28-08-2018', 'DD-MM-YYYY'), 'Literary', 'Sally Rooney', 2, 'PUB03');
INSERT INTO Books VALUES ('9782000000004', 'The Vanishing Half', TO_DATE('02-06-2020', 'DD-MM-YYYY'), 'Literary', 'Brit Bennett', 2, 'PUB04');
INSERT INTO Books VALUES ('9782000000005', 'Anxious People', TO_DATE('18-08-2020', 'DD-MM-YYYY'), 'Humor', 'Fredrik Backman', 2, 'PUB05');
INSERT INTO Books VALUES ('9782000000006', 'The Guest List', TO_DATE('20-02-2020', 'DD-MM-YYYY'), 'Thriller', 'Lucy Foley', 2, 'PUB06');
INSERT INTO Books VALUES ('9782000000007', 'Such a Fun Age', TO_DATE('31-12-2019', 'DD-MM-YYYY'), 'Literary', 'Kiley Reid', 2, 'PUB07');
INSERT INTO Books VALUES ('9782000000008', 'The Invisible Life of Addie LaRue', TO_DATE('06-10-2020', 'DD-MM-YYYY'), 'Fantasy', 'V.E. Schwab', 2, 'PUB08');
INSERT INTO Books VALUES ('9782000000009', 'Transcendent Kingdom', TO_DATE('01-09-2020', 'DD-MM-YYYY'), 'Literary', 'Yaa Gyasi', 2, 'PUB09');
INSERT INTO Books VALUES ('9782000000010', 'The House in the Cerulean Sea', TO_DATE('17-03-2020', 'DD-MM-YYYY'), 'Fantasy', 'TJ Klune', 4, 'PUB10');


INSERT INTO Books VALUES ('9783000000001', 'Dune', TO_DATE('01-08-1965', 'DD-MM-YYYY'), 'Science Fiction', 'Frank Herbert', 6, 'PUB01');
INSERT INTO Books VALUES ('9783000000002', 'The Hobbit', TO_DATE('21-09-1937', 'DD-MM-YYYY'), 'Fantasy', 'J.R.R. Tolkien', 8, 'PUB02');
INSERT INTO Books VALUES ('9783000000003', 'The Name of the Wind', TO_DATE('27-03-2007', 'DD-MM-YYYY'), 'Fantasy', 'Patrick Rothfuss', 4, 'PUB03');
INSERT INTO Books VALUES ('9783000000004', 'Neuromancer', TO_DATE('01-07-1984', 'DD-MM-YYYY'), 'Cyberpunk', 'William Gibson', 2, 'PUB04');
INSERT INTO Books VALUES ('9783000000005', 'The Left Hand of Darkness', TO_DATE('15-06-1969', 'DD-MM-YYYY'), 'Science Fiction', 'Ursula K. Le Guin', 2, 'PUB05');
INSERT INTO Books VALUES ('9783000000006', 'The Martian', TO_DATE('11-02-2014', 'DD-MM-YYYY'), 'Science Fiction', 'Andy Weir', 2, 'PUB06');
INSERT INTO Books VALUES ('9783000000007', 'American Gods', TO_DATE('19-06-2001', 'DD-MM-YYYY'), 'Fantasy', 'Neil Gaiman', 2, 'PUB07');
INSERT INTO Books VALUES ('9783000000008', 'The Three-Body Problem', TO_DATE('23-11-2008', 'DD-MM-YYYY'), 'Science Fiction', 'Liu Cixin', 2, 'PUB08');
INSERT INTO Books VALUES ('9783000000009', 'The Wheel of Time: The Eye of the World', TO_DATE('15-01-1990', 'DD-MM-YYYY'), 'Fantasy', 'Robert Jordan', 2, 'PUB09');
INSERT INTO Books VALUES ('9783000000010', 'Snow Crash', TO_DATE('02-06-1992', 'DD-MM-YYYY'), 'Cyberpunk', 'Neal Stephenson', 2, 'PUB10');


INSERT INTO Books VALUES ('9784000000001', 'Gone Girl', TO_DATE('24-06-2012', 'DD-MM-YYYY'), 'Thriller', 'Gillian Flynn', 6, 'PUB01');
INSERT INTO Books VALUES ('9784000000002', 'The Girl with the Dragon Tattoo', TO_DATE('01-08-2005', 'DD-MM-YYYY'), 'Mystery', 'Stieg Larsson', 6, 'PUB02');
INSERT INTO Books VALUES ('9784000000003', 'The Silent Patient', TO_DATE('05-02-2019', 'DD-MM-YYYY'), 'Psychological', 'Alex Michaelides', 2, 'PUB03');
INSERT INTO Books VALUES ('9784000000004', 'Sharp Objects', TO_DATE('26-09-2006', 'DD-MM-YYYY'), 'Thriller', 'Gillian Flynn', 2, 'PUB04');
INSERT INTO Books VALUES ('9784000000005', 'The Da Vinci Code', TO_DATE('18-03-2003', 'DD-MM-YYYY'), 'Mystery', 'Dan Brown', 4, 'PUB05');
INSERT INTO Books VALUES ('9784000000006', 'Big Little Lies', TO_DATE('30-07-2014', 'DD-MM-YYYY'), 'Thriller', 'Liane Moriarty', 2, 'PUB06');
INSERT INTO Books VALUES ('9784000000007', 'The Woman in the Window', TO_DATE('02-01-2018', 'DD-MM-YYYY'), 'Psychological', 'A.J. Finn', 2, 'PUB07');
INSERT INTO Books VALUES ('9784000000008', 'The Girl on the Train', TO_DATE('13-01-2015', 'DD-MM-YYYY'), 'Thriller', 'Paula Hawkins', 2, 'PUB08');
INSERT INTO Books VALUES ('9784000000009', 'In the Woods', TO_DATE('17-05-2007', 'DD-MM-YYYY'), 'Mystery', 'Tana French', 2, 'PUB09');
INSERT INTO Books VALUES ('9784000000010', 'The Couple Next Door', TO_DATE('23-08-2016', 'DD-MM-YYYY'), 'Thriller', 'Shari Lapena', 2, 'PUB10');

INSERT INTO Books VALUES ('9785000000001', 'The Notebook', TO_DATE('01-10-1996', 'DD-MM-YYYY'), 'Romance', 'Nicholas Sparks', 6, 'PUB01');
INSERT INTO Books VALUES ('9785000000002', 'Outlander', TO_DATE('01-06-1991', 'DD-MM-YYYY'), 'Historical', 'Diana Gabaldon', 4, 'PUB02');
INSERT INTO Books VALUES ('9785000000003', 'Me Before You', TO_DATE('05-01-2012', 'DD-MM-YYYY'), 'Romance', 'Jojo Moyes', 2, 'PUB03');
INSERT INTO Books VALUES ('9785000000004', 'Bridgerton: The Duke and I', TO_DATE('05-01-2000', 'DD-MM-YYYY'), 'Historical', 'Julia Quinn', 2, 'PUB04');
INSERT INTO Books VALUES ('9785000000005', 'The Hating Game', TO_DATE('09-08-2016', 'DD-MM-YYYY'), 'Romance', 'Sally Thorne', 2, 'PUB05');
INSERT INTO Books VALUES ('9785000000006', 'Red, White n Royal Blue', TO_DATE('14-05-2019', 'DD-MM-YYYY'), 'Romance', 'Casey McQuiston', 2, 'PUB06');
INSERT INTO Books VALUES ('9785000000007', 'The Kiss Quotient', TO_DATE('05-06-2018', 'DD-MM-YYYY'), 'Romance', 'Helen Hoang', 2, 'PUB07');
INSERT INTO Books VALUES ('9785000000008', 'Beach Read', TO_DATE('19-05-2020', 'DD-MM-YYYY'), 'Romance', 'Emily Henry', 2, 'PUB08');
INSERT INTO Books VALUES ('9785000000009', 'The Love Hypothesis', TO_DATE('14-09-2021', 'DD-MM-YYYY'), 'Romance', 'Ali Hazelwood', 2, 'PUB09');
INSERT INTO Books VALUES ('9785000000010', 'It Ends with Us', TO_DATE('02-08-2016', 'DD-MM-YYYY'), 'Romance', 'Colleen Hoover', 2, 'PUB10');


INSERT INTO Books VALUES ('9786000000001', 'The Hunger Games', TO_DATE('14-09-2008', 'DD-MM-YYYY'), 'Dystopian', 'Suzanne Collins', 8, 'PUB01');
INSERT INTO Books VALUES ('9786000000002', 'Harry Potter and the Sorcerer''s Stone', TO_DATE('26-06-1997', 'DD-MM-YYYY'), 'Fantasy', 'J.K. Rowling', 8, 'PUB02');
INSERT INTO Books VALUES ('9786000000003', 'The Fault in Our Stars', TO_DATE('10-01-2012', 'DD-MM-YYYY'), 'Romance', 'John Green', 4, 'PUB03');
INSERT INTO Books VALUES ('9786000000004', 'Twilight', TO_DATE('05-10-2005', 'DD-MM-YYYY'), 'Fantasy', 'Stephenie Meyer', 4, 'PUB04');
INSERT INTO Books VALUES ('9786000000005', 'The Book Thief', TO_DATE('14-03-2005', 'DD-MM-YYYY'), 'Historical', 'Markus Zusak', 4, 'PUB05');
INSERT INTO Books VALUES ('9786000000006', 'Divergent', TO_DATE('25-04-2011', 'DD-MM-YYYY'), 'Dystopian', 'Veronica Roth', 2, 'PUB06');
INSERT INTO Books VALUES ('9786000000007', 'Looking for Alaska', TO_DATE('03-03-2005', 'DD-MM-YYYY'), 'Coming-of-Age', 'John Green', 2, 'PUB07');
INSERT INTO Books VALUES ('9786000000008', 'The Perks of Being a Wallflower', TO_DATE('01-02-1999', 'DD-MM-YYYY'), 'Coming-of-Age', 'Stephen Chbosky', 2, 'PUB08');
INSERT INTO Books VALUES ('9786000000009', 'Eleanor n Park', TO_DATE('26-02-2013', 'DD-MM-YYYY'), 'Romance', 'Rainbow Rowell', 2, 'PUB09');
INSERT INTO Books VALUES ('9786000000010', 'Six of Crows', TO_DATE('29-09-2015', 'DD-MM-YYYY'), 'Fantasy', 'Leigh Bardugo', 2, 'PUB10');


INSERT INTO Books VALUES ('9787000000001', 'The Diary of a Young Girl', TO_DATE('25-06-1947', 'DD-MM-YYYY'), 'Memoir', 'Anne Frank', 4, 'PUB01');
INSERT INTO Books VALUES ('9787000000002', 'Steve Jobs', TO_DATE('24-10-2011', 'DD-MM-YYYY'), 'Biography', 'Walter Isaacson', 2, 'PUB02');
INSERT INTO Books VALUES ('9787000000003', 'I Know Why the Caged Bird Sings', TO_DATE('01-01-1969', 'DD-MM-YYYY'), 'Memoir', 'Maya Angelou', 2, 'PUB03');
INSERT INTO Books VALUES ('9787000000004', 'The Autobiography of Malcolm X', TO_DATE('29-10-1965', 'DD-MM-YYYY'), 'Autobiography', 'Malcolm X', 2, 'PUB04');
INSERT INTO Books VALUES ('9787000000005', 'Long Walk to Freedom', TO_DATE('01-01-1994', 'DD-MM-YYYY'), 'Autobiography', 'Nelson Mandela', 2, 'PUB05');
INSERT INTO Books VALUES ('9787000000006', 'Bossypants', TO_DATE('05-04-2011', 'DD-MM-YYYY'), 'Memoir', 'Tina Fey', 2, 'PUB06');
INSERT INTO Books VALUES ('9787000000007', 'Wild: From Lost to Found', TO_DATE('20-03-2012', 'DD-MM-YYYY'), 'Memoir', 'Cheryl Strayed', 2, 'PUB07');
INSERT INTO Books VALUES ('9787000000008', 'The Glass Castle', TO_DATE('09-03-2005', 'DD-MM-YYYY'), 'Memoir', 'Jeannette Walls', 2, 'PUB08');
INSERT INTO Books VALUES ('9787000000009', 'Just Kids', TO_DATE('19-01-2010', 'DD-MM-YYYY'), 'Memoir', 'Patti Smith', 2, 'PUB09');
INSERT INTO Books VALUES ('9787000000010', 'When Breath Becomes Air', TO_DATE('12-01-2016', 'DD-MM-YYYY'), 'Memoir', 'Paul Kalanithi', 2, 'PUB10');


INSERT INTO Books VALUES ('9788000000001', 'A Brief History of Time', TO_DATE('01-03-1988', 'DD-MM-YYYY'), 'Science', 'Stephen Hawking', 4, 'PUB01');
INSERT INTO Books VALUES ('9788000000002', 'The Selfish Gene', TO_DATE('01-01-1976', 'DD-MM-YYYY'), 'Science', 'Richard Dawkins', 2, 'PUB02');
INSERT INTO Books VALUES ('9788000000003', 'Cosmos', TO_DATE('01-01-1980', 'DD-MM-YYYY'), 'Science', 'Carl Sagan', 2, 'PUB03');
INSERT INTO Books VALUES ('9788000000004', 'The Emperor of All Maladies', TO_DATE('16-11-2010', 'DD-MM-YYYY'), 'Medical', 'Siddhartha Mukherjee', 2, 'PUB04');
INSERT INTO Books VALUES ('9788000000005', 'The Gene: An Intimate History', TO_DATE('17-05-2016', 'DD-MM-YYYY'), 'Science', 'Siddhartha Mukherjee', 2, 'PUB05');
INSERT INTO Books VALUES ('9788000000006', 'The Innovators', TO_DATE('07-10-2014', 'DD-MM-YYYY'), 'Technology', 'Walter Isaacson', 2, 'PUB06');
INSERT INTO Books VALUES ('9788000000007', 'The Sixth Extinction', TO_DATE('11-02-2014', 'DD-MM-YYYY'), 'Science', 'Elizabeth Kolbert', 2, 'PUB07');
INSERT INTO Books VALUES ('9788000000008', 'The Hidden Life of Trees', TO_DATE('13-09-2015', 'DD-MM-YYYY'), 'Nature', 'Peter Wohlleben', 2, 'PUB08');
INSERT INTO Books VALUES ('9788000000009', 'Astrophysics for People in a Hurry', TO_DATE('02-05-2017', 'DD-MM-YYYY'), 'Science', 'Neil deGrasse Tyson', 2, 'PUB09');
INSERT INTO Books VALUES ('9788000000010', 'The Order of Time', TO_DATE('15-05-2018', 'DD-MM-YYYY'), 'Science', 'Carlo Rovelli', 2, 'PUB10');

INSERT INTO BookCopys VALUES ('BC001', 'Intact', '9781234567890');
INSERT INTO BookCopys VALUES ('BC002', 'Damage', '9781234567890');
INSERT INTO BookCopys VALUES ('BC003', 'Intact', '9782345678901');
INSERT INTO BookCopys VALUES ('BC004', 'Intact', '9782345678901');
INSERT INTO BookCopys VALUES ('BC005', 'Intact', '9783456789012');
INSERT INTO BookCopys VALUES ('BC006', 'Damage', '9783456789012');
INSERT INTO BookCopys VALUES ('BC007', 'Intact', '9783456789012');
INSERT INTO BookCopys VALUES ('BC008', 'Intact', '9784567890123');
INSERT INTO BookCopys VALUES ('BC009', 'Intact', '9785678901234');
INSERT INTO BookCopys VALUES ('BC010', 'Intact', '9785678901234');
INSERT INTO BookCopys VALUES ('BC011', 'Intact', '9786789012345');
INSERT INTO BookCopys VALUES ('BC012', 'Intact', '9787890123456');
INSERT INTO BookCopys VALUES ('BC013', 'Damage', '9787890123456');
INSERT INTO BookCopys VALUES ('BC014', 'Intact', '9788901234567');
INSERT INTO BookCopys VALUES ('BC015', 'Intact', '9789012345678');
INSERT INTO BookCopys VALUES ('BC016', 'Intact', '9780123456789');
INSERT INTO BookCopys VALUES ('BC017', 'Intact', '9781122334455');
INSERT INTO BookCopys VALUES ('BC018', 'Intact', '9781122334455');
INSERT INTO BookCopys VALUES ('BC019', 'Damage', '9781122334455');
INSERT INTO BookCopys VALUES ('BC020', 'Intact', '9782233445566');
INSERT INTO BookCopys VALUES ('BC021', 'Intact', '9782233445566');
INSERT INTO BookCopys VALUES ('BC022', 'Intact', '9783344556677');
INSERT INTO BookCopys VALUES ('BC023', 'Intact', '9784455667788');
INSERT INTO BookCopys VALUES ('BC024', 'Intact', '9785566778899');
INSERT INTO BookCopys VALUES ('BC025', 'Intact', '9785566778899');
INSERT INTO BookCopys VALUES ('BC026', 'Intact', '9786677889900');
INSERT INTO BookCopys VALUES ('BC027', 'Intact', '9787788990011');
INSERT INTO BookCopys VALUES ('BC028', 'Damage', '9787788990011');
INSERT INTO BookCopys VALUES ('BC029', 'Intact', '9788899001122');
INSERT INTO BookCopys VALUES ('BC030', 'Intact', '9788899001122');
INSERT INTO BookCopys VALUES ('BC031', 'Intact', '9789900112233');
INSERT INTO BookCopys VALUES ('BC032', 'Intact', '9780011223344');
INSERT INTO BookCopys VALUES ('BC033', 'Intact', '9781000000001');
INSERT INTO BookCopys VALUES ('BC034', 'Intact', '9781000000001');
INSERT INTO BookCopys VALUES ('BC035', 'Intact', '9781000000001');
INSERT INTO BookCopys VALUES ('BC036', 'Intact', '9781000000002');
INSERT INTO BookCopys VALUES ('BC037', 'Intact', '9781000000002');
INSERT INTO BookCopys VALUES ('BC038', 'Damage', '9781000000003');
INSERT INTO BookCopys VALUES ('BC039', 'Intact', '9781000000003');
INSERT INTO BookCopys VALUES ('BC040', 'Intact', '9781000000004');
INSERT INTO BookCopys VALUES ('BC041', 'Intact', '9781000000005');
INSERT INTO BookCopys VALUES ('BC042', 'Intact', '9781000000006');
INSERT INTO BookCopys VALUES ('BC043', 'Intact', '9781000000006');
INSERT INTO BookCopys VALUES ('BC044', 'Intact', '9781000000007');
INSERT INTO BookCopys VALUES ('BC045', 'Intact', '9781000000008');
INSERT INTO BookCopys VALUES ('BC046', 'Intact', '9781000000009');
INSERT INTO BookCopys VALUES ('BC047', 'Intact', '9781000000010');
INSERT INTO BookCopys VALUES ('BC048', 'Intact', '9782000000001');
INSERT INTO BookCopys VALUES ('BC049', 'Intact', '9782000000001');
INSERT INTO BookCopys VALUES ('BC050', 'Damage', '9782000000002');
INSERT INTO BookCopys VALUES ('BC051', 'Intact', '9782000000002');
INSERT INTO BookCopys VALUES ('BC052', 'Intact', '9782000000003');
INSERT INTO BookCopys VALUES ('BC053', 'Intact', '9782000000004');
INSERT INTO BookCopys VALUES ('BC054', 'Intact', '9782000000005');
INSERT INTO BookCopys VALUES ('BC055', 'Intact', '9782000000006');
INSERT INTO BookCopys VALUES ('BC056', 'Intact', '9782000000007');
INSERT INTO BookCopys VALUES ('BC057', 'Intact', '9782000000008');
INSERT INTO BookCopys VALUES ('BC058', 'Intact', '9782000000009');
INSERT INTO BookCopys VALUES ('BC059', 'Intact', '9782000000010');
INSERT INTO BookCopys VALUES ('BC060', 'Intact', '9782000000010');
INSERT INTO BookCopys VALUES ('BC061', 'Intact', '9783000000001');
INSERT INTO BookCopys VALUES ('BC062', 'Intact', '9783000000001');
INSERT INTO BookCopys VALUES ('BC063', 'Intact', '9783000000002');
INSERT INTO BookCopys VALUES ('BC064', 'Intact', '9783000000002');
INSERT INTO BookCopys VALUES ('BC065', 'Intact', '9783000000002');
INSERT INTO BookCopys VALUES ('BC066', 'Damage', '9783000000003');
INSERT INTO BookCopys VALUES ('BC067', 'Intact', '9783000000003');
INSERT INTO BookCopys VALUES ('BC068', 'Intact', '9783000000004');
INSERT INTO BookCopys VALUES ('BC069', 'Intact', '9783000000005');
INSERT INTO BookCopys VALUES ('BC070', 'Intact', '9783000000006');
INSERT INTO BookCopys VALUES ('BC071', 'Intact', '9783000000007');
INSERT INTO BookCopys VALUES ('BC072', 'Intact', '9783000000008');
INSERT INTO BookCopys VALUES ('BC073', 'Intact', '9783000000009');
INSERT INTO BookCopys VALUES ('BC074', 'Intact', '9783000000010');
INSERT INTO BookCopys VALUES ('BC075', 'Intact', '9784000000001');
INSERT INTO BookCopys VALUES ('BC076', 'Intact', '9784000000001');
INSERT INTO BookCopys VALUES ('BC077', 'Intact', '9784000000002');
INSERT INTO BookCopys VALUES ('BC078', 'Intact', '9784000000002');
INSERT INTO BookCopys VALUES ('BC079', 'Intact', '9784000000003');
INSERT INTO BookCopys VALUES ('BC080', 'Intact', '9784000000004');
INSERT INTO BookCopys VALUES ('BC081', 'Damage', '9784000000005');
INSERT INTO BookCopys VALUES ('BC082', 'Intact', '9784000000005');
INSERT INTO BookCopys VALUES ('BC083', 'Intact', '9784000000006');
INSERT INTO BookCopys VALUES ('BC084', 'Intact', '9784000000007');
INSERT INTO BookCopys VALUES ('BC085', 'Intact', '9784000000008');
INSERT INTO BookCopys VALUES ('BC086', 'Intact', '9784000000009');
INSERT INTO BookCopys VALUES ('BC087', 'Intact', '9784000000010');
INSERT INTO BookCopys VALUES ('BC088', 'Intact', '9785000000001');
INSERT INTO BookCopys VALUES ('BC089', 'Intact', '9785000000001');
INSERT INTO BookCopys VALUES ('BC090', 'Intact', '9785000000002');
INSERT INTO BookCopys VALUES ('BC091', 'Intact', '9785000000003');
INSERT INTO BookCopys VALUES ('BC092', 'Intact', '9785000000004');
INSERT INTO BookCopys VALUES ('BC093', 'Intact', '9785000000005');
INSERT INTO BookCopys VALUES ('BC094', 'Intact', '9785000000006');
INSERT INTO BookCopys VALUES ('BC095', 'Intact', '9785000000007');
INSERT INTO BookCopys VALUES ('BC096', 'Intact', '9785000000008');
INSERT INTO BookCopys VALUES ('BC097', 'Intact', '9785000000009');
INSERT INTO BookCopys VALUES ('BC098', 'Intact', '9785000000010');
INSERT INTO BookCopys VALUES ('BC099', 'Intact', '9786000000001');
INSERT INTO BookCopys VALUES ('BC100', 'Intact', '9786000000001');
INSERT INTO BookCopys VALUES ('BC101', 'Intact', '9786000000001');
INSERT INTO BookCopys VALUES ('BC102', 'Intact', '9786000000002');
INSERT INTO BookCopys VALUES ('BC103', 'Intact', '9786000000002');
INSERT INTO BookCopys VALUES ('BC104', 'Intact', '9786000000002');
INSERT INTO BookCopys VALUES ('BC105', 'Intact', '9786000000003');
INSERT INTO BookCopys VALUES ('BC106', 'Intact', '9786000000003');
INSERT INTO BookCopys VALUES ('BC107', 'Intact', '9786000000004');
INSERT INTO BookCopys VALUES ('BC108', 'Intact', '9786000000004');
INSERT INTO BookCopys VALUES ('BC109', 'Intact', '9786000000005');
INSERT INTO BookCopys VALUES ('BC110', 'Intact', '9786000000005');
INSERT INTO BookCopys VALUES ('BC111', 'Intact', '9786000000006');
INSERT INTO BookCopys VALUES ('BC112', 'Intact', '9786000000007');
INSERT INTO BookCopys VALUES ('BC113', 'Intact', '9786000000008');
INSERT INTO BookCopys VALUES ('BC114', 'Intact', '9786000000009');
INSERT INTO BookCopys VALUES ('BC115', 'Intact', '9786000000010');
INSERT INTO BookCopys VALUES ('BC116', 'Intact', '9787000000001');
INSERT INTO BookCopys VALUES ('BC117', 'Intact', '9787000000001');
INSERT INTO BookCopys VALUES ('BC118', 'Intact', '9787000000002');
INSERT INTO BookCopys VALUES ('BC119', 'Intact', '9787000000003');
INSERT INTO BookCopys VALUES ('BC120', 'Intact', '9787000000004');
INSERT INTO BookCopys VALUES ('BC121', 'Intact', '9787000000005');
INSERT INTO BookCopys VALUES ('BC122', 'Intact', '9787000000006');
INSERT INTO BookCopys VALUES ('BC123', 'Intact', '9787000000007');
INSERT INTO BookCopys VALUES ('BC124', 'Intact', '9787000000008');
INSERT INTO BookCopys VALUES ('BC125', 'Intact', '9787000000009');
INSERT INTO BookCopys VALUES ('BC126', 'Intact', '9787000000010');
INSERT INTO BookCopys VALUES ('BC127', 'Intact', '9788000000001');
INSERT INTO BookCopys VALUES ('BC128', 'Intact', '9788000000001');
INSERT INTO BookCopys VALUES ('BC129', 'Intact', '9788000000002');
INSERT INTO BookCopys VALUES ('BC130', 'Intact', '9788000000003');
INSERT INTO BookCopys VALUES ('BC131', 'Intact', '9788000000004');
INSERT INTO BookCopys VALUES ('BC132', 'Intact', '9788000000005');
INSERT INTO BookCopys VALUES ('BC133', 'Intact', '9788000000006');
INSERT INTO BookCopys VALUES ('BC134', 'Intact', '9788000000007');
INSERT INTO BookCopys VALUES ('BC135', 'Intact', '9788000000008');
INSERT INTO BookCopys VALUES ('BC136', 'Intact', '9788000000009');
INSERT INTO BookCopys VALUES ('BC137', 'Intact', '9788000000010');
INSERT INTO BookCopys VALUES ('BC138', 'Intact', '9781000000001');
INSERT INTO BookCopys VALUES ('BC139', 'Intact', '9781000000002');
INSERT INTO BookCopys VALUES ('BC140', 'Intact', '9782000000001');
INSERT INTO BookCopys VALUES ('BC141', 'Intact', '9782000000002');
INSERT INTO BookCopys VALUES ('BC142', 'Intact', '9783000000001');
INSERT INTO BookCopys VALUES ('BC143', 'Intact', '9783000000002');
INSERT INTO BookCopys VALUES ('BC144', 'Intact', '9784000000001');
INSERT INTO BookCopys VALUES ('BC145', 'Intact', '9784000000002');
INSERT INTO BookCopys VALUES ('BC146', 'Intact', '9785000000001');
INSERT INTO BookCopys VALUES ('BC147', 'Intact', '9785000000002');
INSERT INTO BookCopys VALUES ('BC148', 'Intact', '9786000000001');
INSERT INTO BookCopys VALUES ('BC149', 'Intact', '9786000000002');
INSERT INTO BookCopys VALUES ('BC150', 'Intact', '9787000000001');



-- Borrow records 
INSERT INTO Borrows VALUES ('BR001', TO_DATE('05-01-2023', 'DD-MM-YYYY'), TO_DATE('19-01-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR002', TO_DATE('07-01-2023', 'DD-MM-YYYY'), TO_DATE('21-01-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR003', TO_DATE('10-01-2023', 'DD-MM-YYYY'), TO_DATE('24-01-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR004', TO_DATE('12-01-2023', 'DD-MM-YYYY'), TO_DATE('26-01-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR005', TO_DATE('15-01-2023', 'DD-MM-YYYY'), TO_DATE('29-01-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR006', TO_DATE('18-01-2023', 'DD-MM-YYYY'), TO_DATE('01-02-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR007', TO_DATE('20-01-2023', 'DD-MM-YYYY'), TO_DATE('03-02-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR008', TO_DATE('22-01-2023', 'DD-MM-YYYY'), TO_DATE('05-02-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR009', TO_DATE('25-01-2023', 'DD-MM-YYYY'), TO_DATE('08-02-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR010', TO_DATE('28-01-2023', 'DD-MM-YYYY'), TO_DATE('11-02-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');

INSERT INTO Borrows VALUES ('BR011', TO_DATE('01-02-2023', 'DD-MM-YYYY'), TO_DATE('15-02-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR012', TO_DATE('03-02-2023', 'DD-MM-YYYY'), TO_DATE('17-02-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR013', TO_DATE('05-02-2023', 'DD-MM-YYYY'), TO_DATE('19-02-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR014', TO_DATE('08-02-2023', 'DD-MM-YYYY'), TO_DATE('22-02-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR015', TO_DATE('10-02-2023', 'DD-MM-YYYY'), TO_DATE('24-02-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR016', TO_DATE('12-02-2023', 'DD-MM-YYYY'), TO_DATE('26-02-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR017', TO_DATE('15-02-2023', 'DD-MM-YYYY'), TO_DATE('01-03-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR018', TO_DATE('18-02-2023', 'DD-MM-YYYY'), TO_DATE('04-03-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR019', TO_DATE('20-02-2023', 'DD-MM-YYYY'), TO_DATE('06-03-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR020', TO_DATE('22-02-2023', 'DD-MM-YYYY'), TO_DATE('08-03-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');

INSERT INTO Borrows VALUES ('BR021', TO_DATE('25-02-2023', 'DD-MM-YYYY'), TO_DATE('11-03-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR022', TO_DATE('28-02-2023', 'DD-MM-YYYY'), TO_DATE('14-03-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR023', TO_DATE('02-03-2023', 'DD-MM-YYYY'), TO_DATE('16-03-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR024', TO_DATE('05-03-2023', 'DD-MM-YYYY'), TO_DATE('19-03-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR025', TO_DATE('08-03-2023', 'DD-MM-YYYY'), TO_DATE('22-03-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR026', TO_DATE('10-03-2023', 'DD-MM-YYYY'), TO_DATE('24-03-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR027', TO_DATE('12-03-2023', 'DD-MM-YYYY'), TO_DATE('26-03-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR028', TO_DATE('15-03-2023', 'DD-MM-YYYY'), TO_DATE('29-03-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR029', TO_DATE('18-03-2023', 'DD-MM-YYYY'), TO_DATE('01-04-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR030', TO_DATE('20-03-2023', 'DD-MM-YYYY'), TO_DATE('03-04-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');

INSERT INTO Borrows VALUES ('BR031', TO_DATE('22-03-2023', 'DD-MM-YYYY'), TO_DATE('05-04-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR032', TO_DATE('25-03-2023', 'DD-MM-YYYY'), TO_DATE('08-04-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR033', TO_DATE('28-03-2023', 'DD-MM-YYYY'), TO_DATE('11-04-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR034', TO_DATE('01-04-2023', 'DD-MM-YYYY'), TO_DATE('15-04-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR035', TO_DATE('03-04-2023', 'DD-MM-YYYY'), TO_DATE('17-04-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR036', TO_DATE('05-04-2023', 'DD-MM-YYYY'), TO_DATE('19-04-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR037', TO_DATE('08-04-2023', 'DD-MM-YYYY'), TO_DATE('22-04-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR038', TO_DATE('10-04-2023', 'DD-MM-YYYY'), TO_DATE('24-04-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR039', TO_DATE('12-04-2023', 'DD-MM-YYYY'), TO_DATE('26-04-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR040', TO_DATE('15-04-2023', 'DD-MM-YYYY'), TO_DATE('29-04-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');


INSERT INTO Borrows VALUES ('BR041', TO_DATE('18-04-2023', 'DD-MM-YYYY'), TO_DATE('02-05-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR042', TO_DATE('20-04-2023', 'DD-MM-YYYY'), TO_DATE('04-05-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR043', TO_DATE('22-04-2023', 'DD-MM-YYYY'), TO_DATE('06-05-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR044', TO_DATE('25-04-2023', 'DD-MM-YYYY'), TO_DATE('09-05-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR045', TO_DATE('28-04-2023', 'DD-MM-YYYY'), TO_DATE('12-05-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR046', TO_DATE('01-05-2023', 'DD-MM-YYYY'), TO_DATE('15-05-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR047', TO_DATE('03-05-2023', 'DD-MM-YYYY'), TO_DATE('17-05-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR048', TO_DATE('05-05-2023', 'DD-MM-YYYY'), TO_DATE('19-05-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR049', TO_DATE('08-05-2023', 'DD-MM-YYYY'), TO_DATE('22-05-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR050', TO_DATE('10-05-2023', 'DD-MM-YYYY'), TO_DATE('24-05-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');

-- Borrow records for next 50 (May-July 2023)
INSERT INTO Borrows VALUES ('BR051', TO_DATE('12-05-2023', 'DD-MM-YYYY'), TO_DATE('26-05-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR052', TO_DATE('15-05-2023', 'DD-MM-YYYY'), TO_DATE('29-05-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR053', TO_DATE('18-05-2023', 'DD-MM-YYYY'), TO_DATE('01-06-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR054', TO_DATE('20-05-2023', 'DD-MM-YYYY'), TO_DATE('03-06-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR055', TO_DATE('22-05-2023', 'DD-MM-YYYY'), TO_DATE('05-06-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR056', TO_DATE('25-05-2023', 'DD-MM-YYYY'), TO_DATE('08-06-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR057', TO_DATE('28-05-2023', 'DD-MM-YYYY'), TO_DATE('11-06-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR058', TO_DATE('30-05-2023', 'DD-MM-YYYY'), TO_DATE('13-06-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR059', TO_DATE('01-06-2023', 'DD-MM-YYYY'), TO_DATE('15-06-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR060', TO_DATE('03-06-2023', 'DD-MM-YYYY'), TO_DATE('17-06-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');

INSERT INTO Borrows VALUES ('BR061', TO_DATE('05-06-2023', 'DD-MM-YYYY'), TO_DATE('19-06-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR062', TO_DATE('08-06-2023', 'DD-MM-YYYY'), TO_DATE('22-06-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR063', TO_DATE('10-06-2023', 'DD-MM-YYYY'), TO_DATE('24-06-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR064', TO_DATE('12-06-2023', 'DD-MM-YYYY'), TO_DATE('26-06-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR065', TO_DATE('15-06-2023', 'DD-MM-YYYY'), TO_DATE('29-06-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR066', TO_DATE('18-06-2023', 'DD-MM-YYYY'), TO_DATE('02-07-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR067', TO_DATE('20-06-2023', 'DD-MM-YYYY'), TO_DATE('04-07-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR068', TO_DATE('22-06-2023', 'DD-MM-YYYY'), TO_DATE('06-07-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR069', TO_DATE('25-06-2023', 'DD-MM-YYYY'), TO_DATE('09-07-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR070', TO_DATE('28-06-2023', 'DD-MM-YYYY'), TO_DATE('12-07-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');

INSERT INTO Borrows VALUES ('BR071', TO_DATE('30-06-2023', 'DD-MM-YYYY'), TO_DATE('14-07-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR072', TO_DATE('02-07-2023', 'DD-MM-YYYY'), TO_DATE('16-07-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR073', TO_DATE('05-07-2023', 'DD-MM-YYYY'), TO_DATE('19-07-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR074', TO_DATE('08-07-2023', 'DD-MM-YYYY'), TO_DATE('22-07-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR075', TO_DATE('10-07-2023', 'DD-MM-YYYY'), TO_DATE('24-07-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR076', TO_DATE('12-07-2023', 'DD-MM-YYYY'), TO_DATE('26-07-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR077', TO_DATE('15-07-2023', 'DD-MM-YYYY'), TO_DATE('29-07-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR078', TO_DATE('18-07-2023', 'DD-MM-YYYY'), TO_DATE('01-08-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR079', TO_DATE('20-07-2023', 'DD-MM-YYYY'), TO_DATE('03-08-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR080', TO_DATE('22-07-2023', 'DD-MM-YYYY'), TO_DATE('05-08-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');


INSERT INTO Borrows VALUES ('BR081', TO_DATE('25-07-2023', 'DD-MM-YYYY'), TO_DATE('08-08-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR082', TO_DATE('28-07-2023', 'DD-MM-YYYY'), TO_DATE('11-08-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR083', TO_DATE('30-07-2023', 'DD-MM-YYYY'), TO_DATE('13-08-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR084', TO_DATE('01-08-2023', 'DD-MM-YYYY'), TO_DATE('15-08-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR085', TO_DATE('03-08-2023', 'DD-MM-YYYY'), TO_DATE('17-08-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR086', TO_DATE('05-08-2023', 'DD-MM-YYYY'), TO_DATE('19-08-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR087', TO_DATE('08-08-2023', 'DD-MM-YYYY'), TO_DATE('22-08-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR088', TO_DATE('10-08-2023', 'DD-MM-YYYY'), TO_DATE('24-08-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR089', TO_DATE('12-08-2023', 'DD-MM-YYYY'), TO_DATE('26-08-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR090', TO_DATE('15-08-2023', 'DD-MM-YYYY'), TO_DATE('29-08-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');

INSERT INTO Borrows VALUES ('BR091', TO_DATE('18-08-2023', 'DD-MM-YYYY'), TO_DATE('01-09-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR092', TO_DATE('20-08-2023', 'DD-MM-YYYY'), TO_DATE('03-09-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR093', TO_DATE('22-08-2023', 'DD-MM-YYYY'), TO_DATE('05-09-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR094', TO_DATE('25-08-2023', 'DD-MM-YYYY'), TO_DATE('08-09-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR095', TO_DATE('28-08-2023', 'DD-MM-YYYY'), TO_DATE('11-09-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR096', TO_DATE('30-08-2023', 'DD-MM-YYYY'), TO_DATE('13-09-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR097', TO_DATE('01-09-2023', 'DD-MM-YYYY'), TO_DATE('15-09-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR098', TO_DATE('03-09-2023', 'DD-MM-YYYY'), TO_DATE('17-09-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR099', TO_DATE('05-09-2023', 'DD-MM-YYYY'), TO_DATE('19-09-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR100', TO_DATE('08-09-2023', 'DD-MM-YYYY'), TO_DATE('22-09-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');


INSERT INTO Borrows VALUES ('BR101', TO_DATE('10-09-2023', 'DD-MM-YYYY'), TO_DATE('24-09-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR102', TO_DATE('12-09-2023', 'DD-MM-YYYY'), TO_DATE('26-09-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR103', TO_DATE('15-09-2023', 'DD-MM-YYYY'), TO_DATE('29-09-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR104', TO_DATE('18-09-2023', 'DD-MM-YYYY'), TO_DATE('02-10-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR105', TO_DATE('20-09-2023', 'DD-MM-YYYY'), TO_DATE('04-10-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR106', TO_DATE('22-09-2023', 'DD-MM-YYYY'), TO_DATE('06-10-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR107', TO_DATE('25-09-2023', 'DD-MM-YYYY'), TO_DATE('09-10-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR108', TO_DATE('28-09-2023', 'DD-MM-YYYY'), TO_DATE('12-10-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR109', TO_DATE('30-09-2023', 'DD-MM-YYYY'), TO_DATE('14-10-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR110', TO_DATE('02-10-2023', 'DD-MM-YYYY'), TO_DATE('16-10-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');

INSERT INTO Borrows VALUES ('BR111', TO_DATE('05-10-2023', 'DD-MM-YYYY'), TO_DATE('19-10-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR112', TO_DATE('08-10-2023', 'DD-MM-YYYY'), TO_DATE('22-10-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR113', TO_DATE('10-10-2023', 'DD-MM-YYYY'), TO_DATE('24-10-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR114', TO_DATE('12-10-2023', 'DD-MM-YYYY'), TO_DATE('26-10-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR115', TO_DATE('15-10-2023', 'DD-MM-YYYY'), TO_DATE('29-10-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR116', TO_DATE('18-10-2023', 'DD-MM-YYYY'), TO_DATE('01-11-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR117', TO_DATE('20-10-2023', 'DD-MM-YYYY'), TO_DATE('03-11-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR118', TO_DATE('22-10-2023', 'DD-MM-YYYY'), TO_DATE('05-11-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR119', TO_DATE('25-10-2023', 'DD-MM-YYYY'), TO_DATE('08-11-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR120', TO_DATE('28-10-2023', 'DD-MM-YYYY'), TO_DATE('11-11-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');


INSERT INTO Borrows VALUES ('BR121', TO_DATE('30-10-2023', 'DD-MM-YYYY'), TO_DATE('13-11-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR122', TO_DATE('01-11-2023', 'DD-MM-YYYY'), TO_DATE('15-11-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR123', TO_DATE('03-11-2023', 'DD-MM-YYYY'), TO_DATE('17-11-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR124', TO_DATE('05-11-2023', 'DD-MM-YYYY'), TO_DATE('19-11-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR125', TO_DATE('08-11-2023', 'DD-MM-YYYY'), TO_DATE('22-11-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR126', TO_DATE('10-11-2023', 'DD-MM-YYYY'), TO_DATE('24-11-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR127', TO_DATE('12-11-2023', 'DD-MM-YYYY'), TO_DATE('26-11-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR128', TO_DATE('15-11-2023', 'DD-MM-YYYY'), TO_DATE('29-11-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR129', TO_DATE('18-11-2023', 'DD-MM-YYYY'), TO_DATE('02-12-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR130', TO_DATE('20-11-2023', 'DD-MM-YYYY'), TO_DATE('04-12-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');

INSERT INTO Borrows VALUES ('BR131', TO_DATE('22-11-2023', 'DD-MM-YYYY'), TO_DATE('06-12-2023', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR132', TO_DATE('25-11-2023', 'DD-MM-YYYY'), TO_DATE('09-12-2023', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR133', TO_DATE('28-11-2023', 'DD-MM-YYYY'), TO_DATE('12-12-2023', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR134', TO_DATE('30-11-2023', 'DD-MM-YYYY'), TO_DATE('14-12-2023', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR135', TO_DATE('02-12-2023', 'DD-MM-YYYY'), TO_DATE('16-12-2023', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR136', TO_DATE('05-12-2023', 'DD-MM-YYYY'), TO_DATE('19-12-2023', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR137', TO_DATE('08-12-2023', 'DD-MM-YYYY'), TO_DATE('22-12-2023', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR138', TO_DATE('10-12-2023', 'DD-MM-YYYY'), TO_DATE('24-12-2023', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR139', TO_DATE('12-12-2023', 'DD-MM-YYYY'), TO_DATE('26-12-2023', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR140', TO_DATE('15-12-2023', 'DD-MM-YYYY'), TO_DATE('29-12-2023', 'DD-MM-YYYY'), 'MEM10', 'STF10');


INSERT INTO Borrows VALUES ('BR141', TO_DATE('18-12-2023', 'DD-MM-YYYY'), TO_DATE('01-01-2024', 'DD-MM-YYYY'), 'MEM01', 'STF01');
INSERT INTO Borrows VALUES ('BR142', TO_DATE('20-12-2023', 'DD-MM-YYYY'), TO_DATE('03-01-2024', 'DD-MM-YYYY'), 'MEM02', 'STF02');
INSERT INTO Borrows VALUES ('BR143', TO_DATE('22-12-2023', 'DD-MM-YYYY'), TO_DATE('05-01-2024', 'DD-MM-YYYY'), 'MEM03', 'STF03');
INSERT INTO Borrows VALUES ('BR144', TO_DATE('25-12-2023', 'DD-MM-YYYY'), TO_DATE('08-01-2024', 'DD-MM-YYYY'), 'MEM04', 'STF04');
INSERT INTO Borrows VALUES ('BR145', TO_DATE('28-12-2023', 'DD-MM-YYYY'), TO_DATE('11-01-2024', 'DD-MM-YYYY'), 'MEM05', 'STF05');
INSERT INTO Borrows VALUES ('BR146', TO_DATE('30-12-2023', 'DD-MM-YYYY'), TO_DATE('13-01-2024', 'DD-MM-YYYY'), 'MEM06', 'STF06');
INSERT INTO Borrows VALUES ('BR147', TO_DATE('02-01-2024', 'DD-MM-YYYY'), TO_DATE('16-01-2024', 'DD-MM-YYYY'), 'MEM07', 'STF07');
INSERT INTO Borrows VALUES ('BR148', TO_DATE('05-01-2024', 'DD-MM-YYYY'), TO_DATE('19-01-2024', 'DD-MM-YYYY'), 'MEM08', 'STF08');
INSERT INTO Borrows VALUES ('BR149', TO_DATE('08-01-2024', 'DD-MM-YYYY'), TO_DATE('22-01-2024', 'DD-MM-YYYY'), 'MEM09', 'STF09');
INSERT INTO Borrows VALUES ('BR150', TO_DATE('10-01-2024', 'DD-MM-YYYY'), TO_DATE('24-01-2024', 'DD-MM-YYYY'), 'MEM10', 'STF10');

INSERT INTO BorrowDetails VALUES ('BR001', 'BC001', 1, TO_DATE('18-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR001', 'BC003', 1, TO_DATE('30-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR001', 'BC005', 1, TO_DATE('23-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR002', 'BC002', 1, TO_DATE('20-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR002', 'BC004', 1, TO_DATE('03-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR002', 'BC006', 1, TO_DATE('25-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR003', 'BC007', 1, TO_DATE('23-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR003', 'BC008', 1, TO_DATE('05-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR003', 'BC009', 1, TO_DATE('28-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR004', 'BC010', 1, TO_DATE('25-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR004', 'BC011', 1, TO_DATE('08-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR004', 'BC012', 1, TO_DATE('30-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR005', 'BC013', 1, TO_DATE('28-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR005', 'BC014', 1, TO_DATE('10-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR005', 'BC015', 1, TO_DATE('02-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR006', 'BC016', 1, TO_DATE('31-01-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR006', 'BC017', 1, TO_DATE('16-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR006', 'BC018', 1, TO_DATE('05-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR007', 'BC019', 1, TO_DATE('02-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR007', 'BC020', 1, TO_DATE('02-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR007', 'BC021', 1, TO_DATE('07-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR008', 'BC022', 1, TO_DATE('04-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR008', 'BC023', 1, TO_DATE('24-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR008', 'BC024', 1, TO_DATE('09-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR009', 'BC025', 1, TO_DATE('07-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR009', 'BC026', 1, TO_DATE('17-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR009', 'BC027', 1, TO_DATE('12-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR010', 'BC028', 1, TO_DATE('10-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR010', 'BC029', 1, TO_DATE('10-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR010', 'BC030', 1, TO_DATE('15-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR011', 'BC031', 1, TO_DATE('13-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR011', 'BC032', 1, TO_DATE('28-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR011', 'BC033', 1, TO_DATE('21-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR012', 'BC034', 1, TO_DATE('15-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR012', 'BC035', 1, TO_DATE('28-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR012', 'BC036', 1, TO_DATE('23-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR013', 'BC037', 1, TO_DATE('18-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR013', 'BC038', 1, TO_DATE('01-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR013', 'BC039', 1, TO_DATE('25-02-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR014', 'BC040', 1, TO_DATE('20-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR014', 'BC041', 1, TO_DATE('20-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR014', 'BC042', 1, TO_DATE('25-02-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR015', 'BC043', 1, TO_DATE('23-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR015', 'BC044', 1, TO_DATE('23-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR015', 'BC045', 1, TO_DATE('27-02-2023', 'DD-MM-YYYY'));

-- Continuing this pattern for BR016-BR050
INSERT INTO BorrowDetails VALUES ('BR016', 'BC046', 1, TO_DATE('25-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR016', 'BC047', 1, TO_DATE('25-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR016', 'BC048', 1, TO_DATE('01-03-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR017', 'BC049', 1, TO_DATE('28-02-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR017', 'BC050', 1, TO_DATE('12-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR017', 'BC051', 1, TO_DATE('04-03-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR018', 'BC052', 1, TO_DATE('03-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR018', 'BC053', 1, TO_DATE('20-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR018', 'BC054', 1, TO_DATE('07-03-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR019', 'BC055', 1, TO_DATE('05-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR019', 'BC056', 1, TO_DATE('25-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR019', 'BC057', 1, TO_DATE('09-03-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR020', 'BC058', 1, TO_DATE('08-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR020', 'BC059', 1, TO_DATE('28-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR020', 'BC060', 1, TO_DATE('11-03-2023', 'DD-MM-YYYY'));

-- Continuing this pattern for BR021-BR050
INSERT INTO BorrowDetails VALUES ('BR021', 'BC061', 1, TO_DATE('10-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR021', 'BC062', 1, TO_DATE('31-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR021', 'BC063', 1, TO_DATE('19-03-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR022', 'BC064', 1, TO_DATE('13-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR022', 'BC065', 1, TO_DATE('25-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR022', 'BC066', 1, TO_DATE('21-03-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR023', 'BC067', 1, TO_DATE('15-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR023', 'BC068', 1, TO_DATE('27-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR023', 'BC069', 1, TO_DATE('23-03-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR024', 'BC070', 1, TO_DATE('18-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR024', 'BC071', 1, TO_DATE('31-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR024', 'BC072', 1, TO_DATE('26-03-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR025', 'BC073', 1, TO_DATE('20-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR025', 'BC074', 1, TO_DATE('01-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR025', 'BC075', 1, TO_DATE('29-03-2023', 'DD-MM-YYYY'));

-- Continuing this pattern for BR026-BR050
INSERT INTO BorrowDetails VALUES ('BR026', 'BC076', 1, TO_DATE('23-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR026', 'BC077', 1, TO_DATE('23-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR026', 'BC078', 1, TO_DATE('31-03-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR027', 'BC079', 1, TO_DATE('25-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR027', 'BC080', 1, TO_DATE('25-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR027', 'BC081', 1, TO_DATE('02-04-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR028', 'BC082', 1, TO_DATE('28-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR028', 'BC083', 1, TO_DATE('28-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR028', 'BC084', 1, TO_DATE('05-04-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR029', 'BC085', 1, TO_DATE('30-03-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR029', 'BC086', 1, TO_DATE('30-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR029', 'BC087', 1, TO_DATE('08-04-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR030', 'BC088', 1, TO_DATE('01-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR030', 'BC089', 1, TO_DATE('15-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR030', 'BC090', 1, TO_DATE('10-04-2023', 'DD-MM-YYYY'));

-- Continuing this pattern for BR031-BR050
INSERT INTO BorrowDetails VALUES ('BR031', 'BC091', 1, TO_DATE('04-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR031', 'BC092', 1, TO_DATE('24-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR031', 'BC093', 1, TO_DATE('12-04-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR032', 'BC094', 1, TO_DATE('06-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR032', 'BC095', 1, TO_DATE('26-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR032', 'BC096', 1, TO_DATE('15-04-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR033', 'BC097', 1, TO_DATE('09-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR033', 'BC098', 1, TO_DATE('09-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR033', 'BC099', 1, TO_DATE('18-04-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR034', 'BC100', 1, TO_DATE('11-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR034', 'BC101', 1, TO_DATE('11-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR034', 'BC102', 1, TO_DATE('22-04-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR035', 'BC103', 1, TO_DATE('14-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR035', 'BC104', 1, TO_DATE('14-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR035', 'BC105', 1, TO_DATE('24-04-2023', 'DD-MM-YYYY'));

-- Continuing this pattern for BR036-BR050
INSERT INTO BorrowDetails VALUES ('BR036', 'BC106', 1, TO_DATE('16-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR036', 'BC107', 1, TO_DATE('30-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR036', 'BC108', 1, TO_DATE('26-04-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR037', 'BC109', 1, TO_DATE('19-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR037', 'BC110', 1, TO_DATE('19-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR037', 'BC111', 1, TO_DATE('29-04-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR038', 'BC112', 1, TO_DATE('21-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR038', 'BC113', 1, TO_DATE('11-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR038', 'BC114', 1, TO_DATE('01-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR039', 'BC115', 1, TO_DATE('24-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR039', 'BC116', 1, TO_DATE('14-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR039', 'BC117', 1, TO_DATE('03-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR040', 'BC118', 1, TO_DATE('26-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR040', 'BC119', 1, TO_DATE('26-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR040', 'BC120', 1, TO_DATE('06-05-2023', 'DD-MM-YYYY'));

-- Continuing this pattern for BR041-BR050
INSERT INTO BorrowDetails VALUES ('BR041', 'BC121', 1, TO_DATE('29-04-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR041', 'BC122', 1, TO_DATE('15-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR041', 'BC123', 1, TO_DATE('09-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR042', 'BC124', 1, TO_DATE('01-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR042', 'BC125', 1, TO_DATE('19-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR042', 'BC126', 1, TO_DATE('11-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR043', 'BC127', 1, TO_DATE('04-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR043', 'BC128', 1, TO_DATE('24-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR043', 'BC129', 1, TO_DATE('13-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR044', 'BC130', 1, TO_DATE('06-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR044', 'BC131', 1, TO_DATE('19-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR044', 'BC132', 1, TO_DATE('16-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR045', 'BC133', 1, TO_DATE('09-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR045', 'BC134', 1, TO_DATE('27-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR045', 'BC135', 1, TO_DATE('19-05-2023', 'DD-MM-YYYY'));

-- Continuing this pattern for BR046-BR050
INSERT INTO BorrowDetails VALUES ('BR046', 'BC136', 1, TO_DATE('11-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR046', 'BC137', 1, TO_DATE('11-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR046', 'BC138', 1, TO_DATE('22-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR047', 'BC139', 1, TO_DATE('14-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR047', 'BC140', 1, TO_DATE('14-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR047', 'BC141', 1, TO_DATE('24-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR048', 'BC142', 1, TO_DATE('16-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR048', 'BC143', 1, TO_DATE('16-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR048', 'BC144', 1, TO_DATE('26-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR049', 'BC145', 1, TO_DATE('19-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR049', 'BC146', 1, TO_DATE('19-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR049', 'BC147', 1, TO_DATE('29-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR050', 'BC148', 1, TO_DATE('21-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR050', 'BC149', 1, TO_DATE('11-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR050', 'BC150', 1, TO_DATE('31-05-2023', 'DD-MM-YYYY'));

-- BorrowDetails for BR051-BR060 (May-June 2023) - 1-2 items per borrow
INSERT INTO BorrowDetails VALUES ('BR051', 'BC001', 1, TO_DATE('27-05-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR051', 'BC002', 1, TO_DATE('27-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR052', 'BC003', 1, TO_DATE('30-05-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR053', 'BC004', 1, TO_DATE('01-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR053', 'BC005', 1, TO_DATE('01-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR054', 'BC006', 1, TO_DATE('04-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR055', 'BC007', 1, TO_DATE('06-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR055', 'BC008', 1, TO_DATE('06-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR056', 'BC009', 1, TO_DATE('09-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR057', 'BC010', 1, TO_DATE('11-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR057', 'BC011', 1, TO_DATE('11-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR058', 'BC012', 1, TO_DATE('14-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR059', 'BC013', 1, TO_DATE('16-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR059', 'BC014', 1, TO_DATE('16-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR060', 'BC015', 1, TO_DATE('19-06-2023', 'DD-MM-YYYY'));

-- BorrowDetails for BR061-BR070 (Jun-Jul 2023)
INSERT INTO BorrowDetails VALUES ('BR061', 'BC016', 1, TO_DATE('21-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR061', 'BC017', 1, TO_DATE('21-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR062', 'BC018', 1, TO_DATE('24-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR063', 'BC019', 1, TO_DATE('26-06-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR063', 'BC020', 1, TO_DATE('26-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR064', 'BC021', 1, TO_DATE('29-06-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR065', 'BC022', 1, TO_DATE('01-07-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR065', 'BC023', 1, TO_DATE('01-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR066', 'BC024', 1, TO_DATE('04-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR067', 'BC025', 1, TO_DATE('06-07-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR067', 'BC026', 1, TO_DATE('06-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR068', 'BC027', 1, TO_DATE('09-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR069', 'BC028', 1, TO_DATE('11-07-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR069', 'BC029', 1, TO_DATE('11-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR070', 'BC030', 1, TO_DATE('14-07-2023', 'DD-MM-YYYY'));

-- BorrowDetails for BR071-BR080 (Jul-Aug 2023)
INSERT INTO BorrowDetails VALUES ('BR071', 'BC031', 1, TO_DATE('16-07-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR071', 'BC032', 1, TO_DATE('16-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR072', 'BC033', 1, TO_DATE('19-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR073', 'BC034', 1, TO_DATE('21-07-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR073', 'BC035', 1, TO_DATE('21-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR074', 'BC036', 1, TO_DATE('24-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR075', 'BC037', 1, TO_DATE('26-07-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR075', 'BC038', 1, TO_DATE('26-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR076', 'BC039', 1, TO_DATE('29-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR077', 'BC040', 1, TO_DATE('31-07-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR077', 'BC041', 1, TO_DATE('31-07-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR078', 'BC042', 1, TO_DATE('03-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR079', 'BC043', 1, TO_DATE('05-08-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR079', 'BC044', 1, TO_DATE('05-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR080', 'BC045', 1, TO_DATE('08-08-2023', 'DD-MM-YYYY'));

-- BorrowDetails for BR081-BR090 (Aug-Sep 2023)
INSERT INTO BorrowDetails VALUES ('BR081', 'BC046', 1, TO_DATE('10-08-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR081', 'BC047', 1, TO_DATE('10-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR082', 'BC048', 1, TO_DATE('13-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR083', 'BC049', 1, TO_DATE('15-08-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR083', 'BC050', 1, TO_DATE('15-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR084', 'BC051', 1, TO_DATE('18-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR085', 'BC052', 1, TO_DATE('20-08-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR085', 'BC053', 1, TO_DATE('20-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR086', 'BC054', 1, TO_DATE('23-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR087', 'BC055', 1, TO_DATE('25-08-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR087', 'BC056', 1, TO_DATE('25-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR088', 'BC057', 1, TO_DATE('28-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR089', 'BC058', 1, TO_DATE('30-08-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR089', 'BC059', 1, TO_DATE('30-08-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR090', 'BC060', 1, TO_DATE('02-09-2023', 'DD-MM-YYYY'));

-- BorrowDetails for BR091-BR100 (Sep-Oct 2023)
INSERT INTO BorrowDetails VALUES ('BR091', 'BC061', 1, TO_DATE('04-09-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR091', 'BC062', 1, TO_DATE('04-09-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR092', 'BC063', 1, TO_DATE('07-09-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR093', 'BC064', 1, TO_DATE('09-09-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR093', 'BC065', 1, TO_DATE('09-09-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR094', 'BC066', 1, TO_DATE('12-09-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR095', 'BC067', 1, TO_DATE('14-09-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR095', 'BC068', 1, TO_DATE('14-09-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR096', 'BC069', 1, TO_DATE('17-09-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR097', 'BC070', 1, TO_DATE('19-09-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR097', 'BC071', 1, TO_DATE('19-09-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR098', 'BC072', 1, TO_DATE('22-09-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR099', 'BC073', 1, TO_DATE('24-09-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR099', 'BC074', 1, TO_DATE('24-09-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR100', 'BC075', 1, TO_DATE('27-09-2023', 'DD-MM-YYYY'));

-- BorrowDetails for BR101-BR110 (Oct-Nov 2023)
INSERT INTO BorrowDetails VALUES ('BR101', 'BC076', 1, TO_DATE('29-09-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR101', 'BC077', 1, TO_DATE('29-09-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR102', 'BC078', 1, TO_DATE('02-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR103', 'BC079', 1, TO_DATE('04-10-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR103', 'BC080', 1, TO_DATE('04-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR104', 'BC081', 1, TO_DATE('07-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR105', 'BC082', 1, TO_DATE('09-10-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR105', 'BC083', 1, TO_DATE('09-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR106', 'BC084', 1, TO_DATE('12-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR107', 'BC085', 1, TO_DATE('14-10-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR107', 'BC086', 1, TO_DATE('14-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR108', 'BC087', 1, TO_DATE('17-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR109', 'BC088', 1, TO_DATE('19-10-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR109', 'BC089', 1, TO_DATE('19-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR110', 'BC090', 1, TO_DATE('22-10-2023', 'DD-MM-YYYY'));

-- BorrowDetails for BR111-BR120 (Nov-Dec 2023)
INSERT INTO BorrowDetails VALUES ('BR111', 'BC091', 1, TO_DATE('24-10-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR111', 'BC092', 1, TO_DATE('24-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR112', 'BC093', 1, TO_DATE('27-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR113', 'BC094', 1, TO_DATE('29-10-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR113', 'BC095', 1, TO_DATE('29-10-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR114', 'BC096', 1, TO_DATE('01-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR115', 'BC097', 1, TO_DATE('03-11-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR115', 'BC098', 1, TO_DATE('03-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR116', 'BC099', 1, TO_DATE('06-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR117', 'BC100', 1, TO_DATE('08-11-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR117', 'BC101', 1, TO_DATE('08-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR118', 'BC102', 1, TO_DATE('11-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR119', 'BC103', 1, TO_DATE('13-11-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR119', 'BC104', 1, TO_DATE('13-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR120', 'BC105', 1, TO_DATE('16-11-2023', 'DD-MM-YYYY'));

-- BorrowDetails for BR121-BR130 (Dec 2023)
INSERT INTO BorrowDetails VALUES ('BR121', 'BC106', 1, TO_DATE('18-11-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR121', 'BC107', 1, TO_DATE('18-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR122', 'BC108', 1, TO_DATE('21-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR123', 'BC109', 1, TO_DATE('23-11-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR123', 'BC110', 1, TO_DATE('23-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR124', 'BC111', 1, TO_DATE('26-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR125', 'BC112', 1, TO_DATE('28-11-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR125', 'BC113', 1, TO_DATE('28-11-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR126', 'BC114', 1, TO_DATE('01-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR127', 'BC115', 1, TO_DATE('03-12-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR127', 'BC116', 1, TO_DATE('03-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR128', 'BC117', 1, TO_DATE('06-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR129', 'BC118', 1, TO_DATE('08-12-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR129', 'BC119', 1, TO_DATE('08-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR130', 'BC120', 1, TO_DATE('11-12-2023', 'DD-MM-YYYY'));

-- BorrowDetails for BR131-BR140 (Dec 2023-Jan 2024)
INSERT INTO BorrowDetails VALUES ('BR131', 'BC121', 1, TO_DATE('13-12-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR131', 'BC122', 1, TO_DATE('13-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR132', 'BC123', 1, TO_DATE('16-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR133', 'BC124', 1, TO_DATE('18-12-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR133', 'BC125', 1, TO_DATE('18-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR134', 'BC126', 1, TO_DATE('21-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR135', 'BC127', 1, TO_DATE('23-12-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR135', 'BC128', 1, TO_DATE('23-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR136', 'BC129', 1, TO_DATE('26-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR137', 'BC130', 1, TO_DATE('28-12-2023', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR137', 'BC131', 1, TO_DATE('28-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR138', 'BC132', 1, TO_DATE('31-12-2023', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR139', 'BC133', 1, TO_DATE('02-01-2024', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR139', 'BC134', 1, TO_DATE('02-01-2024', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR140', 'BC135', 1, TO_DATE('05-01-2024', 'DD-MM-YYYY'));

-- BorrowDetails for BR141-BR150 (Jan 2024)
INSERT INTO BorrowDetails VALUES ('BR141', 'BC136', 1, TO_DATE('07-01-2024', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR141', 'BC137', 1, TO_DATE('07-01-2024', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR142', 'BC138', 1, TO_DATE('10-01-2024', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR143', 'BC139', 1, TO_DATE('12-01-2024', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR143', 'BC140', 1, TO_DATE('12-01-2024', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR144', 'BC141', 1, TO_DATE('15-01-2024', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR145', 'BC142', 1, TO_DATE('17-01-2024', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR145', 'BC143', 1, TO_DATE('17-01-2024', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR146', 'BC144', 1, TO_DATE('20-01-2024', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR147', 'BC145', 1, TO_DATE('22-01-2024', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR147', 'BC146', 1, TO_DATE('22-01-2024', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR148', 'BC147', 1, TO_DATE('25-01-2024', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR149', 'BC148', 1, TO_DATE('27-01-2024', 'DD-MM-YYYY'));
INSERT INTO BorrowDetails VALUES ('BR149', 'BC149', 1, TO_DATE('27-01-2024', 'DD-MM-YYYY'));

INSERT INTO BorrowDetails VALUES ('BR150', 'BC150', 1, TO_DATE('30-01-2024', 'DD-MM-YYYY'));


INSERT INTO Fines VALUES ('FN001', 10, 'Paid', TO_DATE('23-01-2023', 'DD-MM-YYYY'), 'PY001', 'BR001', 'BC005');
INSERT INTO Fines VALUES ('FN002', 10, 'Paid', TO_DATE('25-01-2023', 'DD-MM-YYYY'), 'PY002', 'BR002', 'BC006');
INSERT INTO Fines VALUES ('FN003', 10, 'Paid', TO_DATE('28-01-2023', 'DD-MM-YYYY'), 'PY003', 'BR003', 'BC009');
INSERT INTO Fines VALUES ('FN004', 10, 'Paid', TO_DATE('30-01-2023', 'DD-MM-YYYY'), 'PY004', 'BR004', 'BC012');
INSERT INTO Fines VALUES ('FN005', 50, 'Paid', TO_DATE('30-01-2023', 'DD-MM-YYYY'), 'PY005', 'BR001', 'BC003');
INSERT INTO Fines VALUES ('FN006', 10, 'Paid', TO_DATE('02-02-2023', 'DD-MM-YYYY'), 'PY006', 'BR005', 'BC015');
INSERT INTO Fines VALUES ('FN007', 50, 'Paid', TO_DATE('03-02-2023', 'DD-MM-YYYY'), 'PY007', 'BR002', 'BC004');
INSERT INTO Fines VALUES ('FN008', 10, 'Paid', TO_DATE('05-02-2023', 'DD-MM-YYYY'), 'PY008', 'BR006', 'BC018');
INSERT INTO Fines VALUES ('FN009', 50, 'Paid', TO_DATE('05-02-2023', 'DD-MM-YYYY'), 'PY009', 'BR003', 'BC008');
INSERT INTO Fines VALUES ('FN010', 10, 'Paid', TO_DATE('07-02-2023', 'DD-MM-YYYY'), 'PY010', 'BR007', 'BC021');
INSERT INTO Fines VALUES ('FN011', 50, 'Paid', TO_DATE('08-02-2023', 'DD-MM-YYYY'), 'PY001', 'BR004', 'BC011');
INSERT INTO Fines VALUES ('FN012', 10, 'Paid', TO_DATE('09-02-2023', 'DD-MM-YYYY'), 'PY002', 'BR008', 'BC024');
INSERT INTO Fines VALUES ('FN013', 50, 'Paid', TO_DATE('10-02-2023', 'DD-MM-YYYY'), 'PY003', 'BR005', 'BC014');
INSERT INTO Fines VALUES ('FN014', 10, 'Paid', TO_DATE('12-02-2023', 'DD-MM-YYYY'), 'PY004', 'BR009', 'BC027');
INSERT INTO Fines VALUES ('FN015', 10, 'Paid', TO_DATE('15-02-2023', 'DD-MM-YYYY'), 'PY005', 'BR010', 'BC030');
INSERT INTO Fines VALUES ('FN016', 50, 'Unpaid', NULL, NULL, 'BR006', 'BC017');
INSERT INTO Fines VALUES ('FN017', 30, 'Paid', TO_DATE('17-02-2023', 'DD-MM-YYYY'), 'PY007', 'BR009', 'BC026');
INSERT INTO Fines VALUES ('FN018', 10, 'Paid', TO_DATE('21-02-2023', 'DD-MM-YYYY'), 'PY008', 'BR011', 'BC033');
INSERT INTO Fines VALUES ('FN019', 10, 'Paid', TO_DATE('23-02-2023', 'DD-MM-YYYY'), 'PY009', 'BR012', 'BC036');
INSERT INTO Fines VALUES ('FN020', 50, 'Paid', TO_DATE('24-02-2023', 'DD-MM-YYYY'), 'PY010', 'BR008', 'BC023');
INSERT INTO Fines VALUES ('FN021', 10, 'Paid', TO_DATE('25-02-2023', 'DD-MM-YYYY'), 'PY001', 'BR013', 'BC039');
INSERT INTO Fines VALUES ('FN022', 10, 'Paid', TO_DATE('25-02-2023', 'DD-MM-YYYY'), 'PY002', 'BR014', 'BC042');
INSERT INTO Fines VALUES ('FN023', 10, 'Paid', TO_DATE('27-02-2023', 'DD-MM-YYYY'), 'PY003', 'BR015', 'BC045');
INSERT INTO Fines VALUES ('FN024', 50, 'Unpaid', NULL, NULL, 'BR011', 'BC032');
INSERT INTO Fines VALUES ('FN025', 50, 'Unpaid', NULL, NULL, 'BR012', 'BC035');
INSERT INTO Fines VALUES ('FN026', 50, 'Paid', TO_DATE('01-03-2023', 'DD-MM-YYYY'), 'PY006', 'BR013', 'BC038');
INSERT INTO Fines VALUES ('FN027', 10, 'Paid', TO_DATE('01-03-2023', 'DD-MM-YYYY'), 'PY007', 'BR016', 'BC048');
INSERT INTO Fines VALUES ('FN028', 50, 'Paid', TO_DATE('02-03-2023', 'DD-MM-YYYY'), 'PY008', 'BR007', 'BC020');
INSERT INTO Fines VALUES ('FN029', 10, 'Paid', TO_DATE('04-03-2023', 'DD-MM-YYYY'), 'PY009', 'BR017', 'BC051');
INSERT INTO Fines VALUES ('FN030', 10, 'Paid', TO_DATE('07-03-2023', 'DD-MM-YYYY'), 'PY010', 'BR018', 'BC054');
INSERT INTO Fines VALUES ('FN031', 10, 'Paid', TO_DATE('09-03-2023', 'DD-MM-YYYY'), 'PY001', 'BR019', 'BC057');
INSERT INTO Fines VALUES ('FN032', 50, 'Paid', TO_DATE('10-03-2023', 'DD-MM-YYYY'), 'PY002', 'BR010', 'BC029');
INSERT INTO Fines VALUES ('FN033', 10, 'Paid', TO_DATE('11-03-2023', 'DD-MM-YYYY'), 'PY003', 'BR020', 'BC060');
INSERT INTO Fines VALUES ('FN034', 50, 'Unpaid', NULL, NULL, 'BR017', 'BC050');
INSERT INTO Fines VALUES ('FN035', 30, 'Paid', TO_DATE('19-03-2023', 'DD-MM-YYYY'), 'PY005', 'BR021', 'BC063');
INSERT INTO Fines VALUES ('FN036', 50, 'Paid', TO_DATE('20-03-2023', 'DD-MM-YYYY'), 'PY006', 'BR014', 'BC041');
INSERT INTO Fines VALUES ('FN037', 50, 'Paid', TO_DATE('20-03-2023', 'DD-MM-YYYY'), 'PY007', 'BR018', 'BC053');
INSERT INTO Fines VALUES ('FN038', 30, 'Paid', TO_DATE('21-03-2023', 'DD-MM-YYYY'), 'PY008', 'BR022', 'BC066');
INSERT INTO Fines VALUES ('FN039', 50, 'Paid', TO_DATE('23-03-2023', 'DD-MM-YYYY'), 'PY009', 'BR015', 'BC044');
INSERT INTO Fines VALUES ('FN040', 30, 'Paid', TO_DATE('23-03-2023', 'DD-MM-YYYY'), 'PY010', 'BR023', 'BC069');
INSERT INTO Fines VALUES ('FN041', 50, 'Paid', TO_DATE('25-03-2023', 'DD-MM-YYYY'), 'PY001', 'BR016', 'BC047');
INSERT INTO Fines VALUES ('FN042', 50, 'Paid', TO_DATE('25-03-2023', 'DD-MM-YYYY'), 'PY002', 'BR019', 'BC056');
INSERT INTO Fines VALUES ('FN043', 50, 'Paid', TO_DATE('25-03-2023', 'DD-MM-YYYY'), 'PY003', 'BR022', 'BC065');
INSERT INTO Fines VALUES ('FN044', 30, 'Paid', TO_DATE('26-03-2023', 'DD-MM-YYYY'), 'PY004', 'BR024', 'BC072');
INSERT INTO Fines VALUES ('FN045', 50, 'Paid', TO_DATE('27-03-2023', 'DD-MM-YYYY'), 'PY005', 'BR023', 'BC068');
INSERT INTO Fines VALUES ('FN046', 50, 'Paid', TO_DATE('28-03-2023', 'DD-MM-YYYY'), 'PY006', 'BR020', 'BC059');
INSERT INTO Fines VALUES ('FN047', 30, 'Paid', TO_DATE('29-03-2023', 'DD-MM-YYYY'), 'PY007', 'BR025', 'BC075');
INSERT INTO Fines VALUES ('FN048', 50, 'Paid', TO_DATE('31-03-2023', 'DD-MM-YYYY'), 'PY008', 'BR021', 'BC062');
INSERT INTO Fines VALUES ('FN049', 50, 'Paid', TO_DATE('31-03-2023', 'DD-MM-YYYY'), 'PY009', 'BR024', 'BC071');
INSERT INTO Fines VALUES ('FN050', 30, 'Paid', TO_DATE('31-03-2023', 'DD-MM-YYYY'), 'PY010', 'BR026', 'BC078');
INSERT INTO Fines VALUES ('FN051', 50, 'Unpaid', NULL, NULL, 'BR025', 'BC074');
INSERT INTO Fines VALUES ('FN052', 30, 'Paid', TO_DATE('02-04-2023', 'DD-MM-YYYY'), 'PY002', 'BR027', 'BC081');
INSERT INTO Fines VALUES ('FN053', 30, 'Paid', TO_DATE('05-04-2023', 'DD-MM-YYYY'), 'PY003', 'BR028', 'BC084');
INSERT INTO Fines VALUES ('FN054', 30, 'Paid', TO_DATE('08-04-2023', 'DD-MM-YYYY'), 'PY004', 'BR029', 'BC087');
INSERT INTO Fines VALUES ('FN055', 30, 'Paid', TO_DATE('10-04-2023', 'DD-MM-YYYY'), 'PY005', 'BR030', 'BC090');
INSERT INTO Fines VALUES ('FN056', 30, 'Paid', TO_DATE('12-04-2023', 'DD-MM-YYYY'), 'PY006', 'BR031', 'BC093');
INSERT INTO Fines VALUES ('FN057', 30, 'Paid', TO_DATE('15-04-2023', 'DD-MM-YYYY'), 'PY007', 'BR032', 'BC096');
INSERT INTO Fines VALUES ('FN058', 50, 'Paid', TO_DATE('15-04-2023', 'DD-MM-YYYY'), 'PY008', 'BR030', 'BC089');
INSERT INTO Fines VALUES ('FN059', 30, 'Paid', TO_DATE('18-04-2023', 'DD-MM-YYYY'), 'PY009', 'BR033', 'BC099');
INSERT INTO Fines VALUES ('FN060', 30, 'Paid', TO_DATE('22-04-2023', 'DD-MM-YYYY'), 'PY010', 'BR034', 'BC102');
INSERT INTO Fines VALUES ('FN061', 50, 'Paid', TO_DATE('23-04-2023', 'DD-MM-YYYY'), 'PY001', 'BR026', 'BC077');
INSERT INTO Fines VALUES ('FN062', 50, 'Paid', TO_DATE('24-04-2023', 'DD-MM-YYYY'), 'PY002', 'BR031', 'BC092');
INSERT INTO Fines VALUES ('FN063', 30, 'Paid', TO_DATE('24-04-2023', 'DD-MM-YYYY'), 'PY003', 'BR035', 'BC105');
INSERT INTO Fines VALUES ('FN064', 50, 'Unpaid', NULL, NULL, 'BR027', 'BC080');
INSERT INTO Fines VALUES ('FN065', 50, 'Unpaid', NULL, NULL, 'BR032', 'BC095');
INSERT INTO Fines VALUES ('FN066', 30, 'Paid', TO_DATE('26-04-2023', 'DD-MM-YYYY'), 'PY006', 'BR036', 'BC108');
INSERT INTO Fines VALUES ('FN067', 50, 'Paid', TO_DATE('28-04-2023', 'DD-MM-YYYY'), 'PY007', 'BR028', 'BC083');
INSERT INTO Fines VALUES ('FN068', 30, 'Paid', TO_DATE('29-04-2023', 'DD-MM-YYYY'), 'PY008', 'BR037', 'BC111');
INSERT INTO Fines VALUES ('FN069', 50, 'Paid', TO_DATE('30-04-2023', 'DD-MM-YYYY'), 'PY009', 'BR029', 'BC086');
INSERT INTO Fines VALUES ('FN070', 50, 'Paid', TO_DATE('30-04-2023', 'DD-MM-YYYY'), 'PY010', 'BR036', 'BC107');
INSERT INTO Fines VALUES ('FN071', 30, 'Paid', TO_DATE('01-05-2023', 'DD-MM-YYYY'), 'PY001', 'BR038', 'BC114');
INSERT INTO Fines VALUES ('FN072', 30, 'Paid', TO_DATE('03-05-2023', 'DD-MM-YYYY'), 'PY002', 'BR039', 'BC117');
INSERT INTO Fines VALUES ('FN073', 30, 'Paid', TO_DATE('06-05-2023', 'DD-MM-YYYY'), 'PY003', 'BR040', 'BC120');
INSERT INTO Fines VALUES ('FN074', 50, 'Paid', TO_DATE('09-05-2023', 'DD-MM-YYYY'), 'PY004', 'BR033', 'BC098');
INSERT INTO Fines VALUES ('FN075', 30, 'Paid', TO_DATE('09-05-2023', 'DD-MM-YYYY'), 'PY005', 'BR041', 'BC123');
INSERT INTO Fines VALUES ('FN076', 50, 'Paid', TO_DATE('11-05-2023', 'DD-MM-YYYY'), 'PY006', 'BR034', 'BC101');
INSERT INTO Fines VALUES ('FN077', 50, 'Paid', TO_DATE('11-05-2023', 'DD-MM-YYYY'), 'PY007', 'BR038', 'BC113');
INSERT INTO Fines VALUES ('FN078', 30, 'Paid', TO_DATE('11-05-2023', 'DD-MM-YYYY'), 'PY008', 'BR042', 'BC126');
INSERT INTO Fines VALUES ('FN079', 30, 'Paid', TO_DATE('13-05-2023', 'DD-MM-YYYY'), 'PY009', 'BR043', 'BC129');
INSERT INTO Fines VALUES ('FN080', 30, 'Paid', TO_DATE('14-05-2023', 'DD-MM-YYYY'), 'PY010', 'BR035', 'BC104');
INSERT INTO Fines VALUES ('FN081', 50, 'Unpaid', NULL, NULL, 'BR039', 'BC116');
INSERT INTO Fines VALUES ('FN082', 50, 'Paid', TO_DATE('15-05-2023', 'DD-MM-YYYY'), 'PY002', 'BR041', 'BC122');
INSERT INTO Fines VALUES ('FN083', 30, 'Paid', TO_DATE('16-05-2023', 'DD-MM-YYYY'), 'PY003', 'BR044', 'BC132');
INSERT INTO Fines VALUES ('FN084', 50, 'Paid', TO_DATE('19-05-2023', 'DD-MM-YYYY'), 'PY004', 'BR037', 'BC110');
INSERT INTO Fines VALUES ('FN085', 50, 'Paid', TO_DATE('19-05-2023', 'DD-MM-YYYY'), 'PY005', 'BR042', 'BC125');
INSERT INTO Fines VALUES ('FN086', 50, 'Paid', TO_DATE('19-05-2023', 'DD-MM-YYYY'), 'PY006', 'BR044', 'BC131');
INSERT INTO Fines VALUES ('FN087', 30, 'Paid', TO_DATE('19-05-2023', 'DD-MM-YYYY'), 'PY007', 'BR045', 'BC135');
INSERT INTO Fines VALUES ('FN088', 30, 'Paid', TO_DATE('22-05-2023', 'DD-MM-YYYY'), 'PY008', 'BR046', 'BC138');
INSERT INTO Fines VALUES ('FN089', 50, 'Paid', TO_DATE('24-05-2023', 'DD-MM-YYYY'), 'PY009', 'BR043', 'BC128');
INSERT INTO Fines VALUES ('FN090', 30, 'Paid', TO_DATE('24-05-2023', 'DD-MM-YYYY'), 'PY010', 'BR047', 'BC141');
INSERT INTO Fines VALUES ('FN091', 50, 'Unpaid', NULL, NULL, 'BR040', 'BC119');
INSERT INTO Fines VALUES ('FN092', 30, 'Paid', TO_DATE('26-05-2023', 'DD-MM-YYYY'), 'PY002', 'BR048', 'BC144');
INSERT INTO Fines VALUES ('FN093', 50, 'Paid', TO_DATE('27-05-2023', 'DD-MM-YYYY'), 'PY003', 'BR045', 'BC134');
INSERT INTO Fines VALUES ('FN094', 30, 'Paid', TO_DATE('29-05-2023', 'DD-MM-YYYY'), 'PY004', 'BR049', 'BC147');
INSERT INTO Fines VALUES ('FN095', 30, 'Paid', TO_DATE('31-05-2023', 'DD-MM-YYYY'), 'PY005', 'BR050', 'BC150');
INSERT INTO Fines VALUES ('FN096', 50, 'Unpaid', NULL, NULL, 'BR046', 'BC137');
INSERT INTO Fines VALUES ('FN097', 50, 'Paid', TO_DATE('11-06-2023', 'DD-MM-YYYY'), 'PY007', 'BR050', 'BC149');
INSERT INTO Fines VALUES ('FN098', 50, 'Paid', TO_DATE('14-06-2023', 'DD-MM-YYYY'), 'PY008', 'BR047', 'BC140');
INSERT INTO Fines VALUES ('FN099', 50, 'Paid', TO_DATE('16-06-2023', 'DD-MM-YYYY'), 'PY009', 'BR048', 'BC143');
INSERT INTO Fines VALUES ('FN100', 50, 'Paid', TO_DATE('19-06-2023', 'DD-MM-YYYY'), 'PY010', 'BR049', 'BC146');



INSERT INTO Reservations VALUES ('RS001', TO_DATE('06-01-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS002', TO_DATE('08-01-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS003', TO_DATE('11-01-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS004', TO_DATE('13-01-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS005', TO_DATE('16-01-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS006', TO_DATE('19-01-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS007', TO_DATE('21-01-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS008', TO_DATE('23-01-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS009', TO_DATE('26-01-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS010', TO_DATE('29-01-2023', 'DD-MM-YYYY'), 'MEM10');

INSERT INTO Reservations VALUES ('RS011', TO_DATE('02-02-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS012', TO_DATE('04-02-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS013', TO_DATE('06-02-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS014', TO_DATE('09-02-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS015', TO_DATE('11-02-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS016', TO_DATE('13-02-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS017', TO_DATE('16-02-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS018', TO_DATE('19-02-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS019', TO_DATE('21-02-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS020', TO_DATE('23-02-2023', 'DD-MM-YYYY'), 'MEM10');

INSERT INTO Reservations VALUES ('RS021', TO_DATE('26-02-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS022', TO_DATE('01-03-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS023', TO_DATE('03-03-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS024', TO_DATE('06-03-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS025', TO_DATE('09-03-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS026', TO_DATE('11-03-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS027', TO_DATE('13-03-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS028', TO_DATE('16-03-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS029', TO_DATE('19-03-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS030', TO_DATE('21-03-2023', 'DD-MM-YYYY'), 'MEM10');

INSERT INTO Reservations VALUES ('RS031', TO_DATE('23-03-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS032', TO_DATE('26-03-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS033', TO_DATE('29-03-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS034', TO_DATE('02-04-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS035', TO_DATE('04-04-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS036', TO_DATE('06-04-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS037', TO_DATE('09-04-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS038', TO_DATE('11-04-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS039', TO_DATE('13-04-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS040', TO_DATE('16-04-2023', 'DD-MM-YYYY'), 'MEM10');

INSERT INTO Reservations VALUES ('RS041', TO_DATE('19-04-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS042', TO_DATE('21-04-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS043', TO_DATE('23-04-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS044', TO_DATE('26-04-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS045', TO_DATE('29-04-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS046', TO_DATE('02-05-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS047', TO_DATE('04-05-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS048', TO_DATE('06-05-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS049', TO_DATE('09-05-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS050', TO_DATE('11-05-2023', 'DD-MM-YYYY'), 'MEM10');

INSERT INTO Reservations VALUES ('RS051', TO_DATE('13-05-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS052', TO_DATE('16-05-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS053', TO_DATE('19-05-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS054', TO_DATE('21-05-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS055', TO_DATE('23-05-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS056', TO_DATE('26-05-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS057', TO_DATE('29-05-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS058', TO_DATE('31-05-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS059', TO_DATE('02-06-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS060', TO_DATE('04-06-2023', 'DD-MM-YYYY'), 'MEM10');

INSERT INTO Reservations VALUES ('RS061', TO_DATE('06-06-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS062', TO_DATE('09-06-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS063', TO_DATE('11-06-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS064', TO_DATE('13-06-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS065', TO_DATE('16-06-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS066', TO_DATE('19-06-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS067', TO_DATE('21-06-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS068', TO_DATE('23-06-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS069', TO_DATE('26-06-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS070', TO_DATE('29-06-2023', 'DD-MM-YYYY'), 'MEM10');

INSERT INTO Reservations VALUES ('RS071', TO_DATE('01-07-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS072', TO_DATE('03-07-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS073', TO_DATE('06-07-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS074', TO_DATE('09-07-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS075', TO_DATE('11-07-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS076', TO_DATE('13-07-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS077', TO_DATE('16-07-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS078', TO_DATE('19-07-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS079', TO_DATE('21-07-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS080', TO_DATE('23-07-2023', 'DD-MM-YYYY'), 'MEM10');

INSERT INTO Reservations VALUES ('RS081', TO_DATE('26-07-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS082', TO_DATE('29-07-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS083', TO_DATE('31-07-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS084', TO_DATE('02-08-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS085', TO_DATE('04-08-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS086', TO_DATE('06-08-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS087', TO_DATE('09-08-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS088', TO_DATE('11-08-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS089', TO_DATE('13-08-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS090', TO_DATE('16-08-2023', 'DD-MM-YYYY'), 'MEM10');

INSERT INTO Reservations VALUES ('RS091', TO_DATE('19-08-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS092', TO_DATE('21-08-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS093', TO_DATE('23-08-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS094', TO_DATE('26-08-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS095', TO_DATE('29-08-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS096', TO_DATE('31-08-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS097', TO_DATE('02-09-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS098', TO_DATE('04-09-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS099', TO_DATE('06-09-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS100', TO_DATE('09-09-2023', 'DD-MM-YYYY'), 'MEM10');
INSERT INTO Reservations VALUES ('RS101', TO_DATE('11-09-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS102', TO_DATE('13-09-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS103', TO_DATE('16-09-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS104', TO_DATE('19-09-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS105', TO_DATE('21-09-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS106', TO_DATE('23-09-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS107', TO_DATE('26-09-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS108', TO_DATE('29-09-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS109', TO_DATE('01-10-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS110', TO_DATE('03-10-2023', 'DD-MM-YYYY'), 'MEM10');
INSERT INTO Reservations VALUES ('RS111', TO_DATE('06-10-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS112', TO_DATE('09-10-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS113', TO_DATE('11-10-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS114', TO_DATE('13-10-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS115', TO_DATE('16-10-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS116', TO_DATE('19-10-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS117', TO_DATE('21-10-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS118', TO_DATE('23-10-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS119', TO_DATE('26-10-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS120', TO_DATE('29-10-2023', 'DD-MM-YYYY'), 'MEM10');
INSERT INTO Reservations VALUES ('RS121', TO_DATE('31-10-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS122', TO_DATE('02-11-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS123', TO_DATE('04-11-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS124', TO_DATE('06-11-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS125', TO_DATE('09-11-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS126', TO_DATE('11-11-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS127', TO_DATE('13-11-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS128', TO_DATE('16-11-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS129', TO_DATE('19-11-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS130', TO_DATE('21-11-2023', 'DD-MM-YYYY'), 'MEM10');
INSERT INTO Reservations VALUES ('RS131', TO_DATE('23-11-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS132', TO_DATE('26-11-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS133', TO_DATE('29-11-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS134', TO_DATE('01-12-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS135', TO_DATE('03-12-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS136', TO_DATE('06-12-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS137', TO_DATE('09-12-2023', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS138', TO_DATE('11-12-2023', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS139', TO_DATE('13-12-2023', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS140', TO_DATE('16-12-2023', 'DD-MM-YYYY'), 'MEM10');
INSERT INTO Reservations VALUES ('RS141', TO_DATE('19-12-2023', 'DD-MM-YYYY'), 'MEM01');
INSERT INTO Reservations VALUES ('RS142', TO_DATE('21-12-2023', 'DD-MM-YYYY'), 'MEM02');
INSERT INTO Reservations VALUES ('RS143', TO_DATE('23-12-2023', 'DD-MM-YYYY'), 'MEM03');
INSERT INTO Reservations VALUES ('RS144', TO_DATE('26-12-2023', 'DD-MM-YYYY'), 'MEM04');
INSERT INTO Reservations VALUES ('RS145', TO_DATE('29-12-2023', 'DD-MM-YYYY'), 'MEM05');
INSERT INTO Reservations VALUES ('RS146', TO_DATE('31-12-2023', 'DD-MM-YYYY'), 'MEM06');
INSERT INTO Reservations VALUES ('RS147', TO_DATE('03-01-2024', 'DD-MM-YYYY'), 'MEM07');
INSERT INTO Reservations VALUES ('RS148', TO_DATE('06-01-2024', 'DD-MM-YYYY'), 'MEM08');
INSERT INTO Reservations VALUES ('RS149', TO_DATE('09-01-2024', 'DD-MM-YYYY'), 'MEM09');
INSERT INTO Reservations VALUES ('RS150', TO_DATE('11-01-2024', 'DD-MM-YYYY'), 'MEM10');

INSERT INTO ReservationDetails VALUES ('RS001', 'BC001', 1);
INSERT INTO ReservationDetails VALUES ('RS001', 'BC003', 1);
INSERT INTO ReservationDetails VALUES ('RS002', 'BC002', 1);
INSERT INTO ReservationDetails VALUES ('RS002', 'BC004', 1);
INSERT INTO ReservationDetails VALUES ('RS003', 'BC005', 1);
INSERT INTO ReservationDetails VALUES ('RS003', 'BC007', 1);
INSERT INTO ReservationDetails VALUES ('RS004', 'BC006', 1);
INSERT INTO ReservationDetails VALUES ('RS004', 'BC008', 1);
INSERT INTO ReservationDetails VALUES ('RS005', 'BC009', 1);
INSERT INTO ReservationDetails VALUES ('RS005', 'BC011', 1);
INSERT INTO ReservationDetails VALUES ('RS006', 'BC010', 1);
INSERT INTO ReservationDetails VALUES ('RS006', 'BC012', 1);
INSERT INTO ReservationDetails VALUES ('RS007', 'BC013', 1);
INSERT INTO ReservationDetails VALUES ('RS007', 'BC015', 1);
INSERT INTO ReservationDetails VALUES ('RS008', 'BC014', 1);
INSERT INTO ReservationDetails VALUES ('RS008', 'BC016', 1);
INSERT INTO ReservationDetails VALUES ('RS009', 'BC017', 1);
INSERT INTO ReservationDetails VALUES ('RS009', 'BC019', 1);
INSERT INTO ReservationDetails VALUES ('RS010', 'BC018', 1);
INSERT INTO ReservationDetails VALUES ('RS010', 'BC020', 1);
INSERT INTO ReservationDetails VALUES ('RS011', 'BC021', 1);
INSERT INTO ReservationDetails VALUES ('RS011', 'BC023', 1);
INSERT INTO ReservationDetails VALUES ('RS012', 'BC022', 1);
INSERT INTO ReservationDetails VALUES ('RS012', 'BC024', 1);
INSERT INTO ReservationDetails VALUES ('RS013', 'BC025', 1);
INSERT INTO ReservationDetails VALUES ('RS013', 'BC027', 1);
INSERT INTO ReservationDetails VALUES ('RS014', 'BC026', 1);
INSERT INTO ReservationDetails VALUES ('RS014', 'BC028', 1);
INSERT INTO ReservationDetails VALUES ('RS015', 'BC029', 1);
INSERT INTO ReservationDetails VALUES ('RS015', 'BC031', 1);
INSERT INTO ReservationDetails VALUES ('RS016', 'BC030', 1);
INSERT INTO ReservationDetails VALUES ('RS016', 'BC032', 1);
INSERT INTO ReservationDetails VALUES ('RS017', 'BC033', 1);
INSERT INTO ReservationDetails VALUES ('RS017', 'BC035', 1);
INSERT INTO ReservationDetails VALUES ('RS018', 'BC034', 1);
INSERT INTO ReservationDetails VALUES ('RS018', 'BC036', 1);
INSERT INTO ReservationDetails VALUES ('RS019', 'BC037', 1);
INSERT INTO ReservationDetails VALUES ('RS019', 'BC039', 1);
INSERT INTO ReservationDetails VALUES ('RS020', 'BC038', 1);
INSERT INTO ReservationDetails VALUES ('RS020', 'BC040', 1);
INSERT INTO ReservationDetails VALUES ('RS021', 'BC041', 1);
INSERT INTO ReservationDetails VALUES ('RS021', 'BC043', 1);
INSERT INTO ReservationDetails VALUES ('RS022', 'BC042', 1);
INSERT INTO ReservationDetails VALUES ('RS022', 'BC044', 1);
INSERT INTO ReservationDetails VALUES ('RS023', 'BC045', 1);
INSERT INTO ReservationDetails VALUES ('RS023', 'BC047', 1);
INSERT INTO ReservationDetails VALUES ('RS024', 'BC046', 1);
INSERT INTO ReservationDetails VALUES ('RS024', 'BC048', 1);
INSERT INTO ReservationDetails VALUES ('RS025', 'BC049', 1);
INSERT INTO ReservationDetails VALUES ('RS025', 'BC051', 1);
INSERT INTO ReservationDetails VALUES ('RS026', 'BC050', 1);
INSERT INTO ReservationDetails VALUES ('RS026', 'BC052', 1);
INSERT INTO ReservationDetails VALUES ('RS027', 'BC053', 1);
INSERT INTO ReservationDetails VALUES ('RS027', 'BC055', 1);
INSERT INTO ReservationDetails VALUES ('RS028', 'BC054', 1);
INSERT INTO ReservationDetails VALUES ('RS028', 'BC056', 1);
INSERT INTO ReservationDetails VALUES ('RS029', 'BC057', 1);
INSERT INTO ReservationDetails VALUES ('RS029', 'BC059', 1);
INSERT INTO ReservationDetails VALUES ('RS030', 'BC058', 1);
INSERT INTO ReservationDetails VALUES ('RS030', 'BC060', 1);
INSERT INTO ReservationDetails VALUES ('RS031', 'BC061', 1);
INSERT INTO ReservationDetails VALUES ('RS031', 'BC063', 1);
INSERT INTO ReservationDetails VALUES ('RS032', 'BC062', 1);
INSERT INTO ReservationDetails VALUES ('RS032', 'BC064', 1);
INSERT INTO ReservationDetails VALUES ('RS033', 'BC065', 1);
INSERT INTO ReservationDetails VALUES ('RS033', 'BC067', 1);
INSERT INTO ReservationDetails VALUES ('RS034', 'BC066', 1);
INSERT INTO ReservationDetails VALUES ('RS034', 'BC068', 1);
INSERT INTO ReservationDetails VALUES ('RS035', 'BC069', 1);
INSERT INTO ReservationDetails VALUES ('RS035', 'BC071', 1);
INSERT INTO ReservationDetails VALUES ('RS036', 'BC070', 1);
INSERT INTO ReservationDetails VALUES ('RS036', 'BC072', 1);
INSERT INTO ReservationDetails VALUES ('RS037', 'BC073', 1);
INSERT INTO ReservationDetails VALUES ('RS037', 'BC075', 1);
INSERT INTO ReservationDetails VALUES ('RS038', 'BC074', 1);
INSERT INTO ReservationDetails VALUES ('RS038', 'BC076', 1);
INSERT INTO ReservationDetails VALUES ('RS039', 'BC077', 1);
INSERT INTO ReservationDetails VALUES ('RS039', 'BC079', 1);
INSERT INTO ReservationDetails VALUES ('RS040', 'BC078', 1);
INSERT INTO ReservationDetails VALUES ('RS040', 'BC080', 1);
INSERT INTO ReservationDetails VALUES ('RS041', 'BC081', 1);
INSERT INTO ReservationDetails VALUES ('RS041', 'BC083', 1);
INSERT INTO ReservationDetails VALUES ('RS042', 'BC082', 1);
INSERT INTO ReservationDetails VALUES ('RS042', 'BC084', 1);
INSERT INTO ReservationDetails VALUES ('RS043', 'BC085', 1);
INSERT INTO ReservationDetails VALUES ('RS043', 'BC087', 1);
INSERT INTO ReservationDetails VALUES ('RS044', 'BC086', 1);
INSERT INTO ReservationDetails VALUES ('RS044', 'BC088', 1);
INSERT INTO ReservationDetails VALUES ('RS045', 'BC089', 1);
INSERT INTO ReservationDetails VALUES ('RS045', 'BC091', 1);
INSERT INTO ReservationDetails VALUES ('RS046', 'BC090', 1);
INSERT INTO ReservationDetails VALUES ('RS046', 'BC092', 1);
INSERT INTO ReservationDetails VALUES ('RS047', 'BC093', 1);
INSERT INTO ReservationDetails VALUES ('RS047', 'BC095', 1);
INSERT INTO ReservationDetails VALUES ('RS048', 'BC094', 1);
INSERT INTO ReservationDetails VALUES ('RS048', 'BC096', 1);
INSERT INTO ReservationDetails VALUES ('RS049', 'BC097', 1);
INSERT INTO ReservationDetails VALUES ('RS049', 'BC099', 1);
INSERT INTO ReservationDetails VALUES ('RS050', 'BC098', 1);
INSERT INTO ReservationDetails VALUES ('RS050', 'BC100', 1);
INSERT INTO ReservationDetails VALUES ('RS051', 'BC101', 1);
INSERT INTO ReservationDetails VALUES ('RS051', 'BC103', 1);
INSERT INTO ReservationDetails VALUES ('RS052', 'BC102', 1);
INSERT INTO ReservationDetails VALUES ('RS052', 'BC104', 1);
INSERT INTO ReservationDetails VALUES ('RS053', 'BC105', 1);
INSERT INTO ReservationDetails VALUES ('RS053', 'BC107', 1);
INSERT INTO ReservationDetails VALUES ('RS054', 'BC106', 1);
INSERT INTO ReservationDetails VALUES ('RS054', 'BC108', 1);
INSERT INTO ReservationDetails VALUES ('RS055', 'BC109', 1);
INSERT INTO ReservationDetails VALUES ('RS055', 'BC111', 1);
INSERT INTO ReservationDetails VALUES ('RS056', 'BC110', 1);
INSERT INTO ReservationDetails VALUES ('RS056', 'BC112', 1);
INSERT INTO ReservationDetails VALUES ('RS057', 'BC113', 1);
INSERT INTO ReservationDetails VALUES ('RS057', 'BC115', 1);
INSERT INTO ReservationDetails VALUES ('RS058', 'BC114', 1);
INSERT INTO ReservationDetails VALUES ('RS058', 'BC116', 1);
INSERT INTO ReservationDetails VALUES ('RS059', 'BC117', 1);
INSERT INTO ReservationDetails VALUES ('RS059', 'BC119', 1);
INSERT INTO ReservationDetails VALUES ('RS060', 'BC118', 1);
INSERT INTO ReservationDetails VALUES ('RS060', 'BC120', 1);
INSERT INTO ReservationDetails VALUES ('RS061', 'BC121', 1);
INSERT INTO ReservationDetails VALUES ('RS061', 'BC123', 1);
INSERT INTO ReservationDetails VALUES ('RS062', 'BC122', 1);
INSERT INTO ReservationDetails VALUES ('RS062', 'BC124', 1);
INSERT INTO ReservationDetails VALUES ('RS063', 'BC125', 1);
INSERT INTO ReservationDetails VALUES ('RS063', 'BC127', 1);
INSERT INTO ReservationDetails VALUES ('RS064', 'BC126', 1);
INSERT INTO ReservationDetails VALUES ('RS064', 'BC128', 1);
INSERT INTO ReservationDetails VALUES ('RS065', 'BC129', 1);
INSERT INTO ReservationDetails VALUES ('RS065', 'BC131', 1);
INSERT INTO ReservationDetails VALUES ('RS066', 'BC130', 1);
INSERT INTO ReservationDetails VALUES ('RS066', 'BC132', 1);
INSERT INTO ReservationDetails VALUES ('RS067', 'BC133', 1);
INSERT INTO ReservationDetails VALUES ('RS067', 'BC135', 1);
INSERT INTO ReservationDetails VALUES ('RS068', 'BC134', 1);
INSERT INTO ReservationDetails VALUES ('RS068', 'BC136', 1);
INSERT INTO ReservationDetails VALUES ('RS069', 'BC137', 1);
INSERT INTO ReservationDetails VALUES ('RS069', 'BC139', 1);
INSERT INTO ReservationDetails VALUES ('RS070', 'BC138', 1);
INSERT INTO ReservationDetails VALUES ('RS070', 'BC140', 1);

-- Additional records to reach 300+
INSERT INTO ReservationDetails VALUES ('RS071', 'BC141', 1);
INSERT INTO ReservationDetails VALUES ('RS071', 'BC143', 1);
INSERT INTO ReservationDetails VALUES ('RS072', 'BC142', 1);
INSERT INTO ReservationDetails VALUES ('RS072', 'BC144', 1);
INSERT INTO ReservationDetails VALUES ('RS073', 'BC145', 1);
INSERT INTO ReservationDetails VALUES ('RS073', 'BC147', 1);
INSERT INTO ReservationDetails VALUES ('RS074', 'BC146', 1);
INSERT INTO ReservationDetails VALUES ('RS074', 'BC148', 1);
INSERT INTO ReservationDetails VALUES ('RS075', 'BC149', 1);
INSERT INTO ReservationDetails VALUES ('RS075', 'BC001', 1); 
INSERT INTO ReservationDetails VALUES ('RS076', 'BC002', 1);
INSERT INTO ReservationDetails VALUES ('RS076', 'BC004', 1);
INSERT INTO ReservationDetails VALUES ('RS077', 'BC003', 1);
INSERT INTO ReservationDetails VALUES ('RS077', 'BC005', 1);
INSERT INTO ReservationDetails VALUES ('RS078', 'BC006', 1);
INSERT INTO ReservationDetails VALUES ('RS078', 'BC008', 1);
INSERT INTO ReservationDetails VALUES ('RS079', 'BC007', 1);
INSERT INTO ReservationDetails VALUES ('RS079', 'BC009', 1);
INSERT INTO ReservationDetails VALUES ('RS080', 'BC010', 1);
INSERT INTO ReservationDetails VALUES ('RS080', 'BC012', 1);
INSERT INTO ReservationDetails VALUES ('RS081', 'BC011', 1);
INSERT INTO ReservationDetails VALUES ('RS081', 'BC013', 1);
INSERT INTO ReservationDetails VALUES ('RS082', 'BC014', 1);
INSERT INTO ReservationDetails VALUES ('RS082', 'BC016', 1);
INSERT INTO ReservationDetails VALUES ('RS083', 'BC015', 1);
INSERT INTO ReservationDetails VALUES ('RS083', 'BC017', 1);
INSERT INTO ReservationDetails VALUES ('RS084', 'BC018', 1);
INSERT INTO ReservationDetails VALUES ('RS084', 'BC020', 1);
INSERT INTO ReservationDetails VALUES ('RS085', 'BC019', 1);
INSERT INTO ReservationDetails VALUES ('RS085', 'BC021', 1);
INSERT INTO ReservationDetails VALUES ('RS086', 'BC022', 1);
INSERT INTO ReservationDetails VALUES ('RS086', 'BC024', 1);
INSERT INTO ReservationDetails VALUES ('RS087', 'BC023', 1);
INSERT INTO ReservationDetails VALUES ('RS087', 'BC025', 1);
INSERT INTO ReservationDetails VALUES ('RS088', 'BC026', 1);
INSERT INTO ReservationDetails VALUES ('RS088', 'BC028', 1);
INSERT INTO ReservationDetails VALUES ('RS089', 'BC027', 1);
INSERT INTO ReservationDetails VALUES ('RS089', 'BC029', 1);
INSERT INTO ReservationDetails VALUES ('RS090', 'BC030', 1);
INSERT INTO ReservationDetails VALUES ('RS090', 'BC032', 1);
INSERT INTO ReservationDetails VALUES ('RS091', 'BC031', 1);
INSERT INTO ReservationDetails VALUES ('RS091', 'BC033', 1);
INSERT INTO ReservationDetails VALUES ('RS092', 'BC034', 1);
INSERT INTO ReservationDetails VALUES ('RS092', 'BC036', 1);
INSERT INTO ReservationDetails VALUES ('RS093', 'BC035', 1);
INSERT INTO ReservationDetails VALUES ('RS093', 'BC037', 1);
INSERT INTO ReservationDetails VALUES ('RS094', 'BC038', 1);
INSERT INTO ReservationDetails VALUES ('RS094', 'BC040', 1);
INSERT INTO ReservationDetails VALUES ('RS095', 'BC039', 1);
INSERT INTO ReservationDetails VALUES ('RS095', 'BC041', 1);
INSERT INTO ReservationDetails VALUES ('RS096', 'BC042', 1);
INSERT INTO ReservationDetails VALUES ('RS096', 'BC044', 1);
INSERT INTO ReservationDetails VALUES ('RS097', 'BC043', 1);
INSERT INTO ReservationDetails VALUES ('RS097', 'BC045', 1);
INSERT INTO ReservationDetails VALUES ('RS098', 'BC046', 1);
INSERT INTO ReservationDetails VALUES ('RS098', 'BC048', 1);
INSERT INTO ReservationDetails VALUES ('RS099', 'BC047', 1);
INSERT INTO ReservationDetails VALUES ('RS099', 'BC049', 1);
INSERT INTO ReservationDetails VALUES ('RS100', 'BC050', 1);
INSERT INTO ReservationDetails VALUES ('RS100', 'BC052', 1);
INSERT INTO ReservationDetails VALUES ('RS101', 'BC051', 1);
INSERT INTO ReservationDetails VALUES ('RS101', 'BC053', 1);
INSERT INTO ReservationDetails VALUES ('RS102', 'BC054', 1);
INSERT INTO ReservationDetails VALUES ('RS102', 'BC056', 1);
INSERT INTO ReservationDetails VALUES ('RS103', 'BC055', 1);
INSERT INTO ReservationDetails VALUES ('RS103', 'BC057', 1);
INSERT INTO ReservationDetails VALUES ('RS104', 'BC058', 1);
INSERT INTO ReservationDetails VALUES ('RS104', 'BC060', 1);
INSERT INTO ReservationDetails VALUES ('RS105', 'BC059', 1);
INSERT INTO ReservationDetails VALUES ('RS105', 'BC061', 1);
INSERT INTO ReservationDetails VALUES ('RS106', 'BC062', 1);
INSERT INTO ReservationDetails VALUES ('RS106', 'BC064', 1);
INSERT INTO ReservationDetails VALUES ('RS107', 'BC063', 1);
INSERT INTO ReservationDetails VALUES ('RS107', 'BC065', 1);
INSERT INTO ReservationDetails VALUES ('RS108', 'BC066', 1);
INSERT INTO ReservationDetails VALUES ('RS108', 'BC068', 1);
INSERT INTO ReservationDetails VALUES ('RS109', 'BC067', 1);
INSERT INTO ReservationDetails VALUES ('RS109', 'BC069', 1);
INSERT INTO ReservationDetails VALUES ('RS110', 'BC070', 1);
INSERT INTO ReservationDetails VALUES ('RS110', 'BC072', 1);
INSERT INTO ReservationDetails VALUES ('RS111', 'BC071', 1);
INSERT INTO ReservationDetails VALUES ('RS111', 'BC073', 1);
INSERT INTO ReservationDetails VALUES ('RS112', 'BC074', 1);
INSERT INTO ReservationDetails VALUES ('RS112', 'BC076', 1);
INSERT INTO ReservationDetails VALUES ('RS113', 'BC075', 1);
INSERT INTO ReservationDetails VALUES ('RS113', 'BC077', 1);
INSERT INTO ReservationDetails VALUES ('RS114', 'BC078', 1);
INSERT INTO ReservationDetails VALUES ('RS114', 'BC080', 1);
INSERT INTO ReservationDetails VALUES ('RS115', 'BC079', 1);
INSERT INTO ReservationDetails VALUES ('RS115', 'BC081', 1);
INSERT INTO ReservationDetails VALUES ('RS116', 'BC082', 1);
INSERT INTO ReservationDetails VALUES ('RS116', 'BC084', 1);
INSERT INTO ReservationDetails VALUES ('RS117', 'BC083', 1);
INSERT INTO ReservationDetails VALUES ('RS117', 'BC085', 1);
INSERT INTO ReservationDetails VALUES ('RS118', 'BC086', 1);
INSERT INTO ReservationDetails VALUES ('RS118', 'BC088', 1);
INSERT INTO ReservationDetails VALUES ('RS119', 'BC087', 1);
INSERT INTO ReservationDetails VALUES ('RS119', 'BC089', 1);
INSERT INTO ReservationDetails VALUES ('RS120', 'BC090', 1);
INSERT INTO ReservationDetails VALUES ('RS120', 'BC092', 1);

INSERT INTO ReservationDetails VALUES ('RS028', 'BC108', 2);
INSERT INTO ReservationDetails VALUES ('RS027', 'BC073', 1);
INSERT INTO ReservationDetails VALUES ('RS004', 'BC052', 1);
INSERT INTO ReservationDetails VALUES ('RS019', 'BC053', 2);
INSERT INTO ReservationDetails VALUES ('RS004', 'BC085', 1);
INSERT INTO ReservationDetails VALUES ('RS007', 'BC060', 1);
INSERT INTO ReservationDetails VALUES ('RS009', 'BC011', 2);
INSERT INTO ReservationDetails VALUES ('RS027', 'BC115', 1);
INSERT INTO ReservationDetails VALUES ('RS020', 'BC138', 1);
INSERT INTO ReservationDetails VALUES ('RS019', 'BC105', 2);
INSERT INTO ReservationDetails VALUES ('RS018', 'BC121', 2);
INSERT INTO ReservationDetails VALUES ('RS022', 'BC106', 1);
INSERT INTO ReservationDetails VALUES ('RS010', 'BC099', 1);
INSERT INTO ReservationDetails VALUES ('RS017', 'BC073', 1);
INSERT INTO ReservationDetails VALUES ('RS008', 'BC149', 2);
INSERT INTO ReservationDetails VALUES ('RS007', 'BC039', 2);
INSERT INTO ReservationDetails VALUES ('RS030', 'BC067', 2);
INSERT INTO ReservationDetails VALUES ('RS030', 'BC123', 2);
INSERT INTO ReservationDetails VALUES ('RS021', 'BC116', 1);
INSERT INTO ReservationDetails VALUES ('RS022', 'BC090', 1);
INSERT INTO ReservationDetails VALUES ('RS025', 'BC077', 2);
INSERT INTO ReservationDetails VALUES ('RS018', 'BC052', 1);
INSERT INTO ReservationDetails VALUES ('RS028', 'BC020', 2);
INSERT INTO ReservationDetails VALUES ('RS024', 'BC138', 1);
INSERT INTO ReservationDetails VALUES ('RS001', 'BC030', 2);
INSERT INTO ReservationDetails VALUES ('RS024', 'BC093', 2);
INSERT INTO ReservationDetails VALUES ('RS011', 'BC121', 1);
INSERT INTO ReservationDetails VALUES ('RS021', 'BC071', 1);
INSERT INTO ReservationDetails VALUES ('RS025', 'BC091', 1);
INSERT INTO ReservationDetails VALUES ('RS026', 'BC105', 1);
INSERT INTO ReservationDetails VALUES ('RS015', 'BC060', 1);
INSERT INTO ReservationDetails VALUES ('RS019', 'BC109', 1);
INSERT INTO ReservationDetails VALUES ('RS018', 'BC087', 1);
INSERT INTO ReservationDetails VALUES ('RS002', 'BC105', 1);
INSERT INTO ReservationDetails VALUES ('RS013', 'BC130', 2);
INSERT INTO ReservationDetails VALUES ('RS027', 'BC028', 1);
INSERT INTO ReservationDetails VALUES ('RS007', 'BC138', 1);
INSERT INTO ReservationDetails VALUES ('RS007', 'BC133', 2);
INSERT INTO ReservationDetails VALUES ('RS008', 'BC062', 2);
INSERT INTO ReservationDetails VALUES ('RS010', 'BC139', 1);
INSERT INTO ReservationDetails VALUES ('RS012', 'BC058', 1);
INSERT INTO ReservationDetails VALUES ('RS028', 'BC074', 1);
INSERT INTO ReservationDetails VALUES ('RS011', 'BC112', 2);
INSERT INTO ReservationDetails VALUES ('RS001', 'BC006', 1);
INSERT INTO ReservationDetails VALUES ('RS017', 'BC059', 1);
INSERT INTO ReservationDetails VALUES ('RS009', 'BC114', 1);
INSERT INTO ReservationDetails VALUES ('RS022', 'BC029', 1);
INSERT INTO ReservationDetails VALUES ('RS011', 'BC051', 1);
INSERT INTO ReservationDetails VALUES ('RS018', 'BC124', 2);
INSERT INTO ReservationDetails VALUES ('RS008', 'BC116', 2);
INSERT INTO ReservationDetails VALUES ('RS004', 'BC136', 1);
INSERT INTO ReservationDetails VALUES ('RS005', 'BC136', 2);
INSERT INTO ReservationDetails VALUES ('RS028', 'BC015', 1);
INSERT INTO ReservationDetails VALUES ('RS010', 'BC112', 2);
INSERT INTO ReservationDetails VALUES ('RS017', 'BC034', 1);
INSERT INTO ReservationDetails VALUES ('RS005', 'BC093', 2);
INSERT INTO ReservationDetails VALUES ('RS022', 'BC006', 1);
INSERT INTO ReservationDetails VALUES ('RS006', 'BC056', 2);
INSERT INTO ReservationDetails VALUES ('RS009', 'BC096', 2);
INSERT INTO ReservationDetails VALUES ('RS024', 'BC092', 1);



INSERT INTO Schedules VALUES ('SC001', TO_TIMESTAMP('05-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC002', TO_TIMESTAMP('09-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC003', TO_TIMESTAMP('16-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC004', TO_TIMESTAMP('19-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('19-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC005', TO_TIMESTAMP('07-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('07-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC006', TO_TIMESTAMP('09-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC007', TO_TIMESTAMP('19-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('19-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC008', TO_TIMESTAMP('20-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC009', TO_TIMESTAMP('03-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC010', TO_TIMESTAMP('10-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC011', TO_TIMESTAMP('12-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC012', TO_TIMESTAMP('16-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC013', TO_TIMESTAMP('12-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC014', TO_TIMESTAMP('10-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC015', TO_TIMESTAMP('18-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC016', TO_TIMESTAMP('15-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC017', TO_TIMESTAMP('17-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('17-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC018', TO_TIMESTAMP('23-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('23-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC019', TO_TIMESTAMP('05-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC020', TO_TIMESTAMP('18-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC021', TO_TIMESTAMP('20-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC022', TO_TIMESTAMP('05-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC023', TO_TIMESTAMP('09-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC024', TO_TIMESTAMP('20-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC025', TO_TIMESTAMP('19-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('19-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC026', TO_TIMESTAMP('22-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC027', TO_TIMESTAMP('25-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC028', TO_TIMESTAMP('06-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('06-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC029', TO_TIMESTAMP('14-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('14-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC030', TO_TIMESTAMP('25-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC031', TO_TIMESTAMP('16-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC032', TO_TIMESTAMP('28-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC033', TO_TIMESTAMP('01-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC034', TO_TIMESTAMP('08-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC035', TO_TIMESTAMP('25-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC036', TO_TIMESTAMP('01-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC037', TO_TIMESTAMP('08-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC038', TO_TIMESTAMP('03-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC039', TO_TIMESTAMP('28-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC040', TO_TIMESTAMP('02-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC041', TO_TIMESTAMP('05-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC042', TO_TIMESTAMP('09-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC043', TO_TIMESTAMP('08-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC044', TO_TIMESTAMP('10-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC045', TO_TIMESTAMP('03-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC046', TO_TIMESTAMP('10-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC047', TO_TIMESTAMP('12-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC048', TO_TIMESTAMP('15-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC049', TO_TIMESTAMP('12-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC050', TO_TIMESTAMP('15-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC051', TO_TIMESTAMP('18-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC052', TO_TIMESTAMP('15-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC053', TO_TIMESTAMP('20-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC054', TO_TIMESTAMP('22-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC055', TO_TIMESTAMP('01-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC056', TO_TIMESTAMP('09-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC057', TO_TIMESTAMP('22-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC058', TO_TIMESTAMP('01-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC059', TO_TIMESTAMP('09-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC060', TO_TIMESTAMP('25-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC061', TO_TIMESTAMP('02-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC062', TO_TIMESTAMP('10-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC063', TO_TIMESTAMP('28-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC064', TO_TIMESTAMP('03-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC065', TO_TIMESTAMP('05-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC066', TO_TIMESTAMP('11-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('11-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC067', TO_TIMESTAMP('03-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC068', TO_TIMESTAMP('08-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC069', TO_TIMESTAMP('13-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('13-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC070', TO_TIMESTAMP('04-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('04-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC071', TO_TIMESTAMP('10-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC072', TO_TIMESTAMP('14-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('14-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC073', TO_TIMESTAMP('06-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('06-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC074', TO_TIMESTAMP('12-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC075', TO_TIMESTAMP('14-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('14-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC076', TO_TIMESTAMP('07-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('07-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC077', TO_TIMESTAMP('15-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC078', TO_TIMESTAMP('07-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('07-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC079', TO_TIMESTAMP('16-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC080', TO_TIMESTAMP('01-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC081', TO_TIMESTAMP('08-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC082', TO_TIMESTAMP('20-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC083', TO_TIMESTAMP('16-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC084', TO_TIMESTAMP('03-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC085', TO_TIMESTAMP('18-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC086', TO_TIMESTAMP('03-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC087', TO_TIMESTAMP('20-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC088', TO_TIMESTAMP('12-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC089', TO_TIMESTAMP('04-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('04-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC090', TO_TIMESTAMP('22-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC091', TO_TIMESTAMP('01-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC092', TO_TIMESTAMP('05-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC093', TO_TIMESTAMP('25-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC094', TO_TIMESTAMP('03-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC095', TO_TIMESTAMP('28-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC096', TO_TIMESTAMP('05-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC097', TO_TIMESTAMP('18-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC098', TO_TIMESTAMP('08-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC099', TO_TIMESTAMP('18-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC100', TO_TIMESTAMP('10-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC101', TO_TIMESTAMP('19-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('19-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC102', TO_TIMESTAMP('12-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC103', TO_TIMESTAMP('20-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC104', TO_TIMESTAMP('11-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('11-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC105', TO_TIMESTAMP('15-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC106', TO_TIMESTAMP('02-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC107', TO_TIMESTAMP('12-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-05-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC108', TO_TIMESTAMP('11-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('11-05-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC109', TO_TIMESTAMP('15-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC110', TO_TIMESTAMP('03-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC111', TO_TIMESTAMP('18-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC112', TO_TIMESTAMP('04-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('04-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC113', TO_TIMESTAMP('20-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-05-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC114', TO_TIMESTAMP('16-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC115', TO_TIMESTAMP('22-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-05-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC116', TO_TIMESTAMP('01-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC117', TO_TIMESTAMP('25-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-05-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC118', TO_TIMESTAMP('03-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC119', TO_TIMESTAMP('17-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('17-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC120', TO_TIMESTAMP('28-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC121', TO_TIMESTAMP('05-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-05-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC122', TO_TIMESTAMP('30-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('30-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC123', TO_TIMESTAMP('08-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC124', TO_TIMESTAMP('18-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-05-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC125', TO_TIMESTAMP('10-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC126', TO_TIMESTAMP('19-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('19-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC127', TO_TIMESTAMP('05-06-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC128', TO_TIMESTAMP('30-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('30-06-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC129', TO_TIMESTAMP('08-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-06-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC130', TO_TIMESTAMP('12-06-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC131', TO_TIMESTAMP('10-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC132', TO_TIMESTAMP('13-06-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('13-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC133', TO_TIMESTAMP('12-06-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC134', TO_TIMESTAMP('14-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('14-06-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC135', TO_TIMESTAMP('05-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-06-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC136', TO_TIMESTAMP('15-06-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC137', TO_TIMESTAMP('18-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC138', TO_TIMESTAMP('06-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('06-06-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC139', TO_TIMESTAMP('07-06-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('07-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC140', TO_TIMESTAMP('20-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC141', TO_TIMESTAMP('08-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-06-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC142', TO_TIMESTAMP('22-06-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC143', TO_TIMESTAMP('01-06-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC144', TO_TIMESTAMP('25-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-06-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC145', TO_TIMESTAMP('03-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-06-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC146', TO_TIMESTAMP('28-06-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-06-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC147', TO_TIMESTAMP('20-07-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC148', TO_TIMESTAMP('25-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC149', TO_TIMESTAMP('02-07-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC150', TO_TIMESTAMP('28-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-07-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC151', TO_TIMESTAMP('05-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-07-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC152', TO_TIMESTAMP('30-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('30-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC153', TO_TIMESTAMP('08-07-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC154', TO_TIMESTAMP('15-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC155', TO_TIMESTAMP('10-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC156', TO_TIMESTAMP('18-07-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC157', TO_TIMESTAMP('12-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-07-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC158', TO_TIMESTAMP('17-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('17-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC159', TO_TIMESTAMP('15-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-07-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC160', TO_TIMESTAMP('21-07-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('21-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC161', TO_TIMESTAMP('18-07-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC162', TO_TIMESTAMP('23-07-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('23-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC163', TO_TIMESTAMP('20-07-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC164', TO_TIMESTAMP('25-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC165', TO_TIMESTAMP('22-07-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-07-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC166', TO_TIMESTAMP('27-07-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('27-07-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC167', TO_TIMESTAMP('02-08-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC168', TO_TIMESTAMP('18-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC169', TO_TIMESTAMP('15-08-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC170', TO_TIMESTAMP('20-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-08-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC171', TO_TIMESTAMP('17-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('17-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC172', TO_TIMESTAMP('22-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC173', TO_TIMESTAMP('01-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-08-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC174', TO_TIMESTAMP('25-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC175', TO_TIMESTAMP('03-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-08-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC176', TO_TIMESTAMP('28-08-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC177', TO_TIMESTAMP('05-08-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC178', TO_TIMESTAMP('30-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('30-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC179', TO_TIMESTAMP('08-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC180', TO_TIMESTAMP('30-08-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('30-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC181', TO_TIMESTAMP('10-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC182', TO_TIMESTAMP('16-08-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC183', TO_TIMESTAMP('12-08-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC184', TO_TIMESTAMP('16-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-08-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC185', TO_TIMESTAMP('15-08-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-08-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC186', TO_TIMESTAMP('10-09-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC187', TO_TIMESTAMP('12-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-09-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC188', TO_TIMESTAMP('15-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-09-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC189', TO_TIMESTAMP('18-09-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC190', TO_TIMESTAMP('20-09-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC191', TO_TIMESTAMP('22-09-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-09-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC192', TO_TIMESTAMP('01-09-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC193', TO_TIMESTAMP('25-09-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-09-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC194', TO_TIMESTAMP('03-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-09-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC195', TO_TIMESTAMP('28-09-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC196', TO_TIMESTAMP('05-09-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC197', TO_TIMESTAMP('30-09-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('30-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC198', TO_TIMESTAMP('08-09-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC199', TO_TIMESTAMP('30-09-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('30-09-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC200', TO_TIMESTAMP('05-10-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-10-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC201', TO_TIMESTAMP('30-10-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('30-10-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC202', TO_TIMESTAMP('05-10-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-10-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC203', TO_TIMESTAMP('08-10-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-10-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC204', TO_TIMESTAMP('10-10-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-10-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC205', TO_TIMESTAMP('15-10-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-10-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC206', TO_TIMESTAMP('12-10-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-10-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC207', TO_TIMESTAMP('15-10-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-10-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC208', TO_TIMESTAMP('15-10-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-10-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC209', TO_TIMESTAMP('20-10-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-10-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC210', TO_TIMESTAMP('22-10-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-10-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC211', TO_TIMESTAMP('25-10-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-10-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC212', TO_TIMESTAMP('02-10-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-10-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC213', TO_TIMESTAMP('28-10-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-10-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC214', TO_TIMESTAMP('22-11-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC215', TO_TIMESTAMP('01-11-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC216', TO_TIMESTAMP('25-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-11-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC217', TO_TIMESTAMP('03-11-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC218', TO_TIMESTAMP('28-11-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-11-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC219', TO_TIMESTAMP('05-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-11-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC220', TO_TIMESTAMP('30-11-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('30-11-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC221', TO_TIMESTAMP('08-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-11-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC222', TO_TIMESTAMP('12-11-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC223', TO_TIMESTAMP('10-11-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC224', TO_TIMESTAMP('16-11-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-11-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC225', TO_TIMESTAMP('12-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-11-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC226', TO_TIMESTAMP('17-11-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('17-11-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC227', TO_TIMESTAMP('15-11-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC228', TO_TIMESTAMP('18-11-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-11-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC229', TO_TIMESTAMP('20-11-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-11-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC230', TO_TIMESTAMP('18-12-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-12-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF01');
INSERT INTO Schedules VALUES ('SC231', TO_TIMESTAMP('20-12-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-12-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF02');
INSERT INTO Schedules VALUES ('SC232', TO_TIMESTAMP('22-12-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-12-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF03');
INSERT INTO Schedules VALUES ('SC233', TO_TIMESTAMP('25-12-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-12-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF04');
INSERT INTO Schedules VALUES ('SC234', TO_TIMESTAMP('02-12-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-12-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC235', TO_TIMESTAMP('28-12-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-12-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF05');
INSERT INTO Schedules VALUES ('SC236', TO_TIMESTAMP('05-12-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-12-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC237', TO_TIMESTAMP('30-12-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('30-12-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF06');
INSERT INTO Schedules VALUES ('SC238', TO_TIMESTAMP('08-12-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-12-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC239', TO_TIMESTAMP('10-12-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-12-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC240', TO_TIMESTAMP('12-12-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-12-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC241', TO_TIMESTAMP('15-12-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-12-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');
INSERT INTO Schedules VALUES ('SC242', TO_TIMESTAMP('02-01-2024 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-01-2024 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF07');
INSERT INTO Schedules VALUES ('SC243', TO_TIMESTAMP('05-01-2024 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-01-2024 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF08');
INSERT INTO Schedules VALUES ('SC244', TO_TIMESTAMP('08-01-2024 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-01-2024 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF09');
INSERT INTO Schedules VALUES ('SC245', TO_TIMESTAMP('10-01-2024 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-01-2024 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'STF10');


INSERT INTO Attendance VALUES ('AT001', TO_TIMESTAMP('05-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC001');
INSERT INTO Attendance VALUES ('AT002', TO_TIMESTAMP('09-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC002');
INSERT INTO Attendance VALUES ('AT003', TO_TIMESTAMP('16-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC003');
INSERT INTO Attendance VALUES ('AT004', TO_TIMESTAMP('19-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('19-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC004');
INSERT INTO Attendance VALUES ('AT005', TO_TIMESTAMP('07-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('07-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC005');
INSERT INTO Attendance VALUES ('AT006', TO_TIMESTAMP('09-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC006');
INSERT INTO Attendance VALUES ('AT007', TO_TIMESTAMP('19-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('19-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC007');
INSERT INTO Attendance VALUES ('AT008', TO_TIMESTAMP('20-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC008');
INSERT INTO Attendance VALUES ('AT009', TO_TIMESTAMP('03-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC009');
INSERT INTO Attendance VALUES ('AT010', TO_TIMESTAMP('10-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC010');
INSERT INTO Attendance VALUES ('AT011', NULL, NULL, 'Absence', 'SC011');
INSERT INTO Attendance VALUES ('AT012', TO_TIMESTAMP('16-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC012');
INSERT INTO Attendance VALUES ('AT013', TO_TIMESTAMP('12-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC013');
INSERT INTO Attendance VALUES ('AT014', TO_TIMESTAMP('10-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC014');
INSERT INTO Attendance VALUES ('AT015', TO_TIMESTAMP('18-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC015');
INSERT INTO Attendance VALUES ('AT016', TO_TIMESTAMP('15-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC016');
INSERT INTO Attendance VALUES ('AT017', TO_TIMESTAMP('17-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('17-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC017');
INSERT INTO Attendance VALUES ('AT018', NULL, NULL, 'Absence', 'SC018');
INSERT INTO Attendance VALUES ('AT019', TO_TIMESTAMP('05-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC019');
INSERT INTO Attendance VALUES ('AT020', TO_TIMESTAMP('18-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC020');
INSERT INTO Attendance VALUES ('AT021', TO_TIMESTAMP('20-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC021');
INSERT INTO Attendance VALUES ('AT022', NULL, NULL, 'Absence', 'SC022');
INSERT INTO Attendance VALUES ('AT023', TO_TIMESTAMP('09-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC023');
INSERT INTO Attendance VALUES ('AT024', TO_TIMESTAMP('20-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC024');
INSERT INTO Attendance VALUES ('AT025', TO_TIMESTAMP('19-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('19-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC025');
INSERT INTO Attendance VALUES ('AT026', TO_TIMESTAMP('22-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC026');
INSERT INTO Attendance VALUES ('AT027', TO_TIMESTAMP('25-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC027');
INSERT INTO Attendance VALUES ('AT028', TO_TIMESTAMP('06-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('06-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC028');
INSERT INTO Attendance VALUES ('AT029', TO_TIMESTAMP('14-01-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('14-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC029');
INSERT INTO Attendance VALUES ('AT030', TO_TIMESTAMP('25-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-01-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC030');
INSERT INTO Attendance VALUES ('AT031', TO_TIMESTAMP('16-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC031');
INSERT INTO Attendance VALUES ('AT032', TO_TIMESTAMP('28-01-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-01-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC032');
INSERT INTO Attendance VALUES ('AT033', TO_TIMESTAMP('01-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-02-2023 11:00:00','DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC033');
INSERT INTO Attendance VALUES ('AT034', NULL, NULL, 'Absence', 'SC034');
INSERT INTO Attendance VALUES ('AT035', TO_TIMESTAMP('25-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC035');
INSERT INTO Attendance VALUES ('AT036', TO_TIMESTAMP('01-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC036');
INSERT INTO Attendance VALUES ('AT037', TO_TIMESTAMP('08-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC037');
INSERT INTO Attendance VALUES ('AT038', TO_TIMESTAMP('03-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC038');
INSERT INTO Attendance VALUES ('AT039', TO_TIMESTAMP('28-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC039');
INSERT INTO Attendance VALUES ('AT040', TO_TIMESTAMP('02-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC040');
INSERT INTO Attendance VALUES ('AT041', TO_TIMESTAMP('05-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC041');
INSERT INTO Attendance VALUES ('AT042', TO_TIMESTAMP('09-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC042');
INSERT INTO Attendance VALUES ('AT043', TO_TIMESTAMP('08-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC043');
INSERT INTO Attendance VALUES ('AT044', TO_TIMESTAMP('10-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC044');
INSERT INTO Attendance VALUES ('AT045', TO_TIMESTAMP('03-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC045');
INSERT INTO Attendance VALUES ('AT046',TO_TIMESTAMP('10-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC046');
INSERT INTO Attendance VALUES ('AT047', TO_TIMESTAMP('12-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC047');
INSERT INTO Attendance VALUES ('AT048', TO_TIMESTAMP('15-02-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC048');
INSERT INTO Attendance VALUES ('AT049', TO_TIMESTAMP('12-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC049');
INSERT INTO Attendance VALUES ('AT050', TO_TIMESTAMP('13-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('13-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC050');
INSERT INTO Attendance VALUES ('AT051', TO_TIMESTAMP('18-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC051');
INSERT INTO Attendance VALUES ('AT052', TO_TIMESTAMP('15-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-02-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC052');
INSERT INTO Attendance VALUES ('AT053', TO_TIMESTAMP('20-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC053');
INSERT INTO Attendance VALUES ('AT054', TO_TIMESTAMP('22-02-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-02-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC054');
INSERT INTO Attendance VALUES ('AT055', TO_TIMESTAMP('01-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC055');
INSERT INTO Attendance VALUES ('AT056', TO_TIMESTAMP('09-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC056');
INSERT INTO Attendance VALUES ('AT057', TO_TIMESTAMP('22-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC057');
INSERT INTO Attendance VALUES ('AT058', TO_TIMESTAMP('01-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC058');
INSERT INTO Attendance VALUES ('AT059', TO_TIMESTAMP('09-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC059');
INSERT INTO Attendance VALUES ('AT060', TO_TIMESTAMP('25-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC060');
INSERT INTO Attendance VALUES ('AT061', TO_TIMESTAMP('02-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC061');
INSERT INTO Attendance VALUES ('AT062', TO_TIMESTAMP('10-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC062');
INSERT INTO Attendance VALUES ('AT063', TO_TIMESTAMP('28-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC063');
INSERT INTO Attendance VALUES ('AT064', TO_TIMESTAMP('03-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC064');
INSERT INTO Attendance VALUES ('AT065', TO_TIMESTAMP('05-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC065');
INSERT INTO Attendance VALUES ('AT066', TO_TIMESTAMP('11-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('11-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC066');
INSERT INTO Attendance VALUES ('AT067', TO_TIMESTAMP('03-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC067');
INSERT INTO Attendance VALUES ('AT068', TO_TIMESTAMP('08-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC068');
INSERT INTO Attendance VALUES ('AT069', TO_TIMESTAMP('13-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('13-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC069');
INSERT INTO Attendance VALUES ('AT070', NULL, NULL, 'Absence', 'SC070');
INSERT INTO Attendance VALUES ('AT071', TO_TIMESTAMP('10-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC071');
INSERT INTO Attendance VALUES ('AT072', TO_TIMESTAMP('14-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('14-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC072');
INSERT INTO Attendance VALUES ('AT073', TO_TIMESTAMP('06-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('06-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC073');
INSERT INTO Attendance VALUES ('AT074', TO_TIMESTAMP('12-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC074');
INSERT INTO Attendance VALUES ('AT075', TO_TIMESTAMP('14-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('14-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC075');
INSERT INTO Attendance VALUES ('AT076', TO_TIMESTAMP('07-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('07-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC076');
INSERT INTO Attendance VALUES ('AT077', TO_TIMESTAMP('15-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC077');
INSERT INTO Attendance VALUES ('AT078', TO_TIMESTAMP('07-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('07-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC078');
INSERT INTO Attendance VALUES ('AT079', NULL,NULL, 'Absence', 'SC079');
INSERT INTO Attendance VALUES ('AT080', TO_TIMESTAMP('01-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-03-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC080');
INSERT INTO Attendance VALUES ('AT081', TO_TIMESTAMP('08-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC081');
INSERT INTO Attendance VALUES ('AT082', TO_TIMESTAMP('20-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-03-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC082');
INSERT INTO Attendance VALUES ('AT083', TO_TIMESTAMP('16-03-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-03-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC083');
INSERT INTO Attendance VALUES ('AT084', TO_TIMESTAMP('03-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC084');
INSERT INTO Attendance VALUES ('AT085', TO_TIMESTAMP('18-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC085');
INSERT INTO Attendance VALUES ('AT086', TO_TIMESTAMP('03-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC086');
INSERT INTO Attendance VALUES ('AT087', TO_TIMESTAMP('20-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC087');
INSERT INTO Attendance VALUES ('AT088', NULL, NULL, 'Absence', 'SC088');
INSERT INTO Attendance VALUES ('AT089', TO_TIMESTAMP('04-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('04-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC089');
INSERT INTO Attendance VALUES ('AT090', TO_TIMESTAMP('22-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('22-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC090');
INSERT INTO Attendance VALUES ('AT091', TO_TIMESTAMP('01-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('01-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC091');
INSERT INTO Attendance VALUES ('AT092', TO_TIMESTAMP('05-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC092');
INSERT INTO Attendance VALUES ('AT093', TO_TIMESTAMP('25-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC093');
INSERT INTO Attendance VALUES ('AT094', TO_TIMESTAMP('03-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('03-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC094');
INSERT INTO Attendance VALUES ('AT095', TO_TIMESTAMP('28-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('28-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC095');
INSERT INTO Attendance VALUES ('AT096', TO_TIMESTAMP('05-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('05-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC096');
INSERT INTO Attendance VALUES ('AT097', NULL, NULL, 'Absence', 'SC097');
INSERT INTO Attendance VALUES ('AT098', TO_TIMESTAMP('08-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC098');
INSERT INTO Attendance VALUES ('AT099', TO_TIMESTAMP('18-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('18-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC099');
INSERT INTO Attendance VALUES ('AT100', TO_TIMESTAMP('10-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-04-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC100');
INSERT INTO Attendance VALUES ('AT101', NULL, NULL, 'Absence', 'SC101');
INSERT INTO Attendance VALUES ('AT102', TO_TIMESTAMP('12-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC102');
INSERT INTO Attendance VALUES ('AT103', TO_TIMESTAMP('20-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-04-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC103');
INSERT INTO Attendance VALUES ('AT104', NULL, NULL, 'Absence', 'SC104');
INSERT INTO Attendance VALUES ('AT105', TO_TIMESTAMP('15-04-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-04-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC105');
INSERT INTO Attendance VALUES ('AT106', TO_TIMESTAMP('02-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('02-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC106');
INSERT INTO Attendance VALUES ('AT107', TO_TIMESTAMP('12-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('12-05-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC107');
INSERT INTO Attendance VALUES ('AT108', TO_TIMESTAMP('11-05-2023 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('11-05-2023 18:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC108');
INSERT INTO Attendance VALUES ('AT109', TO_TIMESTAMP('15-05-2023 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-05-2023 11:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Attend', 'SC109');

SELECT COUNT (*) AS MembersCount FROM Members;
SELECT COUNT (*) AS PublishersCount FROM Publishers;
SELECT COUNT (*) AS PaymentsCount FROM Payments;
SELECT COUNT (*) AS StaffsCount FROM Staffs;
SELECT COUNT (*) AS BooksCount FROM Books;
SELECT COUNT (*) AS BookCopysCount FROM BookCopys;
SELECT COUNT (*) AS BorrowsCount FROM Borrows;
SELECT COUNT (*) AS BorrowDetailsCount FROM BorrowDetails;
SELECT COUNT (*) AS FinesCount FROM Fines;
SELECT COUNT (*) AS ReservationsCount FROM Reservations;
SELECT COUNT (*) AS ReservationDetailsCount FROM ReservationDetails;
SELECT COUNT (*) AS SchedulesCount FROM Schedules;
SELECT COUNT (*) AS AttendanceCount FROM Attendance;
