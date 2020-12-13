/*
1. The three main purposes of a database is to store data effieciently, have the ability to find data quickly, and to maintain integrity of data.
2. A table can hold many types of attributes associated with an entity. One example is a table can be about a book and hold the author's name, publish date, publisher, and genre of the book.
3. The three types of relationships are one-to-one, many-to-many, and one-to-many. One example of a one-to-one relationship is: One person has one toothbrush and a toothbrush only has one person that uses it.
4. 1) Given
   2) Orders and OrderItems have a one-to-many relationship. (Foreign key: OrderID) One order can have many order items. One order item belongs to one order.
   3) OrderItems and Products have a one-to-many relationship. (Foreign key: ProductID) One product can be in many order items. One order item can only be one product.
   4) Products and Categories have a one-to-many relationship. (Foreign key: CategoryID) One category can contain many products. One product can only be in one category.
   5) Customers and Addresses have a one-to-many relationship. (Foreign key: CustomerID) One customer can have many addresses. One address is associated with one customer.
*/

Use MyGuitarShop

Select ProductCode, ProductName, ListPrice, DiscountPercent from Products order by ListPrice desc

Select LastName + ', ' + FirstName as FullName from Customers where LastName Like '[M-Z]%' order by LastName

Select ProductName, ListPrice, DiscountPercent, ListPrice * (DiscountPercent / 100) as DiscountAmount,
ListPrice - (ListPrice * (DiscountPercent / 100)) as DiscountPrice from Products order by DiscountPrice desc

Select ItemID, ItemPrice, DiscountAmount, Quantity, ItemPrice * Quantity as ItemTotal,
DiscountAmount * Quantity as DiscountTotal, (ItemPrice - DiscountAmount) * Quantity as DiscountItemTotal from OrderItems
where ItemPrice * Quantity > 500 order by ItemTotal desc

Select OrderID, OrderDate, Shipdate from Orders where ShipDate is null

Select ListPrice * .07 as TaxAmount, ListPRice + (ListPrice * .07) as TotalPrice from Products