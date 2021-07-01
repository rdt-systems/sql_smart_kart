SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemSeasonView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS


if @DateModified is null 
begin
SELECT    *
FROM         dbo.ItemSeasonView
WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
return
end


if  @DeletedOnly=0 
	SELECT    *
FROM         dbo.ItemSeasonView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	SELECT    *
FROM         dbo.ItemSeasonView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO