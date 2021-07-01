SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_PaymentToInvoiceView]
(@FromDate DateTime,
@LastDateSync DateTime)
as

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


--Payment

	  SELECT     dbo.TransactionWithPaidView.CustomerID,
				 dbo.PaymentDetails.PaymentID as PaymentToInvoiceID, 
				 dbo.PaymentDetails.TransactionID as PaymentID, 
				 dbo.PaymentDetails.TransactionPayedID as InvoiceID, 
			  	 dbo.PaymentDetails.Amount

	  INTO #TempSync

	  FROM         dbo.TransactionWithPaidView
	  INNER JOIN
					dbo.PaymentDetails ON dbo.PaymentDetails.TransactionID=TransactionWithPaidView.TransactionID
  
	  WHERE     (dbo.TransactionWithPaidView.Status > 0)and  
				(dbo.TransactionWithPaidView.TransactionType<>2 and 
				dbo.TransactionWithPaidView.TransactionType<>4 and 
				dbo.PaymentDetails.Status>0) and 
				dbo.TransactionWithPaidView.StartSaleTime>=@FromDate



--SELECT
  SELECT    #TempSync.CustomerID,
			    #TempSync.PaymentToInvoiceID,
			    #TempSync.PaymentID,
				#TempSync.InvoiceID,
 			    ISNULL(#TempSync.Amount,2) as Amount,
				0 as DsRowState

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