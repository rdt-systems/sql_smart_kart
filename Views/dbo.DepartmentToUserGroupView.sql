SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




create VIEW [dbo].[DepartmentToUserGroupView]
AS
select 
DepartmentToUserGroup.DepartmentToUserGroupID ,
DepartmentToUserGroup.GroupID,
DepartmentToUserGroup.DepartmentID,
DepartmentToUserGroup.Status,
DepartmentToUserGroup.DateCreated,
DepartmentToUserGroup.UserCreated,
DepartmentToUserGroup.DateModified,
DepartmentToUserGroup.UserModified,
DepartmentStore.Name,
groups.GroupName
From DepartmentToUserGroup  join groups  on DepartmentToUserGroup.GroupID =groups.GroupID
 join DepartmentStore  on DepartmentToUserGroup.DepartmentID =DepartmentStore.DepartmentStoreID
GO