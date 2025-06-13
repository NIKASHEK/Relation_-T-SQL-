--JOIN TSQL2012
USE TSQL2012
GO

SELECT * FROM [dbo].[Nums]
SELECT * FROM [HR].[Employees]
SELECT * FROM [Production].[Categories]
SELECT * FROM [Production].[Products]
SELECT * FROM [Production].[Suppliers]
SELECT * FROM [Sales].[Customers]
SELECT * FROM [Sales].[OrderDetails]
SELECT * FROM [Sales].[Orders]
SELECT * FROM [Sales].[Shippers]
SELECT * FROM [Stats].[Scores]
SELECT * FROM [Stats].[Tests]

--1
SELECT contactname, city, orderdate FROM [Sales].[Customers] c
JOIN [Sales].[Orders] o  on c.custid = o.custid
WHERE city in ('Madrid', 'London')

--2
SELECT UPPER(productname) as ProductName, unitprice, categoryname FROM [Production].[Products] p
JOIN [Production].[Categories] ca on p.categoryid = ca.categoryid
WHERE P.unitprice between 20 and 40

--3
SELECT  lastname, firstname, orderid FROM [HR].[Employees] e
JOIN [Sales].[Orders] o on e.empid = o.empid
WHERE e.title = 'Sales Manager' 
and 
o.freight > 50

--4
SELECT o.orderdate, c.contactname, c.city, c.address FROM [Sales].[Customers] c
JOIN [Sales].[Orders] o on c.custid = o.custid
WHERE c.country = 'USA'
and 
YEAR(O.orderdate) = 2007

--5
SELECT distinct c.city FROM [Sales].[Customers] c   --SELECT  city  FROM [Sales].[Customers] group by city   <-(Secon way for not repeating city)
JOIN [Sales].[Orders] o on c.custid = o.custid
JOIN [HR].[Employees] e on o.empid = e.empid
WHERE e.lastname = 'Cameron'

--6
SELECT orderid, shipcountry, shipcity
FROM [Sales].[Orders]
WHERE shipcountry in ('Germany', 'Austria')

--7
SELECT * FROM [Production].[Products] p
JOIN [Production].[Suppliers] s on p.supplierid = s.supplierid
JOIN [Sales].[OrderDetails] o on p.productid = o.productid
WHERE  o.discount > 0
And
s.city = 'Tokyo'

--8
SELECT c.categoryname, p.productname FROM [Production].[Categories] c
JOIN [Production].[Products] p on c.categoryid = p.categoryid
JOIN [Production].[Suppliers] s on p.supplierid = s.supplierid
WHERE s.country = 'Japan'
and
(c.description like '%fish%' or c.description like '%soft drinks%') -- (for like one condition)

--9
SELECT e.firstname, e.lastname, s.companyname FROM [HR].[Employees] e
JOIN [Sales].[Orders] o on e.empid = o.empid
JOIN [Sales].[Shippers] s on o.shipperid = s.shipperid
WHERE YEAR(o.orderdate) = 2007
and
e.firstname in ('Sara', 'Maria')
and
e.lastname in ('Davis', 'Cameron')

--10
SELECT p.productname, c.categoryname FROM [Production].[Products] p
JOIN [Production].[Suppliers] s on p.supplierid = s.supplierid
JOIN [Production].[Categories] c on p.categoryid = c.categoryid
WHERE s.country = 'USA'
and
c.categoryname not in ('Beverages', 'Seafood')

--11
SELECT o.orderid, e.lastname, e.firstname,e.City, c.contactname FROM [Sales].[Orders] o
JOIN [HR].[Employees] e on o.empid = e.empid
JOIN [Sales].[Customers] c on c.custid = o.custid
WHERE e.city = c.city

--12
SELECT distinct c.contactname FROM [Sales].[Customers] c
JOIN [Sales].[Orders] o on c.custid =o.custid
JOIN [Sales].[OrderDetails] od on o.orderid = od.orderid
JOIN [Production].[Products] p on od.productid = p.productid
JOIN [Production].[Categories] ca on p.categoryid = ca.categoryid
WHERE categoryname in ('Beverages', 'Dairy Products')

------------------------------------------------------------------------------------------------------
-- (SUBQUERY) HARDWARE
USE [Hardware]
GO

SELECT * FROM [dbo].[Manufacturers]
SELECT * FROM [dbo].[Products]

--1	
SELECT Name, Price FROM Products
WHERE ManufacturerId in (SELECT ManufacturerId FROM Manufacturers Where Name = 'Hewlett-Packard')

--2
SELECT Name, Price from Products
Where ManufacturerId not in (SELECT ManufacturerId FROM Manufacturers WHere Name = 'Fujitsu')

--3
SELECT Name, Price FROM Products
WHERE ManufacturerId in (SELECT ManufacturerId FROM Manufacturers where Name in ('Sony', 'Fujitsu', 'IBM', 'Intel'))

--4
SELECT Name FROM [dbo].[Manufacturers]
WHERE ManufacturerId IN (SELECT ManufacturerId FROM [dbo].[Products] WHERE  Price > 200)

--5
SELECT Name, Price FROM Products
WHERE ManufacturerId not in (SELECT ManufacturerId FROM Manufacturers WHERE Name in ('GENIUSM', 'DELL'))

--6
SELECT Count(*)  as Manufacturers FROM [Manufacturers] WHERE ManufacturerId  in (SELECT ManufacturerId FROM Products WHERE Name Like '%drive%')

--7
SELECT Count(*) as ProductAmount FROM Products 
WHERE ManufacturerId in (SELECT ManufacturerId FROM [Manufacturers] WHERE Name = 'Intel')
AND
Price > (SELECT AVG(Price) FROM Products WHERE ManufacturerId = (SELECT ManufacturerId FROM [Manufacturers] where Name = 'Intel'))


----------------------------------------------------------------------------------------------------------------------------------------
--(SUBQUERY) WorldEvents
Use WorldEvents
GO

SELECT * FROM [dbo].[Category]
SELECT * FROM [dbo].[Continent]
SELECT * FROM [dbo].[Country]
SELECT * FROM [dbo].[Event]

--1
SELECT Count(*) as EventsAmountInEurope FROM [dbo].[Event]
WHERE CountryID in (SELECT CountryID FROM Country WHERE ContinentId in (Select ContinentId FROM [Continent] WHERE  CONtinentName = 'EUROPE'))

--2
SELECT TOP 1 EventDate FROM [dbo].[Event]
WHERE CountryID in (SELECT CountryID FROM [dbo].[Country]
WHERE ContinentID in (SELECT ContinentID FROM [dbo].[Continent] 
WHERE ContinentName = 'Africa')) order by EventDate

--3
SELECT COUNT(*) as CountryAmountInAmerica FROM [dbo].[Country]
WHERE ContinentID in (SELECT ContinentID FROM [dbo].[Continent] WHERE ContinentName like '%America%')

--4
SELECT COUNT(*) as NewYearEventsAmount FROM [dbo].[Event] e
WHERE CategoryID in (SELECT CategoryID FROM [dbo].[Category] WHERE CategoryName = 'Economy')
AND
DAY(e.EventDate) = '01'
AND
MONTH(e.EventDate) = '01'

--5
SELECT TOP 1 EventDate FROM [dbo].[Event] 
WHERE CountryID in (SELECT CountryID FROM [dbo].[Country] 
WHERE ContinentID in (SELECT ContinentID FROM [dbo].[Continent] WHERE ContinentName = 'Europe'))
AND
CategoryID in (SELECT CategoryID FROM [dbo].[Category] WHERE CategoryName = 'Sports')
ORDER BY EventDate DESC 