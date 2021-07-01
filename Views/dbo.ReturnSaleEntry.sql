SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ReturnSaleEntry] 
AS 
SELECT       CONVERT(DECIMAL(19, 3), 0) AS NewQty, TransactionEntry.Taxable AS IsTaxable, ItemStore.IsFoodStampable, ItemStore.IsDiscount, ItemStore.IsWIC, (CASE WHEN ISNULL(EntryDescription.Description, '') <> '' THEN EntryDescription.Description ELSE ISNULL(ItemMain.Name, 'Manual Item') 
                         END) AS Name, ItemMain.BarcodeNumber, ItemMain.ModalNumber, (CASE WHEN TransactionEntry.UOMQty = 0 THEN 0 ELSE ISNULL(dbo.TransactionEntry.UOMPrice, 1) / ISNULL(TransactionEntry.UOMQty, 1) 
                         * ISNULL(TransactionEntry.UOMQty, 1) END) AS Price,
                             (SELECT        CASE WHEN TransactionEntry.UOMTYPE IS NULL 
                                                         THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * ItemMain.CaseQty END AS Qty) AS QTY, 
                         TransactionEntry.TotalAfterDiscount, TransactionEntry.TransactionEntryID, TransactionEntry.TransactionID, ISNULL(ReturnTrans.TotalReturn, 0) AS ReturenQty, TransactionEntry.TaxRate, TransactionEntry.Sort,
STUFF((SELECT DISTINCT ',' + ISNULL(T.TransactionNo, '')
FROM            [Transaction] AS T INNER JOIN
                         TransactionEntry AS E ON T.TransactionID = E.TransactionID INNER JOIN
                         TransReturen AS R ON E.TransactionEntryID = R.SaleTransEntryID INNER JOIN
                         TransactionEntry AS EE ON R.ReturenTransID = EE.TransactionEntryID
WHERE        (T.Status > 0) AND (E.Status > 0) AND (R.Status > 0) AND EE.TransactionEntryID = TransactionEntry.TransactionEntryID FOR XML PATH('')), 1, 1, '') AS TransNumbers 
FROM            TransactionEntry INNER JOIN
                         [Transaction] ON TransactionEntry.TransactionID = [Transaction].TransactionID LEFT OUTER JOIN
                         ItemStore INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID ON TransactionEntry.ItemStoreID = ItemStore.ItemStoreID LEFT OUTER JOIN
                         EntryDescription ON TransactionEntry.TransactionEntryID = EntryDescription.TransactionEntryID LEFT OUTER JOIN
                             (SELECT        E.TransactionEntryID, SUM(E.Qty) AS TotalSale, SUM(R.Qty) AS TotalReturn
FROM            TransactionEntry AS E INNER JOIN 
                         TransReturen AS R ON E.TransactionEntryID = R.ReturenTransID INNER JOIN TransactionEntry RE ON R.SaleTransEntryID = RE.TransactionEntryID
WHERE        (E.Status > 0) AND (R.Status > 0) AND (RE.Status >0)
GROUP BY E.TransactionEntryID) AS ReturnTrans ON TransactionEntry.TransactionEntryID = ReturnTrans.TransactionEntryID
WHERE TransactionEntry.Status>0
GO