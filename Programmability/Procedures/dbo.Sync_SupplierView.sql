SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_SupplierView]
(@FromDate DateTime)

AS

SELECT SupplierID,
	   SupplierNo,
	   Supplier.[Name],
	   ISNULL(SupplierAddresses.Line1 ,'') as Address1,
	   ISNULL(SupplierAddresses.Line2 ,'') as Address2,
	   ISNULL(SupplierAddresses.City,'') as City,
	   ISNULL(SupplierAddresses.State,'') as State,
	   ISNULL(SupplierAddresses.Zip,'')as Zip,
	   ISNULL(SupplierAddresses.PhoneNumber1,'') as PhoneNumber,
	   0 as DsRowState

FROM   Supplier 
LEFT OUTER JOIN
 SupplierAddresses ON dbo.Supplier.MainAddress = dbo.SupplierAddresses.AddressID
Where Supplier.Status>-1 And
	  (Supplier.DateCreated>@FromDate Or Supplier.DateModified>@FromDate Or SupplierAddresses.DateModified>@FromDate)
GO