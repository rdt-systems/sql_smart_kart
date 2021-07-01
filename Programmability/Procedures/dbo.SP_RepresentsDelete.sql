SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RepresentsDelete]
(@repID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.Represents
SET              Status = -1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE   RepID=@RepID
GO