SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTenderEntryView]
(@DeletedOnly bit =0,
@DateModified datetime=null)
AS 


if @DateModified is null 
begin

SELECT     dbo.TenderEntryView.*
FROM         dbo.TenderEntryView
WHERE     (Status > - 1)

return
end


if  @DeletedOnly=0 
	SELECT     dbo.TenderEntryView.*
                FROM         dbo.TenderEntryView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	SELECT     dbo.TenderEntryView.*
                 FROM         dbo.TenderEntryView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)
GO