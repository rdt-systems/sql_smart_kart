SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[AddressDetails]
WITH SCHEMABINDING 
AS
SELECT        --ISNULL(CHAR(13) + CustomerAddresses.PhoneNumber1, '') + 
ISNULL(CHAR(13) + CustomerAddresses.Street1 + ' ', '') + ISNULL(CustomerAddresses.Street2 + ' ', '') + ISNULL(CHAR(13) 
                         + CustomerAddresses.City + ' ', '') + ISNULL(CustomerAddresses.State + ' ', '') + ISNULL(CustomerAddresses.Zip + ' ', '') COLLATE SQL_Latin1_General_CP1_CI_AS AS AllDetails, Customer.CustomerID, 
                         CustomerAddresses.Street1, CustomerAddresses.Street2, CustomerAddresses.PhoneNumber1, CustomerAddresses.PhoneNumber2, ISNULL(CustomerAddresses.City, N'') 
                         + N' ' + ISNULL(CustomerAddresses.State, N'') + N' ' + ISNULL(CustomerAddresses.Zip, N'') AS CityStateAndZip, CustomerAddresses.City, CustomerAddresses.Zip, CustomerAddresses.State
FROM            dbo.CustomerAddresses RIGHT OUTER JOIN
                         dbo.Customer ON dbo.CustomerAddresses.CustomerID = dbo.Customer.CustomerID AND dbo.CustomerAddresses.CustomerAddressID = dbo.Customer.MainAddressID
WHERE        (CustomerAddresses.AddressType = 6) AND (CustomerAddresses.Status > 0)
GO