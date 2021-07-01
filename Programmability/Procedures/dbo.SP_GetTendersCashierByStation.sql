SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTendersCashierByStation](@FromDate DateTime,
                                     @ToDate DateTime,
									 @StoreID UniqueIdentifier = null,
									 @RegisterID UniqueIdentifier = null)
AS
IF @StoreID is null AND @RegisterID is null
BEGIN
	SELECT        Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, TenderEntry.Amount, (CASE WHEN TenderType = 2 THEN 'CASH' ELSE 'GIFT' END) 
							 AS TenderType, Credit.TenderName AS CreditName, [Transaction].TransactionNo, [Transaction].TransactionID
	FROM            Tender INNER JOIN
							 TenderEntry ON Tender.TenderID = TenderEntry.TenderID INNER JOIN
							 [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
							 Registers ON [Transaction].RegisterID = Registers.RegisterID LEFT OUTER JOIN
								 (SELECT        SystemValueName AS TenderName, SystemValueNo
								   FROM            SystemValues
								   WHERE        (SystemTableNo = 5)) AS Credit ON TenderEntry.Common3 = Credit.SystemValueNo AND dbo.Getday(StartSaleTime)>=@FromDate AND dbo.Getday(StartSaleTime)<=@ToDate 
	WHERE        ([Transaction].Status > 0) AND (Tender.TenderGroup <> 6) AND (Tender.TenderGroup <> 7)
	--SELECT        Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, SUM(TenderEntry.Amount) AS Amount, 
	--						 (CASE WHEN TenderType = 2 THEN 'CASH' ELSE 'GIFT' END) AS TenderType, Credit.TenderName AS CreditName
	--FROM            Tender INNER JOIN
	--						 TenderEntry ON Tender.TenderID = TenderEntry.TenderID INNER JOIN
	--						 [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
	--						 Registers ON [Transaction].RegisterID = Registers.RegisterID LEFT OUTER JOIN
	--							 (SELECT        SystemValueName AS TenderName, SystemValueNo
	--							   FROM            SystemValues
	--							   WHERE        (SystemTableNo = 5)) AS Credit ON TenderEntry.Common3 = Credit.SystemValueNo
	--WHERE        ([Transaction].Status > 0) AND (Tender.TenderGroup <> 6) AND (Tender.TenderGroup <> 7) AND dbo.Getday(StartSaleTime)>=@FromDate AND dbo.Getday(StartSaleTime)<=@ToDate  
	--GROUP BY Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, Tender.TenderType, Credit.TenderName
END
ELSE IF @RegisterID is null
BEGIN
	SELECT        Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, TenderEntry.Amount, (CASE WHEN TenderType = 2 THEN 'CASH' ELSE 'GIFT' END) 
							 AS TenderType, Credit.TenderName AS CreditName, [Transaction].TransactionNo, [Transaction].TransactionID
	FROM            Tender INNER JOIN
							 TenderEntry ON Tender.TenderID = TenderEntry.TenderID INNER JOIN
							 [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
							 Registers ON [Transaction].RegisterID = Registers.RegisterID LEFT OUTER JOIN
								 (SELECT        SystemValueName AS TenderName, SystemValueNo
								   FROM            SystemValues
								   WHERE        (SystemTableNo = 5)) AS Credit ON TenderEntry.Common3 = Credit.SystemValueNo
	WHERE        ([Transaction].Status > 0) AND (Tender.TenderGroup <> 6) AND (Tender.TenderGroup <> 7) AND (dbo.GetDay([Transaction].StartSaleTime) >= @FromDate) AND 
							 (dbo.GetDay([Transaction].StartSaleTime) <= @ToDate) AND ([Transaction].StoreID = @StoreID)

	--SELECT        Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, SUM(TenderEntry.Amount) AS Amount, 
	--						 (CASE WHEN TenderType = 2 THEN 'CASH' ELSE 'GIFT' END) AS TenderType, Credit.TenderName AS CreditName
	--FROM            Tender INNER JOIN
	--						 TenderEntry ON Tender.TenderID = TenderEntry.TenderID INNER JOIN
	--						 [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
	--						 Registers ON [Transaction].RegisterID = Registers.RegisterID LEFT OUTER JOIN
	--							 (SELECT        SystemValueName AS TenderName, SystemValueNo
	--							   FROM            SystemValues
	--							   WHERE        (SystemTableNo = 5)) AS Credit ON TenderEntry.Common3 = Credit.SystemValueNo
	--WHERE        ([Transaction].Status > 0) AND (Tender.TenderGroup <> 6) AND (Tender.TenderGroup <> 7) AND dbo.Getday(StartSaleTime)>=@FromDate AND dbo.Getday(StartSaleTime)<=@ToDate AND [Transaction].StoreID =@StoreID 
	--GROUP BY Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, Tender.TenderType, Credit.TenderName
END
ELSE IF @StoreID is null
BEGIN
	SELECT        Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, TenderEntry.Amount, (CASE WHEN TenderType = 2 THEN 'CASH' ELSE 'GIFT' END) 
							 AS TenderType, Credit.TenderName AS CreditName, [Transaction].TransactionNo, [Transaction].TransactionID
	FROM            Tender INNER JOIN
							 TenderEntry ON Tender.TenderID = TenderEntry.TenderID INNER JOIN
							 [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
							 Registers ON [Transaction].RegisterID = Registers.RegisterID LEFT OUTER JOIN
								 (SELECT        SystemValueName AS TenderName, SystemValueNo
								   FROM            SystemValues
								   WHERE        (SystemTableNo = 5)) AS Credit ON TenderEntry.Common3 = Credit.SystemValueNo
	WHERE        ([Transaction].Status > 0) AND (Tender.TenderGroup <> 6) AND (Tender.TenderGroup <> 7) AND (dbo.GetDay([Transaction].StartSaleTime) >= @FromDate) AND 
							 (dbo.GetDay([Transaction].StartSaleTime) <= @ToDate) AND ([Transaction].RegisterID = @RegisterID)
	--SELECT        Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, SUM(TenderEntry.Amount) AS Amount, 
	--						 (CASE WHEN TenderType = 2 THEN 'CASH' ELSE 'GIFT' END) AS TenderType, Credit.TenderName AS CreditName
	--FROM            Tender INNER JOIN
	--						 TenderEntry ON Tender.TenderID = TenderEntry.TenderID INNER JOIN
	--						 [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
	--						 Registers ON [Transaction].RegisterID = Registers.RegisterID LEFT OUTER JOIN
	--							 (SELECT        SystemValueName AS TenderName, SystemValueNo
	--							   FROM            SystemValues
	--							   WHERE        (SystemTableNo = 5)) AS Credit ON TenderEntry.Common3 = Credit.SystemValueNo
	--WHERE        ([Transaction].Status > 0) AND (Tender.TenderGroup <> 6) AND (Tender.TenderGroup <> 7) AND dbo.Getday(StartSaleTime)>=@FromDate AND dbo.Getday(StartSaleTime)<=@ToDate AND [Transaction].RegisterID =@RegisterID  
	--GROUP BY Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, Tender.TenderType, Credit.TenderName
END
ELSE 
BEGIN
	SELECT        Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, TenderEntry.Amount, (CASE WHEN TenderType = 2 THEN 'CASH' ELSE 'GIFT' END) 
							 AS TenderType, Credit.TenderName AS CreditName, [Transaction].TransactionNo, [Transaction].TransactionID
	FROM            Tender INNER JOIN
							 TenderEntry ON Tender.TenderID = TenderEntry.TenderID INNER JOIN
							 [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
							 Registers ON [Transaction].RegisterID = Registers.RegisterID LEFT OUTER JOIN
								 (SELECT        SystemValueName AS TenderName, SystemValueNo
								   FROM            SystemValues
								   WHERE        (SystemTableNo = 5)) AS Credit ON TenderEntry.Common3 = Credit.SystemValueNo
	WHERE        ([Transaction].Status > 0) AND (Tender.TenderGroup <> 6) AND (Tender.TenderGroup <> 7) AND (dbo.GetDay([Transaction].StartSaleTime) >= @FromDate) AND 
							 (dbo.GetDay([Transaction].StartSaleTime) <= @ToDate) AND ([Transaction].StoreID = @StoreID) AND ([Transaction].RegisterID = @RegisterID)
	--SELECT        Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, SUM(TenderEntry.Amount) AS Amount, 
	--						 (CASE WHEN TenderType = 2 THEN 'CASH' ELSE 'GIFT' END) AS TenderType, Credit.TenderName AS CreditName
	--FROM            Tender INNER JOIN
	--						 TenderEntry ON Tender.TenderID = TenderEntry.TenderID INNER JOIN
	--						 [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
	--						 Registers ON [Transaction].RegisterID = Registers.RegisterID LEFT OUTER JOIN
	--							 (SELECT        SystemValueName AS TenderName, SystemValueNo
	--							   FROM            SystemValues
	--							   WHERE        (SystemTableNo = 5)) AS Credit ON TenderEntry.Common3 = Credit.SystemValueNo
	--WHERE        ([Transaction].Status > 0) AND (Tender.TenderGroup <> 6) AND (Tender.TenderGroup <> 7) AND dbo.Getday(StartSaleTime)>=@FromDate AND dbo.Getday(StartSaleTime)<=@ToDate AND [Transaction].StoreID =@StoreID AND [Transaction].RegisterID =@RegisterID 
	--GROUP BY Tender.TenderName, Registers.RegisterNo, [Transaction].RegisterID, Tender.TenderType, Credit.TenderName
END
GO