SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPoEntryByPoID]
(@POID uniqueidentifier)
AS
-- SELECT        Supplier.Name, ItemMain.Name AS ItemName, ItemMain.BarcodeNumber, PurchaseOrderEntry.QtyOrdered, PurchaseOrderEntry.PricePerUnit, PurchaseOrders.PoNo, dbo.PurchaseOrders.Freight, 
--                         PurchaseOrders.GrandTotal, CONVERT(char(10), PurchaseOrders.ReqDate, 101) AS ReqDate, CONVERT(char(10), PurchaseOrders.DateCreated, 101) AS ASDateCreated, dbo.Address.Street, dbo.Address.State, 
--                         dbo.Address.Country, dbo.Address.PhoneNumber1, dbo.Address.PhoneNumber2, dbo.ContactName.FirstName, dbo.ContactName.LastName, 
--                         PurchaseOrderEntry.PricePerUnit * PurchaseOrderEntry.QtyOrdered AS Ammount, PurchaseOrders.ShipVia, PurchaseOrders.ShipTo, PurchaseOrders.TrackNo, PurchaseOrders.ExpirationDate, 
--                         dbo.PurchaseOrders.ContactNo, PurchaseOrders.StoreNo, dbo.Address.Zip, dbo.Address.City, PurchaseOrders.Note, ItemMain.ModalNumber, ItemMain.Unit, UOM.UOMName, Supplier.WebSite, 
--                         PurchaseOrders.TermsNo, dbo.PurchaseOrders.SuppInvoiceNo
--FROM            SupplierAddresses RIGHT OUTER JOIN
--                         Supplier ON SupplierAddresses.AddressID = Supplier.MainAddress LEFT OUTER JOIN
--                         MatrixColumn LEFT OUTER JOIN
--                         MatrixValues ON MatrixColumn.MatrixColumnID = MatrixValues.MatrixColumnNo RIGHT OUTER JOIN
--                         MatrixTable ON MatrixColumn.MatrixNo = MatrixTable.MatrixTableID RIGHT OUTER JOIN
--                         ItemMain ON MatrixTable.MatrixTableID = ItemMain.MatrixTableNo LEFT OUTER JOIN
--                         UOM ON ItemMain.Unit = UOM.UOMID RIGHT OUTER JOIN
--                         Store RIGHT OUTER JOIN
--                         ItemStore ON Store.StoreID = ItemStore.StoreNo ON ItemMain.ItemID = ItemStore.ItemNo RIGHT OUTER JOIN
--                         DepartmentStore ON ItemStore.DepartmentID = DepartmentStore.DepartmentStoreID LEFT OUTER JOIN
--                         PurchaseOrderEntry ON ItemStore.ItemStoreID = PurchaseOrderEntry.ItemNo RIGHT OUTER JOIN
--                         PurchaseOrders ON PurchaseOrderEntry.PurchaseOrderNo = PurchaseOrders.PurchaseOrderId ON Supplier.SupplierID = PurchaseOrders.SupplierNo

--WHERE           dbo.PurchaseOrders. PurchaseOrderId=@POID
GO