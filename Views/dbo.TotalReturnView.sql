SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[TotalReturnView]
AS
SELECT        TransactionID, SUM(Debit) AS TotalReturn
FROM            (SELECT DISTINCT TR.TransactionID AS ReturnTranID, E.TransactionID, TR.Debit
                          FROM            TransReturen AS TT INNER JOIN
                                                    TransactionEntry AS RE WITH (NOLOCK) ON TT.SaleTransEntryID = RE.TransactionEntryID INNER JOIN
                                                    [Transaction] AS TR ON RE.TransactionID = TR.TransactionID INNER JOIN
                                                    TransactionEntry AS E ON TT.ReturenTransID = E.TransactionEntryID
                          WHERE        (TR.Status > 0) AND (TT.Status > 0) AND (RE.Status > 0)) AS AA
GROUP BY TransactionID


GO