SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_TransactionView]
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

SELECT     dbo.TransactionWithPaidView.TransactionID, 
		   dbo.TransactionWithPaidView.TransactionNo, 
		   dbo.FormatDateTime(dbo.TransactionWithPaidView.StartSaleTime,'MM/DD/YY hh:mm:ss') as SaleDate, 
		   dbo.TransactionWithPaidView.CustomerID, 
		   dbo.TransactionWithPaidView.Credit, 
		   dbo.TransactionWithPaidView.Debit, 
		   ISNULL(dbo.TransactionWithPaidView.LeftDebit,0) as Paid, 
		   dbo.TransactionWithPaidView.TransactionType, 
		   dbo.TransactionWithPaidView.Note,
           dbo.TransactionWithPaidView.Status as Active

INTO #TempSync

FROM         dbo.TransactionWithPaidView

WHERE     (dbo.TransactionWithPaidView.Status > -1)and  
		  (dbo.TransactionWithPaidView.TransactionType<>2 --and  dbo.TransactionWithPaidView.TransactionType<>4
		  ) and 
		  (dbo.TransactionWithPaidView.StartSaleTime>=@FromDate)

UNION

SELECT     dbo.WorkOrder.WorkOrderID as TransactionID, 
		   dbo.WorkOrder.WONo as TransactionNo, 
		   dbo.FormatDateTime(dbo.WorkOrder.StartSaleTime,'MM/DD/YY hh:mm:ss') as SaleDate, 
		   dbo.WorkOrder.CustomerID, 
		   0 as Credit, 
		   dbo.WorkOrder.Debit, 
		   (CASE WHEN WoStatus=1 THEN 0 END) as Paid, 
		   7 as TransactionType, 
		   dbo.WorkOrder.Note,
           dbo.WorkOrder.Status as Active 

FROM         dbo.WorkOrder

WHERE     (dbo.WorkOrder.Status > -1)and  
		  (dbo.WorkOrder.StartSaleTime>=@FromDate)

				
SELECT  #TempSync.TransactionID,
		#TempSync.TransactionNo,
		#TempSync.SaleDate,
		#TempSync.CustomerID,
		#TempSync.Credit,
		#TempSync.Debit,
		#TempSync.Paid,
		#TempSync.TransactionType,
		#TempSync.Note,
        #TempSync.Active,
		0 as DsRowState
		

FROM #TempSync
 INNER JOIN
		  (select sum(cnt) as CNT,CustomerID
           from #TempCustomer
		   group by  CustomerID
		   having  sum(cnt)>0
		   )
		   AS OnlyChanged
   		   ON onlychanged.CustomerID=dbo.#TempSync.CustomerID
		   Order by #TempSync.CustomerID


drop table #TempSync
drop table #TempCustomer
GO