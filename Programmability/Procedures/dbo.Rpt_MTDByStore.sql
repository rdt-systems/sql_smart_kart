SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_MTDByStore]

(@Date datetime= null)

AS

BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED --TO PREVENT DEADLOCKS
BEGIN TRAN 

Declare @vDate as Datetime
IF @Date is null
	Set @vDate = DATEADD(day, -1, dbo.GetLocalDATE())
ELSE
	Set @vDate = @Date 


SELECT        Store.StoreName, ISNULL(DaySale.DaySale, 0) AS Today_Sale, ISNULL(MatchDate.DaySale, 0) AS Match_Sale, ISNULL(NTDSales.MTDSale, 0) + ISNULL(DaySale.DaySale, 0) AS Mtd_Sale,
						 ISNULL(DayReturen.DaySale, 0) AS TodayReturen, ISNULL(MatchReturn.DaySale, 0) AS MatchReturen, ISNULL(DaySale.SumQty, 0) AS TodaySaleQty, ISNULL(MatchDate.SumQty, 0) AS MatchSaleQty, 
						 ISNULL(DayReturen.SumQty, 0) AS TodayReturnQty, ISNULL(MatchReturn.SumQty, 0) AS MatchReturnQty, ISNULL(DayTrans.CountTransaction, 0) AS TodayCountTransaction, ISNULL(MatchQty.CountTransaction, 0) AS MatchCountTransaction, 
						 ISNULL(DayTrans.CountCustomer, 0) AS TodayCountCustomer, ISNULL(DayTrans.SumTax, 0) AS TodaySumTax, 
						 (CASE WHEN (ISNULL(DaySale.DaySale, 0) > 0 AND IsNull(DayTrans.CountTransaction, 0) > 0) THEN DaySale.DaySale / DayTrans.CountTransaction ELSE 0 END) AS TodayAVGSale, 
						 (CASE WHEN (ISNULL(DaySale.SumQty, 0) > 0 AND IsNull(DayTrans.CountTransaction, 0) > 0) THEN DaySale.SumQty / DayTrans.CountTransaction ELSE 0 END) AS TodayAVGQty, 
						 ISNULL(pplCount.pplCount, 0) AS pplCount, (CASE WHEN (isNull(pplCount.pplCount, 0) > 0 AND IsNull(DayTrans.CountTransaction, 0) > 0) 
						 THEN (CAST(DayTrans.CountTransaction AS float) / (CAST(pplCount.pplCount AS float) / 100)) ELSE 0 END) AS Converstion
FROM            Store LEFT OUTER JOIN
                             (SELECT        SUM(exits) AS pplCount, CAST(stime as date) AS sTime, StoreID
                               FROM            ShopperTrack
                               WHERE        (CAST(stime as date) = CAST(@vDate as date))
                               GROUP BY CAST(stime as date), StoreID) AS pplCount ON Store.StoreID = pplCount.StoreID LEFT OUTER JOIN
                             (SELECT        COUNT(TransactionID) AS CountTransaction, StoreID, COUNT(CustomerID) AS CountCustomer, SUM(Tax) AS SumTax
                               FROM            [Transaction]
                               WHERE        (CAST(StartSaleTime as date) = CAST(@vDate as date)) AND (Status > 0)
                               GROUP BY StoreID) AS DayTrans ON Store.StoreID = DayTrans.StoreID LEFT OUTER JOIN
                             (SELECT        StoreID, SUM(TotalAfterDiscount) AS DaySale, SUM(QTY) AS SumQty
                               FROM            TransactionEntryItem AS TransactionEntryItem_2
                               WHERE        (CAST(StartSaleTime as date) = CAST(@vDate as date)) AND (QTY < 0)
                               GROUP BY StoreID) AS DayReturen ON Store.StoreID = DayReturen.StoreID LEFT OUTER JOIN
                             (SELECT        StoreID, SUM(TotalAfterDiscount) AS MTDSale
                               FROM            TransactionEntryItem AS TransactionEntryItem_1
                               WHERE        (MONTH(StartSaleTime) = MONTH(@vDate)) AND (YEAR(StartSaleTime) = YEAR(@vDate))
                               GROUP BY StoreID) AS NTDSales ON Store.StoreID = NTDSales.StoreID LEFT OUTER JOIN
                             (SELECT        StoreID, SUM(TotalAfterDiscount) AS DaySale, SUM(QTY) AS SumQty
                               FROM            TransactionEntryItem
                               WHERE        (CAST(StartSaleTime as date) = CAST(@vDate as date)) AND (QTY > 0)
                               GROUP BY StoreID) AS DaySale ON Store.StoreID = DaySale.StoreID LEFT OUTER JOIN
                             (SELECT        StoreID, SUM(TotalAfterDiscount) AS DaySale, SUM(QTY) AS SumQty
                               FROM            TransactionEntryItem
                               WHERE        (CAST(StartSaleTime as date) = CAST(@vDate-7 as date)) AND (QTY > 0)
                               GROUP BY StoreID) AS MatchDate ON Store.StoreID = MatchDate.StoreID LEFT OUTER JOIN
                             (SELECT        COUNT(TransactionID) AS CountTransaction, StoreID, COUNT(CustomerID) AS CountCustomer, SUM(Tax) AS SumTax
                               FROM            [Transaction]
                               WHERE        (CAST(StartSaleTime as date) = CAST(@vDate-7 as date)) AND (Status > 0)
                               GROUP BY StoreID) AS MatchQty ON Store.StoreID = MatchQty.StoreID LEFT OUTER JOIN
                             (SELECT        StoreID, SUM(TotalAfterDiscount) AS DaySale, SUM(QTY) AS SumQty
                               FROM            TransactionEntryItem AS TransactionEntryItem_2
                               WHERE        (CAST(StartSaleTime as date) = CAST(@vDate-7 as date)) AND (QTY < 0)
                               GROUP BY StoreID) AS MatchReturn ON Store.StoreID = MatchReturn.StoreID
WHERE        (Store.Status = 1) AND (Store.StoreNumber NOT IN ('B2','B13','B8'))
ORDER BY Store.StoreNumber
COMMIT TRAN
END


SELECT GETDATE()-7
GO