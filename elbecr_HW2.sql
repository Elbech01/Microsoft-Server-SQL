Use MyGuitarShop

-- 1)
Select CategoryName, ProductName, ListPrice 
from Categories Join Products On Categories.CategoryID = Products.CategoryID
order by CategoryName, ProductName

-- 2)
Select FirstName, LastName, Line1, City, State, ZipCode 
from Customers Join Addresses On Customers.CustomerID = Addresses.CustomerID

Select EmailAddress, Line1 as 'Addresses'
from Customers Join Addresses On Customers.CustomerID = Addresses.CustomerID
where EmailAddress like 'tennaco@gmail.com'

-- 3)
Select FirstName, LastName, Line1, City, State, ZipCode 
from Customers Join Addresses On Customers.CustomerID = Addresses.CustomerID
where  AddressID <> BillingAddressID

-- 4)
Select LastName, FirstName, OrderDate, ProductName, ItemPrice, DiscountAmount, Quantity from Customers as C Join Orders as O on C.CustomerID = O.CustomerID 
Join OrderItems as OI On O.OrderID = OI.OrderID Join Products as P ON OI.ProductID = P.ProductID
where LastName Like 'M%r' or LastName Like 'F%r'
order by LastName, OrderDate, ProductName

-- 5)
Select LastName, FirstName, ProductName, ItemPrice, DiscountAmount, Quantity, ItemPrice - DiscountAmount as DiscountItemPrice, (ItemPrice - DiscountAmount) * Quantity as TotalItemPrice
from Customers Join Orders On Customers.CustomerID = Orders.CustomerID Join OrderItems On Orders.OrderID = OrderItems.OrderID Join Products On OrderItems.ProductID = Products.ProductID
where DiscountAmount = 0
order by LastName, ProductName

-- 6)
Select CategoryName, ProductID from Products Full Join Categories On Products.CategoryID = Categories.CategoryID
where ProductID is Null

-- 7)
Select Count(*) as NumOrders, Sum(TaxAmount) as TotalTax from Orders

-- 8)
Select Count(*) as TotalProducts, Avg(ListPrice) as AveragePrice, Min(ListPrice) as MinimumPrice, Max(ListPrice) as MaximumPrice from Products

-- 9)
Select * from OrderItems where Quantity > 1

Select Count(Distinct ProductID) as UniqueItems from OrderItems where Quantity > 1