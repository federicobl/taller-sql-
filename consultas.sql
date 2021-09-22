--1.	Traer el FirstName y LastName de Person.Person cuando el FirstName sea Mark.

	select FirstName, LastName from Person.Person 
	where FirstName = 'Mark';

--2.	¿Cuántas filas hay dentro de Person.Person?

	select count(*) from Person.Person;

--3.	Traer las 100 primeras filas de Production.Product donde el ListPrice no es 0

	select top 100* from Production.Product 
	where ListPrice <> 0;
--4.	Traer todas las filas de de HumanResources.vEmployee donde los apellidos de los empleados empiecen con una letra inferior a “D”
	
	select * from HumanResources.vEmployee 
	where SUBSTRING(LastName,1,1) <> 'd';

--5.	¿Cuál es el promedio de StandardCost para cada producto donde StandardCost es mayor a $0.00? (Production.Product)

	select Name, CAST(ROUND(AVG(StandardCost),2) AS DEC(10,2))  avg_product_price 
	FROM production.product 
	GROUP BY Name HAVING AVG(StandardCost) > 0 
	ORDER BY avg_product_price;

--6.	En la tabla Person.Person ¿cuántas personas están asociadas con cada tipo de persona (PersonType)?

	Select distinct PersonType , count(*) Cantidad_Personas 
	from Person.Person 
	group by PersonType;

--7.	Traer todas las filas y columnas de Person.StateProvince donde el CountryRegionCode sea CA.

	select * from Person.StateProvince 
	where StateProvinceCode ='CA';

--8.	¿Cuántos productos en Production.Product hay que son rojos (red) y cuántos que son negros (black)?

	select distinct color, count(*) Cantidad_Productos 
	from Production.Product 
	Where Color='black' or color='red' 
	Group by Color ;

--9.	¿Cuál es el valor promedio de Freight por cada venta? (Sales.SalesOrderHeader) donde la venta se dio en el TerriotryID 4?

	select SalesOrderNumber, AVG(Freight) PROMEDIO_VENTAS 
	from Sales.SalesOrderHeader 
	where TerritoryID =4 
	group by SalesOrderNumber;

--10.	Traer a todos los clientes de Sales.vIndividualCustomer cuyo apellido sea Lopez, Martin o Wood, y sus nombres empiecen con cualquier letra entre la C y la L.

	Select * from Sales.vIndividualCustomer 
	Where (LastName='Lopez' or LastName='Martin' or LastName='Wood') 
	and  (SUBSTRING(FirstName,1,1) = 'C' or SUBSTRING(FirstName,1,1) = 'L');

--11.	Devolver el FirstName y LastName de Sales.vIndividualCustomer donde el apellido sea Smith, renombra las columnas en español.

	select FirstName AS Nombre, LastName AS Apellido 
	from Sales.vIndividualCustomer 
	where LastName = 'Smith';

--12.	Usando Sales.vIndividualCustomer traer a todos los clientes que tengan el CountryRegionCode de Australia ó todos los clientes que tengan un celular (Cell) y en EmailPromotion sea 0.

	Select * from Sales.vIndividualCustomer 
	where CountryRegionName ='Australia' 
	or (PhoneNumberType='cell' and EmailAddress='0');

--13.	¿Que tan caro es el producto más caro, por ListPrice, en la tabla Production.Product?

	select Name, ListPrice from Production.Product 
	WHERE ListPrice = (select MAX(listprice) from Production.Product);

--14.	¿Cuáles son las ventas por territorio para todas las filas de Sales.SalesOrderHeader? Traer sólo los territorios que se pasen de $10 millones en ventas históricas, traer el total de las ventas y el TerritoryID.

	select name as territorio, count(SalesOrderNumber) as Cantidad_Ventas, SUM(TotalDue) AS Total_vendido 
	from Sales.SalesOrderHeader join Sales.SalesTerritory on Sales.SalesOrderHeader.TerritoryID  = Sales.SalesTerritory.TerritoryID
	group by name 
	having sum(TotalDue) >10000000;

--15.	Usando la query anterior, hacer un join hacia Sales.SalesTerritory y reemplazar el TerritoryID con el nombre del territorio. [NUEVO]

	select Name as territorio, count(SalesOrderNumber) as Cantidad_Ventas, SUM(TotalDue) AS Total_vendido 
	from Sales.SalesOrderHeader join Sales.SalesTerritory on Sales.SalesOrderHeader.TerritoryID  = Sales.SalesTerritory.TerritoryID
	group by Name 
	having sum(TotalDue) >10000000;

--16.	Traer todos los empleados de HumanResources.vEmployeeDepartment que sean del departamento de “Executive”, “Tool Design”, y “Engineering”. Cuáles son las dos formas de hacer esta consulta.
	Select * from HumanResources.vEmployeeDepartment
	where Department ='Executive' or Department ='Tool Design' or Department ='Engineering'; 

--17.	Usando HumanResources.vEmployeeDepartment traer a todos los empleados que hayan empezado entre el primero de Julio del 2000 y el 30 de Junio del 2002. Hay dos posibilidades para hacer esta consulta. Hacer ambas.
	--1
		declare @fechaInicio date = '2000-07-01';
		declare @fechaFin date = '2002-06-30';

		select * from HumanResources.vEmployeeDepartment
		where StartDate >= @fechaInicio
		and StartDate < dateadd(day, 1, @fechaFin);
	--2
		select *
		from HumanResources.vEmployeeDepartment
		where StartDate between '20100701' and '20150630';

