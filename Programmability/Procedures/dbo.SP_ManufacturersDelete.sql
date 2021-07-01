SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ManufacturersDelete]
(@ManufacturerID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE dbo.Manufacturers

SET	Status=-1,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
WHERE	ManufacturerID=@ManufacturerID
GO