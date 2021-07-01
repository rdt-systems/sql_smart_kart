SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionByCustomers]

@FromDate  nvarchar(20),
@ToDate  nvarchar(20),
@FilterClause nvarchar(4000)=''

AS
		DECLARE @S  as nvarchar(1000) 
		SET @S = 'SELECT CustomerID, sum(CurrBalance)	as BalanceTotal
					FROM [transaction]' 

		SET @S  =  @S + ' GROUP BY CustomerID, StartSaleTime'

        SET @S  =  @S + ' HAVING (CustomerID IS NOT NULL) 
							AND (StartSaleTime BETWEEN ''' + @FromDate + '''' + ' AND ''' + @ToDate +''')'

		IF @FilterClause <> '' 
			SET @S  =  @S +  @FilterClause 
		ELSE
			SET @S = @S

		EXEC(@S)
GO