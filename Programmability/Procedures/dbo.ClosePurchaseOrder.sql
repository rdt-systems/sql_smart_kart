SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[ClosePurchaseOrder] 
(@PoID uniqueidentifier,
 @ModifierID uniqueidentifier)
AS

             UPDATE PurchaseOrders
             SET    POStatus=2 ,--Close
                    DateModified=dbo.GetLocalDATE(),
		    UserModified =@ModifierID
             WHERE  PurchaseOrderID=@PoID

Declare @ItemNo uniqueidentifier
DECLARE PO1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT ItemNo FROM PurchaseOrderEntryView Where PurchaseOrderNO=@PoID

OPEN PO1

FETCH NEXT FROM PO1
INTO @ItemNo

WHILE  @@FETCH_STATUS = 0
BEGIN
	Exec UpdateOnOrderByOrder @ItemNo,@ModifierID

	FETCH NEXT FROM PO1
	INTO @ItemNo
END

CLOSE PO1
DEALLOCATE PO1
GO