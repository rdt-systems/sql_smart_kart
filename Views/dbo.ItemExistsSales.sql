SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemExistsSales]

AS


Select EndSaleTime, ItemStoreID From [Transaction] T INNER JOIN TransactionEntry R ON T.TransactionID = R.TransactionID
Where   (R.Status > 0) AND (R.TransactionEntryType <> 4) AND (R.TransactionEntryType <> 5) AND (T.Status > 0)

GO