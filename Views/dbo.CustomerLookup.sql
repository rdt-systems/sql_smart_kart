SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[CustomerLookup]
AS
SELECT        dbo.Customer.CustomerID, dbo.Customer.CustomerNo, ISNULL(dbo.Customer.LastName, '') + ' ' + ISNULL(dbo.Customer.FirstName, '') AS Name, ISNULL(dbo.CustomerAddresses.Street1, '') 
                         + ' ' + ISNULL(dbo.CustomerAddresses.Street2, '') AS Address
FROM            dbo.Customer INNER JOIN
                         dbo.CustomerAddresses ON dbo.Customer.CustomerID = dbo.CustomerAddresses.CustomerID and dbo.Customer.MainAddressID = dbo.CustomerAddresses.CustomerAddressID
						 where Customer.Status>0
GO