SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ReturnToVendorPrintView]
AS
SELECT     dbo.ReturnToVenderView.ReturnToVenderID, dbo.ReturnToVenderView.ReturnToVenderNo, dbo.SupplierView.SupplierNo, dbo.SupplierView.Name, 
                      dbo.ReturnToVenderView.Total, dbo.ReturnToVenderView.ReturnToVenderDate, dbo.SupplierAddressView.Line1, dbo.SupplierAddressView.Line2, 
                      dbo.SupplierAddressView.City, dbo.SupplierAddressView.State, dbo.SupplierAddressView.Zip, dbo.SupplierView.ContactName
FROM         dbo.ReturnToVenderView INNER JOIN
                      dbo.SupplierView ON dbo.ReturnToVenderView.SupplierID = dbo.SupplierView.SupplierID INNER JOIN
                      dbo.SupplierAddressView ON dbo.SupplierView.MainAddress = dbo.SupplierAddressView.AddressID
GO