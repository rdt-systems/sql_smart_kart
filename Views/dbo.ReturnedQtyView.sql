SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ReturnedQtyView]

AS


SELECT DISTINCT T.TransactionID, T.TransactionEntryID, CASE WHEN M.ItemType = 4 THEN 1 ELSE T .UOMQty END AS Qty, ISNULL(R.Qty, 0) AS ReturnedQty
FROM            dbo.TransactionEntry AS T WITH (NOLOCK) INNER JOIN
                         dbo.ItemStore AS S WITH (NOLOCK)  ON T.ItemStoreID = S.ItemStoreID INNER JOIN
                         dbo.ItemMain AS M WITH (NOLOCK)  ON S.ItemNo = M.ItemID LEFT OUTER JOIN
                             (SELECT        ReturenTransID, SUM(TT.Qty) AS Qty
                               FROM            dbo.TransReturen AS TT WITH (NOLOCK)  INNER JOIN dbo.TransactionEntry RE WITH (NOLOCK) ON TT.SaleTransEntryID = RE.TransactionEntryID
                               WHERE        (TT.Status > 0) and (RE.Status >0)
                               GROUP BY ReturenTransID) AS R ON T.TransactionEntryID = R.ReturenTransID
WHERE        (T.Status > 0) AND (T.TransactionEntryType = 0)
GO