SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerViewBasic]
AS
SELECT DISTINCT 
                         dbo.Customer.CustomerID, dbo.Customer.CustomerNo, dbo.Customer.Status, dbo.Customer.DateModified, ISNULL(dbo.Customer.LastName, '') + ISNULL(', ' + CASE WHEN dbo.Customer.FirstName = '' THEN NULL
                          ELSE dbo.Customer.FirstName END, ' ') AS Name, dbo.AddressDetails.Street1 AS Address, dbo.AddressDetails.PhoneNumber1 AS Phone, dbo.AddressDetails.CityStateAndZip, dbo.Customer.Email, 
                         CASE WHEN ISNUMERIC(SUBSTRING(Street1, 1, (CHARINDEX(' ', Street1 + ' ') - 1))) = 1 THEN SUBSTRING(Street1, 1, (CHARINDEX(' ', Street1 + ' ') - 1)) ELSE '' END AS HouseNo, 
                         SUBSTRING(dbo.AddressDetails.Street1, CHARINDEX(' ', dbo.AddressDetails.Street1 + ' ', 1) + 1, LEN(dbo.AddressDetails.Street1)) AS StreetName, dbo.Customer.BalanceDoe AS BalanceDue
FROM            dbo.Customer LEFT OUTER JOIN
                         dbo.AddressDetails ON dbo.Customer.CustomerID = dbo.AddressDetails.CustomerID
GO