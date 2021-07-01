SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSupplyUpdateChild]
(@ParentBarcodeNumber nvarchar(50))
AS 

--select the ItemID from Itemmain
Declare @ItemID Uniqueidentifier
Declare @SupplierNo Uniqueidentifier
Declare @IsMainSupplier bit
Declare @ItemStoreID Uniqueidentifier

select @ItemID = itemID from ItemMain where BarcodeNumber = @ParentBarcodeNumber

--declare ItemSupplyCursor cursor for
--Select all records from ItemSupply
select top 1 @SupplierNo = SupplierNo,@IsMainSupplier = IsMainSupplier from ItemSupply 
where ItemStoreNo in (select ItemStoreID from ItemStore where ItemNo = @ItemID) and IsMainSupplier = 1

--Open ItemSupplyCursor
--fetch next from ItemSupplyCursor into @SupplierNo,@IsMainSupplier
--while @@FETCH_STATUS = 0
    --begin
		
		Declare ItemSupplyChildCursor Cursor for
		select ItemStoreID from ItemStore where ItemNo in (select ItemID from ItemMain where LinkNo = @ItemID) 
		
		Open ItemSupplyChildCursor
		fetch next from ItemSupplyChildCursor into @ItemStoreID

		while @@FETCH_STATUS = 0
		begin
			exec Sync_UpdateItemSupply @ItemStoreID,@SupplierNo, NULL
			fetch next from ItemSupplyChildCursor into @ItemStoreID
		end

--	end
--close ItemSupplyCursor
--deallocate ItemSupplyCursor
GO