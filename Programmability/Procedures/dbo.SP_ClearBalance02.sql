SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ClearBalance02]

@backdate1 as int,
@backdate2 as int

AS
			DECLARE @SQL as nvarchar(1000)


			SET @SQL= 'SELECT  CustomerNo, FirstName, LastName,   Balancedoe,	dbo.[Transaction].CurrBalance
			FROM dbo.[Transaction] INNER JOIN dbo.Customer ON dbo.[Transaction].CustomerID=dbo.Customer.CustomerID '

			SET @SQL= @SQL + 'WHERE dbo.Customer.CustomerID IN (Select dbo.[Transaction].CustomerID
									FROM [Transaction]
									WHERE (EndSaleTime>(dbo.GetLocalDATE()- ' + CONVERT(char(10),@backdate1)+ ')
											AND CurrBalance < 2
											AND CustomerID IS NOT NULL)'
--											AND CustomerID NOT IN(SELECT Max_TR.CustomerID
--																	FROM [Transaction] AS TR 
--																	INNER JOIN (SELECT dbo.[Transaction].CustomerID, MAX(EndSaleTime) AS MAX_DATE
--																				FROM [Transaction]
--																				WHERE (dbo.[Transaction].CustomerID IS NOT NULL)
--																				GROUP BY dbo.[Transaction].CustomerID
--																				HAVING (MAX(EndSaleTime) < dbo.GetLocalDATE() - ' + CONVERT(char(10),@backdate1)+ ')) AS Max_TR
--																	ON TR.EndSaleTime = Max_TR.MAX_DATE 
--																	AND TR.CustomerID = Max_TR.CustomerID)
			SET @SQL = @SQL + '				AND CurrBalance < 2)
			ORDER BY Currbalance desc'

			EXEC (@SQL)
GO