SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSpecialDelete]

(@ItemSpecialID int,
@ModifierID uniqueidentifier)

AS

UPDATE [dbo].[ItemSpecial]
SET
       	
	Status=-1,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID

WHERE ItemSpecialID=@ItemSpecialID
GO