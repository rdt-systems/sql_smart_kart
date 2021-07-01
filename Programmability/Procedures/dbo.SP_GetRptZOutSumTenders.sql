SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetRptZOutSumTenders]
(
@BatchID uniqueidentifier
)
AS

SELECT     case when dbo.TenderEntry.TenderID=3 then 'All '+dbo.Tender.TenderName+'s' else dbo.Tender.TenderName end AS Tender, SUM(dbo.TenderEntry.Amount) AS Amount, case when dbo.TenderEntry.TenderID=3 then 1000 else dbo.Tender.SortOrder end AS Sort, dbo.[Transaction].BatchID
FROM         	dbo.TenderEntry INNER JOIN
                      	dbo.Tender ON dbo.TenderEntry.TenderID = dbo.Tender.TenderID INNER JOIN
                      	dbo.[Transaction] ON dbo.TenderEntry.TransactionID = dbo.[Transaction].TransactionID
WHERE	BatchID=@BatchID And tenderGroup<>1
GROUP BY 	dbo.TenderEntry.TenderID, dbo.Tender.TenderName, dbo.Tender.SortOrder, dbo.[Transaction].BatchID
union all

SELECT     '        '+SystemValues.SystemValueName AS Tender, SUM(dbo.TenderEntry.Amount) AS Amount, 10000 AS Sort, dbo.[Transaction].BatchID
FROM         dbo.TenderEntry INNER JOIN
                      dbo.[Transaction] ON dbo.TenderEntry.TransactionID = dbo.[Transaction].TransactionID INNER JOIN
                      dbo.Tender ON dbo.TenderEntry.TenderID = dbo.Tender.TenderID LEFT OUTER JOIN
                          (SELECT     SystemValueNo, SystemValueName
                            FROM          dbo.SystemValues
                            WHERE      dbo.SystemValues.SystemTableNo = 5) SystemValues ON dbo.TenderEntry.Common3 = SystemValues.SystemValueNo
WHERE     	(dbo.Tender.TenderGroup = 3) And BatchID=@BatchID
GROUP BY SystemValues.SystemValueName, dbo.[Transaction].BatchID


ORDER BY Sort
GO