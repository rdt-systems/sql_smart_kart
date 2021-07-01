SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCouponCustomerDetails]
	
		@CustID nvarchar(100)


AS
		DECLARE @SQL AS nvarchar(1000)
		
		SET @SQL='	SELECT     dbo.Customer.FirstName, dbo.Customer.LastName, dbo.CustomerAddresses.Name, 
								dbo.Customer.CustomerNo, dbo.CustomerAddresses.Street1, dbo.CustomerAddresses.Street2,
								 dbo.CustomerAddresses.City, dbo.CustomerAddresses.State, dbo.CustomerAddresses.Zip, 
									dbo.CustomerAddresses.PhoneNumber1, dbo.Customer.CustomerID

					FROM        dbo.Customer INNER JOIN	dbo.CustomerAddresses 
								ON dbo.Customer.CustomerID = dbo.CustomerAddresses.CustomerID

					WHERE		dbo.Customer.CustomerNo='''+ CONVERT(char(100),@CustID) + ''''

		EXEC(@SQL)
GO