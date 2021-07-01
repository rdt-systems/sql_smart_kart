SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[OnRequestUpdateOneItem](@ItemStoreID uniqueidentifier)
as

update ItemStore set OnRequest = isnull(Request.Sum_Qty,0)
From
    ItemStore Left Join
    (Select
         Sum(RequestTransferEntry.Qty) As Sum_Qty,
         RequestTransferEntry.ItemId,
		 RequestTransfer.ToStoreID
     From
         RequestTransfer Inner Join
         RequestTransferEntry On RequestTransferEntry.RequestTransferID = RequestTransfer.RequestTransferID
     Where
         RequestTransfer.Status > 0 And
         RequestTransferEntry.Status > 0 And
         Not Exists(Select
              1
          From
              TransferEntry As TE
          Where
              TE.RequestTransferEntryID = RequestTransferEntry.RequestTransferEntryID)
     Group By
         RequestTransferEntry.ItemID,ToStoreID) As Request On ItemStore.ItemNo = Request.ItemID AND ItemStore.StoreNo= Request.ToStoreID AND ItemStoreID =@ItemStoreID

EXEC	 [dbo].[OnRequestUpdateOneItem] @ItemStoreID = @ItemStoreID
EXEC	 [dbo].[SP_UpdateOnHandOneItem] @ItemStoreID = @ItemStoreID
GO