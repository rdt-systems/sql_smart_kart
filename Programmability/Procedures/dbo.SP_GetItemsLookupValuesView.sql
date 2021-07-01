SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemsLookupValuesView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS


if @DateModified is null 
begin
SELECT     dbo.ItemsLookupValuesView.*
FROM         dbo.ItemsLookupValuesView
WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
 return
end


if  @DeletedOnly=0 
SELECT     dbo.ItemsLookupValuesView.*
FROM         dbo.ItemsLookupValuesView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
SELECT     dbo.ItemsLookupValuesView.*
FROM         dbo.ItemsLookupValuesView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO