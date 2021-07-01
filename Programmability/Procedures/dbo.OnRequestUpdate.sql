SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[OnRequestUpdate]
as

update ItemStore set OnRequest = isnull(Request.Sum_Qty,0)
From
    dbo.ItemStore WITH (NOLOCK) Left Join
    (Select
         Sum(RequestTransferEntry.Qty) As Sum_Qty,
         RequestTransferEntry.ItemId,
		 RequestTransfer.ToStoreID
     From
         dbo.RequestTransfer WITH (NOLOCK) Inner Join
         dbo.RequestTransferEntry WITH (NOLOCK) On RequestTransferEntry.RequestTransferID = RequestTransfer.RequestTransferID
     Where
         RequestTransfer.Status > 0 And
         RequestTransferEntry.Status > 0 And
         Not Exists(Select
              1
          From
              dbo.TransferEntry As TE WITH (NOLOCK)
          Where
              TE.RequestTransferEntryID = RequestTransferEntry.RequestTransferEntryID)
     Group By
         RequestTransferEntry.ItemID,ToStoreID) As Request On ItemStore.ItemNo = Request.ItemID AND ItemStore.StoreNo= Request.ToStoreID
GO