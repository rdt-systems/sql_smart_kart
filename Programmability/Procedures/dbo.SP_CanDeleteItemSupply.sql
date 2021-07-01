SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CanDeleteItemSupply]
(@ItemStoreNo uniqueidentifier,
@SupplierNo uniqueidentifier)
AS
if 
(  SELECT   count(*)
   FROM              dbo.PurchaseOrderEntryView INNER JOIN
                      dbo.PurchaseOrdersView ON dbo.PurchaseOrderEntryView.PurchaseOrderNo = dbo.PurchaseOrdersView.PurchaseOrderId
   WHERE     (dbo.PurchaseOrderEntryView.ItemNo = @ItemStoreNo) AND (dbo.PurchaseOrdersView.SupplierNo = @SupplierNo) AND
	     (dbo.PurchaseOrderEntryView.Status >-1) AND (dbo.PurchaseOrdersView.Status>-1) 
)
+
(   SELECT count(*)
    FROM  dbo.ReceiveOrderView INNER JOIN
                dbo.ReceiveEntryView ON dbo.ReceiveOrderView.ReceiveID = dbo.ReceiveEntryView.ReceiveNo 
     WHERE        (dbo.ReceiveEntryView.ItemStoreNo = @ItemStoreNo) AND (dbo.ReceiveOrderView.SupplierNo = @SupplierNo) AND
                   (dbo.ReceiveEntryView.Status>-1) AND (dbo.ReceiveOrderView.Status>-1) 
)
+
(    SELECT count(*)
     FROM         dbo.ReturnToVenderView INNER JOIN
                      dbo.ReturnToVenderEntryView ON dbo.ReturnToVenderView.ReturnToVenderID = dbo.ReturnToVenderEntryView.ReturnToVenderID 
     WHERE          (dbo.ReturnToVenderEntryView.ItemStoreNo = @ItemStoreNo) AND (dbo.ReturnToVenderView.SupplierID = @SupplierNo) AND
                    (dbo.ReturnToVenderEntryView.Status>-1) AND (dbo.ReturnToVenderView.Status>-1)
)>0
	select 0
else
	select 1
GO