SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPurchaseOrderEntryView]
(@PurchaseOrderID uniqueidentifier = NULL,
@DeletedOnly bit =0,
@DateModified datetime=null, 
@refreshTime  datetime output)

AS 

IF @PurchaseOrderID IS NOT NULL 
BEGIN
   SELECT     dbo.PurchaseOrderEntryView.*
   FROM         dbo.PurchaseOrderEntryView
   WHERE  (PurchaseOrderNo = @PurchaseOrderID ) AND   (Status > - 1)

  RETURN
END

if @DateModified is null 
begin

 SELECT     dbo.PurchaseOrderEntryView.*
FROM         dbo.PurchaseOrderEntryView
WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
return
end

if  @DeletedOnly=0 

	 SELECT     dbo.PurchaseOrderEntryView.*
                 FROM         dbo.PurchaseOrderEntryView
	WHERE     (DateModified>@DateModified)  AND (Status > - 1)

else
	 SELECT     dbo.PurchaseOrderEntryView.*
                 FROM         dbo.PurchaseOrderEntryView
	WHERE     (DateModified>@DateModified)  
	                  AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO