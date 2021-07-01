SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_OpenOrdersWithSupplier]
@Filter  nvarchar(4000)


AS
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT        PurchaseOrderId, PoNo, POStatus, PurchaseOrdersView.Status, StoreNo, PurchaseOrdersView.SupplierNo, Supplier AS SupplierName
FROM            PurchaseOrdersView 
WHERE        (POStatus < 2) AND (PurchaseOrdersView.Status > 0) AND (OpenItemsCount > 0)  '
Execute (@MySelect + @Filter )
GO