SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemGroupInsert]
(@ItemGroupID uniqueidentifier,
@ItemGroupName nvarchar(50),
@ParentID uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier)

AS
 INSERT INTO dbo.ItemGroup
                 
                    (ItemGroupID, ItemGroupName, ParentID,   Status, DateCreated, UserCreated,DateModified, UserModified)
	
VALUES        (@ItemGroupID, dbo.CheckString(@ItemGroupName),@ParentID, 1,   dbo.GetLocalDATE(),   @ModifierID,    dbo.GetLocalDATE(),      @ModifierID)
GO