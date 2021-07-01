SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[CustomerTansactionView]
AS

SELECT        [Transaction].TransactionNo, [Transaction].TransactionID, [Transaction].Debit AS Total, [Transaction].Credit AS Paid, [Transaction].StartSaleTime, Entry.Qty, [Transaction].CustomerID,
 IsNull([Transaction].Tax,0) As Tax,CONVERT(nvarchar(500), STUFF((SELECT ','+ cast(T.TenderName as varchar(30))+' $'+CAST(CONVERT(DECIMAL(30,2),Sum(E.Amount)) AS varchar(20)) FROM dbo.Tender AS T
        INNER JOIN dbo.TenderEntry AS E WITH (NOLOCK) ON T.TenderID = E.TenderID WHERE E.TransactionID = [Transaction].TransactionID And  (E.Status > 0) GROUP BY E.TenderID, E.TransactionID,T.TenderName FOR xml PATH ('')), 1, 1, '')) AS Tender,
		 CASE WHEN ISNULL(Returns.TotalReturn, 0) = 0 THEN 0 WHEN ISNULL(Returns.TotalReturn,0) < ISNULL(Returns.TotalSale, 0) THEN 2 ELSE 1 END AS Returned 
FROM            dbo.[Transaction] WITH (NOLOCK) LEFT OUTER JOIN
                             (SELECT        TransactionID, SUM(Qty) AS Qty
                               FROM            dbo.TransactionEntry WITH (NOLOCK) 
                               WHERE        (Status > 0) AND (TransactionEntryType = 0)
                               GROUP BY TransactionID) AS Entry ON [Transaction].TransactionID = Entry.TransactionID LEFT OUTER JOIN
                             (SELECT        E.TransactionID, SUM(E.Qty) AS TotalSale, SUM(R.Qty) AS TotalReturn
                               FROM            dbo.TransactionEntry AS E WITH (NOLOCK) INNER JOIN
                                                         dbo.TransReturen AS R ON E.TransactionEntryID = R.ReturenTransID
                               GROUP BY E.TransactionID) AS [Returns] ON [Transaction].TransactionID = [Returns].TransactionID
WHERE        ([Transaction].Status > 0) AND ([Transaction].CustomerID IS NOT NULL)
GO