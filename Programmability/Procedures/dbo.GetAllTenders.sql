SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetAllTenders]
(@FromDate datetime,
@ToDate datetime)
AS
SELECT        Store.StoreName, dbo.GetDay([Transaction].StartSaleTime) AS Date, Tender.TenderName, SUM(TenderEntry.Amount) AS Amount
FROM            [Transaction] INNER JOIN
                         TenderEntry ON [Transaction].TransactionID = TenderEntry.TransactionID INNER JOIN
                         Tender ON TenderEntry.TenderID = Tender.TenderID INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID
WHERE        ([Transaction].Status > 0) AND (TenderEntry.Status > 0) AND (dbo.GetDay([Transaction].StartSaleTime) >= @FromDate) AND (dbo.GetDay([Transaction].StartSaleTime) <= @ToDate)
and TenderGroup <>6
GROUP BY dbo.GetDay([Transaction].StartSaleTime), Tender.TenderName, Store.StoreName 

Union
SELECT        Store.StoreName, dbo.GetDay([Transaction].StartSaleTime) AS Date,  'ON ACCOUNT' AS TenderName, 
                         SUM([Transaction].Debit - [Transaction].Credit) AS Amount
FROM            [Transaction] INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID
WHERE        ([Transaction].Status > 0)AND (dbo.GetDay([Transaction].StartSaleTime) >= @FromDate) AND (dbo.GetDay([Transaction].StartSaleTime) <= @ToDate)
 AND ([Transaction].Debit > [Transaction].Credit)
GROUP BY Store.StoreName, dbo.GetDay([Transaction].StartSaleTime)
GO