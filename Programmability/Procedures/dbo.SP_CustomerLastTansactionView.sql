SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CustomerLastTansactionView]
(
				 @DateModified datetime = NULL
)
AS


	SELECT DISTINCT F.DupeCount AS Number, F.TransactionID, [Transaction].CustomerID, [Transaction].TransactionNo, Entry.Qty, [Transaction].StartSaleTime, C.DateModified,
	[Transaction].Credit AS Paid, [Transaction].Debit AS Total, CONVERT(varchar(100), CAST(DupeCount AS decimal(38, 0))) + C.CustomerNo AS ID, 1 AS Status,
	CONVERT(nvarchar(500), STUFF((SELECT ',' + CAST(T.TenderName AS varchar(30)) + ' $' + CAST(CONVERT(decimal(30, 2), SUM(E.Amount)) AS varchar(20))
  FROM dbo.Tender AS T WITH (NOLOCK)
	   INNER JOIN
	   dbo.TenderEntry AS E WITH (NOLOCK)
	   ON T.TenderID = E.TenderID
  WHERE (E.Status > 0) AND
		E.TransactionID = [Transaction].TransactionID
  GROUP BY E.TenderID, E.TransactionID, T.TenderName
  FOR xml PATH ('')), 1, 1, '')) AS Tender, ISNULL([Transaction].Tax, 0) AS Tax,
	CASE
		 WHEN ISNULL(Returns.TotalReturn, 0) = 0 THEN 0
		 WHEN ISNULL(Returns.TotalReturn, 0) < ISNULL(Returns.TotalSale, 0) THEN 2
		 ELSE 1
	END AS Returned
	FROM dbo.[Transaction] WITH (NOLOCK)
		 LEFT OUTER JOIN
		 (SELECT TransactionID, SUM(Qty) AS Qty
	   FROM dbo.TransactionEntry WITH (NOLOCK)
	   WHERE (Status > 0) AND
			 (TransactionEntryType = 0)
	   GROUP BY TransactionID) AS Entry
		 ON [Transaction].TransactionID = Entry.TransactionID
		 LEFT OUTER JOIN
		 (SELECT E.TransactionID, SUM(E.Qty) AS TotalSale, SUM(R.Qty) AS TotalReturn
	   FROM dbo.TransactionEntry AS E WITH (NOLOCK)
			INNER JOIN
			dbo.TransReturen AS R WITH (NOLOCK)
			ON E.TransactionEntryID = R.ReturenTransID
	   WHERE E.Status > 0 AND
			 R.Status > 0
	   GROUP BY E.TransactionID) AS [Returns]
		 ON [Transaction].TransactionID = [Returns].TransactionID
		 INNER JOIN
		 dbo.Customer AS C WITH (NOLOCK)
		 ON C.CustomerID = [Transaction].CustomerID
		 INNER JOIN
		 (SELECT TF.*
	   FROM (SELECT ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY StartSaleTime DESC, CustomerID) AS DupeCount, TransactionID
	 FROM dbo.[Transaction] WITH (NOLOCK)
	 WHERE Status > 0 AND
		   CustomerID IS NOT NULL AND
		   EndSaleTime > DATEADD(DAY, -60, GETDATE())) AS TF
	   WHERE TF.DupeCount < 6) AS F
		 ON [Transaction].TransactionID = F.TransactionID
	WHERE ([Transaction].Status > 0) AND
		  ([Transaction].CustomerID IS NOT NULL) 
		  AND  EndSaleTime > DATEADD(DAY, -60, GETDATE())AND
		  (C.DateModified > @DateModified OR
		  @DateModified IS NULL)
GO