SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceivesWithFilter]
(@FromDate DateTime,
@LastDateSync DateTime)
As 

                  SELECT     dbo.ReceiveOrderView.SupplierNo AS Supplier,
			     dbo.ReceiveOrderView.ReceiveID as ID, 
			     dbo.ReceiveOrderView.BillNo as No,
		             dbo.ReceiveOrderView.ReceiveOrderDate as Date,
			     0 as Credit,
			     dbo.ReceiveOrderView.Total as Debit,
			     dbo.ReceiveOrderView.AmountPay as Paid,
			     dbo.ReceiveOrderView.Note as Note,
			     2 as Type,
			     dbo.ReceiveOrderView.Discount as Discount,
			     dbo.ReceiveOrderView.IsDiscAmount as IsDiscountAmount

		  INTO #TempSync

		  FROM       dbo.ReceiveOrderView

    		  WHERE     (dbo.ReceiveOrderView.Status > 0) AND (dbo.ReceiveOrderView.ReceiveOrderDate>=@FromDate)
			
 UNION      

 		  SELECT     dbo.ReturnToVenderview.SupplierID AS Supplier,
			     dbo.ReturnToVenderview.ReturnToVenderID as ID, 
			     dbo.ReturnToVenderView.ReturnToVenderNo as No,
		             dbo.ReturnToVenderView.ReturnToVenderDate as Date,
			     dbo.ReturnToVenderView.Total as Credit,
			     0 as Debit,
			     0 as Paid,
			     dbo.ReturnToVenderView.Note as Note,
			     3 as Type,
 			     null as Discount,
			     null as IsDiscountAmount

		  FROM       dbo.ReturnToVenderView

    		  WHERE     (dbo.ReturnToVenderView.Status > 0) AND (dbo.ReturnToVenderView.ReturnToVenderDate>=@FromDate)

 UNION      

 		  SELECT     dbo.SupplierTenderEntryView.SupplierID AS Supplier,
			     dbo.SupplierTenderEntryView.SuppTenderEntryID as ID, 
			     dbo.SupplierTenderEntryView.SuppTenderNo as No,
		             dbo.SupplierTenderEntryView.TenderDate as Date,
			     dbo.SupplierTenderEntryView.Amount as Credit,
			     0 as Debit,
			     0 as Paid,
			     '' as Note,
			     5 as Type,
  			     null as Discount,
			     null as IsDiscountAmount

		  FROM       dbo.SupplierTenderEntryView

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
		  SELECT    #TempSync.ID as ReceiveID,
			    #TempSync.No as ReceiveNo,
			    #TempSync.Date as ReceiveDate,
 			    ISNULL(#TempSync.Credit,2) as Credit,
 			    ISNULL(#TempSync.Debit,2) as Debit,
			    ISNULL(#TempSync.Paid,2)as Paid,
 			    #TempSync.Note,
 			    #TempSync.Type,
			    #TempSync.Discount,
			    #TempSync.IsDiscountAmount,
			    #TempSync.Supplier as SupplierID,
				0 as DsRowState

		  FROM      #TempSync

		  INNER JOIN
		  (select sum(cnt) as CNT,SupplierNo
                   from #TempSupplier
		   group by  SupplierNo
		   having  sum(cnt)>0
		   )
		   AS OnlyChanged
   		   ON onlychanged.SupplierNo=dbo.#TempSync.Supplier


drop table #TempSync
drop table #TempSupplier
GO