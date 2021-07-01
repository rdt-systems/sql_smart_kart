SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPurchaseOrdersView]
(@StoreID uniqueidentifier=null,
@DeletedOnly bit =0,
@DateModified datetime=null,
@POStatus as smallint=1, @refreshTime  datetime output)

AS 

if @DateModified is null 
begin
	
	SELECT     dbo.PurchaseOrdersView.*
	FROM         dbo.PurchaseOrdersView
	WHERE     (Status > - 1) AND (StoreNo = @StoreID or @StoreID is null)   and POStatus<=@POStatus
	set @refreshTime = dbo.GetLocalDATE()
	return

end

if  @DeletedOnly=0 


	SELECT     dbo.PurchaseOrdersView.*
                FROM         dbo.PurchaseOrdersView
	WHERE  DateModified>@DateModified  and StoreNo = @StoreID and POStatus>=@POStatus
	 AND Status > - 1

else
	SELECT     dbo.PurchaseOrdersView.*
                FROM         dbo.PurchaseOrdersView
	WHERE     DateModified>@DateModified  and StoreNo = @StoreID and POStatus>=@POStatus
                AND  Status = - 1
set @refreshTime = dbo.GetLocalDATE()
GO