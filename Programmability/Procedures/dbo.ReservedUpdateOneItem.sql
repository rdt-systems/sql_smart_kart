SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReservedUpdateOneItem](@ItemStoreID uniqueidentifier)
 AS

 UPDATE ItemStore Set Reserved =IsNull(Receive.rsv,0)+IsNull(Request.Sum_Qty,0)
From
    ItemStore Left Join
    (Select
         Sum(RequestTransferEntry.Qty) As Sum_Qty,
         RequestTransferEntry.ItemId,
         RequestTransfer.FromStoreID
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
         RequestTransferEntry.ItemId,
         RequestTransfer.FromStoreID) As Request On ItemStore.ItemNo = Request.ItemId
            And ItemStore.StoreNo = Request.FromStoreID Left Join
    (Select
         Sum(ReceiveTransferEntry.Qty) As rsv,
         TransactionEntry.ItemStoreID
     From
         TransactionEntry Inner Join
         RequestTransferEntry On TransactionEntry.TransactionEntryID = RequestTransferEntry.TransactionEntryID
         Inner Join
         TransferEntry On RequestTransferEntry.RequestTransferEntryID = TransferEntry.RequestTransferEntryID Inner Join
         ReceiveTransferEntry On ReceiveTransferEntry.TransferEntryID = TransferEntry.TransferEntryID
     Where
         TransactionEntry.Status > 0 And
         TransactionEntry.TransactionEntryType = 11 And
         RequestTransferEntry.Status > 0 And
         TransferEntry.Status > 0 And
         ReceiveTransferEntry.Status > 0
     Group By
         TransactionEntry.ItemStoreID) Receive On ItemStore.ItemStoreID = Receive.ItemStoreID
WHERE ItemStore.ItemStoreID=@ItemStoreID
GO