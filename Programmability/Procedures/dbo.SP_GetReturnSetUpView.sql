SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReturnSetUpView](@StoreID uniqueidentifier,
@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS 


if @DateModified is null 
begin
	SELECT     dbo.ReturnSetUpView.*
	FROM         dbo.ReturnSetUpView
	WHERE     (Status > - 1) AND (StoreID = @StoreID)
set @refreshTime = dbo.GetLocalDATE()
  return
end


if  @DeletedOnly=0 
	SELECT     dbo.ReturnSetUpView.*
	FROM         dbo.ReturnSetUpView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)AND (StoreID = @StoreID)

else
	SELECT     dbo.ReturnSetUpView.*
	FROM         dbo.ReturnSetUpView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)AND (StoreID = @StoreID)
set @refreshTime = dbo.GetLocalDATE()
GO