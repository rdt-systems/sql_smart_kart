SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_GetSalesHistory]
(@Filter nvarchar(4000),
 @IsPOS bit = 1,
 @ItemStoreID uniqueidentifier = null,
 @MainStore bit = 0,
 @Stores Guid_list_tbltype READONLY)
as

declare @MySelect nvarchar(4000)

IF @MainStore = 1 
BEGIN
set @MySelect= 
	   'SELECT     TransactionNo, TransactionType, TransactionID, StartSaleTime,StartSaleTime As SaleTime, TotalAfterDiscount,
                      QtyCase, Qty, Price, ExtPrice AS Total, StoreName, CustomerNo, Type, [Customer Name]
FROM         HistoryView  '

Set @itemStoreID =(Select ItemNo from ItemStore where ItemStoreID = @ItemStoreID AND Status > 0)

SET @Filter = @Filter + ' AND ItemStoreID IN (SELECT ItemStoreID FROM ItemStore WHERE Status > 0 AND ItemNo =''' + CAST(@ItemStoreID as varchar(50)) + ''')'

END
 ELSE
BEGIN



IF @IsPOS =1 BEGIN
set @MySelect= 
	   'SELECT        TransactionNo, TransactionType, TransactionID, StartSaleTime, StartSaleTime As SaleTime, TotalAfterDiscount,
                         QtyCase, Qty, Price, ExtPrice AS Total, StoreName, CustomerNo,Type,[Customer Name]
FROM            HistoryView '
END ELSE
BEGIN
	 set @MySelect= 
	   'SELECT TransactionNo, TransactionType, TransactionID, StartSaleTime, 
						  ItemStoreID, UOMQty AS Qty, Status, Total, 
						  UOMPrice AS Price,StartSaleTime As SaleTime, Type
	FROM      HistoryView  '
END


 IF not EXISTS ( Select 1 from @Stores)  OR (SELECT COUNT(*) From @Stores) <=1
 begin 
SET @Filter = @Filter + ' AND  ItemStoreID =''' +  CAST(@ItemStoreID as varchar(50))  + ''''
end 
else
begin 
 declare @ItemId uniqueidentifier
select @ItemId =ItemStore.itemno
from ItemStore 
where ItemStore.ItemStoreID=@ItemStoreID

SET @Filter = @Filter + ' AND  ItemID =''' +  CAST(@ItemId as varchar(50))  + ''''
SET @Filter = @Filter + ' AND  StoreID in (select n from  @Stores)'
end 
END	

Print @MySelect + @Filter
set @MySelect =@MySelect+@Filter

 exec sp_executesql @query=@MySelect, @params=N'@Stores Guid_list_tbltype READONLY ', @Stores=@Stores
--Execute (@MySelect + @Filter)




---------
GO