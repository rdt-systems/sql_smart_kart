SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_LocalTransactionEntry]
(
@DateModified datetime=null
)
AS 
SELECT        TransactionEntry.TransactionEntryID, TransactionEntry.Status, (CASE WHEN ISNULL(EntryDescription.Description, '') <> '' THEN EntryDescription.Description ELSE ISNULL(ItemMain.Name, 'Manual Item') END) AS Name, 
                         ItemMain.BarcodeNumber, ItemMain.ModalNumber, TransactionEntry.UOMQty AS Qty, TransactionEntry.Total,TransactionEntry.TotalAfterDiscount, TransactionEntry.RegUnitPrice, TransactionEntry.UOMPrice, [Transaction].TransactionID, 
                         [Transaction].TransactionNo, TransactionEntry.TransactionEntryType, ISNULL(ReturnTrans.TotalReturn, 0) AS ReturenQty, ISNULL([Transaction].DateModified, [Transaction].DateCreated) AS DateModified, TransactionEntry.Sort, [Transaction].StoreID
FROM            dbo.TransactionEntry WITH (NOLOCK) INNER JOIN
                         dbo.[Transaction] WITH (NOLOCK)  ON TransactionEntry.TransactionID = [Transaction].TransactionID LEFT OUTER JOIN
                         dbo.ItemStore INNER JOIN
                         dbo.ItemMain ON ItemStore.ItemNo = ItemMain.ItemID ON TransactionEntry.ItemStoreID = ItemStore.ItemStoreID LEFT OUTER JOIN
                         dbo.EntryDescription ON TransactionEntry.TransactionEntryID = EntryDescription.TransactionEntryID  LEFT OUTER JOIN
                             (SELECT TransactionEntryID, SUM(ISNULL(Qty,0)) AS TotalSale , SUM(ISNULL(ReturnedQty,0)) AS TotalReturn From dbo.ReturnedQtyView
GROUP BY TransactionEntryID) AS ReturnTrans ON TransactionEntry.TransactionEntryID = ReturnTrans.TransactionEntryID
WHERE    TransactionEntry.Status >0 AND [Transaction].Status > 0 AND   (DATEDIFF(DAY, [Transaction].StartSaleTime, dbo.GetLocalDate()) < 60) AND (ISNULL([Transaction].DateModified, [Transaction].DateCreated) >@DateModified) AND TransactionEntry.Status >0
GO