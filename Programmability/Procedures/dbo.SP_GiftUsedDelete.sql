SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftUsedDelete]
(@GiftUsedID uniqueidentifier,
@ModifierId uniqueidentifier)
AS 
--UPDATE   dbo.GiftUsed
--SET              Status = - 1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierId
--WHERE     (GiftUsedID = @GiftUsedID)
GO