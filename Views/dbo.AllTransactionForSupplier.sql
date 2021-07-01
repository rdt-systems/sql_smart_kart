SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE   view      [dbo].[AllTransactionForSupplier]
as
SELECT     PurchaseOrderId AS IDc, SupplierNo, 0 AS Type, PurchaseOrderDate AS Datet, PoNo AS Num, GrandTotal AS Amount, StoreNo,Status
FROM         dbo.PurchaseOrders
where Status>0

union 

SELECT     ReturnToVenderID AS IDc, SupplierID AS SupplierNo, 2 AS Type, ReturnToVenderDate AS DateT, ReturnToVenderNo AS Num, -Total AS Amount, 
                      StoreNo,Status
FROM         dbo.ReturnToVender
where Status>0
union

SELECT     ReceiveID AS IDc, SupplierNo, 1 AS Type, ReceiveOrderDate AS DateT, BillNo AS Num, Amount, StoreID AS StoreNo,Status
FROM         dbo.ReceiveOrderView
where Status>0
union

SELECT     SuppTenderEntryID AS IDc, SupplierID AS SupplierNo, 3 AS Type, TenderDate AS DateT, SuppTenderNo AS Num, -Amount, 
                      StoreID AS StoreNo,Status
FROM         dbo.SupplierTenderEntry
where Status>0
GO