SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SeekCustomerByCustomerID]
	
	@CustID as nvarchar(100)

AS

	DECLARE @SQL as nvarchar(2000)

	SET @SQL='SELECT dbo.Customer.CustomerID, dbo.Customer.CustomerNo, dbo.Customer.FirstName, dbo.Customer.LastName, dbo.Customer.BalanceDoe
				FROM Customer'

	SET @SQL=@SQL + ' WHERE (dbo.Customer.CustomerID='''+ CONVERT(char(100),@CustID) + ''') AND (dbo.Customer.FirstName IS NOT NULL)'

	SET @SQL=@SQL + ' ORDER BY dbo.Customer.CustomerID'

	EXEC(@SQL)
GO