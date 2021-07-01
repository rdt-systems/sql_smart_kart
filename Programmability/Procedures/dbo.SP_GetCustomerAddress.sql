SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomerAddress]
		
	@CustID nvarchar(100)

AS
		DECLARE @SQL as nvarchar(1000)

		SET @SQL='SELECT CustomerNo, dbo.CustomerAddresses.Street1, dbo.Customeraddresses.street2, dbo.CustomerAddresses.City, dbo.CustomerAddresses.State, dbo.CustomerAddresses.Zip
					FROM Customer INNER JOIN CustomerAddresses ON Customer.CustomerID=CustomerAddresses.CustomerID
					WHERE dbo.Customer.CustomerNo='''+ CONVERT(char(100),@CustID) + ''''



		EXEC(@SQL)
GO