SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemMainDelete]
	@ItemID uniqueidentifier,
	@ModifierID uniqueidentifier
AS

IF
	(select count(*) from dbo.ItemStore
	where ItemNo = @ItemID and ItemStore.Status > -1) = 0
begin
	update dbo.ItemMain
	set Status = -1, DateModified = dbo.GetLocalDATE(),
		UserModified = @ModifierID
	where ItemID = @ItemID

	Update ItemStore Set Status = -1, DateModified = dbo.GetLocalDATE() where ItemNo = @ItemID

end
GO