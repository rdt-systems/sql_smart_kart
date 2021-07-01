SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SubstitueItemsInsert]
(@SubstitueItemsId uniqueidentifier,
@ItemNo uniqueidentifier,
@SubstitueNo uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier)

AS INSERT INTO dbo.SubstitueItems
                      (SubstitueItemsId, ItemNo, SubstitueNo, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@SubstitueItemsId, @ItemNo, @SubstitueNo, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO