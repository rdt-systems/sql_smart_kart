SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetUsersStoreView]
(@StoreID uniqueidentifier,@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)

AS
if @DateModified is null 
begin
	SELECT     dbo.UsersStoreView.*
	FROM         dbo.UsersStoreView
	WHERE     (Status > - 1)AND (StoreID = @StoreID) 
set @refreshTime = dbo.GetLocalDATE()
   return
end


if  @DeletedOnly=0 
	SELECT     dbo.UsersStoreView.*
	FROM         dbo.UsersStoreView
	WHERE     (DateModified>@DateModified) AND (StoreID = @StoreID) 
	
	 AND (Status > - 1)

else
	SELECT     dbo.UsersStoreView.*
	FROM         dbo.UsersStoreView
	WHERE     (DateModified>@DateModified) AND (StoreID = @StoreID) 
	
                AND  (Status = - 1)

set @refreshTime = dbo.GetLocalDATE()
GO