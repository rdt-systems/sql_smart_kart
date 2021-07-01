SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[SP_MPYToDateSales]
(@DateModified datetime=null)

AS

Select ItemStoreID, ItemNo, Status, ISNULL(DateModified,dbo.GetLocalDate()) AS DateModified INTO #Items from dbo.ItemStore WITH (NOLOCK) Where Status > 0 AND (ISNULL(DateModified,dbo.GetLocalDate()) > = @DateModified OR  @DateModified IS NULL)

Select DISTINCT SUM(ISNULL(YTD.YTD, 0)) AS Last12Months, SUM(ISNULL(PTD.PTD, 0)) AS Last90, SUM(ISNULL(MTD.MTD, 0)) AS Last30, ItemNo, MAX(DateModified) AS DateModified, 1 AS Status

From dbo.[#Items] AS ItemStore WITH (NOLOCK) LEFT OUTER JOIN
(
SELECT  E.ItemStoreID, SUM(Qty) AS MTD FROM dbo.TransactionEntry E WITH (NOLOCK) INNER JOIN #Items I ON E.ItemStoreID = I.ItemStoreID INNER JOIN dbo.[Transaction] T WITH (NOLOCK)  ON E.TransactionID = T.TransactionID
Where E.Status > 0 AND T.Status > 0 AND T.EndSaleTime between (Dateadd(day,-31, CAST(dbo.GetLocalDate() as Date))) and (Dateadd(day,-1, CAST(dbo.GetLocalDate() as Date)))
Group BY E.ItemStoreID) AS MTD on ItemStore.ItemStoreID = MTD.ItemStoreID
LEFT OUTER JOIN
(SELECT  E.ItemStoreID, SUM(Qty) AS PTD FROM dbo.TransactionEntry E WITH (NOLOCK) INNER JOIN #Items I ON E.ItemStoreID = I.ItemStoreID INNER JOIN dbo.[Transaction] T WITH (NOLOCK) ON E.TransactionID = T.TransactionID
Where E.Status > 0 AND T.Status > 0 AND T.EndSaleTime between (Dateadd(day,-91, CAST(dbo.GetLocalDate() as Date))) and (Dateadd(day,-1, CAST(dbo.GetLocalDate() as Date)))
Group BY E.ItemStoreID) AS PTD on ItemStore.ItemStoreID = PTD.ItemStoreID
LEFT OUTER JOIN
(
SELECT  E.ItemStoreID, SUM(Qty) AS YTD FROM dbo.TransactionEntry E WITH (NOLOCK)  INNER JOIN #Items I ON E.ItemStoreID = I.ItemStoreID INNER JOIN dbo.[Transaction] T WITH (NOLOCK) ON E.TransactionID = T.TransactionID
Where E.Status > 0 AND T.Status > 0 AND T.EndSaleTime between (Dateadd(day,-361, CAST(dbo.GetLocalDate() as Date))) and (Dateadd(day,-1, CAST(dbo.GetLocalDate() as Date)))
Group BY E.ItemStoreID) AS YTD on ItemStore.ItemStoreID = YTD.ItemStoreID
GROUP BY ItemNo

--SELECT        SUM(ISNULL(YTDQty, 0)) AS Last12Months, SUM(ISNULL(PTDQty, 0)) AS Last90, SUM(ISNULL(MTDQty, 0)) AS Last30, ItemNo, MAX(DateModified) AS DateModified, Status
--FROM            ItemStore
--GROUP BY ItemNo, Status
GO