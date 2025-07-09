-- Task1---ProjectTitle:Library Management System 

CREATE DATABASE LibraryManagementSystem;
USE LibraryManagementSystem;

-- Create Book Table
CREATE TABLE Books (BOOK_ID INT PRIMARY KEY,
TITLE VARCHAR (100),
AUTHOR VARCHAR (100),
GENRE VARCHAR (50),
YEAR_PUBLISHED INT,
AVAILABLE_COPIES INT );

-- Create Memebers Table
CREATE TABLE MEMBERS (MEMBER_ID INT PRIMARY KEY,
NAME VARCHAR (100),
EMAIL VARCHAR (100),
PHONE_NO VARCHAR (15),
ADDRESS VARCHAR (200),
MEMBERSHIP_DATE DATE );

-- Create Bowrrowing Records table
CREATE TABLE BORROWINGRECORDS (BORROW_ID INT PRIMARY KEY,
MEMBER_ID INT,
foreign key (MEMBER_ID) references Members(MEMBER_ID),
BOOK_ID INT,
foreign key (BOOK_ID) references Books (BOOK_ID),
BORROW_DATE DATE,
RETURN_DATE DATE );

-- Insert into Books
INSERT INTO Books VALUES
(1, 'Wings of Fire', 'A.P.J. Abdul Kalam', 'Biography', 1999, 5),
(2, 'The White Tiger', 'Aravind Adiga', 'Fiction', 2008, 3),
(3, 'The Palace of Illusions', 'Chitra Banerjee', 'Mythology', 2008, 4),
(4, 'Train to Pakistan', 'Khushwant Singh', 'Historical Fiction', 1956, 2),
(5, 'Discovery of India', 'Jawaharlal Nehru', 'History', 1946, 3);

-- Insert into Members
INSERT INTO Members VALUES
(101, 'Rahul Sharma', 'rahul.s@gmail.com', '9791187761', 'Delhi', '2024-01-15'),
(102, 'Anjali Menon', 'anjali.m@gmail.com', '9789058574', 'Mumbai', '2023-11-10'),
(103, 'Vikram Iyer', 'vikram.iyer@yahoo.com', '9840035674', 'Chennai', '2024-02-01'),
(104, 'Sneha Reddy', 'sneha.r@gmail.com', '9877891234', 'Hyderabad', '2024-04-20');

-- Insert into BorrowingRecords
INSERT INTO BorrowingRecords VALUES
(1, 101, 1, '2024-06-01', NULL),
(2, 101, 2, '2024-05-10', '2024-06-10'),
(3, 102, 3, '2024-04-01', NULL),
(4, 102, 4, '2024-06-20', NULL),
(5, 103, 5, '2024-05-01', NULL),
(6, 103, 3, '2024-05-15', '2024-06-01'),
(7, 104, 2, '2024-06-15', NULL),
(8, 104, 3, '2024-06-20', NULL),
(9, 104, 1, '2024-07-01', NULL);

-- Information retrievel Queries
-- Retrieve a list of books currently borrowed by a specific member
SELECT b.Title
FROM BorrowingRecords BR
JOIN Books B on BR.Book_ID = B.Book_ID
WHERE BR.Member_ID = 103 AND BR.Return_Date IS NULL;

-- Find members who have overdue books (borrowed more than 30 days ago, not returned).
SELECT DISTINCT M.NAME, M.EMAIL
FROM BorrowingRecords BR
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
WHERE BR.RETURN_DATE IS NULL AND BR.BORROW_DATE < CURRENT_DATE - INTERVAL '30' DAY;

-- Retrieve books by genre along with the count of available copies
SELECT GENRE, COUNT(*) AS TOTAL_BOOKS, SUM(AVAILABLE_COPIES) AS TOTAL_AVAILABLE
FROM Books
GROUP BY GENRE;

-- Find the most borrowed books overall
SELECT B.TITLE, COUNT(*) AS TIMES_BORROWED
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY B.TITLE
ORDER BY TIMES_BORROWED DESC
LIMIT 1;

-- Retrieve members who have borrowed books from at least three different genres
SELECT M.NAME, COUNT(DISTINCT B.GENRE) AS GENRES_BORROWED
FROM BorrowingRecords BR
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY M.NAME
HAVING COUNT(DISTINCT B.GENRE) >= 3;

-- Reporting and Analytics
-- Calculate the total number of books borrowed per month
SELECT 
    DATE_FORMAT(BORROW_DATE, '%Y-%m') AS MONTH,
    COUNT(*) AS TOTAL_BORROWED
FROM BorrowingRecords
GROUP BY DATE_FORMAT(BORROW_DATE, '%Y-%m')
ORDER BY MONTH;

-- Find the top three most active members based on the number of books borrowed
SELECT M.NAME, COUNT(*) AS TOTAL_BORROWED
FROM BorrowingRecords BR
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
GROUP BY M.NAME
ORDER BY TOTAL_BORROWED DESC
LIMIT 3;

-- Retrieve authors whose books have been borrowed at least 10 times
SELECT B.AUTHOR, COUNT(*) AS TIMES_BORROWED
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY B.AUTHOR
HAVING COUNT(*) >= 10;

-- Identify members who have never borrowed a book
SELECT M.NAME
FROM Members M
LEFT JOIN BorrowingRecords BR ON M.MEMBER_ID = BR.MEMBER_ID
WHERE BR.MEMBER_ID IS NULL;