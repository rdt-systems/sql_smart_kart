SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO













CREATE VIEW [dbo].[PurchaseOrdersView]
AS
SELECT        PurchaseOrders.PurchaseOrderId, PurchaseOrders.SupplierNo, PurchaseOrders.StoreNo, PurchaseOrders.PoNo, PurchaseOrders.PersonOrderdId, PurchaseOrders.GrandTotal, PurchaseOrders.ShipVia, 
                         PurchaseOrders.ShipTo, PurchaseOrders.TrackNo, PurchaseOrders.TermsNo, PurchaseOrders.PurchaseOrderDate, PurchaseOrders.ReqDate, PurchaseOrders.ExpirationDate, PurchaseOrders.Shipdrop, 
                         PurchaseOrders.POStatus, PurchaseOrders.Note, PurchaseOrders.Status, PurchaseOrders.DateCreated, PurchaseOrders.UserCreated, PurchaseOrders.DateModified, PurchaseOrders.UserModified, 
                         ISNULL(Opens.OpenItems, 0) AS OpenItemsCount, Store.StoreName, PurchaseOrders.Reorder, Supplier.Name AS Supplier, Supplier.SupplierNo AS [Supplier No], Users.UserName AS [User], 
                         PurchaseOrders.TermsID, PurchaseOrders.BuyerID, PurchaseOrders.BillToStoreID, PurchaseOrders.VendorPONo, PurchaseOrders.DepartmentID, PurchaseOrders.SeasonID, PurchaseOrders.ClassID, 
						 PurchaseOrders.MinMarkup, PurchaseOrders.ListPrice, PurchaseOrders.Import, PurchaseOrders.Sent, CAST(ISNULL(PurchaseOrders.Approved,0) as bit) as Approved
FROM            PurchaseOrders INNER JOIN
                         Store ON PurchaseOrders.StoreNo = Store.StoreID INNER JOIN
                         Supplier ON PurchaseOrders.SupplierNo = Supplier.SupplierID LEFT OUTER JOIN
                         Users ON PurchaseOrders.UserCreated = Users.UserId LEFT OUTER JOIN
                             (SELECT        COUNT(*) AS OpenItems, PurchaseOrderNo
                               FROM            (SELECT        PurchaseOrderEntry.PurchaseOrderNo, CASE WHEN QtyOrdered > isnull(ReceivedQty, 0) THEN QtyOrdered - isnull(ReceivedQty, 0) ELSE 0 END AS OrderDeficit
                                                         FROM            PurchaseOrderEntry INNER JOIN
                                                                                   PurchaseOrders AS PO ON PurchaseOrderEntry.PurchaseOrderNo = PO.PurchaseOrderId LEFT OUTER JOIN
                                                                                       (SELECT        SUM(Qty) AS ReceivedQty, PurchaseOrderEntryNo
                                                                                         FROM            ReceiveEntry
                                                                                         WHERE        (Status > 0)
                                                                                         GROUP BY PurchaseOrderEntryNo) AS Receives ON PurchaseOrderEntry.PurchaseOrderEntryId = Receives.PurchaseOrderEntryNo
                                                         WHERE        (PurchaseOrderEntry.Status > 0)) AS Counts
                               WHERE        (OrderDeficit > 0)
                               GROUP BY PurchaseOrderNo) AS Opens ON Opens.PurchaseOrderNo = PurchaseOrders.PurchaseOrderId
GO