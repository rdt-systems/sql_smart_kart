SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetStatementTransactionEntry] (@ShowOnlyOpenInvoices bit =1)
AS
IF @ShowOnlyOpenInvoices = 1
BEGIN
SELECT TransactionEntryView.TransactionID, Name, UOMQty AS Qty, CASE WHEN Name = 'Discount' THEN 0 - UOMPrice ELSE UOMPrice END AS Price, CASE WHEN Name = 'Discount' THEN 0 - Total ELSE Total END AS Total, Sort
FROM TransactionEntryView
INNER JOIN [Transaction] ON TransactionEntryView.TransactionID = [Transaction].TransactionID AND [Transaction].LeftDebit > 0
WHERE TransactionEntryView.Status >0 and EXISTS
                             (SELECT 1 AS Expr1
                               FROM TransactionIDS
                               WHERE (TransactionID = TransactionEntryView.TransactionID))
UNION  
SELECT        TransactionID, 'Sales Tax' AS Name, 1 AS Qty, TaxRate AS Price, Tax AS Total, 99999 AS Sort
                               FROM            [Transaction]
                               WHERE        (ISNULL(Tax, 0) <> 0)and EXISTS
                             (SELECT 1 AS Expr1
                               FROM TransactionIDS
                               WHERE (TransactionID = [Transaction].TransactionID))
ORDER BY Sort
End
ELSE Begin
SELECT TransactionEntryView.TransactionID, Name, UOMQty AS Qty, CASE WHEN Name = 'Discount' THEN 0 - UOMPrice ELSE UOMPrice END AS Price,
                  CASE WHEN Name = 'Discount' THEN 0 - Total ELSE Total END AS Total, Sort
FROM TransactionEntryView
INNER JOIN [Transaction] ON TransactionEntryView.TransactionID = [Transaction].TransactionID
WHERE TransactionEntryView.Status >0 and EXISTS
                             (SELECT 1 AS Expr1
                               FROM TransactionIDS
                               WHERE (TransactionID = TransactionEntryView.TransactionID))
UNION  
SELECT        TransactionID, 'Sales Tax' AS Name, 1 AS Qty, TaxRate AS Price, Tax AS Total, 99999 AS Sort
                               FROM            [Transaction]
                               WHERE        (ISNULL(Tax, 0) <> 0)and EXISTS
                             (SELECT 1 AS Expr1
                               FROM TransactionIDS
                               WHERE (TransactionID = [Transaction].TransactionID))
ORDER BY Sort
END
GO