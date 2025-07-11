--- Task1---ProjectTitle:Library Management System 

create database LibraryManagementSystem;
use LibraryManagementSystem;

-- Create Book Table
create table books (
  book_id int primary key,
  title varchar(100),
  author varchar(100),
  genre varchar(50),
  year_published int,
  available_copies int
);

-- Create Members Table
create table members (
  member_id int primary key,
  name varchar(100),
  email varchar(100),
  phone_no varchar(15),
  address varchar(200),
  membership_date date
);

-- Create Borrowing Records Table
create table borrowingrecords (
  borrow_id int primary key,
  member_id int,
  foreign key (member_id) references members(member_id),
  book_id int,
  foreign key (book_id) references books(book_id),
  borrow_date date,
  return_date date
);

-- Insert into Books
insert into books values
(1, 'Wings of Fire', 'A.P.J. Abdul Kalam', 'Biography', 1999, 5),
(2, 'The White Tiger', 'Aravind Adiga', 'Fiction', 2008, 3),
(3, 'The Palace of Illusions', 'Chitra Banerjee', 'Mythology', 2008, 4),
(4, 'Train to Pakistan', 'Khushwant Singh', 'Historical Fiction', 1956, 2),
(5, 'Discovery of India', 'Jawaharlal Nehru', 'History', 1946, 3);

-- Insert into Members
insert into members values
(101, 'Rahul Sharma', 'rahul.s@gmail.com', '9791187761', 'Delhi', '2024-01-15'),
(102, 'Anjali Menon', 'anjali.m@gmail.com', '9789058574', 'Mumbai', '2023-11-10'),
(103, 'Vikram Iyer', 'vikram.iyer@yahoo.com', '9840035674', 'Chennai', '2024-02-01'),
(104, 'Sneha Reddy', 'sneha.r@gmail.com', '9877891234', 'Hyderabad', '2024-04-20');

-- Insert into Borrowing Records
insert into borrowingrecords values
(1, 101, 1, '2024-06-01', null),
(2, 101, 2, '2024-05-10', '2024-06-10'),
(3, 102, 3, '2024-04-01', null),
(4, 102, 4, '2024-06-20', null),
(5, 103, 5, '2024-05-01', null),
(6, 103, 3, '2024-05-15', '2024-06-01'),
(7, 104, 2, '2024-06-15', null),
(8, 104, 3, '2024-06-20', null),
(9, 104, 1, '2024-07-01', null);

-- Information retrievel Queries
-- Retrieve a list of books currently borrowed by a specific member
select b.title
from borrowingrecords br
join books b on br.book_id = b.book_id
where br.member_id = 103 and br.return_date is null;

-- Find members who have overdue books (borrowed more than 30 days ago, not returned).
select distinct m.name, m.email
from borrowingrecords br
join members m on br.member_id = m.member_id
where br.return_date is null and br.borrow_date < current_date - interval '30' day;

-- Retrieve books by genre along with the count of available copies
select genre, count(*) as total_books, sum(available_copies) as total_available
from books
group by genre;

-- Find the most borrowed books overall
select b.title, count(*) as times_borrowed
from borrowingrecords br
join books b on br.book_id = b.book_id
group by b.title
order by times_borrowed desc
limit 1;

-- Retrieve members who have borrowed books from at least three different genres
select m.name, count(distinct b.genre) as genres_borrowed
from borrowingrecords br
join members m on br.member_id = m.member_id
join books b on br.book_id = b.book_id
group by m.name
having count(distinct b.genre) >= 3;

-- Reporting and Analytics
-- Calculate the total number of books borrowed per month
select 
  date_format(borrow_date, '%Y-%m') as month,
  count(*) as total_borrowed
from borrowingrecords
group by date_format(borrow_date, '%Y-%m')
order by month;

-- Find the top three most active members based on the number of books borrowed
select m.name, count(*) as total_borrowed
from borrowingrecords br
join members m on br.member_id = m.member_id
group by m.name
order by total_borrowed desc
limit 3;

-- Retrieve authors whose books have been borrowed at least 10 times
select b.author, count(*) as times_borrowed
from borrowingrecords br
join books b on br.book_id = b.book_id
group by b.author
having count(*) >= 10;

-- Identify members who have never borrowed a book
select m.name
from members m
left join borrowingrecords br on m.member_id = br.member_id
where br.member_id is null;
