SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[GetDepartmentToUserGroup]
(@GroupID uniqueidentifier)
as 
select DepartmentToUserGroup.DepartmentToUserGroupID ,
DepartmentToUserGroup.GroupID,
groups.GroupName,
DepartmentToUserGroup.DepartmentID,
DepartmentStore.Name,
DepartmentToUserGroup.Status,
DepartmentToUserGroup.DateCreated,
DepartmentToUserGroup.UserCreated,
DepartmentToUserGroup.DateModified,
DepartmentToUserGroup.UserModified
From DepartmentToUserGroup  join groups  on DepartmentToUserGroup.GroupID =groups.GroupID
 join DepartmentStore  on DepartmentToUserGroup.DepartmentID =DepartmentStore.DepartmentStoreID
where DepartmentToUserGroup.GroupID=@GroupID 




/****** Object:  StoredProcedure [dbo].[GetSecuirtyOfColumns]    Script Date: 2/23/2017 4:52:47 PM ******/
GO