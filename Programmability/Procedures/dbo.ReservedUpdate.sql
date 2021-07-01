SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReservedUpdate]
 AS

 UPDATE ItemStore Set Reserved =IsNull(Receive.rsv,0)+IsNull(Request.Sum_Qty,0)
From
    dbo.ItemStore WITH (NOLOCK) Left Join
    (Select
         Sum(RequestTransferEntry.Qty) As Sum_Qty,
         RequestTransferEntry.ItemId,
         RequestTransfer.FromStoreID
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
         RequestTransferEntry.ItemId,
         RequestTransfer.FromStoreID) As Request On ItemStore.ItemNo = Request.ItemId
            And ItemStore.StoreNo = Request.FromStoreID Left Join
    (Select
         Sum(ReceiveTransferEntry.Qty) As rsv,
         TransactionEntry.ItemStoreID
     From
         dbo.TransactionEntry WITH (NOLOCK) Inner Join
         dbo.RequestTransferEntry WITH (NOLOCK) On TransactionEntry.TransactionEntryID = RequestTransferEntry.TransactionEntryID
         Inner Join
         dbo.TransferEntry WITH (NOLOCK) On RequestTransferEntry.RequestTransferEntryID = TransferEntry.RequestTransferEntryID Inner Join
         dbo.ReceiveTransferEntry WITH (NOLOCK) On ReceiveTransferEntry.TransferEntryID = TransferEntry.TransferEntryID
     Where
         TransactionEntry.Status > 0 And
         TransactionEntry.TransactionEntryType = 11 And
         RequestTransferEntry.Status > 0 And
         TransferEntry.Status > 0 And
         ReceiveTransferEntry.Status > 0
     Group By
         TransactionEntry.ItemStoreID) Receive On ItemStore.ItemStoreID = Receive.ItemStoreID
GO