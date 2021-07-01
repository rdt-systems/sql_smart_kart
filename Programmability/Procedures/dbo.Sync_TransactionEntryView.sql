SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_TransactionEntryView]
(@FromDate DateTime,
@LastDateSync DateTime)

As
--Table Customer Changes

		   SELECT Count(*) as cnt,CustomerID
           INTO #TempCustomer
		   FROM dbo.[Transaction]
		   WHERE DateModified>= @LastDateSync or DateCreated>=@LastDateSync 
  	       GROUP BY CustomerID

           UNION

		   SELECT Count(*) as cnt,CustomerID
		   FROM dbo.WorkOrder 
           WHERE DateModified>= @LastDateSync or DateCreated>=@LastDateSync  
		   GROUP BY CustomerID

--Select

  SELECT     dbo.TransactionWithPaidView.CustomerID,
			 dbo.TransactionEntry.TransactionEntryID, 
			 dbo.TransactionEntry.ItemStoreID, 
			 dbo.TransactionEntry.TransactionID, 
			 dbo.TransactionEntry.UOMQty as Qty, 
			 dbo.TransactionEntry.UOMType as PC, 
			 dbo.TransactionEntry.UOMPrice as Price, 
			 (CASE WHEN TransactionEntry.TransactionEntryType<>4 THEN Sort ELSE -999 END) as Sort,
			 NULL AS QtySold

  INTO #TempSync
  FROM         dbo.TransactionWithPaidView
  INNER JOIN
	  dbo.TransactionEntry ON dbo.TransactionEntry.TransactionID=TransactionWithPaidView.TransactionID

  WHERE TransactionWithPaidView.Status>0 And
		TransactionWithPaidView.EndSaleTime>=@FromDate And 
		TransactionEntry.Status>0

  UNION
 

   SELECT     dbo.WorkOrder.CustomerID,
			 dbo.WorkOrderEntryView.WorkOrderEntryID as TransactionEntryID, 
			 dbo.WorkOrderEntryView.ItemStoreID, 
			 dbo.WorkOrderEntryView.WorkOrderID as TransactionID, 
			 dbo.WorkOrderEntryView.UOMQty as Qty, 
			 dbo.WorkOrderEntryView.UOMType as PC, 
			 dbo.WorkOrderEntryView.UOMPrice as Price, 
			 ISNULL(dbo.WorkOrderEntryView.Sort,0) as Sort,
			 (Select SoldQty From OpenSaleOrderView Where WOID=WorkOrderEntryView.WorkOrderID And OpenSaleOrderView.ItemStoreID=WorkOrderEntryView.ItemStoreID) As QtySold

  FROM         dbo.WorkOrder
  INNER JOIN
	  dbo.WorkOrderEntryView ON dbo.WorkOrderEntryView.WorkOrderID=WorkOrder.WorkOrderID

  Where WorkOrderEntryView.Status>0 And
		WorkOrder.Status>0 And
		WorkOrder.EndSaleTime>=@FromDate
  

--SELECT

		  SELECT    #TempSync.CustomerID,
					#TempSync.TransactionEntryID,
					#TempSync.ItemStoreID,
					#TempSync.TransactionID,
					#TempSync.Qty,
					#TempSync.PC,
					#TempSync.Price,
					#TempSync.Sort,
				    0 as DsRowState,
				    #TempSync.QtySold

		  FROM      #TempSync

		  INNER JOIN
		  (select sum(cnt) as CNT,CustomerID
                   from #TempCustomer
		   group by  CustomerID
		   having  sum(cnt)>0
		   )
		   AS OnlyChanged
   		   ON onlychanged.CustomerID=dbo.#TempSync.CustomerID


drop table #TempSync
drop table #TempCustomer
GO