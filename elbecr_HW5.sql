-- 1)
Declare @DistinctCount int
Select @DistinctCount = (Select Count(Distinct OrderID)) from Orders

Declare @TotalSales smallmoney
Select @TotalSales = (Select Sum((ItemPrice - DiscountAmount) * Quantity)) from OrderItems

Declare @AverageSales money
Select @AverageSales = (Select @TotalSales/@DistinctCount)
Print @AverageSales

-- 2)
Declare @ProductsCount int
Select @ProductsCount = (Select Count(ProductID) From Products)

Declare @AverageListPrice smallmoney
Select @AverageListPrice = (Select Sum(ListPrice/@ProductsCount) from Products)
If @ProductsCount >= 7
	Begin
	Print 'Number of Products: ' + Convert(varchar, @ProductsCount)
	Print 'Average List Price: ' + Convert(varchar, @AverageListPrice)
	End
Else
	Print 'There are less than 7 Products'

-- 3)
Declare @TopOrderCustomer varchar(50)
 Select Top 1 @TopOrderCustomer = FirstName + ' ' +  LastName From Customers Join Orders on Customers.CustomerID = Orders.CustomerID 
 Join OrderItems on Orders.OrderID = OrderItems.OrderID
 Order By (ItemPrice - DiscountAmount) * Quantity desc
 Declare @HighPrice money
 Select Top 1 @HighPrice = (ItemPrice-DiscountAmount)*Quantity From Customers Join Orders on Customers.CustomerID = Orders.CustomerID 
 Join OrderItems on Orders.OrderID = OrderItems.OrderID
 Order By (ItemPrice - DiscountAmount) * Quantity desc
 Print 'The largest order was ' + Convert(varchar(50), @HighPrice) + ' by ' + @TopOrderCustomer

 -- 4)
Begin Try
Insert Categories
Values ('Guitars')
Print 'SUCCESS: Record was inserted.'
End Try
Begin Catch
Print 'FAILURE: Record was not inserted.'
Print 'Error ' + Convert(varchar, ERROR_NUMBER()) + ': ' + ERROR_MESSAGE();
End Catch

-- 5)
go
Create Proc findAverageSales
	@AverageSales money OUTPUT
As
	Set @AverageSales = (Select Sum((ItemPrice - DiscountAmount) * Quantity)/Count(Distinct Orders.OrderID) from OrderItems Join Orders on OrderItems.OrderID = Orders.OrderID)
	
	Declare @AverageSalesOut money
	Exec findAverageSales
	@AverageSales = @AverageSalesOut Output
	Print @AverageSalesOut

-- 6)
go
Create Proc spInsertCategory
	@NameOfCategory varchar(50)
As
Begin Try
Insert Categories 
Values (@NameOfCategory)
Print 'SUCCESS: Record was inserted.'
End Try
Begin Catch
Print 'FAILURE: Record was not inserted'
End Catch
-- Valid name
Exec spInsertCategory Saxophones
-- Invalid name
Exec spInsertCategory Guitars