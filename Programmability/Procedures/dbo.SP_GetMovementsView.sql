SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetMovementsView](@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS


if @DateModified is null 
begin
   	SELECT     dbo.MovementsView.*
	FROM         dbo.MovementsView
	WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
 return
end


if  @DeletedOnly=0 
	SELECT     dbo.MovementsView.*
	FROM         dbo.MovementsView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	SELECT     dbo.MovementsView.*
	FROM         dbo.MovementsView
	WHERE     (DateModified>@DateModified) 
	                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO