SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UOMDelete]
(@UOMID uniqueidentifier,
@ModifierID uniqueidentifier)
As
UPDATE UOM
SET   Status  = -1,  DateModified = dbo.GetLocalDATE(),     UserModified = @ModifierID
                            
WHERE UOMID = @UOMID
GO