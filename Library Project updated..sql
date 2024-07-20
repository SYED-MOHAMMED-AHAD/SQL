create database library;

use library;

create table library_branch (
	branchID int primary key auto_increment,
	branch_name varchar (255)  ,
    branch_address varchar (255));
    
    

  
  create table Authors (
	authorID int primary key auto_increment,
	Book_Id int ,
	Author_name varchar(255),
    foreign key (book_id) references books(book_id)
    on delete cascade
    on update cascade
  );
     
    
    create table borrower (
		card_no int primary key auto_increment ,
        Borrower_name varchar (255) ,
        Borrower_Address varchar(255) ,
        Borrower_Phone varchar(255)
        );
    

    
    create table Books (
		Book_Id int primary key auto_increment,
        Book_Title varchar (255),
        PublisherName varchar (255),
		foreign key (PublisherName) references publisher (PublisherName)
        on delete cascade
		on update cascade
    );
    
create table publisher (
		PublisherName varchar(255) primary key,
        PublisherAddress varchar(255),
        PublisherPhone varchar (255));
      
      

create table Books_Loan (
	loanID int primary key auto_increment,
	Book_Id int ,
	foreign key (Book_Id) references books(Book_Id)   on delete cascade on update cascade,
	branchID int, 
    foreign key (branchID) references library_branch (branchID) on delete cascade on update cascade,
	card_no int ,
	foreign key (Card_no) references borrower (Card_no) on delete cascade on update cascade,
    Date_Out Date,
    Due_Date Date
);
    

create table Copies (
	copiesID int primary key auto_increment,
	Book_Id int ,
	foreign key (Book_Id) references books(Book_Id ) on delete cascade on update cascade,
    branchID int ,
    foreign key (branchID) references library_branch (branchID) on delete cascade on update cascade,
    No_Of_Copies int
);
  
select * from Copies; 
select * from Books_Loan;
select * from Books; 
select * from borrower; 
select * from library_branch;
select * from authors;
select * from publisher;



-- 1)  How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
 
select book_title,sum(no_of_copies) as copies,branch_name from library_branch
left join copies on library_branch.branchid = copies.branchid
left join books on copies.book_id = books.book_id
where branch_name = "Sharpstown" and book_title = 'the lost tribe';


-- 2)  How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select branch_name,book_title,sum(no_of_copies) as copies_ from library_branch lb
left join copies co on lb.branchId = co.branchID
left join books on co.book_id = books.book_id
where  book_title='The Lost Tribe' 
group by branch_name,book_title;

-- 3) Retrieve the names of all borrowers who do not have any books checked out.

select borrower_name from borrower 
where card_no not in (select card_no from books_loan);

-- 4) For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, 
 --  the borrower's name, and the borrower's address. 


select branch_name,Book_Title,Borrower_name,Borrower_Address from library_branch lb
left join books_loan bl on  lb.branchID = bl.branchID
left join borrower br on  bl.card_no = br.card_no 
left join books on bl.Book_Id = books.Book_Id
where branch_name = 'Sharpstown' and Due_Date = '2018-02-03' ;


-- 5)  For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select branch_name, count(*) as books_loand from library_branch lb
left join books_loan bl on  lb.branchID = bl.branchID
group by branch_name;


-- 6) Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

select Borrower_name,Borrower_Address,count(*) as checked_out from borrower br
left join books_loan bl on br.card_no = bl.card_no 
group by Borrower_name,Borrower_Address
having count(*) > 5 ;

-- 7) For each book authored by "Stephen King", 
-- retrieve the title and the number of copies owned by the library branch whose name is "Central".


SELECT b.Book_Title, c.No_Of_Copies
FROM Books b
left JOIN Authors a ON b.Book_Id = a.Book_Id
left JOIN Copies c ON b.Book_Id = c.Book_Id
left JOIN library_branch lb ON c.branchID = lb.branchID
WHERE a.Author_name = 'Stephen King'
AND lb.branch_name = 'Central';











