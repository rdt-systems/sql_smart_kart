SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_OpenOrders]
@Filter nvarchar(4000)
 
AS
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT        PurchaseOrderId, PoNo, POStatus, PurchaseOrdersView.Status, StoreNo, PurchaseOrdersView.SupplierNo, Supplier AS SupplierName,Note
FROM            PurchaseOrdersView 
WHERE        (POStatus < 2) AND (PurchaseOrdersView.Status > 0) AND (OpenItemsCount > 0) '

print (@MySelect + @Filter )

Execute (@MySelect + @Filter )
GO