-- 1)
-- a)
Create View CustomerAddresses as 
Select Cust.CustomerID, EmailAddress, LastName, FirstName, BillAddresses.Line1 as BillLine1, BillAddresses.Line2 as BillLine2, BillAddresses.City as BillCity, 
BillAddresses.State as BillState, BillAddresses.ZipCode as BillZip, ShipAddresses.Line1 as ShipLine1, ShipAddresses.Line2 as ShipLine2, ShipAddresses.City as ShipCity,
ShipAddresses.State as ShipState, ShipAddresses.ZipCode as ShipZip
from Customers as Cust Join Addresses as BillAddresses On Cust.BillingAddressID  = BillAddresses.AddressID Join Addresses as ShipAddresses On Cust.ShippingAddressID = ShipAddresses.AddressID

-- b)
Select CustomerID, LastName, FirstName, BillLine1 from CustomerAddresses

-- c)
Update CustomerAddresses Set ShipLine1 = '1990 Westwood Blvd.' where CustomerID = 8

-- 2)
Create View OrderItemProducts as
Select Orders.OrderID, OrderDate, TaxAmount, ShipDate, ItemPrice, DiscountAmount, (ItemPrice - DiscountAmount) as DiscountItemPrice, Quantity, ((ItemPrice - DiscountAmount) * Quantity) as ItemTotal, ProductName
from Orders Join OrderItems on Orders.OrderID = OrderItems.OrderID Join Products On OrderItems.ProductID = Products.ProductID

-- 3)
Create View ProductSummary as
Select ProductName, Count(OrderID) as OrderCount, Sum(ItemTotal) as OrderTotal
from OrderItemProducts group by ProductName

-- 4)
Select Top 3 * From ProductSummary order by OrderCount desc