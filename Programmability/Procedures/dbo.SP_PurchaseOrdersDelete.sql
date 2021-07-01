SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PurchaseOrdersDelete]
(@PurchaseOrderId uniqueidentifier,
@ModifierID uniqueidentifier)

AS
  Update  dbo.PurchaseOrders
  SET   Status  =  -1, 
         DateModified = dbo.GetLocalDATE(),   UserModified =@ModifierID
  WHERE  PurchaseOrderId  = @PurchaseOrderId
GO