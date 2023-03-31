GO

USE [SoftuniDatabase]

GO

-- Problem 01

    SELECT 
	   TOP (5)
	       [e].[EmployeeID],
		   [e].[JobTitle],
		   [e].[AddressID],
		   [a].[AddressText]
      FROM [Employees]
        AS [e]
INNER JOIN [Addresses]
        AS [a]
		ON [e].[AddressID] = [a].AddressID
  ORDER BY [e].[AddressID]

-- Problem 02

    SELECT 
       TOP (50) 
           [e].[FirstName],
           [e].[LastName],
		   [t].[Name]
		AS [Town],
		   [a].[AddressText]
      FROM [Employees]
        AS [e]
INNER JOIN [Addresses]
        AS [a]
		ON [e].AddressID = [a].[AddressID]
INNER JOIN [Towns]
        AS [t]
		ON [a].[TownID] = [t].[TownID]
  ORDER BY [e].[FirstName],
           [e].[LastName]

-- Problem 03

   SELECT [e].[EmployeeID],
          [e].[FirstName],
		  [e].[LastName],
		  [d].[Name]
	   AS [DepartmentName]
     FROM [Employees]
       AS [e]
LEFT JOIN [Departments]
       AS [d]
	   ON [e].[DepartmentID] = [d].[DepartmentID]
	WHERE [d].[Name] = 'Sales'
 ORDER BY [e].[EmployeeID]

-- Problem 04

   SELECT 
      TOP (5)
	      [e].[EmployeeID],
		  [e].[FirstName],
		  [e].[Salary],
		  [d].[Name]
	   AS [DepartmentName]
     FROM [Employees]
	   AS [e]
LEFT JOIN [Departments]
       AS [d]
	   ON [e].[DepartmentID] = [d].[DepartmentID]
    WHERE [Salary] > 15000
 ORDER BY [e].[DepartmentID]

-- Problem 05

    SELECT 
	   TOP (3)
	       [e].[EmployeeID],
		   [e].[FirstName]
      FROM [Employees]
        AS [e]
 LEFT JOIN [EmployeesProjects]
        AS [ep]
		ON [e].[EmployeeID] = [ep].[EmployeeID]
     WHERE [ep].[ProjectID] IS NULL
	
-- Problem 06


	SELECT [e].[FirstName],
	       [e].[LastName],
		   [e].[HireDate],
		   [d].[Name] 
		AS [DeptName]
	  FROM [Employees]
		AS [e]
 LEFT JOIN [Departments]
		AS [d]
		ON [e].[DepartmentID] = [d].[DepartmentID]
	 WHERE [e].[HireDate] > '1/1/1999' AND [d].[Name] IN ('Sales', 'Finance')
  ORDER BY [e].[HireDate]

-- Problem 07

   SELECT 
      TOP (5)
	      [e].[EmployeeID],
		  [e].[FirstName],
		  [p].[Name]
	   AS [ProjectName]
     FROM [Employees]
       AS [e]
LEFT JOIN [EmployeesProjects]
       AS [ep]
	   ON [e].[EmployeeID] = [ep].[EmployeeID]
LEFT JOIN [Projects]
       AS [p]
	   ON [ep].[ProjectID] = [p].[ProjectID]
	WHERE [p].[StartDate] > '8/13/2002' AND [p].[EndDate] IS NULL
 ORDER BY [e].[EmployeeID]

-- Problem 08

   SELECT 
          [e].[EmployeeID],
          [e].[FirstName],
		  CASE WHEN YEAR([p].[StartDate]) >= 2005 THEN 'NULL'
		  ELSE [p].[Name]
		  END
       AS [ProjectName]
	 FROM [Employees]
       AS [e]
LEFT JOIN [EmployeesProjects]
       AS [ep]
	   ON [e].[EmployeeID] = [ep].[EmployeeID]
LEFT JOIN [Projects]
       AS [p]
	   ON [ep].[ProjectID] = [p].[ProjectID]
    WHERE [e].[EmployeeID] = 24

-- Problem 09

   SELECT [e].[EmployeeID],
          [e].[FirstName],
		  [e].[ManagerID],
		  [m].[FirstName]
     FROM [Employees]
       AS [e]
LEFT JOIN [Employees]
       AS [m]
	   ON [m].EmployeeID = [e].[ManagerID]
	WHERE [e].[ManagerID] IN (3, 7)
 ORDER BY [e].[EmployeeID]

-- Problem 10

   SELECT 
      TOP (50)
	      [e].[EmployeeID],
		  CONCAT_WS(' ', [e].[FirstName], [e].[LastName])
	   AS [EmployeeName],
	      CONCAT_WS(' ', [m].[FirstName], [m].[LastName])
	   AS [ManagerName],
		  [d].[Name]
	   AS [DepartmentName]
     FROM [Employees]
       AS [e]
