SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_DepartmentToUserGroupDelete]
(@DepartmentToUserGroupID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 

UPDATE dbo.DepartmentToUserGroup             
SET     status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
WHERE DepartmentToUserGroupID=@DepartmentToUserGroupID
GO