SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReturnItemDelete](@ReturnItemId uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.ReturnItem
SET              Status = - 1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE     (ReturnItemID = @ReturnItemID)
GO