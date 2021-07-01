SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemStoreUpdate_HandHeld]
(@ItemStoreID uniqueidentifier,
@ItemNo uniqueidentifier,
@StoreNo uniqueidentifier,
@Cost money,
@Price money,
@ModifierID uniqueidentifier)
AS 


Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @OldPrice money
set @OldPrice=(select Price 
	       from dbo.ItemStore
	       where ItemStoreID=@ItemStoreID)


declare @OldDateModified datetime
Set @OldDateModified=(Select DateModified From [ItemStore] Where ItemStoreID=@ItemStoreID)


UPDATE      dbo.ItemStore
SET         ItemNo = @ItemNo, 
			StoreNo = @StoreNo,
			Cost = @Cost, 
			Price = @Price, 
			UserModified = @ModifierID

WHERE     (ItemStoreID = @ItemStoreID) --AND (DateModified = @DateModified OR DateModified IS NULL) 

begin

IF @Price<>@OldPrice
INSERT INTO dbo.PriceChangeHistory(PriceChangeHistoryID,ItemStoreID,PriceLevel,OldPrice,NewPrice,UserID,[Date])
VALUES (NEWID(),@ItemStoreID,'Price',@OldPrice,@Price,@ModifierID,@UpdateTime)
end



select @UpdateTime as DateModified
GO