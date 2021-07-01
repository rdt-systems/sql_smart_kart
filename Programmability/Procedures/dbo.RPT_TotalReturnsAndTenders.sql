SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RPT_TotalReturnsAndTenders]
(
				 @Date AS datetime = NULL
)

AS
	DECLARE @D datetime
	SET @D = (SELECT ISNULL(@Date, dbo.GetDay(dbo.GetLocalDate())))
	IF EXISTS(Select 1 from Store Where StoreID = '0806793E-8915-457E-B0AC-EF91FE29B5D0')
	BEGIN
		SELECT StoreName COLLATE SQL_Latin1_General_CP1_CI_AS + ': Total Transaction Count' AS Name
		, ISNULL(COUNT(DISTINCT TransactionID), 0) AS Total
		FROM dbo.TransactionEntryItem
		WHERE (Qty > 0) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D))
		GROUP BY StoreName

		UNION
		SELECT StoreName + ': Total Sale' AS Name
		, ISNULL(SUM(Total), 0) AS Total
		FROM dbo.TransactionEntryItem
		WHERE (Qty > 0) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D))
		GROUP BY StoreName
		UNION
		SELECT StoreName + ': Jewlery Total Sale' AS Name
		, ISNULL(SUM(Total), 0) AS Total
		FROM dbo.TransactionEntryItem 
		WHERE (Qty > 0) AND Department like 'JEWE%' AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D))
		GROUP BY StoreName

		UNION
		SELECT StoreName + ': Total Discount' AS Name
		, ISNULL(SUM(Total), 0) AS Total
		FROM dbo.TransactionEntry E WITH (NOLOCK)
			 INNER JOIN
			 dbo.[Transaction] T WITH (NOLOCK)
			 ON E.TransactionID = T.TransactionID
			 INNER JOIN
			 dbo.Store S
			 ON T.StoreID = S.StoreID
		WHERE (E.Status > 0) AND
			  (T.Status > 0) AND
			  (TransactionEntryType = 4) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY StoreName

		UNION
		SELECT StoreName + ': Total COGS' AS Name
		, ISNULL(SUM(ISNULL(AVGCost, ISNULL(Cost, 0)) * ISNULL(Qty, 0)), 0) AS Total
		FROM dbo.TransactionEntryItem
		WHERE (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY StoreName
		UNION
		SELECT StoreName + ': Total Returns' AS Name
		, ISNULL(SUM(TotalAfterDiscount), 0) AS Total
		FROM dbo.TransactionEntryItem
		WHERE (Qty < 0) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY StoreName
		UNION
		SELECT StoreName + ': Jewlery Total Returns' AS Name
		, ISNULL(SUM(TotalAfterDiscount), 0) AS Total
		FROM dbo.TransactionEntryItem
		WHERE (Qty < 0) AND Department like 'JEWE%' AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY StoreName

		UNION
		SELECT StoreName + ': Total Tax' AS Name
		, ISNULL(SUM(Tax), 0) AS Total
		FROM dbo.[Transaction] T WITH (NOLOCK)
			 INNER JOIN
			 dbo.Store S
			 ON T.StoreID = S.StoreID
		WHERE (T.Status > 0) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY S.StoreName

		UNION
		SELECT StoreName + ': Total Gift Card Sold' AS Name
		, ISNULL(SUM(ISNULL(Total, 0)), 0) AS Total
		FROM dbo.TransactionEntry AS E WITH (NOLOCK)
			 INNER JOIN
			 dbo.[Transaction] AS T WITH (NOLOCK)
			 ON E.TransactionID = T.TransactionID
			 INNER JOIN
			 dbo.Store S
			 ON T.StoreID = S.StoreID
		WHERE (E.Status > 0) AND
			  (T.Status > 0) AND
			  (TransactionEntryType = 5) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY S.StoreName

		UNION
		SELECT StoreName + ': ' + CASE
									  WHEN ISNULL(Tender.TenderNameHe, '?') NOT LIKE '%?%' THEN Tender.TenderNameHe
									  ELSE Tender.TenderName
								 END AS Name
		, ISNULL(SUM(TenderEntry.Amount), 0) AS Total
		FROM dbo.[Transaction] WITH (NOLOCK)
			 INNER JOIN
			 dbo.TenderEntry WITH (NOLOCK)
			 ON [Transaction].TransactionID = TenderEntry.TransactionID
			 INNER JOIN
			 dbo.Tender
			 ON TenderEntry.TenderID = Tender.TenderID
			 INNER JOIN
			 dbo.Store S
			 ON [Transaction].StoreID = S.StoreID
		WHERE (TenderEntry.Status > 0) AND
			  (Tender.Status > 0) AND
			  ([Transaction].Status > 0) AND
			  (dbo.GetDay([Transaction].EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY S.StoreName, Tender.SortOrder, Tender.TenderName, Tender.TenderNameHe
	END
	Else
BEGIN
		SELECT StoreName COLLATE SQL_Latin1_General_CP1_CI_AS + ': Total Transaction Count' AS Name
		, ISNULL(COUNT(DISTINCT TransactionID), 0) AS Total
		FROM dbo.TransactionEntryItem
		WHERE (Qty > 0) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D))
		GROUP BY StoreName

		UNION
		SELECT StoreName + ': Total Sale' AS Name
		, ISNULL(SUM(Total), 0) AS Total
		FROM dbo.TransactionEntryItem
		WHERE (Qty > 0) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D))
		GROUP BY StoreName

		UNION
		SELECT StoreName + ': Total Discount' AS Name
		, ISNULL(SUM(Total), 0) AS Total
		FROM dbo.TransactionEntry E WITH (NOLOCK)
			 INNER JOIN
			 dbo.[Transaction] T WITH (NOLOCK)
			 ON E.TransactionID = T.TransactionID
			 INNER JOIN
			 dbo.Store S
			 ON T.StoreID = S.StoreID
		WHERE (E.Status > 0) AND
			  (T.Status > 0) AND
			  (TransactionEntryType = 4) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY StoreName

		UNION
		SELECT StoreName + ': Total COGS' AS Name
		, ISNULL(SUM(ISNULL(AVGCost, ISNULL(Cost, 0)) * ISNULL(Qty, 0)), 0) AS Total
		FROM dbo.TransactionEntryItem
		WHERE (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY StoreName
		UNION
		SELECT StoreName + ': Total Returns' AS Name
		, ISNULL(SUM(TotalAfterDiscount), 0) AS Total
		FROM dbo.TransactionEntryItem
		WHERE (Qty < 0) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY StoreName

		UNION
		SELECT StoreName + ': Total Tax' AS Name
		, ISNULL(SUM(Tax), 0) AS Total
		FROM dbo.[Transaction] T WITH (NOLOCK)
			 INNER JOIN
			 dbo.Store S
			 ON T.StoreID = S.StoreID
		WHERE (T.Status > 0) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY S.StoreName

		UNION
		SELECT StoreName + ': Total Gift Card Sold' AS Name
		, ISNULL(SUM(ISNULL(Total, 0)), 0) AS Total
		FROM dbo.TransactionEntry AS E WITH (NOLOCK)
			 INNER JOIN
			 dbo.[Transaction] AS T WITH (NOLOCK)
			 ON E.TransactionID = T.TransactionID
			 INNER JOIN
			 dbo.Store S
			 ON T.StoreID = S.StoreID
		WHERE (E.Status > 0) AND
			  (T.Status > 0) AND
			  (TransactionEntryType = 5) AND
			  (dbo.GetDay(EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY S.StoreName

		UNION
		SELECT StoreName + ': ' + CASE
									  WHEN ISNULL(Tender.TenderNameHe, '?') NOT LIKE '%?%' THEN Tender.TenderNameHe
									  ELSE Tender.TenderName
								 END AS Name
		, ISNULL(SUM(TenderEntry.Amount), 0) AS Total
		FROM dbo.[Transaction] WITH (NOLOCK)
			 INNER JOIN
			 dbo.TenderEntry WITH (NOLOCK)
			 ON [Transaction].TransactionID = TenderEntry.TransactionID
			 INNER JOIN
			 dbo.Tender
			 ON TenderEntry.TenderID = Tender.TenderID
			 INNER JOIN
			 dbo.Store S
			 ON [Transaction].StoreID = S.StoreID
		WHERE (TenderEntry.Status > 0) AND
			  (Tender.Status > 0) AND
			  ([Transaction].Status > 0) AND
			  (dbo.GetDay([Transaction].EndSaleTime) = dbo.GetDay(@D ))
		GROUP BY S.StoreName, Tender.SortOrder, Tender.TenderName, Tender.TenderNameHe
	END
GO