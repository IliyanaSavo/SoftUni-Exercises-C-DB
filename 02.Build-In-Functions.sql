USE [SoftUniDatabase]

GO

--problem 01

SELECT [FirstName],
       [LastName] 
  FROM [Employees]
 WHERE [FirstName] LIKE 'Sa%'

 --problem 02

 SELECT [FirstName],
        [LastName]
   FROM [Employees]
  WHERE [LastName] LIKE '%ei%'

--problem 03

SELECT [FirstName] 
  FROM [Employees]
 WHERE [DepartmentID] IN (3, 10) 
       AND YEAR([HireDate]) BETWEEN 1995 AND 2005

--problem 04

SELECT [FirstName],
       [LastName]
  FROM [Employees]
 WHERE [JobTitle] NOT LIKE '%engineer%'

 --problem 05

  SELECT [Name]
    FROM [Towns]
   WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name] 

--PROBLEM 06

  SELECT [TownID],
         [Name]
    FROM [Towns]
   WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

--problem 07

  SELECT [TownID],
         [Name]
    FROM [Towns]
   WHERE [Name] NOT LIKE '[RBD]%'
ORDER BY [Name]

--problem 08

CREATE VIEW [V_EmployeesHiredAfter2000] 
         AS
     SELECT [FirstName],
	        [LastName]
	   FROM [Employees]
	  WHERE YEAR([HireDate]) > 2000;

--PROBLEM 09

SELECT [FirstName],
       [LastName]
  FROM [Employees]
 WHERE LEN([LastName]) = 5

 --PROBLEM 11
 SELECT *
   FROM (
          SELECT [EmployeeID],
				 [FirstName],
				 [LastName],
				 [Salary],
				 DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID])
			  AS [Rank]
			FROM [Employees]
		   WHERE [Salary] BETWEEN 10000 AND 50000
   ) AS [RankingSubquery]
   WHERE [Rank] = 2
ORDER BY [Salary] DESC

--problem 12

GO 

USE [Geography]

GO

  SELECT [CountryName] AS [Country Name],
         [IsoCode] AS [ISO Code]
    FROM [Countries]
   WHERE [CountryName] LIKE '%a%a%a%'
ORDER BY [IsoCode]

--problem 13

SELECT [p].[PeakName],
       [r].[RiverName],
	   LOWER(CONCAT(SUBSTRING([p].[PeakName], 1, LEN([p].[PeakName]) - 1), [r].[RiverName]))
	AS [Mix]
  FROM [Peaks]
    AS [p],
	   [Rivers]
	AS [r]
 WHERE RIGHT(LOWER([p].[PeakName]), 1) = LEFT(LOWER([r].[RiverName]), 1)
ORDER BY [Mix]

--problem 14

GO

USE [Diablo]

GO

  SELECT TOP 50
         [Name],
         FORMAT([Start], 'yyyy-MM-dd') AS [Start]
    FROM [Games]
   WHERE YEAR([Start]) BETWEEN 2011 AND 2012
ORDER BY [Start],
         [Name]

--problem 15

  SELECT [Username],
         SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email]) - CHARINDEX('@', [Email]))
	  AS [Email Provider]
    FROM [Users]
ORDER BY [Email Provider],
         [Username]

--problem 16

  SELECT [Username],
         [IpAddress] AS [IP Address]
    FROM [Users]
   WHERE [IpAddress] LIKE '___.1_%._%.___'
ORDER BY [Username]

--problem 17

  SELECT [Name] AS [Game],
         CASE 
	       WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
           WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
		   ELSE 'Evening'
		  END
	  AS [Part of the Day],
	     CASE
              WHEN [Duration] <= 3 THEN 'Extra Short'
              WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
              WHEN [Duration] > 6 THEN 'Long'
              ELSE 'Extra Long'
		  END
	  AS [Duration]
    FROM [Games]
      AS [g]
ORDER BY [Game],
         [Duration],
		 [Part of the Day]

--problem 18

GO 

USE [Orders]

GO

SELECT [ProductName], 
       [OrderDate], 
       DATEADD(DAY,3,[OrderDate]) AS [Pay Due],
       DATEADD(MONTH,1,[OrderDate]) AS [Deliver Due]
  FROM [Orders]

--PROBLEM 19