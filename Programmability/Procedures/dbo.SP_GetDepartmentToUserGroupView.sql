SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_GetDepartmentToUserGroupView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)

AS

if @DateModified is null 

begin
   SELECT     dbo.DepartmentToUserGroupView.*
   FROM         dbo.DepartmentToUserGroupView
        WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
return
end


if  @DeletedOnly=0 
   SELECT     dbo.DepartmentToUserGroupView.*
   FROM         dbo.DepartmentToUserGroupView
	WHERE     (DateModified>@DateModified )
	 AND (Status > - 1)
else

   SELECT     dbo.DepartmentToUserGroupView.*
   FROM         dbo.DepartmentToUserGroupView
	WHERE     (DateModified>@DateModified )
                AND  (Status = - 1) 
set @refreshTime = dbo.GetLocalDATE()
GO