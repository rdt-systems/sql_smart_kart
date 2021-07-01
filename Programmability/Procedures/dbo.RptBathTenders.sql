SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[RptBathTenders]
(@Filter nvarchar(4000))
as
declare @Sel1 nvarchar(4000)
declare @Sel2 nvarchar(4000)


--'Declare @From datetime
--			Declare @To datetime
--
--			Set @From= '+ @FromDate +'
--			Set @To= '+ @ToDate +'
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
			dbo.[Transaction].BatchID

			FROM  

			dbo.TenderEntry 
			INNER JOIN
			dbo.Tender ON dbo.TenderEntry.TenderID = dbo.Tender.TenderID 
			INNER JOIN
			dbo.[Transaction] ON dbo.TenderEntry.TransactionID = dbo.[Transaction].TransactionID 
			INNER JOIN
			#FilteredTbl BatchRep on BatchRep.batchid=dbo.[Transaction].batchid

			WHERE		dbo.[Transaction].BatchID is not null 
						and [Transaction].Status>0 
						and TenderEntry.Status>0
						AND Tender.TenderType<>1
			GROUP BY 	dbo.TenderEntry.TenderID, dbo.Tender.TenderName, dbo.Tender.SortOrder, dbo.[Transaction].BatchID

			union all

			select 
			''    '' + Credits.TenderName as Tender,
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

			union  all

			select 
			dbo.Tender.TenderName,
			SUM(dbo.TenderEntry.Amount) AS Amount, 
			Count(dbo.TenderEntry.Amount) as [Count],
			1002 as sort, 
			''00000000-0000-0000-0000-000000000000'' as BatchID

			from      
			dbo.TenderEntry INNER JOIN
			dbo.Tender ON dbo.TenderEntry.TenderID = dbo.Tender.TenderID INNER JOIN
			dbo.[Transaction] ON dbo.TenderEntry.TransactionID = dbo.[Transaction].TransactionID INNER JOIN
			#FilteredTbl BatchRep on BatchRep.batchid=dbo.[Transaction].batchid

			WHERE		dbo.[Transaction].BatchID is not null 
						AND Tender.TenderType<>1
						and [Transaction].Status>0 
						and TenderEntry.Status>0
			GROUP BY 	dbo.Tender.TenderName

			union all

			select 
			''    '' + Credits.TenderName as Tender,
			SUM(dbo.TenderEntry.Amount) AS Amount,
			Count(dbo.TenderEntry.Amount) as [Count],
			1003 as Sort,
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

			ORDER BY Sort

			drop table #FilteredTbl'

execute (@Sel1 + @Filter + @Sel2)
GO