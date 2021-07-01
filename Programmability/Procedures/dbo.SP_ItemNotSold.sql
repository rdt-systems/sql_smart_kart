SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemNotSold]

		@FromDate  nvarchar(20),
		@ToDate  nvarchar(20),
		@FilterClause nvarchar(4000)

AS

		DECLARE @SQL  as nvarchar(2000) 

		IF ((@FilterClause is NULL) OR (@FilterClause = ''))
			SET @SQL = 'SELECT [CustomerID], [StartSaleTime], [CurrBalance]

						FROM [Transaction] 

						WHERE dbo.[Transaction].[StartSaleTime] BETWEEN CONVERT(DATETIME, ''' + @FromDate + ''',102) AND CONVERT(DATETIME,''' + @ToDate + ''',102)'

		ELSE
			SET @SQL = 'SELECT [CustomerID], [StartSaleTime], [CurrBalance]

						FROM [Transaction] 

						WHERE dbo.[Transaction].[StartSaleTime] BETWEEN CONVERT(DATETIME, ''' + @FromDate + ''',102) AND CONVERT(DATETIME,''' + @ToDate + ''',102)
						AND ' + @FilterClause + ''

		EXEC(@SQL)
GO