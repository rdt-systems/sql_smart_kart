SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReturnToVenderEntryInsert]
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
@ModifierID uniqueidentifier)


AS INSERT INTO dbo.ReturnToVenderEntry
                      (ReturnToVenderEntryID, ReturnToVenderID,ItemStoreNo,Cost,Qty,UOMQty,UOMType,ExtPrice , IsSpecialPrice,LinkNo,Taxable,    ReturnReason,          Note,ReceiveID,SortOrder,  Status, DateCreated,  UserCreated, DateModified, UserModified)

VALUES     (@ReturnToVenderEntryID, @ReturnToVenderID,  @ItemStoreNo,@Cost, @Qty,@UOMQty,@UOMType,@ExtPrice, @IsSpecialPrice,    @LinkNo,@Taxable, @ReturnReason,  @Note,@ReceiveID,@SortOrder,  1,  dbo.GetLocalDATE(),   @ModifierID,   dbo.GetLocalDATE(), @ModifierID)
                
exec UpdateToReturnToVenderEntryInsert
 @ItemStoreNo ,
 @Qty ,
 @ModifierID
GO