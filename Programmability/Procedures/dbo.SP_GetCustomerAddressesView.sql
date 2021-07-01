SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomerAddressesView]
(@DeletedOnly bit =0,
@DateModified datetime=null, 
@ID uniqueidentifier=null,
@refreshTime  datetime output)
AS


if @DateModified is null 
begin
   	SELECT     dbo.CustomerAddressesView.*
	FROM         dbo.CustomerAddressesView
	WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
 return
end

IF @ID IS NOT NULL
BEGIN 
   	SELECT     dbo.CustomerAddressesView.*
	FROM         dbo.CustomerAddressesView
	WHERE     Status > - 1 AND CustomerID=@ID AND DateModified>=@DateModified
   
    SET @RefreshTime = dbo.GetLocalDATE()
    RETURN
END 

if  @DeletedOnly=0 
	SELECT     dbo.CustomerAddressesView.*
	FROM         dbo.CustomerAddressesView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	SELECT   dbo.CustomerAddressesView.*
	FROM         dbo.CustomerAddressesView
	WHERE     (DateModified>@DateModified) 
	                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO