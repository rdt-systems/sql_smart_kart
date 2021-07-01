SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetRptZOut]
(
@BatchID uniqueidentifier
)
AS

SELECT     BatchID, BatchNumber, UserName,  --ISNULL(SalesCash, 0) - ISNULL(ReturnCash, 0) + ISNULL(PayBalance, 0) AS TotalCashFlow, 
                      --ISNULL(SaleOnAccount, 0) - ISNULL(ReturnOnAccount, 0) AS TotalOnAccount, 
						ISNULL(TotalSales, 0) - ISNULL(TotalReturn, 0) AS Total,
                          (SELECT     COUNT(*)
                            FROM          [TRANSACTION]
                            WHERE      BatchID = RepBatchView.BatchID AND status > 0) AS TransactionCount, TotalSales, TotalReturn, PayBalance, Tax, PayOut,
                          (SELECT     COUNT(*)
                            FROM          (SELECT DISTINCT customerid
                                                    FROM          [TRANSACTION]
                                                    WHERE      Status > 0 AND BatchID = RepBatchView.BatchID) dt) AS CustomerCount,
                          (SELECT     COUNT(*)
                            FROM          actions
                            WHERE      status > 0 AND BatchID = RepBatchView.BatchID AND ActionType = 1) AS CancelSale,
                          (SELECT     COUNT(*)
                            FROM          actions
                            WHERE      status > 0 AND BatchID = RepBatchView.BatchID AND ActionType = 2) AS VoiidItem,
                          (SELECT     COUNT(*)
                            FROM          actions
                            WHERE      status > 0 AND BatchID = RepBatchView.BatchID AND ActionType = 3) AS OpenDrawer,
                          (SELECT     SUM(dbo.TransactionEntry.UOMPrice)
                            FROM          dbo.TransactionEntry INNER JOIN
                                                   dbo.[TRANSACTION] ON dbo.TransactionEntry.TransactionID = dbo.[TRANSACTION].TransactionID AND transactionEntryType = 4 AND 
                                                   BatchID = RepBatchView.BatchID) AS TotalDiscount
FROM         dbo.RepBatchView
WHERE BatchID=@BatchID
GO