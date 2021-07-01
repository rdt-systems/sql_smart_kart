SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetMothlySales] 
(@Year int,
@ItemStoreID uniqueidentifier,
 @Stores Guid_list_tbltype READONLY)
 AS

 
 IF not EXISTS ( Select 1 from @Stores) 
 begin 
   SELECT   MONTH(dbo.[Transaction].StartSaleTime) SaleMonth,
			SUM(UOMQty) Qty , 
			SUM(Total) Price ,
			isnull(SUM(UOMQty*AVGCost),0) Cost
   
   FROM     dbo.TransactionEntry 
            INNER JOIN 
            dbo.[Transaction] on dbo.TransactionEntry.TransactionID=dbo.[Transaction].TransactionID

   WHERE    YEAR(dbo.[Transaction].StartSaleTime)=@Year and
			dbo.[Transaction].Status>0 and
	        ItemStoreID=@ItemStoreID and
			dbo.TransactionEntry.Status>0

   GROUP BY MONTH(dbo.[Transaction].StartSaleTime),ItemStoreID
   end 
   else 
   
    begin 
	declare @ItemNo uniqueidentifier
	select @ItemNo =ItemNo
	from ItemStore 
	where ItemStore.ItemStoreID=@ItemStoreID

   SELECT   MONTH(dbo.[Transaction].StartSaleTime) SaleMonth,
			SUM(UOMQty) Qty , 
			SUM(Total) Price ,
			isnull(SUM(UOMQty*TransactionEntry.AVGCost),0) Cost
   
   FROM     dbo.TransactionEntry 
            INNER JOIN 
            dbo.[Transaction] on dbo.TransactionEntry.TransactionID=dbo.[Transaction].TransactionID
			INNER JOIN 
            dbo.[ItemStore] on dbo.TransactionEntry.ItemStoreID=dbo.[ItemStore].ItemStoreID

   WHERE    YEAR(dbo.[Transaction].StartSaleTime)=@Year and
			dbo.[Transaction].Status>0 and
	        [ItemStore].itemNo=@ItemNo and
			dbo.TransactionEntry.Status>0
			 AND  [ItemStore].StoreNo in (select n from  @Stores)
   GROUP BY MONTH(dbo.[Transaction].StartSaleTime)
   end 
   RETURN
GO