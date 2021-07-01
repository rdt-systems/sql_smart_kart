SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[TransactionEntryForTax]
AS
SELECT      DISTINCT  TransactionEntry.TransactionEntryID, 
			  [Transaction].TransactionID, 
			  [Transaction].TransactionNo, 
			  [Transaction].StoreID, 
			  [Transaction].StartSaleTime,
			  [Transaction].Tax AS TaxCollected ,
			  ISNULL(TotalAfterDiscount, 0) AS TotalAfterDiscount, 
			  Store.StoreName, TransactionEntry.Taxable, 
			  ISNULL(TransactionEntry.TaxRate, 
                         ISNULL([Transaction].TaxRate, 0)) AS TaxRate
FROM            TransactionEntry INNER JOIN
                         [Transaction] ON [Transaction].TransactionID = TransactionEntry.TransactionID INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID
WHERE        (TransactionEntry.Status > 0) AND (TransactionEntry.TransactionEntryType <> 4) AND (TransactionEntry.TransactionEntryType <> 5) AND ([Transaction].Status > 0)
GO