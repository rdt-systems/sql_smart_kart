SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





create procedure [dbo].[SearchItemBySold]
(
	@SoldType nvarchar(4000),
	@Days int,
	@StoreID uniqueidentifier
)
AS



if @SoldType ='Sold' 
	begin 
	   		Select ItemID 
			From ItemMain im inner join ItemStore i on i.ItemNo = im.ItemID
			Where i.Status > 0 
			AND im.Status > 0 
			AND StoreNo = @StoreID 
			and exists (
			select 1
			from TransactionEntry te join [Transaction] t on te.transactionid=t.transactionid
 			where te.ItemStoreID=i.ItemStoreID
			and te.status>0
			and t.status>0
			and t.StartSaleTime > DATEADD(d,@days*-1,dbo.getlocaldate()))
	end 
else
	begin 
			Select ItemID 
			From ItemMain im inner join ItemStore i on i.ItemNo = im.ItemID
			Where i.Status > 0 
			AND im.Status > 0 
			AND StoreNo = @StoreID 
			and not  exists (
			select 1
			from TransactionEntry te join [Transaction] t on te.transactionid=t.transactionid
 			where te.ItemStoreID=i.ItemStoreID
			and te.status>0
			and t.status>0
			and t.StartSaleTime > DATEADD(d,@days*-1,dbo.getlocaldate()))

	end
GO