SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSupplierDetails]
AS SELECT     dbo.SupplierGridView.SupplierID, dbo.SupplierGridView.SupplierNo, dbo.SupplierGridView.Name, dbo.SupplierGridView.ContactName, 
                      dbo.SupplierGridView.Balance, dbo.SupplierAddressView.PhoneNumber1, ISNULL(dbo.SupplierAddressView.Line1 + ' ', '') 
                      + ISNULL(dbo.SupplierAddressView.Line2, '') AS Address, dbo.SupplierAddressView.City, dbo.SupplierAddressView.State, 
                      dbo.SupplierAddressView.Zip, dbo.SupplierAddressView.Country, dbo.SupplierAddressView.CCRT
FROM         dbo.SupplierGridView LEFT OUTER JOIN
                      dbo.SupplierAddressView ON dbo.SupplierGridView.MainAddress = dbo.SupplierAddressView.AddressID
WHERE     (dbo.SupplierGridView.Status > 0)
GO