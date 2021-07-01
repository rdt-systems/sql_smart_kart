SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DamageItemUpdate]
(
@DamageItemID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Qty int,
@DamageStatus int,
@TransactionEntryID uniqueidentifier ,
@ReturnEntryID uniqueidentifier,
@Date DateTime,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

declare @OldDateModified datetime
Set @OldDateModified=(Select DateModified From DamageItem Where DamageItemID=@DamageItemID)

declare @OldStatus int
Set @OldStatus=(Select DamageStatus From DamageItem Where DamageItemID=@DamageItemID)

declare @OldQty decimal(19,3)
Set @OldQty=(Select Qty From DamageItem Where DamageItemID=@DamageItemID)

declare @OldItem uniqueidentifier
Set @OldItem=(Select ItemStoreID From DamageItem Where DamageItemID=@DamageItemID)

UPDATE dbo.DamageItem
SET	 
	ItemStoreID =@ItemStoreID, 
	Qty=@Qty, 
	DamageStatus=@DamageStatus, 
	TransactionEntryID=@TransactionEntryID  ,
	ReturnEntryID=@ReturnEntryID ,
	Date=@Date ,
	Status=@Status, 
	DateCreated=@UpdateTime, 
	UserCreated=@ModifierID, 
	DateModified=@UpdateTime, 
	UserModified=@ModifierID

where  (DamageItemID=@DamageItemID)
	and (DateModified = @DateModified OR DateModified IS NULL OR @DateModified IS NULL)

if  (@OldDateModified = @DateModified or @OldDateModified is NULL OR @DateModified IS NULL)
begin

		if @DamageStatus<>1
		begin
				UPDATE dbo.ItemStore
				SET OnHand = isnull(OnHand,0) - @Qty , 
					DateModified = dbo.GetLocalDATE(), 
					UserModified = @ModifierID
				WHERE ItemStoreID = @ItemStoreID
				EXEC UpdateParent @ItemStoreID,@ModifierID,1,0,0
		end
		if @OldStatus<>1
		begin
				UPDATE dbo.ItemStore
				SET OnHand = isnull(OnHand,0) + @OldQty , 
					DateModified = dbo.GetLocalDATE(), 
					UserModified = @ModifierID
				WHERE ItemStoreID = @OldItem
				EXEC UpdateParent @OldItem,@ModifierID,1,0,0
		end

end


select @UpdateTime as DateModified
GO