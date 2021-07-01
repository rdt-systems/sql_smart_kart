SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceiveEntryView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS 


if @DateModified is null 
begin
	SELECT     dbo.ReceiveEntryView.*
	FROM         dbo.ReceiveEntryView
	WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
 return
end


if  @DeletedOnly=0 
	SELECT     dbo.ReceiveEntryView.*
	FROM         dbo.ReceiveEntryView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	SELECT     dbo.ReceiveEntryView.*
	FROM         dbo.ReceiveEntryView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO