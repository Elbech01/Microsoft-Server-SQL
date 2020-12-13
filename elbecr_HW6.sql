-- 1)
IF OBJECT_ID('spInsertProduct') IS NOT NULL
    DROP PROC spInsertProduct
go
 
Create Proc spInsertProduct
    @CategoryID int,
    @ProductCode varchar(10),
    @ProductName varchar(255),
    @ListPrice money,
    @DiscountPercent money
as
    If @ListPrice >= 0 And @DiscountPercent >= 0
    Begin
    Insert Products (CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, DateAdded)
    Values (@CategoryID, @ProductCode, @ProductName, ' ', @ListPrice, @DiscountPercent, GetDate());
    End
 
    Else
    Throw 55050, 'You cannot have negative numbers!', 1
go
 
Exec spInsertProduct @CategoryID = 3, @ProductCode = 'ProdPass2', @ProductName = 'RealProduct', @ListPrice = 474.25, @DiscountPercent = 42.25
Exec spInsertProduct @CategoryID = 3, @ProductCode = 'ProdFail', @ProductName = 'FakeProduct', @ListPrice = 856.73, @DiscountPercent = -270.00

-- 2)
IF OBJECT_ID('spUpdateProductDiscount') IS NOT NULL
    DROP PROC spUpdateProductDiscount
go
 
Create Proc spUpdateProductDiscount
    @ProductID int,
    @DiscountPercent money
as 
    If @DiscountPercent >= 0 Or @ProductID = (Select ProductID from Products where ProductID = @ProductID)
    Update Products
    set DiscountPercent = @DiscountPercent
    where ProductID = @ProductID
 
    Else
    Throw 53754, 'DiscountPercent cannot be negative and ProductID must be valid!', 1
 
go

Exec spUpdateProductDiscount @ProductID = 8, @DiscountPercent = 100.00
Exec spUpdateProductDiscount @ProductID = 918, @DiscountPercent = 2422.12
 
-- 3)
IF OBJECT_ID('Products_INSERT') is not null
    DROP TRIGGER Products_INSERT
go

Create Trigger Products_INSERT
    on Products
    After Insert
as
    Update Products
    set DateAdded = GetDate()
    where DateAdded is null
 
INSERT INTO Products (CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent)
VALUES (1, 'G5122', 'Gretsch G5122 Double Cutaway Hollowbody', '', 999.99, 32);

Select * from Products
 
-- 4)
IF OBJECT_ID('Products_UPDATE') is not null
    DROP TRIGGER Products_UPDATE
go

Create Trigger Products_UPDATE
    on Products
    Instead of UPDATE
as
    Declare @DiscountPercent money
    set @DiscountPercent = (Select DiscountPercent from Inserted)
   
    If @DiscountPercent < 0
    Throw 55374, 'DiscountPercent cannot be negative!', 1
	
    If @DiscountPercent > 100
    Throw 55375, 'DiscountPercent must be less than 100!', 1
	
    If @DiscountPercent < 1
    set @DiscountPercent = @DiscountPercent * 100

    If @DiscountPercent >= 1 and @DiscountPercent < 100
    Update Products
    set DiscountPercent = @DiscountPercent
    where ProductID = 1
 
UPDATE Products
SET DiscountPercent = -10.0
WHERE ProductID = 1;
UPDATE Products
SET DiscountPercent = 120.0
WHERE ProductID = 1;
UPDATE Products
SET DiscountPercent = .25
WHERE ProductID = 1;
Select DiscountPercent from Products where DiscountPercent = 25
UPDATE Products
SET DiscountPercent = 50
WHERE ProductID = 1;
Select DiscountPercent from Products where DiscountPercent = 50
 
-- 5)
Create Role OrderEntry
 
Grant Insert, Update on Orders to OrderEntry

Grant Insert, Update on OrderItems to OrderEntry

Grant Select to OrderEntry
 
-- 6)
Create Login RobertHalliday
    with Password = 'HelloBob',
    Default_Database = MyGuitarShop
 
Create User RobertHalliday for login RobertHalliday
Alter Role OrderEntry add Member RobertHalliday
 
-- 7)
Alter Role OrderEntry drop Member RobertHalliday
Drop Role OrderEntry
 
-- 8)
-- A) A server role is a role that applies to all databases in the server.
-- ex) The admin role of a server would have access to all databases in the server.
-- B) A databse role is a role that applies to a specific database, not all databases
-- ex) The database owner role would have access to everything in the database, but not other databases