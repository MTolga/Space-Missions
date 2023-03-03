select * from spacemissions

WITH NewTable as (
SELECT *, TRIM(PARSENAME(REPLACE(Location,',','.'),1)) AS Country 
FROM spacemissions)
SELECT * FROM NewTable
WHERE Country LIKE 'USA'

ALTER TABLE spacemissions
ADD Country varchar(20)

ALTER TABLE spacemissions
DROP Column Country

SELECT *, CONVERT(DATE,[Date]) FROM spacemissions


ALTER TABLE spacemissions
ADD Year DATE

UPDATE spacemissions
SET Year=CONVERT(DATE,[Date])

/*This SQL query calculates the total number of rockets launched by each country, 
by extracting the country name from the Location column in a table called spacemissions. 
The query uses a common table expression to add a new column with the country name, 
and then groups the results by country and calculates the total number of rockets launched for each country. 
The results are sorted in descending order by the total number of rockets launched.
*/

WITH NewTable as (
SELECT *, TRIM(PARSENAME(REPLACE(Location,',','.'),1)) AS Country 
FROM spacemissions)
SELECT Country,SUM(1) as totalrocket FROM NewTable
group by Country
ORDER BY totalrocket DESC

/*
This SQL query retrieves the top 10 countries that have spent the most money on space missions based on data stored in a table called spacemissions.
It uses a Common Table Expression (CTE) to add a new Country column and calculates the total cost of space missions for each country using the SUM function,
then sorts the results in descending order by the totalcost column.
*/
WITH NewTable as (
SELECT *, TRIM(PARSENAME(REPLACE(Location,',','.'),1)) AS Country 
FROM spacemissions)
SELECT TOP 10 Country,SUM(Price) as totalcost FROM NewTable
group by Country
ORDER BY totalcost DESC

/*
the total cost of all active space missions for each country and
sorts the results in descending order by the total cost of active missions.
*/
WITH NewTable as (
SELECT *, TRIM(PARSENAME(REPLACE(Location,',','.'),1)) AS Country 
FROM spacemissions)
SELECT Country, RocketStatus, SUM(Price) as totalcost FROM NewTable
WHERE RocketStatus LIKE '%active%' AND Price>0
group by Country, RocketStatus
ORDER BY totalcost DESC

/*
space missions data and finds out the top 5 companies that have spent the most money on space missions after the year 2015,
based on the total cost of their space missions.
*/
WITH NewTable as (
SELECT *, TRIM(PARSENAME(REPLACE(Location,',','.'),1)) AS Country 
FROM spacemissions)
SELECT TOP 5 Company, SUM(Price) as totalcost FROM NewTable
WHERE Year>'2015/01/01'
group by Company
ORDER BY totalcost DESC


SELECT Company, MAX(Price) AS maxp, Mission FROM spacemissions
WHERE price>0
GROUP BY Company, Mission
ORDER BY maxp DESC

/*
What is the average price of space missions for each company, and how does it compare to the overall average price?
*/

SELECT DISTINCT(Company), AVG(Price) as avg_price,
       AVG(Price) OVER () as overall_avg_price
FROM spacemissions
where price>0
GROUP BY Company,Price
ORDER BY avg_price DESC


-- That calculates the running total cost of all missions by each company and displays the results in descending order.

SELECT DISTINCT(Company), SUM(Price) OVER (PARTITION BY Company
                                 ORDER BY Company) as running_total
FROM spacemissions
WHERE Price>0
ORDER BY running_total DESC



--Calculates the average price of all missions and categorizes 
--each company's mission cost as high, low, or normal based on how it compares to the average price, 
--and then displays the results in descending order by company name.

WITH costtable AS (SELECT *, AVG(Price) OVER() AS avg_price 
FROM spacemissions) 
SELECT DISTINCT(Company), CASE WHEN Price>avg_price+100 THEN 'HIGH COST' 
							WHEN Price<avg_price-100 THEN 'LOW COST' 
							ELSE 'NORMAL COST'
END AS cost
FROM costtable
WHERE Price>0
ORDER BY Company DESC



SELECT *, TRIM(PARSENAME(REPLACE(Location,',','.'),1)) AS Country 
FROM spacemissions

