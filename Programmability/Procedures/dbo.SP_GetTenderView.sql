SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTenderView]
(@DeletedOnly bit =0,
@DateModified datetime=null,
 @StoreID uniqueidentifier =null,
 @refreshTime  datetime output)
AS 


if @DateModified is null 
begin
	SELECT     dbo.TenderView.*
	FROM         dbo.TenderView
	WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
 return
end


if  @DeletedOnly=0 
	SELECT     dbo.TenderView.*
        FROM         dbo.TenderView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	SELECT     dbo.TenderView.*
        FROM         dbo.TenderView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)

set @refreshTime = dbo.GetLocalDATE()
GO