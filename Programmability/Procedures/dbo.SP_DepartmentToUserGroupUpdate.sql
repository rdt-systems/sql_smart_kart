SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DepartmentToUserGroupUpdate]
(
@DepartmentToUserGroupID uniqueidentifier,
@GroupID uniqueidentifier,
@DepartmentID uniqueidentifier,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier
)


AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE dbo.DepartmentToUserGroup
                
       SET  GroupID =@GroupID, DepartmentID=@DepartmentID, Status=@Status,DateModified=@UpdateTime, UserModified=@ModifierID

WHERE (DepartmentToUserGroupID=@DepartmentToUserGroupID)
GO