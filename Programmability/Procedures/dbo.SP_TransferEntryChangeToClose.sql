SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferEntryChangeToClose]
(@TransferID uniqueidentifier)
AS 

UPDATE TransferItems SET TransferStatus = 3
WHERE  TransferID = @TransferID

Update TransferEntry Set Status = 25, DateModified = dbo.GetLocalDATE() 
Where TransferID = @TransferID And TransferEntryID NOT IN (Select TransferEntryID From ReceiveTransferEntry Where Status >0)

Begin
Declare @ItemStoreID Uniqueidentifier

Declare Ro  CURSOR For
SELECT ItemStoreNo From TransferEntry 
Where TransferID = @TransferID 
And TransferEntryID NOT IN (Select TransferEntryID From ReceiveTransferEntry Where Status >0)

Open Ro

FETCH NEXT FROM Ro
Into @ItemStoreID

WHILE @@FETCH_STATUS = 0
Begin
Exec SP_UpdateOnHandOneItem @ItemStoreID
FETCH NEXT FROM Ro
Into @ItemStoreID
END

CLOSE Ro

DEALLOCATE Ro
End
GO