LEFT JOIN [Employees]
       AS [m]
	   ON [e].[ManagerID] = [m].[EmployeeID]
LEFT JOIN [Departments]
       AS [d]
	   ON [e].[DepartmentID] = [d].[DepartmentID]
 ORDER BY [e].[EmployeeID]

 -- Problem 11

  SELECT MIN([Average]) 
      AS [MinAverageSalary] 
	FROM
       (
  SELECT AVG([Salary])
      AS [Average]
    FROM [Employees]
GROUP BY [DepartmentID]
       ) AS [AverageSalary]

GO

USE [Geography]

GO

 -- Problem 12

  SELECT *
    FROM
          (
   SELECT [c].[CountryCode],
          [m].[MountainRange],
		  [p].[PeakName],
		  [p].[Elevation]
     FROM [Peaks]
       AS [p]
LEFT JOIN [Mountains]
       AS [m]
	   ON [p].[MountainId] = [m].[Id]
LEFT JOIN [MountainsCountries]
       AS [mc]
	   ON [m].[Id] = [mc].[MountainId]
LEFT JOIN [Countries]
       AS [c]
	   ON [mc].[CountryCode] = [c].[CountryCode]
          ) AS [PeaksSubquery]
    WHERE [Elevation] > 2835 AND [CountryCode] = 'BG'
 ORDER BY [Elevation] DESC

 -- Problem 13
    SELECT [CountryCode],
           COUNT([MountainId])
	    AS [MountainsCountries]
      FROM [MountainsCountries]
     WHERE [CountryCode] IN (
                         SELECT [CountryCode]
                         FROM [Countries]
                         WHERE [CountryName] IN ('United States', 'Russia', 'Bulgaria')
                            )
  GROUP BY [CountryCode]

  -- Problem 14

    SELECT 
     TOP 5 [c].[CountryName],
           [r].[RiverName]
      FROM [Rivers]
	    AS [r]
RIGHT JOIN [CountriesRivers]
        AS [cr]
	    ON [r].[Id] = [cr].[RiverId]
RIGHT JOIN [Countries]
        AS [c]
	    ON [cr].[CountryCode] = [c].[CountryCode]
 LEFT JOIN [Continents]
        AS [co]
	    ON [c].[ContinentCode] = [co].[ContinentCode]
	 WHERE [ContinentName] = 'Africa' 
  ORDER BY [CountryName]

  -- Problem 15

  SELECT [ContinentCode],
         [CurrencyCode],
         [CurrencyUsage]
  FROM (
            SELECT *,
                   DENSE_RANK() OVER (PARTITION BY [ContinentCode] ORDER BY [CurrencyUsage] DESC)
                AS [CurrencyRank]
              FROM (
                        SELECT [ContinentCode],
                               [CurrencyCode],
                               COUNT(*)
                            AS [CurrencyUsage]
                          FROM [Countries]
                      GROUP BY [ContinentCode], [CurrencyCode]
                        HAVING COUNT(*) > 1
                   )
                AS [CurrencyUsageSubquery]
       )
    AS [CurrencyRankingSubquery]
 WHERE [CurrencyRank] = 1

 -- Problem 16

   SELECT COUNT([c].[CountryCode])
       AS [Count]
     FROM [Countries]
       AS [c]
LEFT JOIN [MountainsCountries]
       AS [m]
	   ON [c].[CountryCode] = [m].[CountryCode]
	WHERE [m].[MountainId] IS NULL


-- Problem 17

  SELECT 
  TOP (5) [c].[CountryName],
          MAX([p].[Elevation])
       AS [HighestPeakElevation],
          MAX([r].[Length])
       AS [LongestRiverLength]
     FROM [Countries]
       AS [c]
LEFT JOIN [CountriesRivers]
       AS [cr]
       ON [cr].[CountryCode] = [c].[CountryCode]
LEFT JOIN [Rivers]
       AS [r]
       ON [cr].[RiverId] = [r].[Id]
LEFT JOIN [MountainsCountries]
       AS [mc]
       ON [mc].[CountryCode] = [c].[CountryCode]
LEFT JOIN [Mountains]
       AS [m]
       ON [mc].[MountainId] = [m].[Id]
LEFT JOIN [Peaks]
       AS [p]
       ON [p].[MountainId] = [m].[Id]
 GROUP BY [c].[CountryName]
 ORDER BY [HighestPeakElevation] DESC,
          [LongestRiverLength] DESC,
          [CountryName]


