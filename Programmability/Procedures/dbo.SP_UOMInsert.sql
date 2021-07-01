SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_UOMInsert]
(@UOMID uniqueidentifier,
@UOMName  nvarchar(50),
@SortValue smallint,
@Status smallint,
@ModifierID uniqueidentifier)
As
INSERT INTO UOM (UOMID, UOMName,  SortValue,  Status,  DateCreated, 
                                 UserCreated, DateModified, UserModified)

VALUES(@UOMID,   dbo.CheckString(@UOMName), @SortValue, 1, dbo.GetLocalDATE(), @ModifierID,   dbo.GetLocalDATE(), @ModifierID)
GO