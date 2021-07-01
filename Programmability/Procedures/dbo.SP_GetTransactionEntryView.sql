SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionEntryView]
(@DeletedOnly bit =0,
@DateModified datetime=null)
AS 

if @DateModified is null 
begin
	SELECT     dbo.TransactionEntryView.*
	FROM         dbo.TransactionEntryView
	WHERE     (Status > - 1)

  return
end


if  @DeletedOnly=0 
	SELECT     dbo.TransactionEntryView.*
	FROM         dbo.TransactionEntryView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)
	

else
	SELECT     dbo.TransactionEntryView.*
	FROM         dbo.TransactionEntryView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)
GO