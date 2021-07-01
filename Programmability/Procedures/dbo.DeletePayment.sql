SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[DeletePayment]
(@PaymentID uniqueidentifier,@ModifierID uniqueidentifier)

as

DECLARE @PayToBillID uniqueidentifier

UPDATE   dbo.SupplierTenderEntry
SET      Status = -1 ,
	     DateModified = dbo.GetLocalDATE(), 
	     UserModified = @ModifierID
WHERE    SuppTenderEntryID  = @PaymentID

DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT PayToBillID
FROM dbo.PayToBill WHERE(SuppTenderID = @PaymentID) 

OPEN c2

FETCH NEXT FROM c2 
INTO @PayToBillID   

WHILE @@FETCH_STATUS = 0
	BEGIN
		exec dbo.SP_PayToBillDelete @PayToBillID,@ModifierID
	FETCH NEXT FROM c2    
		INTO @PayToBillID
	END

CLOSE c2
DEALLOCATE c2
GO