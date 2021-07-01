SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomerToPhoneView]
(@DeletedOnly bit =0,
@DateModified datetime=null, 
@ID uniqueidentifier=null,
@refreshTime  datetime output)

AS 


if @DateModified is null 
begin
   	SELECT     dbo.CustomerToPhoneView.*
	FROM         dbo.CustomerToPhoneView
	WHERE     (Status > - 1)

set @refreshTime = dbo.GetLocalDATE()
 return
end

IF @ID IS NOT NULL
BEGIN 
   	SELECT     dbo.CustomerToPhoneView.*
	FROM         dbo.CustomerToPhoneView
	WHERE     (Status > - 1) AND CostumerID=@ID AND DateModified>=@DateModified
   
    SET @RefreshTime = dbo.GetLocalDATE()
    RETURN
END 

if  @DeletedOnly=0 

	SELECT     dbo.CustomerToPhoneView.*
	FROM         dbo.CustomerToPhoneView
	WHERE     (DateModified>@DateModified) 
	 AND (Status > - 1)

else
	SELECT     dbo.CustomerToPhoneView.*
	FROM         dbo.CustomerToPhoneView
	WHERE     (DateModified>@DateModified) 
	                AND  (Status = - 1)

set @refreshTime = dbo.GetLocalDATE()
GO