-- Part A
Use Master
Go
If DB_ID('Library') Is Not Null
	Drop Database Library

Create Database Library
Go
Use Library

If Object_ID('Readers') Is Not Null
	Drop Table Readers
If Object_ID('BorrowerInfo') Is Not Null
	Drop Table BorrowerInfo
If Object_ID('Books') Is Not Null
	Drop Table Books
If Object_ID('BookInfo') Is Not Null
	Drop Table BookInfo
If Object_ID('BookCategory') Is Not Null
	Drop Table BookCategory

If Object_ID('Sequence1') Is Not Null
	Drop Sequence Sequence1

Go

Create Table BookCategory(
BookCategoryID Int Primary Key Identity(1,1),
BookCategoryName Varchar(100) Not Null,
Memo Varchar(100) Null)

Create Table BookInfo(
ISBN Bigint Primary Key Not Null Check (Len(ISBN)=10 or Len(ISBN)=13),
BookCategoryID Int Foreign Key References BookCategory(BookCategoryID),
BookName Varchar(100) Not Null,
BookAuthor Varchar(100) Not Null,
BookPublisher Varchar(100) Not Null,
BookPubDate smalldatetime Not Null,
BookPages int Not Null Check (BookPages > 0),
BookPrice smallmoney Not Null Check (BookPrice > 0),
CopiesNo int Not Null Default 1 Check (CopiesNo > 0),
Memo Varchar(100) Null)

Create Table Books(
BookID Int Primary Key Identity(1,1),
ISBN Bigint References BookInfo(ISBN),
BookInDate smalldatetime Not Null,
Memo varchar(100) Null)

Create Table Readers(
ReaderNo Int Primary Key Identity(1,1),
ReaderName varchar(100) Not Null,
AccountCreated smalldatetime Default GetDate() Not Null,
ReaderMemo varchar(100) Null)

Create table BorrowerInfo(
BorrowID Int Primary Key,
ReaderNo Int Foreign Key References Readers(ReaderNo),
BookID Int References Books(BookID),
BorrowDate smalldatetime Default GetDate() Not Null,
ReturnDate smalldatetime Null,
ActualReturnDate smalldatetime Null,
Memo varchar(100) Null)

Go

Create NonClustered Index ix_BookCategoryName on BookCategory(BookCategoryName) -- Frequently searched
Create NonClustered Index ix_BookCategoryID on BookInfo(BookCategoryID) -- Foreign key
Create NonClustered Index ix_ISBN on Books(ISBN) -- Foreign key
Create NonClustered Index ix_ReaderNo on BorrowerInfo(ReaderNo) -- Foreign key
Create NonClustered Index ix_ReaderName on Readers(ReaderName) -- Frequently searched

Go

Insert Into BookCategory Values(1, 'Science and Technology')
Insert Into BookCategory Values(2, 'Computers and Technology, Biography')

insert Into Readers (ReaderName) Values  ('John Doe')
Insert Into Readers (ReaderName) Values ('Susan Smith')

Insert Into BookInfo Values (9780393248968, 1, 'Storm in a Teacup: The Physics of Everyday Life', 
'Helen Czerski', 'W. W. Norton & Company', '1-1-2017', 288, 26.95, 4, null)
Insert Into BookInfo Values (9780062328502, 1, 'Dark Matter and the Dinosaurs: The Astounding interconnectedness of the Universe', 
'Lisa Randall', 'Ecco', '10-18-2016', 432, 17.99, 2, null)
Insert Into BookInfo Values (9780262517263, 2, 'Grace Hopper and the Invention of the Information Age', 
'Kurt Beyer', 'MIT Press', '2-1-2012', 404, 27.95, 2, null)

Insert into Books Values(9780393248968, '1-10-2017', null)
Insert into Books Values(9780393248968, '1-10-2017', null)
Insert into Books Values(9780393248968, '1-10-2017', null)
Insert into Books Values(9780393248968, '1-10-2017', null)
Insert Into Books Values(9780062328502, '10-18-2016', null)
Insert Into Books Values(9780062328502, '10-18-2016', null)
Insert Into Books Values(9780262517263, '2-1-2012', null)
Insert Into Books Values(9780262517263, '2-1-2012', null)

Insert Into BorrowerInfo Values(12, 1, 1, '2-11-2020', '3-11-2020', '3-3-2020', null)
Insert Into BorrowerInfo Values(13, 1, 7, '3-11-2020', '4-11-2020', '4-9-2020', null)
Insert Into BorrowerInfo Values(19, 2, 3, '3-1-2020', '4-1-2020', null, null)
Insert Into BorrowerInfo Values(20, 2, 8, '4-4-2020', '5-4-2020', null, null)

-- Part B

Go
If Object_ID ('ShowAllBooksBorrowed') Is Not Null
	Drop View ShowALlBooksBorrowed
Go
	Create View ShowAllBooksBorrowed As 
	Select BookName, BookInfo.ISBN, BookCategoryName, BookAuthor, BorrowDate, ReturnDate, ActualReturnDate from BookCategory 
	Join BookInfo on BookCategory.BookCategoryID = BookInfo.BookCategoryID Join Books On BookInfo.ISBn = Books.ISBN Join BorrowerInfo 
	On Books.BookID = BorrowerInfo.BookID Join Readers On BorrowerInfo.ReaderNo = Readers.ReaderNo where ActualReturnDate Is Null
Go
If Object_ID ('ShowReaders') Is Not Null
	Drop View ShowReaders
Go
	Create View ShowReaders As
	Select Readers.ReaderNo, Count(BorrowerInfo.ReaderNo) as NumberBorrowed From Readers Join BorrowerInfo On Readers.ReaderNo = BorrowerInfo.ReaderNo group by Readers.ReaderNo
Go
If Object_ID ('FindABookbyISBN') Is Not Null
	Drop Procedure FindABookbyISBN
Go
	Create Proc FindABookbyISBN 
	@value varchar(20)
	As
	If @value = (Select ISBN From BookInfo where ISBN = @value)
	Begin
	Select * From BookInfo where ISBN = @value
	Print 'Found book with ISBN: ' + @value
	Return 1
	End
	Else
	Begin
	Print 'Unable to find the book with ISBN: ' + @value
	Return 0
	End
	
If Object_ID ('InsteadTrigger') Is Not Null
	Drop Trigger InsteadTrigger
Go
	Create Trigger InsteadTrigger On Books Instead Of Insert As
	Declare @BookID Int,
			@ISBN BigInt,
			@BookInDate smalldatetime,
			@Memo varchar(100),
			@CopiesNo int, 
			@TestRowCount int
	Set @TestRowCount = (Select Count(*) from Inserted)
	If @TestRowCount = 1
		Begin
		Set @ISBN = (Select ISBN from inserted)
		Set @BookInDate = (Select BookInDate from inserted)
		Set @Memo = (Select Memo from inserted)
		Set @CopiesNo = (Select CopiesNo From BookInfo where ISBN = @ISBN)
		If ((Select Count(ISBN) from Books where ISBN = @ISBN group by ISBN) > @CopiesNo)
		Throw 57039, 'There are too many copies of this book!', 1
		Else
		Begin
		Insert Books 
		(ISBN, BookInDate, Memo) 
		Values (@ISBN, @BookInDate, @Memo)
		Print 'Insertion completed!'
		End
	End
	Else
		Throw 55186, 'Limit Insert to a single row.', 1
	Go
-- Part C

Create Login Librarian
With Password = 'book123',
Check_Policy = Off,
Default_Database = Library

Create User Librarian for Login Librarian

Alter Role db_datareader Add Member Librarian

Drop User Librarian
Drop Login Librarian

--Part D

/*REMOVE THIS COMMENT BLOCK TO TEST

	-- All tables
	Select * From BookCategory
	Select * From Readers
	Select * From Books
	Select * From BookInfo
	Select * From BorrowerInfo

	--Check Constraints
	--ISBN Length at 11
	Insert Into BookInfo Values (12345678912, 1, 'Storm in a Teacup: The Physics of Everyday Life', 
	'Helen Czerski', 'W. W. Norton & Company', '1-1-2017', 288, 26.95, 4, null)
	--ISBN Length at 12
	Insert Into BookInfo Values (123456789123, 1, 'Storm in a Teacup: The Physics of Everyday Life', 
	'Helen Czerski', 'W. W. Norton & Company', '1-1-2017', 288, 26.95, 4, null)
	--Pages less than 0
	Insert Into BookInfo Values (9780313248968, 1, 'Storm in a Teacup: The Physics of Everyday Life', 
	'Helen Czerski', 'W. W. Norton & Company', '1-1-2017', -288, 26.95, 4, null)
	--BookPrice less than 0
	Insert Into BookInfo Values (9780313248968, 1, 'Storm in a Teacup: The Physics of Everyday Life', 
	'Helen Czerski', 'W. W. Norton & Company', '1-1-2017', -288, -26.95, 4, null)
	--CopiesNo less than 0
	Insert Into BookInfo Values (9780313248968, 1, 'Storm in a Teacup: The Physics of Everyday Life', 
	'Helen Czerski', 'W. W. Norton & Company', '1-1-2017', -288, 26.95, -4, null)

	--Views
	Select * From ShowAllBooksBorrowed
	Select * From ShowReaders

	-- Procedure Exec Good
	Declare @GoodExec varchar(100)
	Exec @GoodExec = FindABookbyISBN 9780393248968
	Print @GoodExec
	-- Procedure Exec Bad
	Declare @BadExec varchar(100)
	Exec @BadExec = FindABookbyISBN 1234
	Print @BadExec

	--Trigger Test
	Insert into Books Values(9780393248968, '1-10-2017', null)
*/