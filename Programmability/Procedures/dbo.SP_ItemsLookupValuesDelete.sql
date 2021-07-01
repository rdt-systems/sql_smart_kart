SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemsLookupValuesDelete]
(@ValueID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE dbo.ItemsLookupValues

SET	Status=-1,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
WHERE	ValueID=@ValueID
GO