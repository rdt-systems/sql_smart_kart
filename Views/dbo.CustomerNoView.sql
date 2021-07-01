SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerNoView]
AS
SELECT     (CASE WHEN ISNULL(FirstName, '') = '' THEN LASTNAME ELSE ISNULL(FirstName, '') + ' , ' + LASTNAME END) AS FullName, Customer.CustomerNo, 
                      CustomerAddresses.Street1 AS FullAddress
FROM         Customer INNER JOIN
                      CustomerAddresses ON Customer.CustomerID = CustomerAddresses.CustomerID
GO