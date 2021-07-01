SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_EmailDiscountReport]
	(@Date datetime = NULL
	,@StoreID Uniqueidentifier = NULL)

AS

IF @Date IS NULL 
Select  @Date = CAST(dbo.GetLocalDate() as date)

SELECT        TransactionView.TransactionNo, 
CONVERT(VARCHAR, TransactionView.StartSaleTime, 22) AS SaleDate,
CustomerView.CustomerNo, 
CASE WHEN dbo.CustomerView.LastName IS NOT NULL OR dbo.CustomerView.FirstName IS NOT NULL THEN ISNULL(dbo.CustomerView.LastName, '') + ', ' + ISNULL(dbo.CustomerView.FirstName, '') ELSE NULL END AS CustomerName,
FORMAT(CAST(TransactionView.Debit + TransactionEntryView.UOMPrice + ISNULL(TotalQtyTransaction.TotalReturn, 0) + ISNULL(TotalQtyTransaction.TotalReturnTax, 0) + ISNULL(TotalQtyTransaction.disRetern, 0) as money), 'C', 'en-US') AS TotalBeforeDiscount,
FORMAT(CAST(TransactionView.Debit + ISNULL(TotalQtyTransaction.TotalReturn, 0) + ISNULL(TotalQtyTransaction.TotalReturnTax, 0) as money), 'C', 'en-US') AS SaleTotal,
FORMAT(CAST(TransactionView.Debit - TransactionView.Tax + ISNULL(TotalQtyTransaction.TotalReturn, 0) as money), 'C', 'en-US') AS SaleTotalWithoutTax, 
FORMAT(CAST(TransactionEntryView.UOMPrice + ISNULL(TotalQtyTransaction.disRetern, 0) as money), 'C', 'en-US') AS Discount, 
FORMAT(TransactionView.Credit, 'C', 'en-US') AS Paid
FROM            TransactionEntryView INNER JOIN
                         TransactionView ON TransactionEntryView.TransactionID = TransactionView.TransactionID LEFT OUTER JOIN
                             (SELECT        TransactionEntryView.TransactionID, SUM(TransactionEntryView.Qty) AS TotalQty, SUM(TransactionEntryView.Total) AS Total, SUM(ter.Total) AS TotalReturn, MIN(trr.Tax) AS TotalReturnTax, 
                                                         SUM((TransactionEntryView.Total - TransactionEntryView.TotalAfterDiscount) / TransactionEntryView.Qty * ter.Qty) AS disRetern
                               FROM            TransactionEntryView LEFT OUTER JOIN
                                                         TransReturen ON TransReturen.ReturenTransID = TransactionEntryView.TransactionEntryID LEFT OUTER JOIN
                                                         TransactionEntry AS ter ON ter.TransactionEntryID = TransReturen.SaleTransEntryID AND ter.Status > 0 LEFT OUTER JOIN
                                                         [Transaction] AS trr ON trr.TransactionID = ter.TransactionID AND trr.Status > 0
                               WHERE        (TransactionEntryView.Status > 0) AND (TransactionEntryView.TransactionEntryType = 0)
                               GROUP BY TransactionEntryView.TransactionID) AS TotalQtyTransaction ON TotalQtyTransaction.TransactionID = TransactionView.TransactionID LEFT OUTER JOIN
                         CustomerView ON TransactionView.CustomerID = CustomerView.CustomerID AND CustomerView.Status > 0
WHERE        (TransactionEntryView.TransactionEntryType = 4) AND (TransactionEntryView.Status > 0) AND (TransactionView.StoreID = @StoreID OR @StoreID IS NULL) AND (TransactionView.TransactionType = 0) AND (TransactionView.Status > 0) AND (CAST(TransactionView.StartSaleTime AS date) 
                         = CAST(@Date AS date))
GO