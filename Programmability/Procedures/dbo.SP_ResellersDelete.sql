SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ResellersDelete]
(@ResellerID uniqueidentifier,
@ModifierID uniqueidentifier)

AS UPDATE    dbo.Resellers
SET	Status = -1,
	DateModified = dbo.GetLocalDATE(),
	userModified=@ModifierID
	
WHERE	ResellerID = @ResellerID
GO