SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_ReceiveEntryView]
(@FromDate DateTime,
@LastDateSync DateTime)
As 

          SELECT     dbo.ReceiveOrderView.SupplierNo AS Supplier,
				 dbo.ReceiveOrderView.ReceiveID as ID, 
				 dbo.ReceiveEntryView.ReceiveEntryID, 
			     dbo.ReceiveEntryView.ItemStoreNo as ItemStoreID,
		         dbo.ReceiveEntryView.UOMType as PC,
			     dbo.ReceiveEntryView.UOMQty as Qty,
			     dbo.ReceiveEntryView.UOMPrice as Cost,
			     dbo.ReceiveEntryView.SortOrder as Sort

		  INTO #TempSync

		  FROM       dbo.ReceiveOrderView
		  INNER JOIN dbo.ReceiveEntryView On dbo.ReceiveOrderView.ReceiveID=dbo.ReceiveEntryView.ReceiveNo

    		  WHERE     (dbo.ReceiveOrderView.Status > 0) AND (dbo.ReceiveOrderView.ReceiveOrderDate>=@FromDate)AND(dbo.ReceiveEntryView.Status>0)
			
 UNION      

 		  SELECT     dbo.ReturnToVenderView.SupplierID AS Supplier,
			     dbo.ReturnToVenderView.ReturnToVenderID as ID, 
			     dbo.ReturnToVenderEntryView.ReturnToVenderEntryID as ReceiveEntryID, 
			     dbo.ReturnToVenderEntryView.ItemStoreNo as ItemStoreID,
		         dbo.ReturnToVenderEntryView.UOMType as PC,
			     dbo.ReturnToVenderEntryView.UOMQty as Qty,
			     dbo.ReturnToVenderEntryView.UOMPrice as Cost,
			     dbo.ReturnToVenderEntryView.SortOrder as Sort

		  FROM       dbo.ReturnToVenderView
		  INNER JOIN dbo.ReturnToVenderEntryView On dbo.ReturnToVenderView.ReturnToVenderID=dbo.ReturnToVenderEntryView.ReturnToVenderID

    		  WHERE     (dbo.ReturnToVenderView.Status > 0) AND (dbo.ReturnToVenderView.ReturnToVenderDate>=@FromDate)AND(dbo.ReturnToVenderEntryView.Status>0)

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
					#TempSync.Supplier as SupplierID,
					#TempSync.ReceiveEntryID,
					#TempSync.ItemStoreID,
					#TempSync.PC,
					#TempSync.Qty,
					#TempSync.Cost,
					#TempSync.Sort,
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