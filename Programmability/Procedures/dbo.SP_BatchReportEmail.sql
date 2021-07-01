SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
Create Procedure [dbo].[SP_BatchReportEmail]
AS

Declare @D NVARCHAR(MAX), @Q NVARCHAR(MAX)
SELECT @D = STUFF((SELECT ',' + QUOTENAME(TenderName) 
                    from Tender where Status > 0
                    group by TenderName
                    order by TenderName
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
Print @D

SELECT @Q = 'Select BatchNumber, StatusOfBatch, OpeningDateTime, UserName, OpenningAmount, TotalSales, Discounts, Tax, TotalReturn, TotalTransactions,
                      SaleOnAccount, PayBalance, PayOut, ' + @D + ' from (
SELECT     B.BatchNumber, B.StatusOfBatch, FORMAT(B.OpeningDateTime, ''MM/dd/yyyy hh:mm:s tt'') AS OpeningDateTime, B.UserName, FORMAT(B.OpeningAmount, ''c'', ''en-us'') AS OpenningAmount, FORMAT(B.TotalSales, ''c'', ''en-us'') 
                      AS TotalSales, FORMAT(B.Discounts, ''c'', ''en-us'') AS Discounts, FORMAT(B.Tax, ''c'', ''en-us'') AS Tax, FORMAT(B.TotalReturn, ''c'', ''en-us'') AS TotalReturn, 
                      B.TotalTransactions, FORMAT(B.SaleOnAccount, ''c'', ''en-us'') AS SaleOnAccount, FORMAT(B.PayBalance, ''c'', ''en-us'') AS PayBalance, FORMAT(B.PayOut, ''c'', ''en-us'') 
                      AS PayOut, T.TenderName, T.Total
FROM         RepBatchView AS B INNER JOIN
                          (SELECT     T.BatchID, TT.TenderName, SUM(E.Amount) AS Total
                            FROM          [Transaction] AS T INNER JOIN
                                                   TenderEntry AS E ON T.TransactionID = E.TransactionID INNER JOIN
                                                   Tender AS TT ON E.TenderID = TT.TenderID
                            WHERE      (T.Status > 0) AND (E.Status > 0)
                            GROUP BY T.BatchID, TT.TenderName) AS T ON B.BatchID = T.BatchID
WHERE     (B.BatchStatus <> 2) and OpeningDateTime < GETDATE() -1


) x
pivot  
(
SUM(Total)
for TenderName in (' + @D + ')
) p'

--SELECT * INTO TT 
Execute(@Q)
GO