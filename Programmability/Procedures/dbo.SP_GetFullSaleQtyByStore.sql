SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetFullSaleQtyByStore]
(
    @ItemID uniqueidentifier

)
as
BEGIN
     SELECT        TOP (100) PERCENT M.Name, T.StoreName, ISNULL(Month5.Qty, 0) AS Month5, ISNULL(Month4.Qty, 0) AS Month4, 
                         ISNULL(Month3.Qty, 0) AS Month3, ISNULL(Month2.Qty, 0) AS Month2, ISNULL(Month1.Qty, 0) AS Month1, ISNULL(Last7Days.Qty, 0) AS last7days, 
                         ISNULL(S.YTDQty,0) AS YTD, ISNULL(MtdLastYr.Qty, 0) AS MtdLastYr, ISNULL(S.MTDQty,0) AS MTD, ISNULL(YtdLastYr.Qty, 
                         0) AS YtdLastYr, ISNULL(S.OnHand,0) AS OnHand , ISNULL(S.OnOrder, 0) AS OnOrder, M.ItemID, 
                         S.ItemStoreID, S.StoreNo
FROM            dbo.ItemStore S INNER JOIN dbo.ItemMain M ON S.ItemNo = M.ItemID INNER JOIN Store AS T ON S.StoreNo = T.StoreID  LEFT OUTER JOIN
                             (SELECT        ItemStoreID, SUM(QTY) AS Qty
                               FROM         TransactionEntry E INNER JOIN [Transaction] R ON E.TransactionID = R.TransactionID
                               WHERE      (E.Status > 0) AND (E.TransactionEntryType <> 4) AND (E.TransactionEntryType <> 5) AND (R.Status > 0) AND
							     (MONTH(StartSaleTime) <= MONTH(dbo.GetLocalDATE())) AND (YEAR(StartSaleTime) = YEAR(DATEADD(YEAR, - 1, dbo.GetLocalDATE()))) AND (DAY(StartSaleTime) 
                                                         <= DAY(dbo.GetLocalDATE()))
                               GROUP BY ItemStoreID) AS YtdLastYr ON S.ItemStoreID = YtdLastYr.ItemStoreID LEFT OUTER JOIN
                             (SELECT        ItemStoreID, SUM(QTY) AS Qty
                               FROM          TransactionEntry E INNER JOIN [Transaction] R ON E.TransactionID = R.TransactionID
                               WHERE        (E.Status > 0) AND (E.TransactionEntryType <> 4) AND (E.TransactionEntryType <> 5) AND (R.Status > 0) AND
							      (MONTH(StartSaleTime) = MONTH(dbo.GetLocalDATE())) AND (YEAR(StartSaleTime) = YEAR(DATEADD(YEAR, - 1, dbo.GetLocalDATE()))) AND (DAY(StartSaleTime) 
                                                         <= DAY(dbo.GetLocalDATE()))
                               GROUP BY ItemStoreID) AS MtdLastYr ON S.ItemStoreID = MtdLastYr.ItemStoreID LEFT OUTER JOIN
                             (SELECT        ItemStoreID, SUM(QTY) AS Qty
                               FROM           TransactionEntry E INNER JOIN [Transaction] R ON E.TransactionID = R.TransactionID
                               WHERE       (E.Status > 0) AND (E.TransactionEntryType <> 4) AND (E.TransactionEntryType <> 5) AND (R.Status > 0) AND
							       (dbo.GetDay(StartSaleTime) >= dbo.GetDay(DATEADD(day, - 7, dbo.GetLocalDATE())))
                               GROUP BY ItemStoreID) AS Last7Days ON S.ItemStoreID = Last7Days.ItemStoreID LEFT OUTER JOIN
                             (SELECT        ItemStoreID, SUM(QTY) AS Qty
                               FROM        TransactionEntry E INNER JOIN [Transaction] R ON E.TransactionID = R.TransactionID
							    WHERE   (E.Status > 0) AND (E.TransactionEntryType <> 4) AND (E.TransactionEntryType <> 5) AND (R.Status > 0) AND
								     (MONTH(StartSaleTime) = MONTH(DATEADD(Month, - 1, dbo.GetLocalDATE()))) AND (YEAR(StartSaleTime) = YEAR(DATEADD(Month, - 1, dbo.GetLocalDATE())))
                               GROUP BY ItemStoreID) AS Month1 ON S.ItemStoreID = Month1.ItemStoreID LEFT OUTER JOIN
                             (SELECT        ItemStoreID, SUM(QTY) AS Qty
                               FROM           TransactionEntry E INNER JOIN [Transaction] R ON E.TransactionID = R.TransactionID
                               WHERE      
							     (MONTH(StartSaleTime) = MONTH(DATEADD(Month, - 2, dbo.GetLocalDATE()))) AND (YEAR(StartSaleTime) = YEAR(DATEADD(Month, - 2, dbo.GetLocalDATE())))
                               GROUP BY ItemStoreID) AS Month2 ON S.ItemStoreID = Month2.ItemStoreID LEFT OUTER JOIN
                             (SELECT        ItemStoreID, SUM(QTY) AS Qty
                               FROM           TransactionEntry E INNER JOIN [Transaction] R ON E.TransactionID = R.TransactionID
                               WHERE   (E.Status > 0) AND (E.TransactionEntryType <> 4) AND (E.TransactionEntryType <> 5) AND (R.Status > 0) AND 
							       (MONTH(StartSaleTime) = MONTH(DATEADD(Month, - 3, dbo.GetLocalDATE()))) AND (YEAR(StartSaleTime) = YEAR(DATEADD(Month, - 3, dbo.GetLocalDATE())))
                               GROUP BY ItemStoreID) AS Month3 ON S.ItemStoreID = Month3.ItemStoreID LEFT OUTER JOIN
                             (SELECT        ItemStoreID, SUM(QTY) AS Qty
                               FROM           TransactionEntry E INNER JOIN [Transaction] R ON E.TransactionID = R.TransactionID
                               WHERE   (E.Status > 0) AND (E.TransactionEntryType <> 4) AND (E.TransactionEntryType <> 5) AND (R.Status > 0) AND
							        (MONTH(StartSaleTime) = MONTH(DATEADD(Month, - 4, dbo.GetLocalDATE()))) AND (YEAR(StartSaleTime) = YEAR(DATEADD(Month, - 4, dbo.GetLocalDATE())))
                               GROUP BY ItemStoreID) AS Month4 ON S.ItemStoreID = Month4.ItemStoreID LEFT OUTER JOIN
                             (SELECT        ItemStoreID, SUM(QTY) AS Qty
                               FROM           TransactionEntry E INNER JOIN [Transaction] R ON E.TransactionID = R.TransactionID
                               WHERE   (E.Status > 0) AND (E.TransactionEntryType <> 4) AND (E.TransactionEntryType <> 5) AND (R.Status > 0) AND
							        (MONTH(StartSaleTime) = MONTH(DATEADD(Month, - 5, dbo.GetLocalDATE()))) AND (YEAR(StartSaleTime) = YEAR(DATEADD(Month, - 5, dbo.GetLocalDATE())))
                               GROUP BY ItemStoreID) AS Month5 ON S.ItemStoreID = Month5.ItemStoreID
Where M.ItemID = @ItemID
END
GO