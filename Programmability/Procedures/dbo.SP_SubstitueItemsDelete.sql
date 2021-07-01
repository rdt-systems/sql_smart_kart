SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SubstitueItemsDelete]
(@SubstitueItemsId uniqueidentifier,
@ModifierID uniqueidentifier)

AS 
UPDATE   dbo.SubstitueItems
                  SET  Status = -1,  DateModified = dbo.GetLocalDATE(), UserModified  = @ModifierID
WHERE  @SubstitueItemsId = SubstitueItemsId
GO