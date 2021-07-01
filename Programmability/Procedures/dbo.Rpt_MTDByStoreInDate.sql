SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_MTDByStoreInDate]
(@FromDate datetime,
 @ToDate datetime,
 @Filter nvarchar(4000))
AS
DECLARE @MySelect nvarchar(4000)

SET @MySelect =
'SELECT        Store.StoreName, ISNULL(DaySale.DaySale, 0) AS TodaysSale, ISNULL(DayReturen.DaySale, 0) AS Returns, ISNULL(DaySale.SumQty, 0) AS SalesQty, 
                         ISNULL(DayReturen.SumQty, 0) AS ReturnQty, ISNULL(DayTrans.CountTransaction, 0) AS TransactionCount, ISNULL(DayTrans.CountCustomer, 0) 
                         AS CustomerCount, ISNULL(SumTax.SumTax, 0) AS TaxSum, (CASE WHEN (ISNULL(DaySale.DaySale, 0) > 0 AND IsNull(DayTrans.CountTransaction, 0) 
                         > 0) THEN DaySale.DaySale / DayTrans.CountTransaction ELSE 0 END) AS AVGSale, (CASE WHEN (ISNULL(DaySale.SumQty, 0) > 0 AND 
                         IsNull(DayTrans.CountTransaction, 0) > 0) THEN DaySale.SumQty / DayTrans.CountTransaction ELSE 0 END) AS AVGQty, isNull(pplCount.pplCount,0)as [Traffic Counts]
FROM            Store LEFT OUTER JOIN
                             (SELECT        dbo.GetDay(stime) AS sTime, SUM(enters) AS pplCount, StoreID
                               FROM            ShopperTrack
							   WHERE        (dbo.GetDay(STime) >= dbo.GetDay('''+CONVERT(VARCHAR, @FromDate, 23)+''')AND dbo.GetDay(STime) <= dbo.GetDay('''+CONVERT(VARCHAR, @ToDate, 23)+'''))
                               GROUP BY StoreID, dbo.GetDay(stime)) AS pplCount ON Store.StoreID = pplCount.StoreID LEFT OUTER JOIN
                             (SELECT        COUNT(Distinct TransactionID) AS CountTransaction, StoreID, COUNT(Distinct CustomerID) AS CountCustomer
                               FROM            [TransactionEntryItem]
                               WHERE        (dbo.GetDay(StartSaleTime) >= dbo.GetDay('''+CONVERT(VARCHAR, @FromDate, 23)+''')AND dbo.GetDay(StartSaleTime) <= dbo.GetDay('''+CONVERT(VARCHAR, @ToDate, 23)+'''))
                               GROUP BY StoreID) AS DayTrans ON Store.StoreID = DayTrans.StoreID LEFT OUTER JOIN
                             (SELECT        StoreID, SUM(TotalAfterDiscount) AS DaySale, SUM(QTY) AS SumQty
                               FROM            TransactionEntryItem AS TransactionEntryItem_2
                               WHERE        (dbo.GetDay(StartSaleTime) >= dbo.GetDay('''+CONVERT(VARCHAR, @FromDate, 23)+''')AND dbo.GetDay(StartSaleTime) <= dbo.GetDay('''+CONVERT(VARCHAR, @ToDate, 23)+''')) AND (QTY < 0)
                               GROUP BY StoreID) AS DayReturen ON Store.StoreID = DayReturen.StoreID LEFT OUTER JOIN
                             (SELECT        StoreID, SUM(TotalAfterDiscount) AS DaySale, SUM(QTY) AS SumQty
                               FROM            TransactionEntryItem
                               WHERE        (dbo.GetDay(StartSaleTime) >= dbo.GetDay('''+CONVERT(VARCHAR, @FromDate, 23)+''')AND dbo.GetDay(StartSaleTime) <= dbo.GetDay('''+CONVERT(VARCHAR, @ToDate, 23)+''')) AND (QTY > 0)
                               GROUP BY StoreID) AS DaySale ON Store.StoreID = DaySale.StoreID LEFT OUTER JOIN
                          (SELECT     SUM(Tax) AS SumTax, StoreID
                            FROM          [Transaction] 
                            WHERE        (dbo.GetDay(StartSaleTime) >= dbo.GetDay('''+CONVERT(VARCHAR, @FromDate, 23)+''')AND dbo.GetDay(StartSaleTime) <= dbo.GetDay('''+CONVERT(VARCHAR, @ToDate, 23)+''')) AND Status>0
							 GROUP BY StoreID) AS SumTax ON Store.StoreID = SumTax.StoreID 
WHERE        (Store.Status > 0)   '


print (@MySelect +@Filter)
exec(@MySelect +@Filter)
GO