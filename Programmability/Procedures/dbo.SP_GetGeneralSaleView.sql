SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetGeneralSaleView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS


if @DateModified is null 
begin
   SELECT     dbo.GeneralSale.*
   FROM         dbo.GeneralSale
   WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
 return
end


if  @DeletedOnly=0 
	SELECT     dbo.GeneralSale.*
   FROM         dbo.GeneralSale
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	SELECT     dbo.GeneralSale.*
   FROM         dbo.GeneralSale
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO