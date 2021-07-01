SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_AuthorizationDelete](@GroupID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.[Authorization]
SET              Status = - 1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE     (GroupID = @GroupID)
Update Users Set DateModified = dbo.GetLocalDATE()
GO