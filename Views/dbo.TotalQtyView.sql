SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[TotalQtyView]
AS
SELECT        TransactionID, TransactionEntryID, CASE When M.ItemType = 4 Then 1 ELSE T.UOMQty END AS Qty
                               FROM            TransactionEntry T INNER JOIN ItemStore S  ON  T.ItemStoreID = S.ItemStoreID INNER JOIN
							   ItemMain M on S.ItemNo = M.ItemID 
                               WHERE        (T.Status > 0) AND (TransactionEntryType = 0)


GO