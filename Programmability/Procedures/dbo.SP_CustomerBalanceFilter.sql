SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerBalanceFilter]

		@FromDt nvarchar(50) ,
		@ToDt nvarchar(50) ,
		@minBal money,
		@maxBal money

AS

		DECLARE @SQL as nvarchar(1000)

		SET @SQL='SELECT     dbo.Customer.CustomerNo, dbo.Customer.FirstName, dbo.Customer.LastName,  dbo.[Transaction].EndSaleTime AS SaleDate,
									  dbo.[Transaction].CurrBalance'

		SET @SQL=@SQL + ' FROM         dbo.[Transaction] INNER JOIN
									  dbo.Customer ON dbo.[Transaction].CustomerID = dbo.Customer.CustomerID'

		SET @SQL=@SQL + ' WHERE     (dbo.[Transaction].CurrBalance BETWEEN 20 AND 400) 
										AND (dbo.Customer.CustomerID IS NOT NULL)
										AND (dbo.[Transaction].StartSaleTime BETWEEN CONVERT(DATETIME, ''' + @FromDt + ''',102) AND CONVERT(DATETIME,''' + @ToDt + ''',102))
										AND (dbo.[Transaction].CurrBalance BETWEEN '+ CONVERT(char(10), @minBal) + ' AND ' +  CONVERT(char(10), @maxBal) + ')'
		
		SET @SQL=@SQL + ' ORDER BY dbo.[Transaction].CurrBalance DESC'

		EXEC(@SQL)
GO