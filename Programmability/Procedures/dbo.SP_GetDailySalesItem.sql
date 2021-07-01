SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetDailySalesItem]
(@Year int,
@MonthSale int,
@ItemStoreID uniqueidentifier,
@Stores Guid_list_tbltype READONLY)
as

 IF not EXISTS ( Select 1 from @Stores) 

 begin 
	SELECT 	 DAY(dbo.[Transaction].StartSaleTime) SaleDay,
		 SUM(UOMQty) Qty , 
	         Sum(Total) Price ,
		 isnull(SUM(UOMQty*AVGCost),0) Cost

	FROM     dbo.TransactionEntry
                 INNER JOIN 
                 dbo.[Transaction] ON dbo.TransactionEntry.TransactionID=dbo.[Transaction].TransactionID

	WHERE    MONTH(dbo.[Transaction].StartSaleTime)=@MonthSale and 
	         YEAR(dbo.[Transaction].StartSaleTime)=@Year and 
	         ItemStoreID=@ItemStoreID and dbo.[Transaction].Status>0 and
	         dbo.TransactionEntry.Status>0

 	GROUP BY DAY(dbo.[Transaction].StartSaleTime)
	end 
	else 

	begin 

		declare @ItemNo uniqueidentifier
	select @ItemNo =ItemNo
	from ItemStore 
	where ItemStore.ItemStoreID=@ItemStoreID

		SELECT 	 DAY(dbo.[Transaction].StartSaleTime) SaleDay,
		 SUM(UOMQty) Qty , 
	         Sum(Total) Price ,
		 isnull(SUM(UOMQty*TransactionEntry.AVGCost),0) Cost

	FROM     dbo.TransactionEntry
                 INNER JOIN 
                 dbo.[Transaction] ON dbo.TransactionEntry.TransactionID=dbo.[Transaction].TransactionID
				 INNER JOIN 
            dbo.[ItemStore] on dbo.TransactionEntry.ItemStoreID=dbo.[ItemStore].ItemStoreID

	WHERE    MONTH(dbo.[Transaction].StartSaleTime)=@MonthSale and 
	         YEAR(dbo.[Transaction].StartSaleTime)=@Year and 
	          [ItemStore].itemNo=@ItemNo and dbo.[Transaction].Status>0 and
	         dbo.TransactionEntry.Status>0
			  AND  [ItemStore].StoreNo in (select n from  @Stores)
 	GROUP BY DAY(dbo.[Transaction].StartSaleTime)
	end
GO