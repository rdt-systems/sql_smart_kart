SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[RptBatchCreditTenders]
(@Filter nvarchar(4000))
as
declare @Sel1 nvarchar(4000)
declare @Sel2 nvarchar(4000)



set @Sel1 = 'SELECT batchid 
			INTO #FilteredTbl
			FROM RepBatchView
			where 1=1 '

set @Sel2= 'GROUP BY batchid

			select 
			Credits.TenderName as Tender,
			SUM(dbo.TenderEntry.Amount) AS Amount,
			Count(dbo.TenderEntry.Amount) as [Count],
			1001 as Sort,
			[Transaction].BatchID

			from	

			TenderEntry  
			inner join
			(select SystemValueName as TenderName,SystemValueNo
			 from dbo.SystemValues 
			 where SystemTableNo=5) Credits on Credits.SystemValueNo=TenderEntry.common3
			inner join
			[Transaction] on [Transaction].TransactionID=TenderEntry.TransactionID
			INNER JOIN
			#FilteredTbl BatchRep on BatchRep.batchid=dbo.[Transaction].batchid

			where 
					TenderEntry.TenderID=3 and 
					common3 is not null
					and [Transaction].Status>0 
					and TenderEntry.Status>0

			group by Credits.TenderName,[Transaction].BatchID

			union all

			select 
			Credits.TenderName as Tender,
			SUM(dbo.TenderEntry.Amount) AS Amount,
			Count(dbo.TenderEntry.Amount) as [Count],
			2001 as Sort,
			''00000000-0000-0000-0000-000000000000'' as BatchID

			from	

			TenderEntry  
			inner join
			(select SystemValueName as TenderName,SystemValueNo
			 from dbo.SystemValues 
			 where SystemTableNo=5) Credits on Credits.SystemValueNo=TenderEntry.common3
			inner join
			[Transaction] on [Transaction].TransactionID=TenderEntry.TransactionID
			INNER JOIN
			#FilteredTbl BatchRep on BatchRep.batchid=dbo.[Transaction].batchid

			where 
				TenderEntry.TenderID=3 and 
				common3 is not null
				and [Transaction].Status>0 
				and TenderEntry.Status>0

			group by Credits.TenderName

		union all

		select 
			Credits.TenderName as Tender,
			SUM(dbo.TenderEntry.Amount) AS Amount,
			Count(dbo.TenderEntry.Amount) as [Count],
			1001 as Sort,
			PayOut.BatchID

			from	

			TenderEntry  
			inner join
			(select SystemValueName as TenderName,SystemValueNo
			 from dbo.SystemValues 
			 where SystemTableNo=5) Credits on Credits.SystemValueNo=TenderEntry.common3
			inner join
			PayOut on PayOut.PayOutID=TenderEntry.TransactionID
			INNER JOIN
			#FilteredTbl BatchRep on BatchRep.batchid=dbo.PayOut.batchid

			where 
					TenderEntry.TenderID=3 and 
					common3 is not null
					and PayOut.Status>0 
					and TenderEntry.Status>0

			group by Credits.TenderName,PayOut.BatchID

			union all

			select 
			Credits.TenderName as Tender,
			SUM(dbo.TenderEntry.Amount) AS Amount,
			Count(dbo.TenderEntry.Amount) as [Count],
			2001 as Sort,
			''00000000-0000-0000-0000-000000000000'' as BatchID

			from	

			TenderEntry  
			inner join
			(select SystemValueName as TenderName,SystemValueNo
			 from dbo.SystemValues 
			 where SystemTableNo=5) Credits on Credits.SystemValueNo=TenderEntry.common3
			inner join
			PayOut on PayOut.PayOutID=TenderEntry.TransactionID
			INNER JOIN
			#FilteredTbl BatchRep on BatchRep.batchid=dbo.PayOut.batchid

			where 
				TenderEntry.TenderID=3 and 
				common3 is not null
				and PayOut.Status>0 
				and TenderEntry.Status>0

			group by Credits.TenderName


			ORDER BY Sort

			drop table #FilteredTbl'

execute (@Sel1 + @Filter + @Sel2)
GO