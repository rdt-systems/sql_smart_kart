SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReturnToVenderEntryUpdate]
(@ReturnToVenderEntryID uniqueidentifier,
@ReturnToVenderID uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@Cost Money, 
@Qty decimal,
@UOMQty decimal,
@UOMType int,
@ExtPrice Money, 
@IsSpecialPrice Bit,
@Taxable bit,
@LinkNo uniqueidentifier,
@ReturnReason int,
@Note nvarchar(4000),
@ReceiveID uniqueidentifier,
@SortOrder int,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @OldItem uniqueidentifier
SET @OldItem =(SELECT ItemStoreNo FROM dbo.ReturnToVenderEntry WHERE  ReturnToVenderEntryID = @ReturnToVenderEntryID)
DECLARE @OldQty decimal
SET @OldQty = (SELECT Qty FROM dbo.ReturnToVenderEntry WHERE  ReturnToVenderEntryID = @ReturnToVenderEntryID)

UPDATE    dbo.ReturnToVenderEntry
SET              ReturnToVenderID = @ReturnToVenderID, ItemStoreNo = @ItemStoreNo, Cost = @Cost, Qty=@Qty,UOMQty=@UOMQty,UOMType=@UOMType,
                      ExtPrice=@ExtPrice,LinkNo = @LinkNo,Taxable=@Taxable, ReturnReason = @ReturnReason, 
                      Note = @Note,ReceiveID=@ReceiveID, Status = @Status, DateModified = @UpdateTime, SortOrder=@SortOrder,
                      UserModified = @ModifierID
WHERE     (ReturnToVenderEntryID = @ReturnToVenderEntryID) and  (DateModified = @DateModified or DateModified is NULL)


Exec UpdateToReturnToVenderEntryUpdate @ItemStoreNo, @OldItem ,@OldQty ,@Qty ,@Status , @ModifierID 

select @UpdateTime as DateModified
GO