SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[CustomerLastItemsView]
AS
 select F.DupeCount AS Number,F.TransactionNo  ,C.CustomerID , F.Qty, F.StartSaleTime,C.DateModified,F.Price,
                         F.BarcodeNumber,F.ModalNumber,F.Name,CONVERT(varchar(100), Cast(DupeCount as decimal(38, 0)))+C.CustomerNo AS ID , ReturenQty, 1 As Status from (
SELECT ROW_NUMBER() OVER (PARTITION BY CustomerID
      ORDER BY StartSaleTime desc,CustomerID  ) AS DupeCount,       ItemMain.BarcodeNumber, [Transaction].StartSaleTime, TransactionEntry.UOMPrice AS Price, ItemMain.Name, ItemMain.ModalNumber, [Transaction].CustomerID, [Transaction].TransactionNo, 
                         TransactionEntry.UOMQty AS Qty,  ISNULL(ReturnTrans.TotalReturn, 0) AS ReturenQty
FROM            dbo.[Transaction] WITH (NOLOCK) INNER JOIN
                         dbo.TransactionEntry WITH (NOLOCK)  ON [Transaction].TransactionID = TransactionEntry.TransactionID INNER JOIN
                         dbo.ItemStore ON TransactionEntry.ItemStoreID = ItemStore.ItemStoreID INNER JOIN
                         dbo.ItemMain ON ItemStore.ItemNo = ItemMain.ItemID  LEFT OUTER JOIN
                             (SELECT TransactionEntryID, SUM(ISNULL(Qty,0)) AS TotalSale , SUM(ISNULL(ReturnedQty,0)) AS TotalReturn From ReturnedQtyView
GROUP BY TransactionEntryID) AS ReturnTrans ON TransactionEntry.TransactionEntryID = ReturnTrans.TransactionEntryID) as F
  INNER JOIN dbo.Customer As C On C.CustomerID = F.CustomerID 
  where DupeCount<6
GO