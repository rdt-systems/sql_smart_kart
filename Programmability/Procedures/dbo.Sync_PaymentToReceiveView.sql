SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_PaymentToReceiveView]
(@FromDate DateTime,
@LastDateSync DateTime)
As 

 		  SELECT     dbo.SupplierTenderEntryView.SupplierID,
					 dbo.PayToBill.PayToBillID as PaymentToReceiveID,
			         dbo.SupplierTenderEntryView.SuppTenderEntryID as PaymentID, 
			         dbo.ReceiveOrder.ReceiveID as ReceiveID,
			         dbo.PayToBill.Amount

		  INTO #TempSync

		  FROM       dbo.SupplierTenderEntryView
	      INNER JOIN              
					dbo.PayToBill ON dbo.PayToBill.SuppTenderID = dbo.SupplierTenderEntryView.SuppTenderEntryID
	      INNER JOIN dbo.ReceiveOrder On dbo.PayToBill.BillID=ReceiveOrder.BillID
 		  WHERE     (dbo.SupplierTenderEntryView.Status > 0)   AND (dbo.SupplierTenderEntryView.TenderDate > @FromDate)   


--Create table with supplier and count of changes

		   SELECT Count(*) as cnt,SupplierNo as SupplierNo
                   INTO #TempSupplier
		   FROM dbo.ReceiveOrderView
		   WHERE DateModified>= @LastDateSync or DateCreated>=@LastDateSync 
  	           GROUP BY SupplierNo

                   UNION

		   SELECT Count(*) as cnt,SupplierID as SupplierNo
		   FROM dbo.ReturnToVenderView 
                   WHERE DateModified>= @LastDateSync or DateCreated>=@LastDateSync  
		   GROUP BY SupplierID

                   UNION

                   SELECT Count(*) as cnt,SupplierID as SupplierNo
		   FROM dbo.SupplierTenderEntryView  
		   WHERE DateModified>= @LastDateSync or DateCreated>=@LastDateSync 
		   GROUP BY SupplierID
--select
		  SELECT    #TempSync.SupplierID,
			    #TempSync.PaymentToReceiveID,
			    #TempSync.PaymentID,
				#TempSync.ReceiveID,
 			    ISNULL(#TempSync.Amount,2) as Amount,
				0 as DsRowState

		  FROM      #TempSync

		  INNER JOIN
		  (select sum(cnt) as CNT,SupplierNo
                   from #TempSupplier
		   group by  SupplierNo
		   having  sum(cnt)>0
		   )
		   AS OnlyChanged
   		   ON onlychanged.SupplierNo=dbo.#TempSync.SupplierID


drop table #TempSync
drop table #TempSupplier
GO