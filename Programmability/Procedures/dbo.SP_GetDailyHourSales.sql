SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetDailyHourSales]
	(@FromDate datetime = null,
	 @Todate datetime = null,
	 @StoreID uniqueidentifier= null,
     @ReportType Int)
AS 
BEGIN
	IF @ReportType = 1 --Divide by Day of week
	BEGIN 
		SELECT     StoreName, DATENAME(WEEKDAY, Date)AS WeekDay, dbo.GetHourFromToFormat(OrderCol, 1) AS Hour, 
		SUM(Debit) AS Debit, SUM(Credit) AS Credit, SUM(Balance) AS Balance, SUM(CountTransaction) 
        AS CountTransaction, SUM(Registers) AS Registers, SUM(SalePrec) AS SalePrec, SUM(Customers) AS Customers, SUM(TransactionWithCustomer) 
        AS TransactionWithCustomer, SUM(CustomerPrec) AS CustomerPrec, SUM(CustomerDebit) AS CustomerDebit, SUM(Items) AS Items
        FROM DailyHourSales
		WHERE    (OrderCol >= Dbo.FormatDateTime(@FromDate,'SHORTDATE') AND OrderCol <= Dbo.FormatDateTime(@ToDate,'SHORTDATE'))
		and (@StoreID=StoreID or @StoreID is null)
		GROUP BY StoreName, DATENAME(WEEKDAY, Date), dbo.GetHourFromToFormat(OrderCol, 1)
	END

	ELSE IF @ReportType = 2 --Divide by Date
    BEGIN 
       
		--if Bijuju
		if (select Count(*) From Store Where StoreID = '613389BD-9D2C-4FA2-81AF-208D2153FC8D') >0
		Begin
		 IF @STOREID IS NULL
        BEGIN 
		SELECT        TOP (100) PERCENT dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE') AS Date, [Transaction].StoreID, StoreName, 
                         SUM([Transaction].Debit) AS Debit, SUM([Transaction].Credit) AS Credit, SUM([Transaction].LeftDebit) AS Balance, COUNT(1) AS CountTransaction, 
                         COUNT(DISTINCT [Transaction].RegisterID) AS Registers, ROUND(SUM([Transaction].Debit) / CAST
                             ((SELECT        SUM(Debit) AS Expr1
                                 FROM            [Transaction]
                                 WHERE        (TransactionType = 0) AND (Status > 0) AND (dbo.FormatDateTime(EndSaleTime, 'SHORTDATE') = dbo.FormatDateTime([Transaction].EndSaleTime, 
                                                          'SHORTDATE'))) AS float) * 100, 2) AS SalePrec, COUNT(DISTINCT [Transaction].CustomerID) AS Customers, COUNT([Transaction].CustomerID) 
                         AS TransactionWithCustomer, COUNT([Transaction].CustomerID) / CAST(COUNT(1) AS float) * 100 AS CustomerPrec,
                             (SELECT        SUM(Debit) AS Expr1
                               FROM            [Transaction] AS Transaction_1
                               WHERE        (TransactionType = 0) AND (Status > 0) AND (CustomerID IS NOT NULL) AND (dbo.FormatDateTime(EndSaleTime, 'SHORTDATE') 
                                                         = dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE')) AND (dbo.GetHourFromToFormat(EndSaleTime, 1) 
                                                         = dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1))) AS CustomerDebit, SUM(a.items) AS Items, MAX([Transaction].EndSaleTime) 
                         AS OrderCol, dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1) AS Hour, Store.StoreNumber, Traffic.enters AS pplCount
FROM            [Transaction] INNER JOIN
                             (SELECT        TransactionID, SUM(Qty) AS items
                               FROM            TransactionEntry
                               WHERE        (Status > 0)
                               GROUP BY TransactionID) AS a ON [Transaction].TransactionID = a.TransactionID INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID LEFT OUTER JOIN
                             (SELECT        dbo.FormatDateTime(stime, 'SHORTDATE') AS Date, SUM(enters) AS enters, dbo.GetHourFromToFormat(stime, 1) AS Hour, StoreNo
                               FROM            ShopperTrack 
                               GROUP BY dbo.FormatDateTime(stime, 'SHORTDATE'), dbo.GetHourFromToFormat(stime, 1), StoreNo) AS Traffic ON 
                         dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE') = Traffic.Date AND Store.StoreNumber COLLATE SQL_Latin1_General_CP1_CI_AS = Traffic.StoreNo COLLATE SQL_Latin1_General_CP1_CI_AS
						 AND dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1)=Traffic.Hour  
