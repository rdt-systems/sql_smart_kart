SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[CustomerLastTansactionView]
AS
SELECT DISTINCT   F.DupeCount AS Number,F.TransactionID,  [Transaction].CustomerID ,[Transaction].TransactionNo,  Entry.Qty,  [Transaction].StartSaleTime,C.DateModified, 
                         [Transaction].Credit AS Paid, [Transaction].Debit AS Total , CONVERT(varchar(100), Cast(DupeCount as decimal(38, 0)))+C.CustomerNo AS ID ,1 As Status,
						 CONVERT(nvarchar(500), STUFF((SELECT ','+ cast(T.TenderName as varchar(30))+' $'+CAST(CONVERT(DECIMAL(30,2),Sum(E.Amount)) AS varchar(20))
 FROM dbo.Tender AS T WITH (NOLOCK)
        INNER JOIN dbo.TenderEntry AS E WITH (NOLOCK) ON T.TenderID = E.TenderID WHERE (E.Status > 0)  
		AND E.TransactionID = [Transaction].TransactionID GROUP BY E.TenderID, E.TransactionID,T.TenderName FOR xml PATH ('')), 1, 1, '')) AS Tender,IsNull([Transaction].Tax,0) As Tax,
						 CASE WHEN ISNULL(Returns.TotalReturn, 0) = 0 THEN 0 WHEN ISNULL(Returns.TotalReturn,0) < ISNULL(Returns.TotalSale, 0) THEN 2 ELSE 1 END AS Returned
FROM            dbo.[Transaction] WITH (NOLOCK) LEFT OUTER JOIN
                             (SELECT        TransactionID, SUM(Qty) AS Qty
                               FROM            dbo.TransactionEntry WITH (NOLOCK) 
                               WHERE        (Status > 0) AND (TransactionEntryType = 0)
                               GROUP BY TransactionID) AS Entry ON [Transaction].TransactionID = Entry.TransactionID LEFT OUTER JOIN
                             (SELECT        E.TransactionID, SUM(E.Qty) AS TotalSale, SUM(R.Qty) AS TotalReturn
                               FROM            dbo.TransactionEntry AS E WITH (NOLOCK) INNER JOIN
                                                         dbo.TransReturen AS R WITH (NOLOCK) ON E.TransactionEntryID = R.ReturenTransID
                               Where E.Status > 0 AND R.Status >0
                               GROUP BY E.TransactionID) AS [Returns] ON [Transaction].TransactionID = [Returns].TransactionID  INNER JOIN 
							   dbo.Customer As C WITH (NOLOCK) On C.CustomerID = [Transaction].CustomerID INNER JOIN (
SELECT ROW_NUMBER() OVER (PARTITION BY CustomerID
      ORDER BY StartSaleTime desc,CustomerID  ) AS DupeCount,TransactionID
  FROM dbo.[Transaction] WITH (NOLOCK) Where Status > 0 and CustomerID IS NOT NULL) as F ON [Transaction].TransactionID = F.TransactionID
WHERE        ([Transaction].Status > 0) AND ([Transaction].CustomerID IS NOT NULL) AND DupeCount<6  
GO