--18.	Traer todas las filas de Sales.SalesOrderHeader donde exista un vendedor (SalesPersonID)

	Select * from Sales.SalesOrderHeader 
	where SalesPersonID is not null;

--19.	¿Cuántas filas en Person.Person no tienen NULL en MiddleName?

	Select Count(*) as cantidad 
	from Person.Person 
	where MiddleName is not null;

--20.	Traer SalesPersonID y TotalDue de Sales.SalesOrderHeader por todas las ventas que no tienen valores vacíos en SalesPersonID y TotalDue excede $70000
	
	select SalesPersonID, TotalDue 
	from Sales.SalesOrderHeader 
	where (SalesPersonID is not null) and (TotalDue > 70000);

--21.	Traer a todos los clientes de Sales.vIndividualCustomer cuyo apellido empiece con R

	Select * from Sales.vIndividualCustomer
	where SUBSTRING(LastName,1,1) = 'R';

--22.	Traer a todos los clientes de Sales.vIndividualCustomer cuyo apellido termine con R.

	Select * from Sales.vIndividualCustomer
	where RIGHT(LastName,1) = 'R';

--23.	Usando Production.Product encontrar cuántos productos están asociados con cada color. Ignorar las filas donde el color no tenga datos (NULL). Luego de agruparlos, devolver sólo los colores que tienen al menos 20 productos en ese color.

	select color,count(ProductNumber) as Cantidad_productos 
	from Production.Product 
	where (Color is not null) 
	group by Color
	having Count(ProductNumber) >=20;

--24.	Hacer un join entre Production.Product y Production.ProductInventory sólo cuando los productos aparecen en ambas tablas. Hacerlo sobre el ProductID. Production.ProductInventory tiene la cantidad de cada producto, si se vende cada producto con un ListPrice mayor a cero, ¿cuánto dinero se ganaría? 

	Select  sum(Quantity * ListPrice) as dinero 
	from Production.ProductInventory  inner join Production.Product 
	on Production.Product.ProductID = Production.ProductInventory.ProductID 
	where ListPrice <> 0 ;
--25.	Traer FirstName y LastName de Person.Person. Crear una tercera columna donde se lea “Promo 1” si el EmailPromotion es 0, “Promo 2” si el valor es 1 o “Promo 3” si el valor es 2

	select FirstName, LastName, 
		case 
			when EmailPromotion = 0 then 'Promo 1' 
			when EmailPromotion = 1 then 'Promo 2'
			when EmailPromotion = 2 then 'Promo 3'
		end as EmailPromotion
	from Person.Person;

--26.	Traer el BusinessEntityID y SalesYTD de Sales.SalesPerson, juntarla con Sales.SalesTerritory de tal manera que Sales.SalesPerson devuelva valores aunque no tenga asignado un territorio. Traes el nombre de Sales.SalesTerritory.

	select BusinessEntityID, Sales.SalesPerson.SalesYTD ,Name
	from Sales.SalesPerson  left join Sales.SalesTerritory 
	on Sales.SalesPerson.TerritoryID  = Sales.SalesTerritory.TerritoryID ;

--27.	Usando el ejemplo anterior, vamos a hacerlo un poco más complejo. Unir Person.Person para traer también el nombre y apellido. Sólo traer las filas cuyo territorio sea “Northeast” o “Central”.

	select FirstName, LastName, Sales.SalesPerson.SalesYTD ,Name
	from Sales.SalesPerson  left join Sales.SalesTerritory 
	on Sales.SalesPerson.TerritoryID  = Sales.SalesTerritory.TerritoryID 
	left join Person.Person 
	on Sales.SalesPerson.BusinessEntityID = Person.Person.BusinessEntityID 
	where Name='Northeast' or Name= 'Central' ;

--28.	Usando Person.Person y Person.Password hacer un INNER JOIN trayendo FirstName, LastName y PasswordHash.

	select FirstName,LastName, PasswordHash 
	from Person.Person inner join Person.Password 
	on Person.BusinessEntityID = Password.BusinessEntityID;

--29.	Traer el título de Person.Person. Si es NULL devolver “No hay título”.

	Select COALESCE(title,'No hay titulo')  as title 
	from Person.Person;

--30.	Si MiddleName es NULL devolver FirstName y LastName concatenados, con un espacio de por medio. Si MiddeName no es NULL devolver FirstName, MiddleName y LastName concatenados, con espacios de por medio.

	Select firstName + ' ' + coalesce(MiddleName,'') +' '+ LastName  
	from Person.Person;

--31.	Usando Production.Product si las columnas MakeFlag y FinishedGoodsFlag son iguales, que devuelva NULL

	Select  Name,ProductNumber,MakeFlag,FinishedGoodsFlag, 
	case when Makeflag = FinishedGoodsFlag then null 
	else 'diferentes' end as result 
	from Production.Product;
	
--32.	Usando Production.Product si el valor en color no es NULL devolver “Sin color”. Si el color sí está, devolver el color. Se puede hacer de dos maneras, desarrollar ambas.
	--1
	Select COALESCE(color,'sin color')  as Color 
	from Production.Product;
	-- 2 	
	Select 
	case
	when Color is null then 'sin color'
	else color end as color  from Production.Product;

--33.	Usando Person.Person y Person.Password hacer un INNER JOIN trayendo FirstName, LastName y PasswordHash.
	select FirstName,LastName, PasswordHash 
	from Person.Person inner join Person.Password 
	on Person.BusinessEntityID = Password.BusinessEntityID;

