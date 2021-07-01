SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetWorkOrderEntryView]
(@DeletedOnly bit =0,
@DateModified datetime=null)
AS 

if @DateModified is null 
begin
	SELECT     dbo.WorkOrderEntryView.*
	FROM         dbo.WorkOrderEntryView
	WHERE     (Status > - 1)

  return
end


if  @DeletedOnly=0 
	SELECT     dbo.WorkOrderEntryView.*
	FROM         dbo.WorkOrderEntryView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)
	

else
	SELECT     dbo.WorkOrderEntryView.*
	FROM         dbo.WorkOrderEntryView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)
GO