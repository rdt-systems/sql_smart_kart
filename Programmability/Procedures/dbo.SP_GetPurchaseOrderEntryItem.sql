SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetPurchaseOrderEntryItem]  
(@ItemNo uniqueidentifier,  
@ShowClose int = 1,  
@Stores Guid_list_tbltype  READONLY)  
AS   
declare @ItemId uniqueidentifier  
 IF not EXISTS ( Select 1 from @Stores)   
 begin   
SELECT      PurchaseOrdersView.StoreName StoreName ,  PurchaseOrdersView.Supplier AS Name, PurchaseOrdersView.PoNo, PurchaseOrderEntryView.ItemNo, SUM(PurchaseOrderEntryView.QtyOrdered) AS QtyOrdered, PurchaseOrderEntryView.PricePerUnit,   
                         PurchaseOrdersView.PurchaseOrderId, PurchaseOrdersView.PurchaseOrderDate, SUM(PurchaseOrderEntryView.OrderDeficit) AS OrderDeficit  
FROM            PurchaseOrderEntryView INNER JOIN  
                         PurchaseOrdersView ON PurchaseOrderEntryView.PurchaseOrderNo = PurchaseOrdersView.PurchaseOrderId  
WHERE        (PurchaseOrdersView.Status > 0) AND (PurchaseOrderEntryView.ItemNo = @ItemNo) AND (PurchaseOrdersView.POStatus <= @ShowClose) AND (PurchaseOrderEntryView.Status > 0)  
GROUP BY PurchaseOrdersView.storeName ,PurchaseOrdersView.Supplier,PurchaseOrdersView.PoNo,PurchaseOrderEntryView.ItemNo, PurchaseOrderEntryView.PricePerUnit, PurchaseOrdersView.PurchaseOrderId, PurchaseOrdersView.PurchaseOrderDate  
end   
else  
  
  
begin  
select @ItemId =ItemStore.itemno  
from ItemStore   
where ItemStore.ItemStoreID=@ItemNo  
  
  
  
SELECT    PurchaseOrdersView.StoreName  ,  PurchaseOrdersView.Supplier AS Name, PurchaseOrdersView.PoNo, PurchaseOrderEntryView.ItemNo, SUM(PurchaseOrderEntryView.QtyOrdered) AS QtyOrdered, PurchaseOrderEntryView.PricePerUnit,   
                         PurchaseOrdersView.PurchaseOrderId, PurchaseOrdersView.PurchaseOrderDate, SUM(PurchaseOrderEntryView.OrderDeficit) AS OrderDeficit  
FROM            PurchaseOrderEntryView INNER JOIN  
                         PurchaseOrdersView ON PurchaseOrderEntryView.PurchaseOrderNo = PurchaseOrdersView.PurchaseOrderId  
WHERE        (PurchaseOrdersView.Status > 0) AND (PurchaseOrderEntryView.Itemid = @ItemId) AND (PurchaseOrdersView.POStatus <= @ShowClose) AND (PurchaseOrderEntryView.Status > 0)  
and PurchaseOrdersView.StoreNo in (select n from  @Stores)  
GROUP BY  PurchaseOrdersView.storeName  , PurchaseOrdersView.Supplier,PurchaseOrdersView.PoNo,PurchaseOrderEntryView.ItemNo, PurchaseOrderEntryView.PricePerUnit, PurchaseOrdersView.PurchaseOrderId, PurchaseOrdersView.PurchaseOrderDate  
  
end
GO