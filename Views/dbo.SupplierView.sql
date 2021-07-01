SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[SupplierView]
WITH SCHEMABINDING
AS
SELECT        Supplier.SupplierID, Supplier.SupplierNo, Supplier.Name, Supplier.DefaultCredit, Supplier.WebSite, Supplier.EmailAddress, Supplier.MainAddress, ISNULL(Supplier.ContactName, N'') AS ContactName, 
                         Supplier.BarterID, Supplier.WarehouseID, Supplier.Status, Supplier.DateCreated, Supplier.UserCreated, Supplier.DateModified, Supplier.UserModified, Supplier.AccountNo, Supplier.Note, 
                         ISNULL(SupplierAddresses.Line1, N'') AS Address1, ISNULL(SupplierAddresses.Line2, N'') AS Address2, ISNULL(SupplierAddresses.City, N'') AS City, ISNULL(SupplierAddresses.State, N'') AS State, 
                         ISNULL(SupplierAddresses.Zip, N'') AS Zip, ISNULL(SupplierAddresses.PhoneNumber1, N'') AS PhoneNumber1, SupplierAddresses.Ext1, ISNULL(SupplierAddresses.PhoneNumber2, N'') AS PhoneNumber2, 
                         ISNULL(SupplierAddresses.PhoneNumber3, N'') AS PhoneNumber3, IsNull(Supplier.MinMarkup,0) As MinMarkup, Supplier.BuyerID, Supplier.ListPrice, Supplier.Department, Supplier.Import ,	 CONVERT(nvarchar(500),
	                STUFF((SELECT DISTINCT ',' + CONVERT(varchar(4000),SupplierNotes.NoteValue)
                              FROM         dbo.SupplierNotes 
                              WHERE     SupplierNotes.SupplierID = Supplier.SupplierID AND SupplierNotes.Status > 0
							FOR xml PATH ('')), 1, 1, '')) AS SupplierNote
FROM            dbo.Supplier LEFT OUTER JOIN
                         dbo.SupplierAddresses ON Supplier.MainAddress = SupplierAddresses.AddressID
GO