WHERE        ([Transaction].TransactionType = 0) AND ([Transaction].Status > 0) AND (dbo.GetDay([Transaction].EndSaleTime) >= @FromDate) AND 
                         (dbo.GetDay([Transaction].EndSaleTime) <= @Todate)
GROUP BY dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE'), dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1), [Transaction].StoreID, 
                         StoreName, dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1), Store.StoreNumber, Traffic.enters
ORDER BY OrderCol

		END
		ELSE
		BEGIN
SELECT        TOP (100) PERCENT dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE') AS Date, [Transaction].StoreID, StoreName, 
                         SUM([Transaction].Debit) AS Debit, SUM([Transaction].Credit) AS Credit, SUM([Transaction].LeftDebit) AS Balance, COUNT(1) AS CountTransaction, 
                         COUNT(DISTINCT [Transaction].RegisterID) AS Registers, ROUND(SUM([Transaction].Debit) / CAST
                             ((SELECT        SUM(Debit) AS Expr1
                                 FROM            [Transaction]
                                 WHERE        (TransactionType = 0) AND (Status > 0) AND (dbo.FormatDateTime(EndSaleTime, 'SHORTDATE') = dbo.FormatDateTime([Transaction].EndSaleTime, 
                                                          'SHORTDATE'))) AS float) * 100, 2) AS SalePrec, COUNT(DISTINCT [Transaction].CustomerID) AS Customers, COUNT([Transaction].CustomerID) 
                         AS TransactionWithCustomer, COUNT([Transaction].CustomerID) / CAST(COUNT(1) AS float) * 100 AS CustomerPrec,
                             (SELECT        SUM(Debit) AS Expr1
                               FROM            [Transaction] AS Transaction_1
                               WHERE        (TransactionType = 0) AND (Status > 0) AND (CustomerID IS NOT NULL) AND (dbo.FormatDateTime(EndSaleTime, 'SHORTDATE') 
                                                         = dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE')) AND (dbo.GetHourFromToFormat(EndSaleTime, 1) 
                                                         = dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1))) AS CustomerDebit, SUM(a.items) AS Items, MAX([Transaction].EndSaleTime) 
                         AS OrderCol, dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1) AS Hour, Store.StoreNumber, Traffic.enters AS pplCount
FROM            [Transaction] INNER JOIN
                             (SELECT        TransactionID, SUM(Qty) AS items
                               FROM            TransactionEntry
                               WHERE        (Status > 0)
                               GROUP BY TransactionID) AS a ON [Transaction].TransactionID = a.TransactionID INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID LEFT OUTER JOIN
                             (SELECT        dbo.FormatDateTime(stime, 'SHORTDATE') AS Date, SUM(enters) AS enters, dbo.GetHourFromToFormat(stime, 1) AS Hour, StoreNo
                               FROM            ShopperTrack
                               GROUP BY dbo.FormatDateTime(stime, 'SHORTDATE'), dbo.GetHourFromToFormat(stime, 1), StoreNo) AS Traffic ON 
                         dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE') = Traffic.Date AND Store.StoreNumber COLLATE SQL_Latin1_General_CP1_CI_AS = Traffic.StoreNo 
						 AND dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1)=Traffic.Hour  
WHERE        ([Transaction].TransactionType = 0) AND ([Transaction].Status > 0) AND (dbo.GetDay([Transaction].EndSaleTime) >= @FromDate) AND 
                         (dbo.GetDay([Transaction].EndSaleTime) <= @Todate)AND ([Transaction].StoreID = @StoreID)
GROUP BY dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE'), dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1), [Transaction].StoreID, 
                         StoreName, dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1), Store.StoreNumber, Traffic.enters
