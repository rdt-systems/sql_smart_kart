SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UOMUpdate]
(@UOMID uniqueidentifier,
@UOMName  nvarchar(50),
@SortValue smallint,
@Status smallint,
@ModifierID uniqueidentifier)
As
UPDATE UOM
SET   UOMName = @UOMID, SortValue = @SortValue,  Status  =@Status,  DateCreated = dbo.GetLocalDATE(),   UserCreated = @ModifierID, DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
                            
WHERE UOMID = @UOMID
GO