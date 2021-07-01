SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_AdjustInventoryOneItem](
@AdjustInventoryId uniqueidentifier,
@Qty decimal,
@OldQty decimal,
@AdjustReason nvarchar(4000),
@Cost money,
@AdjustType int,
@ItemStoreNo uniqueidentifier,
@Status smallint = 1,
@ModifierID uniqueidentifier,
@DateCreated datetime =null)
AS
BEGIN
declare @vDate as datetime
if @DateCreated IS NULL
  set @vDate =dbo.GetLocalDATE()
ELSE
  set @vDate =@DateCreated
Insert Into     AdjustInventory   (AdjustInventoryId, ItemStoreNo, AdjustType, Qty, OldQty, AdjustReason, AccountNo, Cost, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES (@AdjustInventoryId, @ItemStoreNo, @AdjustType, @Qty, @OldQty, @AdjustReason, 0, @Cost, 1,@vDate , @ModifierID,@vDate, @ModifierID)

Exec SP_UpdateOnHandOneItem @ItemStoreNo

END
GO