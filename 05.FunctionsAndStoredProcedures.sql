USE [SoftUniDatabase]

GO

-- Problem 01. Employees with Salary Above 35000

CREATE PROCEDURE [usp_GetEmployeesSalaryAbove35000]
   AS
BEGIN
       SELECT [FirstName],
	          [LastName]
		 FROM [Employees]
		WHERE [Salary] > 35000
  END

EXEC [dbo].[usp_GetEmployeesSalaryAbove35000]

-- Problem 02. Employees with Salary Above Number

GO

CREATE PROCEDURE [usp_GetEmployeesSalaryAboveNumber] @Salary DECIMAL(18, 4)
   AS
BEGIN
       SELECT [FirstName],
	          [LastName]
		 FROM [Employees]
		WHERE [Salary] >= @Salary
  END

EXEC [dbo].[usp_GetEmployeesSalaryAboveNumber] 48100

-- Problem 03. Town Names Starting With

GO

CREATE PROCEDURE [usp_GetTownsStartingWith] @StringParameter VARCHAR(10)
   AS
BEGIN
       SELECT [Name]
	     FROM [Towns]
		WHERE [Name] LIKE CONCAT(@StringParameter, '%')
  END

EXEC [dbo].[usp_GetTownsStartingWith] 'b'

GO

-- Problem 04.Employees from Town

CREATE PROCEDURE [usp_GetEmployeesFromTown] @TownName VARCHAR(50)
   AS
BEGIN
       SELECT [e].[FirstName],
	          [e].[LastName]
	     FROM [Employees]
		   AS [e]
   INNER JOIN [Addresses]
           AS [a]
		   ON [e].[AddressID] = [a].[AddressID]
   INNER JOIN [Towns]
           AS [t]
		   ON [a].[TownID] = [t].[TownID]
		WHERE [t].[Name] = @TownName
  END

EXEC [dbo].[usp_GetEmployeesFromTown] 'Sofia'

GO

-- Problem 05. Salary Level Function

CREATE FUNCTION [ufn_GetSalaryLevel](@Salary DECIMAL(18, 4))
RETURNS VARCHAR(8)
   AS
BEGIN
    DECLARE @SalaryLevel VARCHAR(8)

       IF @Salary < 30000 
	      BEGIN
		         SET @SalaryLevel = 'Low'
		    END
	   ELSE IF @Salary BETWEEN 30000 AND 50000
	      BEGIN
				 SET @SalaryLevel = 'Average'
		    END
	   ELSE IF @Salary > 50000
	      BEGIN
				 SET @SalaryLevel = 'High'
		    END

		RETURN @SalaryLevel
  END

GO

-- Problem 06. Employees by Salary Level

CREATE PROCEDURE [usp_EmployeesBySalaryLevel] @SalaryLevel VARCHAR(8)
   AS
BEGIN
       SELECT [FirstName],
	          [LastName]
		 FROM [Employees]
		WHERE [dbo].[ufn_GetSalaryLevel]([Salary]) = @SalaryLevel
  END

EXEC [dbo].[usp_EmployeesBySalaryLevel] 'High'

GO

-- Problem 07. Define Function

CREATE FUNCTION [ufn_IsWordComprised](@SetOfLetters VARCHAR(50), @Word VARCHAR(50))
RETURNS BIT
     AS
  BEGIN
        DECLARE @WordIndex INT = 1;
		WHILE (@WordIndex <= LEN(@Word))
		BEGIN
		      DECLARE @CurrentCharacter CHAR = SUBSTRING(@Word, @WordIndex, 1);

			  IF CHARINDEX(@CurrentCharacter, @SetOfLetters) = 0
			  BEGIN
			        RETURN 0;
				END

				SET @WordIndex += 1;
			END

			RETURN 1;

    END

GO

-- Problem 08. Delete Employees and Departments

CREATE PROCEDURE [usp_DeleteEmployeesFromDepartment] @departmentId INT
   AS
BEGIN
       DECLARE @employeesToDelete TABLE ([Id] INT);
	   INSERT INTO @employeesToDelete
	               SELECT [EmployeeID]
				     FROM [Employees]
					WHERE [DepartmentID] = @departmentId


		DELETE
		  FROM [EmployeesProjects]
		 WHERE [EmployeeID] IN (
									SELECT *
									  FROM @employeesToDelete
		                       )


		ALTER TABLE [Departments]
	   ALTER COLUMN [ManagerID] INT


	   UPDATE [Departments]
	      SET [ManagerID] = NULL
		WHERE [ManagerID] IN (
									SELECT *
									  FROM @employeesToDelete
		                     )


		UPDATE [Employees]
		   SET [ManagerID] = NULL
		 WHERE [ManagerID] IN (
									SELECT *
									  FROM @employeesToDelete
		                      )


		DELETE 
		  FROM [Employees]
		 WHERE [DepartmentID] = @departmentId

		DELETE 
		  FROM [Departments]
		 WHERE [DepartmentID] = @departmentId

		SELECT COUNT(*)
		  FROM [Employees]
		 WHERE [DepartmentID] = @departmentId
  END

  GO

USE [Bank]

-- Problem 09. Find Full Name
GO

CREATE PROCEDURE [usp_GetHoldersFullName]
    AS
 BEGIN
       SELECT CONCAT_WS(' ', [FirstName], [LastName])
	       AS [Full Name]
	     FROM [AccountHolders]
   END

EXEC [dbo].[usp_GetHoldersFullName]

GO

-- Problem 10. People with Balance Higher Than

CREATE PROCEDURE [usp_GetHoldersWithBalanceHigherThan] @sum MONEY
   AS
BEGIN
       SELECT [FirstName]
	       AS [First Name],
		      [LastName]
		   AS [Last Name]
		 FROM (
				  SELECT [FirstName],
				         [LastName],
						 SUM([a].[Balance])
					  AS [TotalBalance]
					FROM [AccountHolders]
					  AS [ah]
			  INNER JOIN [Accounts]
			          AS [a]
					  ON [ah].[Id] = [a].[AccountHolderId]
				GROUP BY [ah].[FirstName], [ah].[LastName]
		      ) AS tb
			  WHERE tb.[TotalBalance] > @sum
  END

  GO

  -- Problem 11. Future Value Function

  CREATE FUNCTION [ufn_CalculateFutureValue](@sum DECIMAL(10,4), @yearlyInterestRate FLOAT, @numberOfYears INT)
  RETURNS DECIMAL(10,4)
     AS
  BEGIN
         DECLARE @futureValue DECIMAL(10, 4);

         SET @futureValue = @sum * POWER((1 + @yearlyInterestRate), @numberOfYears)

		 return @futureValue
    END

GO 

-- Problem 13. Cash in User Games Odd Rows*

USE [Diablo]

CREATE FUNCTION [ufn_CashInUsersGames](@gameName NVARCHAR(50))
RETURNS TABLE
AS
RETURN
       (
			SELECT SUM([Cash])
			    AS [SumCash]
			  FROM (
						SELECT [g].[Name],
						       [ug].[Cash],
							   ROW_NUMBER() OVER(ORDER BY [ug].[Cash] DESC)
							AS [RowNumber]
						  FROM [UsersGames]
						    AS [ug]
					INNER JOIN [Games]
					        AS [g]
							ON [ug].[GameId] = [g].[Id]
						 WHERE [g].[Name] = @gameName
			       ) AS [Ranking]
			 WHERE [RowNumber] % 2 <> 0
	   )

GO

