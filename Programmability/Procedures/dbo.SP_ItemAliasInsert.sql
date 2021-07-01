SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemAliasInsert]
(@AliasId uniqueidentifier,
@ItemNo uniqueidentifier,
@BarcodeNumber nvarchar(50),
@Status smallint,
@ModifierID uniqueidentifier)
AS 

INSERT INTO dbo.ItemAlias
                      (AliasId, ItemNo, BarcodeNumber, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@AliasId, @ItemNo, @BarcodeNumber, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)

Update ItemMain Set DateModified = dbo.GetLocalDATE() Where ItemID = @ItemNo
Update ItemStore Set DateModified = dbo.GetLocalDATE() Where ItemNo = @ItemNo
GO