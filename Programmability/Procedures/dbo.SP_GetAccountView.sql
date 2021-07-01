SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetAccountView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS


if @DateModified is null 
begin
    SELECT     AccountID, AccountName, AccountDescription, Status
    FROM         dbo.AccountView
    WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
    return
end


if  @DeletedOnly=0 
	SELECT     AccountID, AccountName, AccountDescription, Status
        FROM         dbo.AccountView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	 SELECT     AccountID, AccountName, AccountDescription, Status
    FROM         dbo.AccountView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO