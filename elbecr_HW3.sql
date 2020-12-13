Use MyGuitarShop

-- 1)
Select CategoryName, Count(ProductID) as NumProducts, Max(ListPrice) as HighestPrice 
from Categories Join Products On Categories.CategoryID = Products.CategoryID
group by CategoryName order by Max(ListPrice) desc

-- 2)
Select EmailAddress, Sum(ItemPrice * Quantity) as SumOfItems, Sum(DiscountAmount * Quantity) as SumDiscountedItems
from Customers Join Orders On Customers.CustomerID = Orders.CustomerID Join OrderItems On Orders.OrderID = OrderItems.OrderID
group by EmailAddress order by Sum(ItemPrice) desc

-- 3)
Select EmailAddress, Sum(ItemPrice * Quantity) as SumOfItems, Sum(DiscountAmount * Quantity) as SumDiscountedItems
from Customers Join Orders On Customers.CustomerID = Orders.CustomerID Join OrderItems On Orders.OrderID = OrderItems.OrderID
where ItemPrice > 400 group by EmailAddress order by Sum(ItemPrice) desc

-- 4)
Select EmailAddress, Count(Distinct Orders.OrderID) as NumOrders, Sum((ItemPrice - DiscountAmount) * Quantity) as TotalPrice
from Customers Join Orders on Customers.CustomerID = Orders.CustomerID Join OrderItems On Orders.OrderID = OrderItems.OrderID
group by EmailAddress having Count(Distinct Orders.OrderID) > 1 order by Sum((ItemPrice * Quantity) - (DiscountAmount * Quantity)) desc

-- 5)
Select ProductName, Sum((ItemPrice - DiscountAmount) * Quantity) as TotalAmount
from Products Join OrderItems on Products.ProductID = OrderItems.ProductID 
group by ProductName order by TotalAmount desc

-- 6)
Select EmailAddress, Count(Distinct ProductID) as NumProductsOrdered
from Customers Join Orders on Customers.CustomerID = Orders.CustomerID Join OrderItems On Orders.OrderID = OrderItems.OrderID
group by EmailAddress having Count(Distinct ProductID) > 1 order by NumProductsOrdered

-- 7)
-- a) 
Insert Into Categories Values ('Brass')
-- b)
Update Categories set CategoryName = 'Woodwinds' where CategoryName = 'Brass'
-- c)
Delete Categories where CategoryName = 'Woodwinds'

-- 8)
-- a)
Insert Into Products ([CategoryID], [ProductCode], [ProductName], [Description], [ListPrice], [DiscountPercent], [DateAdded])
Values (4, 'dgx_640', 'Yamaha DGX 640 88-Key Piano', 'Long Description to Coem', 799.99, 0, GETDATE())
-- b)
Update Products set DiscountPercent = .35 where ProductCode = 'dgx_640'
-- c)
Delete Categories where CategoryID = 4 
-- Cannot delete because there is a reference to this category from another table
-- You would have to dereference all data from the Categories table with that CategoryID

-- 9)
-- a)
Insert Into Customers ([EmailAddress], [Password], [FirstName], [LastName])
Values ('rick@raven.com', '', 'Rick', 'Raven')
-- b)
Update Customers set Password = 'secret' where EmailAddress = 'rick@raven.com'
-- c)
Update Customers set Password = 'reset' 