ORDER BY OrderCol	
		END  	
	END
		Else Begin
		--all other remove for now the ppl count
		 IF @STOREID IS NULL
        BEGIN 
			SELECT        TOP (100) PERCENT dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE') AS Date, [Transaction].StoreID, StoreName, 
									 SUM([Transaction].Debit) AS Debit, SUM([Transaction].Credit) AS Credit, SUM([Transaction].LeftDebit) AS Balance, COUNT(1) AS CountTransaction, 
									 COUNT(DISTINCT [Transaction].RegisterID) AS Registers, ROUND(SUM([Transaction].Debit) / CAST
										 ((SELECT        SUM(Debit) AS Expr1
											 FROM            [Transaction]
											 WHERE        (TransactionType = 0) AND (Status > 0) AND (dbo.FormatDateTime(EndSaleTime, 'SHORTDATE') = dbo.FormatDateTime([Transaction].EndSaleTime, 
																	  'SHORTDATE'))) AS float) * 100, 2) AS SalePrec, COUNT(DISTINCT [Transaction].CustomerID) AS Customers, COUNT([Transaction].CustomerID) 
									 AS TransactionWithCustomer, COUNT([Transaction].CustomerID) / CAST(COUNT(1) AS float) * 100 AS CustomerPrec,
										 (SELECT        SUM(Debit) AS Expr1
										   FROM            [Transaction] AS Transaction_1
										   WHERE        (TransactionType = 0) AND (Status > 0) AND (CustomerID IS NOT NULL) AND (dbo.FormatDateTime(EndSaleTime, 'SHORTDATE') 
																	 = dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE')) AND (dbo.GetHourFromToFormat(EndSaleTime, 1) 
																	 = dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1))) AS CustomerDebit, SUM(a.items) AS Items, MAX([Transaction].EndSaleTime) 
									 AS OrderCol, DATENAME(WEEKDAY, [Transaction].EndSaleTime) AS WeekDay, dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1) AS Hour
			FROM            [Transaction] INNER JOIN  Store ON [Transaction].StoreID = Store.StoreID INNER JOIN
										 (SELECT        TransactionID, SUM(Qty) AS items
										   FROM            TransactionEntry
										   WHERE        (Status > 0)
										   GROUP BY TransactionID) AS a ON [Transaction].TransactionID = a.TransactionID
			WHERE        ([Transaction].TransactionType = 0) AND ([Transaction].Status > 0) AND (dbo.GetDay([Transaction].EndSaleTime) >= @FromDate) AND 
									 (dbo.GetDay([Transaction].EndSaleTime) <= @Todate)
			GROUP BY dbo.FormatDateTime([Transaction].EndSaleTime, 'SHORTDATE'), dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1), [Transaction].StoreID, 
									 StoreName, DATENAME(WEEKDAY, [Transaction].EndSaleTime), dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1)
			ORDER BY OrderCol
		END
		ELSE
		BEGIN
			SELECT     TOP 100 PERCENT dbo.FormatDateTime(dbo.[Transaction].EndSaleTime, 'SHORTDATE') AS Date,[Transaction].StoreID,StoreName, 
								  /*dbo.GetHourFromToFormat(dbo.[Transaction].EndSaleTime,1) AS Hour,*/ SUM([Transaction].Debit) AS Debit, 
								  SUM(dbo.[Transaction].Credit) AS Credit, SUM(dbo.[Transaction].LeftDebit) AS Balance, COUNT(1) 
								  AS CountTransaction, COUNT(DISTINCT dbo.[Transaction].RegisterID) AS Registers, 
								  ROUND(SUM(dbo.[Transaction].Debit) / CAST
									  ((SELECT     SUM(Debit) AS Expr1
										  FROM         dbo.[Transaction]
										  WHERE     (TransactionType = 0) AND (Status > 0) AND (dbo.FormatDateTime(EndSaleTime, 'SHORTDATE') 
																= dbo.FormatDateTime(dbo.[Transaction].EndSaleTime, 'SHORTDATE'))) AS float) * 100, 2) AS SalePrec, 
								  COUNT(DISTINCT dbo.[Transaction].CustomerID) AS Customers, COUNT(dbo.[Transaction].CustomerID) 
								  AS TransactionWithCustomer, COUNT(dbo.[Transaction].CustomerID) / CAST(COUNT(1) AS float) * 100 AS CustomerPrec,
									  (SELECT     SUM(Debit) AS Expr1
										FROM          dbo.[Transaction] AS Transaction_1
										WHERE      (TransactionType = 0) AND (Status > 0) AND (CustomerID IS NOT NULL) AND (dbo.FormatDateTime(EndSaleTime, 'SHORTDATE') 
															   = dbo.FormatDateTime(dbo.[Transaction].EndSaleTime, 'SHORTDATE')) AND (dbo.GetHourFromToFormat(EndSaleTime,1) 
															   = dbo.GetHourFromToFormat(dbo.[Transaction].EndSaleTime,1))) AS CustomerDebit, SUM(a.items) AS Items, 
								  MAX(dbo.[Transaction].EndSaleTime) AS OrderCol, DATENAME(WEEKDAY, dbo.[Transaction].EndSaleTime)AS WeekDay, dbo.GetHourFromToFormat(dbo.[Transaction].EndSaleTime, 1) AS Hour
									
			FROM         dbo.[Transaction] INNER JOIN  Store ON [Transaction].StoreID = Store.StoreID INNER JOIN
									  (SELECT     TransactionID, SUM(Qty) AS items
										FROM          dbo.TransactionEntry
										WHERE      (Status > 0)
										GROUP BY TransactionID) AS a ON dbo.[Transaction].TransactionID = a.TransactionID LEFT OUTER JOIN
                          (SELECT     SUM(enters) AS pplCount, dbo.GetHourFromToFormat(stime, 1) AS Houre, dbo.GetDay(stime) AS Day, StoreID
                            FROM          ShopperTrack
                            GROUP BY dbo.GetHourFromToFormat(stime, 1), dbo.GetDay(stime), StoreID) AS pplCount ON [Transaction].StoreID = pplCount.StoreID AND 
                      dbo.GetHourFromToFormat([Transaction].EndSaleTime, 1) = pplCount.Houre AND dbo.GetDay([Transaction].EndSaleTime) = pplCount.Day
			WHERE     (dbo.[Transaction].TransactionType = 0) AND (dbo.[Transaction].Status > 0) AND 
			(Dbo.GetDay(EndSaleTime)>=@FromDate AND Dbo.GetDay(EndSaleTime)<=@Todate)AND [Transaction].StoreID =@StoreID
			GROUP BY dbo.FormatDateTime(dbo.[Transaction].EndSaleTime, 'SHORTDATE'),dbo.GetHourFromToFormat(dbo.[Transaction].EndSaleTime,1),
			[Transaction].StoreID,StoreName, DATENAME(WEEKDAY, dbo.[Transaction].EndSaleTime), dbo.GetHourFromToFormat(dbo.[Transaction].EndSaleTime, 1) 
			ORDER BY OrderCol		
		END  	
	END
	end
	
		ELSE		BEGIN  --Total
		SELECT     StoreName,  dbo.GetHourFromToFormat(OrderCol, 1) AS Hour, 
		SUM(Debit) AS Debit, SUM(Credit) AS Credit, SUM(Balance) AS Balance, SUM(CountTransaction) 
		AS CountTransaction, SUM(Registers) AS Registers, SUM(SalePrec) AS SalePrec, SUM(Customers) AS Customers, SUM(TransactionWithCustomer) 
		AS TransactionWithCustomer, SUM(CustomerPrec) AS CustomerPrec, SUM(CustomerDebit) AS CustomerDebit, SUM(Items) AS Items
		FROM         DailyHourSales
		WHERE    (OrderCol >= Dbo.FormatDateTime(@FromDate,'SHORTDATE') AND OrderCol <= Dbo.FormatDateTime(@ToDate,'SHORTDATE'))
		and (@StoreID=StoreID or @StoreID is null)
		GROUP BY StoreName, dbo.GetHourFromToFormat(OrderCol, 1)
	END
END
GO