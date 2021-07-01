SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[UpdateMYPSmartKart]
as
declare @StartDate as DateTime
declare @EndDate as DateTime

set @EndDate =DATEADD(DAY, DATEDIFF(DAY, 0, dbo.GetLocalDate()), 0)
set @StartDate =@EndDate-30  
UPDATE       ItemStore
SET                MTDQty = Sales.Qty,DateModified=dbo.GetLocalDATE()
FROM            ItemStore INNER JOIN
                             (SELECT        TransactionEntry.ItemStoreID, SUM(TransactionEntry.Qty) AS Qty
                               FROM            [Transaction] INNER JOIN
                                                         TransactionEntry ON [Transaction].TransactionID = TransactionEntry.TransactionID
                               WHERE        ([Transaction].Status > 0) AND (TransactionEntry.Status > 0) AND ([Transaction].StartSaleTime > @StartDate) AND ([Transaction].StartSaleTime < @EndDate)
                               GROUP BY TransactionEntry.ItemStoreID) AS Sales ON ItemStore.ItemStoreID = Sales.ItemStoreID
							   where ItemStore.MTDQty<> Sales.Qty
	   

set @StartDate =@EndDate-90  
UPDATE       ItemStore
SET                PTDQty = Sales.Qty,DateModified=dbo.GetLocalDATE()
FROM            ItemStore INNER JOIN
                             (SELECT        TransactionEntry.ItemStoreID, SUM(TransactionEntry.Qty) AS Qty
                               FROM            [Transaction] INNER JOIN
                                                         TransactionEntry ON [Transaction].TransactionID = TransactionEntry.TransactionID
                               WHERE        ([Transaction].Status > 0) AND (TransactionEntry.Status > 0) AND ([Transaction].StartSaleTime > @StartDate) AND ([Transaction].StartSaleTime < @EndDate)
                               GROUP BY TransactionEntry.ItemStoreID) AS Sales ON ItemStore.ItemStoreID = Sales.ItemStoreID
							   where ItemStore.PTDQty<> Sales.Qty

set @StartDate = DATEADD(DAY, DATEDIFF(DAY, 0,DATEADD(YEAR , -1, dbo.GetLocalDate())), 0)
UPDATE       ItemStore
SET                YTDQty = Sales.Qty,DateModified=dbo.GetLocalDATE()
FROM            ItemStore INNER JOIN
                             (SELECT        TransactionEntry.ItemStoreID, SUM(TransactionEntry.Qty) AS Qty
                               FROM            [Transaction] INNER JOIN
                                                         TransactionEntry ON [Transaction].TransactionID = TransactionEntry.TransactionID
                               WHERE        ([Transaction].Status > 0) AND (TransactionEntry.Status > 0) AND ([Transaction].StartSaleTime > @StartDate) AND ([Transaction].StartSaleTime < @EndDate)
                               GROUP BY TransactionEntry.ItemStoreID) AS Sales ON ItemStore.ItemStoreID = Sales.ItemStoreID
							   where ItemStore.YTDQty<> Sales.Qty
GO