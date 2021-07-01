SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemAliasDelete]
(@AliasId uniqueidentifier,
@ModifierID uniqueidentifier)
AS
declare @ItemID Uniqueidentifier
SELECT @ItemID = ItemNo From ItemAlias where AliasId = @AliasId
UPDATE dbo.ItemAlias

SET     status = - 1,  DateModified = dbo.GetLocalDATE(),  UserModified =  @ModifierID
WHERE  AliasId = @AliasId
Update ItemMain Set DateModified = dbo.GetLocalDATE() Where ItemID = @ItemID
Update ItemStore Set DateModified = dbo.GetLocalDATE() Where ItemNo = @ItemID



Delete From ItemAlias Where Status = - 1
GO