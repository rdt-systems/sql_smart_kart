SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetRegistersView]

(@StoreID uniqueidentifier=null,
@DeletedOnly bit =0,
@DateModified datetime=null, 
@refreshTime  datetime output)
AS


if @DateModified is null 
begin
	if @StoreID is null
		
		SELECT     dbo.RegistersView.*
		FROM         dbo.RegistersView
   		WHERE     (Status > - 1) 
	else

		SELECT     dbo.RegistersView.*
		FROM         dbo.RegistersView
   		WHERE     (Status > - 1) and (StoreID=@StoreID)

 set @refreshTime = dbo.GetLocalDATE()
 return
end


if  @DeletedOnly=0 

	SELECT     dbo.RegistersView.*
	FROM         dbo.RegistersView
	WHERE     (DateModified>@DateModified) 
	 AND (Status > - 1)and (StoreID=@StoreID)

else

	SELECT     dbo.RegistersView.*
	FROM         dbo.RegistersView
	WHERE     (DateModified>@DateModified) 
                AND  (Status = - 1)and (StoreID=@StoreID)
set @refreshTime = dbo.GetLocalDATE()
GO