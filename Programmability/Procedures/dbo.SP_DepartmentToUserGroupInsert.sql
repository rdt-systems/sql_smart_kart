SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_DepartmentToUserGroupInsert](
@DepartmentToUserGroupID uniqueidentifier,
@GroupID uniqueidentifier,
@DepartmentID uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier
)
AS 


INSERT INTO dbo.DepartmentToUserGroup
                      (	 DepartmentToUserGroupID,GroupID,DepartmentID,Status,DateCreated,UserCreated,DateModified,UserModified)
VALUES     (@DepartmentToUserGroupID, @GroupID,@DepartmentID, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO