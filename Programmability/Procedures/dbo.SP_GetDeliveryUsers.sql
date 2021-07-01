SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetDeliveryUsers]
(@StoreID uniqueidentifier,
@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)

AS
if @DateModified is null 
begin
 	SELECT     dbo.UsersView.*
	FROM       dbo.UsersView
	   
WHERE(Status > - 1) AND (StoreID = @StoreID Or IsSuperAdmin=1)And(GroupName = 'Drivers') 
set @refreshTime = dbo.GetLocalDATE()
 	return
end

if  @DeletedOnly=0 
	SELECT     dbo.UsersView.*
	FROM       dbo.UsersView
	WHERE     (DateModified>@DateModified OR UserStoreDateM >=@DateModified ) AND (StoreID = @StoreID Or IsSuperAdmin=1) 
	
	 AND (Status > - 1)

else
	SELECT     dbo.UsersView.*
	FROM       dbo.UsersView
	WHERE     (DateModified>@DateModified OR UserStoreDateM >=@DateModified) 
	
                AND  (Status = - 1) AND (StoreID = @StoreID Or IsSuperAdmin=1) 
				
set @refreshTime = dbo.GetLocalDATE()
GO