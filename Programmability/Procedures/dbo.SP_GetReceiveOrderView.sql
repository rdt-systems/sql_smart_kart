SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceiveOrderView]
(@StoreID uniqueidentifier,
@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)

AS 

if @DateModified is null 
begin

 SELECT     dbo.ReceiveOrderView.*
 FROM         dbo.ReceiveOrderView
 WHERE     (Status > - 1) AND (StoreID = @StoreID)
set @refreshTime = dbo.GetLocalDATE()
return
end


if  @DeletedOnly=0 

	SELECT     dbo.ReceiveOrderView.*
 FROM         dbo.ReceiveOrderView
	 WHERE     (DateModified>@DateModified)  and (StoreID = @StoreID)
	 AND (Status > - 1)

else
	 SELECT     dbo.ReceiveOrderView.*
 FROM         dbo.ReceiveOrderView
	 WHERE     (DateModified>@DateModified)  and (StoreID = @StoreID)

	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO