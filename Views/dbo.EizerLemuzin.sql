SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[EizerLemuzin]
WITH SCHEMABINDING 
AS
SELECT        CustomerGroup.CustomerGroupName, ISNULL(Customer.LastName, '') + N' ' + ISNULL(Customer.FirstName, '') AS CustName, Customer.CustomerID, Customer.CustomerNo, AddressDetails.Street1, 
                         AddressDetails.PhoneNumber1, AddressDetails.CityStateAndZip
FROM            dbo.CustomerToGroup INNER JOIN
                         dbo.Customer ON dbo.CustomerToGroup.CustomerID = dbo.Customer.CustomerID INNER JOIN
                         dbo.CustomerGroup ON dbo.CustomerToGroup.CustomerGroupID = dbo.CustomerGroup.CustomerGroupID LEFT OUTER JOIN
                         dbo.AddressDetails ON dbo.Customer.CustomerID = dbo.AddressDetails.CustomerID
WHERE        (CustomerToGroup.Status > 0) AND (CustomerGroup.Status > 0) AND (Customer.Status > 0) AND (ISNULL(Customer.LockAccount,0) <> 1)
GO