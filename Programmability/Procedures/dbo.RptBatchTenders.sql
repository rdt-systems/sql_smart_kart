SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[RptBatchTenders]
(@Filter nvarchar(4000))
as
declare @Sel1 nvarchar(4000)
declare @Sel2 nvarchar(4000)



set @Sel1 = 'SELECT batchid 
			INTO #FilteredTbl
			FROM RepBatchView
			where 1=1 '

set @Sel2= 'GROUP BY batchid

			SELECT	

			dbo.Tender.TenderName AS Tender, 
			SUM(dbo.TenderEntry.Amount) AS Amount, 
			Count(dbo.TenderEntry.Amount) as [Count],
			case when dbo.TenderEntry.TenderID=3 then 1000 else dbo.Tender.SortOrder end AS Sort, 
			Transactions.BatchID

			FROM  

			dbo.TenderEntry 
			INNER JOIN
			dbo.Tender ON dbo.TenderEntry.TenderID = dbo.Tender.TenderID 
			INNER JOIN 
			(	(select transactionid,batchid 
				from dbo.[Transaction] 
				where status>0) 
				union all 
				(select cashcheckID transactionid,batchid 
				from cashcheck 
				where status>0) )Transactions ON dbo.TenderEntry.TransactionID = Transactions.TransactionID 
			INNER JOIN
			#FilteredTbl BatchRep on BatchRep.batchid=Transactions.batchid					

			WHERE		Transactions.BatchID is not null and 
						TenderEntry.Status>0 AND 
						Tender.TenderType<>1
			GROUP BY 	dbo.TenderEntry.TenderID, dbo.Tender.TenderName, dbo.Tender.SortOrder, Transactions.BatchID

			union all

			select 
			dbo.Tender.TenderName,
			SUM(dbo.TenderEntry.Amount) AS Amount, 
			Count(dbo.TenderEntry.Amount) as [Count],
			1002 as sort, 
			''00000000-0000-0000-0000-000000000000'' as BatchID

			from      
			dbo.TenderEntry 
			INNER JOIN
			dbo.Tender ON dbo.TenderEntry.TenderID = dbo.Tender.TenderID 
			INNER JOIN
			(	(select transactionid,batchid 
				from dbo.[Transaction] 
				where status>0) 
				union all 
				(select cashcheckID transactionid,batchid 
				from cashcheck 
				where status>0) )Transactions ON dbo.TenderEntry.TransactionID = Transactions.TransactionID 
			INNER JOIN
			#FilteredTbl BatchRep on BatchRep.batchid=Transactions.batchid

			WHERE		Transactions.BatchID is not null 
						AND Tender.TenderType<>1
						and TenderEntry.Status>0
			GROUP BY 	dbo.Tender.TenderName

			union all

			SELECT	

			dbo.Tender.TenderName + '' - Paid Out'' AS Tender, 
			SUM(dbo.TenderEntry.Amount) AS Amount, 
			Count(dbo.TenderEntry.Amount) as [Count],
			case when dbo.TenderEntry.TenderID=3 then 1000 else dbo.Tender.SortOrder end AS Sort, 
			dbo.Payout.BatchID

			FROM  

			dbo.TenderEntry 
			INNER JOIN
			dbo.Tender ON dbo.TenderEntry.TenderID = dbo.Tender.TenderID 
			INNER JOIN
			dbo.Payout ON dbo.TenderEntry.TransactionID = dbo.Payout.PayoutID 
			INNER JOIN
			#FilteredTbl BatchRep on BatchRep.batchid=dbo.Payout.batchid					

			WHERE		dbo.Payout.BatchID is not null 
						and Payout.Status>0 
						and TenderEntry.Status>0
						AND Tender.TenderType<>1
			GROUP BY 	dbo.TenderEntry.TenderID, dbo.Tender.TenderName, dbo.Tender.SortOrder, dbo.Payout.BatchID

			union all

			select 
			dbo.Tender.TenderName + '' - Paid Out'' AS Tender,
			SUM(dbo.TenderEntry.Amount) AS Amount, 
			Count(dbo.TenderEntry.Amount) as [Count],
			1002 as sort, 
			''00000000-0000-0000-0000-000000000000'' as BatchID

			from      
			dbo.TenderEntry INNER JOIN
			dbo.Tender ON dbo.TenderEntry.TenderID = dbo.Tender.TenderID INNER JOIN
			dbo.Payout ON dbo.TenderEntry.TransactionID = dbo.Payout.PayoutID INNER JOIN
			#FilteredTbl BatchRep on BatchRep.batchid=dbo.Payout.batchid

			WHERE		dbo.Payout.BatchID is not null 
						AND Tender.TenderType<>1
						and Payout.Status>0 
						and TenderEntry.Status>0
			GROUP BY 	dbo.Tender.TenderName



			ORDER BY Sort
			drop table #FilteredTbl'

execute (@Sel1 + @Filter + @Sel2)
GO