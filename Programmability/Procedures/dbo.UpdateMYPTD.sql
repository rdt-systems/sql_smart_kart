SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[UpdateMYPTD]
(@StoreID uniqueidentifier)
as
Declare @WeekSDate DateTime
Declare @WeekEDate DateTime
Declare @MonthSDate DateTime
Declare @MonthEDate DateTime
Declare @YearSDate DateTime
Declare @YearEDate DateTime

Declare @LYearSDate DateTime
Declare @LYearEDate DateTime
Declare @2YearSDate DateTime
Declare @2YearEDate DateTime
Declare @3YearSDate DateTime
Declare @3YearEDate DateTime


If (Select OptionValue From SetUpValuesView Where OptionID = 938 And StoreID = @StoreID) =1
Begin

Set  @WeekSDate = (SELECT DATEADD(month, DATEDIFF(month, 0, dbo.GetLocalDATE()), 0 ))
Set  @WeekEDate = dbo.GetDay(dbo.GetLocalDATE())
Set  @MonthSDate = ((SELECT DATEADD(qq, DATEDIFF(qq, 0, dbo.GetLocalDATE()), 0)))
Set  @MonthEDate = dbo.GetDay(dbo.GetLocalDATE())
Set  @YearSDate = (SELECT DATEADD(yy, DATEDIFF(yy,0,dbo.GetLocalDATE()), 0) )
Set  @YearEDate = dbo.GetDay(dbo.GetLocalDATE())



End
Else Begin


Set  @WeekSDate = dbo.GetDay(dbo.GetLocalDATE() -31)
Set  @WeekEDate = dbo.GetDay(dbo.GetLocalDATE() -1)
Set  @MonthSDate = (SELECT        DATEADD(MONTH, -3, dbo.GetLocalDATE() -1))
Set  @MonthEDate = dbo.GetDay(dbo.GetLocalDATE() -1)
Set  @YearSDate = (SELECT        DATEADD(MONTH, -12, dbo.GetLocalDATE() -1))
Set  @YearEDate = dbo.GetDay(dbo.GetLocalDATE() -1)
End


Set  @LYearSDate = (SELECT DATEADD(yy, DATEDIFF(yy,0,dbo.GetLocalDATE())-1, 0) )
Set  @LYearEDate =  DATEADD(yy,1,@LYearSDate)
Set  @2YearSDate = (SELECT DATEADD(yy, DATEDIFF(yy,0,dbo.GetLocalDATE())-2, 0) )
Set  @2YearEDate =  DATEADD(yy,1,@2YearSDate)
Set  @3YearSDate = (SELECT DATEADD(yy, DATEDIFF(yy,0,dbo.GetLocalDATE())-3, 0) )
Set  @3YearEDate =  DATEADD(yy,1,@3YearSDate)

PRINT 'FINISHED SETTING PARAMETERS'

--****MTD****
PRINT 'Started MTD'

SELECT 	 I.ItemStoreID, ISNULL(SUM(ISNULL(E.Qty,0)),0) AS MTDQty, ISNULL(SUM(ISNULL(Total,0)),0) AS MTDDollar  Into #MTD
from dbo.ItemStore AS I WITH (NOLOCK) LEFT OUTER JOIN dbo.TransactionEntry E  WITH (NOLOCK)	 ON I.ItemStoreID = E.ItemStoreID
					 inner join dbo.[Transaction] T WITH (NOLOCK) on E.TransactionID=T.TransactionID
					 where I.Status > 0 AND E.TransactionEntryType<>2 AND E.Status>0 and T.Status>0 and StoreNo=@StoreID AND CAST(T.StartSaleTime as date) >= @WeekSDate 
						  and CAST(T.StartSaleTime as date) <= @WeekEDate
GROUP BY I.ItemStoreID

SELECT 	 I.ItemStoreID, ABS(ISNULL(SUM(ISNULL(E.Qty,0)),0)) AS MTDReturnQty Into #MTDReturn
from dbo.ItemStore AS I WITH (NOLOCK) LEFT OUTER JOIN dbo.TransactionEntry E  WITH (NOLOCK)	 ON I.ItemStoreID = E.ItemStoreID
					 inner join dbo.[Transaction] T WITH (NOLOCK) on E.TransactionID=T.TransactionID
					 where I.Status > 0 AND E.TransactionEntryType=2 AND E.Status>0 and T.Status>0 and StoreNo=@StoreID AND CAST(T.StartSaleTime as date) >= @WeekSDate
						  and CAST(T.StartSaleTime as date) <= @WeekEDate
GROUP BY I.ItemStoreID

Update ItemStore SET MTDQty = 0, MTDDollar = 0, MTDReturnQty = 0, TotalSold = 0

Update ItemStore Set MTDQty = M.MTDQty, MTDDollar = M.MTDDollar
FROM dbo.ItemStore S WITH (NOLOCK)	INNER JOIN #MTD M ON S.ItemStoreID = M.ItemStoreID
Where S.StoreNo = @StoreID

Update ItemStore Set MTDReturnQty = M.MTDReturnQty
FROM dbo.ItemStore S WITH (NOLOCK)	INNER JOIN #MTDReturn M ON S.ItemStoreID = M.ItemStoreID
Where S.StoreNo = @StoreID

DROP TABLE #MTD
DROP TABLE #MTDReturn

PRINT 'Finished MTD'
--***END MTD***

--***PTD***

PRINT 'Started PTD'

SELECT 	 I.ItemStoreID, ISNULL(SUM(ISNULL(E.Qty,0)),0) AS PTDQty, ISNULL(SUM(ISNULL(Total,0)),0) AS PTDDollar  Into #PTD
from dbo.ItemStore AS I WITH (NOLOCK) LEFT OUTER JOIN dbo.TransactionEntry E  WITH (NOLOCK)	 ON I.ItemStoreID = E.ItemStoreID
					 inner join dbo.[Transaction] T WITH (NOLOCK) on E.TransactionID=T.TransactionID
					 where I.Status > 0 AND E.TransactionEntryType<>2 AND E.Status>0 and T.Status>0 and StoreNo=@StoreID AND CAST(T.StartSaleTime as date) >= @MonthSDate 
						  and CAST(T.StartSaleTime as date) <= @MonthEDate
GROUP BY I.ItemStoreID

SELECT 	 I.ItemStoreID, ABS(ISNULL(SUM(ISNULL(E.Qty,0)),0)) AS PTDReturnQty Into #PTDReturn
from dbo.ItemStore AS I WITH (NOLOCK) LEFT OUTER JOIN dbo.TransactionEntry E  WITH (NOLOCK)	 ON I.ItemStoreID = E.ItemStoreID
					 inner join dbo.[Transaction] T WITH (NOLOCK) on E.TransactionID=T.TransactionID
					 where I.Status > 0 AND E.TransactionEntryType=2 AND E.Status>0 and T.Status>0 and StoreNo=@StoreID AND CAST(T.StartSaleTime as date) >= @MonthSDate
						  and CAST(T.StartSaleTime as date) <= @MonthEDate
GROUP BY I.ItemStoreID

Update ItemStore SET PTDQty = 0, PTDDollar = 0, PTDReturnQty = 0

Update ItemStore Set PTDQty = M.PTDQty, PTDDollar = M.PTDDollar
FROM dbo.ItemStore S WITH (NOLOCK)	INNER JOIN #PTD M ON S.ItemStoreID = M.ItemStoreID
Where S.StoreNo = @StoreID

Update ItemStore Set PTDReturnQty = M.PTDReturnQty
FROM dbo.ItemStore S WITH (NOLOCK)	INNER JOIN #PTDReturn M ON S.ItemStoreID = M.ItemStoreID
Where S.StoreNo = @StoreID

DROP TABLE #PTD
DROP TABLE #PTDReturn

PRINT 'Finished PTD'
--***END PTD***


--***YTD***
PRINT 'Started YTD'

SELECT 	 I.ItemStoreID, ISNULL(SUM(ISNULL(E.Qty,0)),0) AS YTDQty, ISNULL(SUM(ISNULL(Total,0)),0) AS YTDDollar  Into #YTD
from dbo.ItemStore AS I WITH (NOLOCK) LEFT OUTER JOIN dbo.TransactionEntry E  WITH (NOLOCK)	 ON I.ItemStoreID = E.ItemStoreID
					 inner join dbo.[Transaction] T WITH (NOLOCK) on E.TransactionID=T.TransactionID
					 where I.Status > 0 AND E.TransactionEntryType<>2 AND E.Status>0 and T.Status>0 and StoreNo=@StoreID AND CAST(T.StartSaleTime as date) >= @YearSDate 
						  and CAST(T.StartSaleTime as date) <= @YearEDate
GROUP BY I.ItemStoreID

SELECT 	 I.ItemStoreID, ABS(ISNULL(SUM(ISNULL(E.Qty,0)),0)) AS YTDReturnQty Into #YTDReturn
from dbo.ItemStore AS I WITH (NOLOCK) LEFT OUTER JOIN dbo.TransactionEntry E  WITH (NOLOCK)	 ON I.ItemStoreID = E.ItemStoreID
					 inner join dbo.[Transaction] T WITH (NOLOCK) on E.TransactionID=T.TransactionID
					 where I.Status > 0 AND E.TransactionEntryType=2 AND E.Status>0 and T.Status>0 and StoreNo=@StoreID AND CAST(T.StartSaleTime as date) >= @YearSDate
						  and CAST(T.StartSaleTime as date) <= @YearEDate
GROUP BY I.ItemStoreID

Update ItemStore SET YTDQty = 0, YTDDollar = 0, YTDReturnQty = 0

Update ItemStore Set YTDQty = M.YTDQty, YTDDollar = M.YTDDollar
FROM dbo.ItemStore S WITH (NOLOCK)	INNER JOIN #YTD M ON S.ItemStoreID = M.ItemStoreID
Where S.StoreNo = @StoreID

Update ItemStore Set YTDReturnQty = M.YTDReturnQty
FROM dbo.ItemStore S WITH (NOLOCK)	INNER JOIN #YTDReturn M ON S.ItemStoreID = M.ItemStoreID
Where S.StoreNo = @StoreID

DROP TABLE #YTD
DROP TABLE #YTDReturn

PRINT 'Finished YTD'

--***END YTD***

-- Update LastSoldDate	   and LastSoldUser

PRINT 'Started Last Sold'

SELECT        E.ItemStoreID, MAX(T.UserCreated) AS Usr, MAX(ISNULL(T.EndSaleTime,T.StartSaleTime)) AS LastSale, SUM(E.Qty) AS SoldQty  INTO #Temp
FROM            dbo.TransactionEntry AS E WITH (NOLOCK) INNER JOIN
                         dbo.[Transaction] AS T WITH (NOLOCK) ON E.TransactionID = T.TransactionID
WHERE        (E.Status > 0) AND (E.TransactionEntryType <> 4) AND (E.TransactionEntryType <> 5) AND (T.Status > 0)
GROUP BY E.ItemStoreID

Update ItemStore Set LastSoldDate = T.LastSale, LastSoldQty = T.SoldQty, LastSoldUser = T.Usr
from ItemStore S WITH (NOLOCK) INNER JOIN #Temp T ON S.ItemStoreID = T.ItemStoreID

DROP TABLE #Temp

PRINT 'Finished Last Sold'

-- Finish

-- ***Update LastReceived***

PRINT 'Started Last Received'

SELECT DISTINCT R.ItemStoreID, MAX(cast(R.ReceivedDate as date)) AS ReceivedDate, MAX(I.UserCreated) AS UserReceived, MAX(I.UOMQty) AS ReceivedQty INTO	#LastReceived
from dbo.ReceiveOrder O WITH (NOLOCK)  INNER JOIN (
SELECT E.ItemStoreNo AS ItemStoreID, MAX(R.ReceiveOrderDate) AS ReceivedDate 
FROM            dbo.ReceiveEntry E WITH (NOLOCK) INNER JOIN
dbo.ReceiveOrder R WITH (NOLOCK)  ON E.ReceiveNo = R.ReceiveID
WHERE       R.StoreID = @StoreID AND (E.Status > 0) AND (R.Status > 0 ) GROUP BY E.ItemStoreNo ) AS R ON O.ReceiveOrderDate = O.ReceiveOrderDate INNER JOIN 
dbo.ReceiveEntry AS I WITH (NOLOCK) ON O.ReceiveID = I.ReceiveNo AND R.ItemStoreID = I.ItemStoreNo
Where O.StoreID = @StoreID AND  O.Status > 0 and I.Status > 0
GROUP BY R.ItemStoreID 

Update ItemStore Set LastReceivedDate = L.ReceivedDate, LastReceivedQty = L.ReceivedQty, LastReceivedUser = L.UserReceived 
From dbo.ItemStore S WITH (NOLOCK) INNER JOIN #LastReceived L ON S.ItemStoreID = L.ItemStoreID
Where S.Status > 0 AND StoreNo = @StoreID

DROP TABLE #LastReceived

PRINT 'Finished Last Received'

--***End LastReceived***

-- ***Update TotalReceived***

PRINT 'Started Total Received'

SELECT DISTINCT E.ItemStoreNo AS ItemStoreID, SUM(E.UOMQty) AS Total INTO	#TotalReceived
FROM            dbo.ReceiveEntry E WITH (NOLOCK) INNER JOIN
dbo.ReceiveOrder R WITH (NOLOCK)  ON E.ReceiveNo = R.ReceiveID
WHERE       R.StoreID = @StoreID AND (E.Status > 0) AND (R.Status > 0 ) GROUP BY E.ItemStoreNo 

Update ItemStore Set TotalReceive = L.Total
From dbo.ItemStore S WITH (NOLOCK) INNER JOIN #TotalReceived L ON S.ItemStoreID = L.ItemStoreID
Where S.Status > 0 AND StoreNo = @StoreID

DROP TABLE #TotalReceived

PRINT 'Finished Total Received'

--***End TotalReceived***

--***TotalSold and TotalProfit***

 PRINT 'Started Total Sold and Profit'

SELECT        E.ItemStoreID, SUM(ISNULL(E.TotalAfterDiscount, E.Total) - ISNULL(E.AVGCost, 0) * ISNULL
                             ((CASE WHEN BARCODETYPE <> 0 THEN E.Qty ELSE (CASE WHEN E.UOMTYPE IS NULL 
                                                          THEN E.UOMQty WHEN E.UOMTYPE = 0 THEN E.UOMQty ELSE E.UOMQty * M.CaseQty END) END), 0))  AS TotalProfit,
                             SUM(ISNULL((CASE WHEN E.UOMTYPE IS NULL THEN E.UOMQty WHEN E.UOMTYPE = 0 THEN E.UOMQty ELSE E.UOMQty * M.CaseQty END),0)) AS TotalSold	 INTO #Sold
FROM            dbo.TransactionEntry AS E WITH (NOLOCK) INNER JOIN
                         dbo.[Transaction] AS T WITH (NOLOCK)  ON E.TransactionID = T.TransactionID INNER JOIN
                         dbo.ItemStore AS S WITH (NOLOCK)  ON E.ItemStoreID = S.ItemStoreID INNER JOIN
                         dbo.ItemMain AS M WITH (NOLOCK)  ON S.ItemNo = M.ItemID
WHERE        (E.Status > 0) AND (E.TransactionEntryType <> 4) AND (E.TransactionEntryType <> 5) AND (T.Status > 0)
AND T.StoreID = @StoreID
GROUP BY E.ItemStoreID

Update ItemStore Set TotalSold = L.TotalSold, TotalProfit = L.TotalProfit 
From dbo.ItemStore S WITH (NOLOCK) INNER JOIN #Sold L ON S.ItemStoreID = L.ItemStoreID
Where S.Status > 0 AND StoreNo = @StoreID

DROP TABLE #Sold

PRINT 'Finished Total Sold and Profit'

--***End TotalSold and TotalProfit***

--***YTD 1 2 3 ***

PRINT 'Started YTD 1 2 3'

SELECT 	 I.ItemStoreID, ISNULL(SUM(ISNULL(E.Qty,0)),0) AS YTDQty1  Into #YTD1
from dbo.ItemStore AS I WITH (NOLOCK) LEFT OUTER JOIN dbo.TransactionEntry E  WITH (NOLOCK)	 ON I.ItemStoreID = E.ItemStoreID
					 inner join dbo.[Transaction] T WITH (NOLOCK) on E.TransactionID=T.TransactionID
					 where I.Status > 0 AND E.TransactionEntryType<>2 AND E.Status>0 and T.Status>0 and StoreNo=@StoreID AND CAST(T.StartSaleTime as date) >= @LYearSDate 
						  and CAST(T.StartSaleTime as date) <= @LYearEDate
GROUP BY I.ItemStoreID
SELECT 	 I.ItemStoreID, ISNULL(SUM(ISNULL(E.Qty,0)),0) AS YTDQty2  Into #YTD2
from dbo.ItemStore AS I WITH (NOLOCK) LEFT OUTER JOIN dbo.TransactionEntry E  WITH (NOLOCK)	 ON I.ItemStoreID = E.ItemStoreID
					 inner join dbo.[Transaction] T WITH (NOLOCK) on E.TransactionID=T.TransactionID
					 where I.Status > 0 AND E.TransactionEntryType<>2 AND E.Status>0 and T.Status>0 and StoreNo=@StoreID AND CAST(T.StartSaleTime as date) >= @2YearSDate 
						  and CAST(T.StartSaleTime as date) <= @2YearEDate
GROUP BY I.ItemStoreID
SELECT 	 I.ItemStoreID, ISNULL(SUM(ISNULL(E.Qty,0)),0) AS YTDQty3  Into #YTD3
from dbo.ItemStore AS I WITH (NOLOCK) LEFT OUTER JOIN dbo.TransactionEntry E  WITH (NOLOCK)	 ON I.ItemStoreID = E.ItemStoreID
					 inner join dbo.[Transaction] T WITH (NOLOCK) on E.TransactionID=T.TransactionID
					 where I.Status > 0 AND E.TransactionEntryType<>2 AND E.Status>0 and T.Status>0 and StoreNo=@StoreID AND CAST(T.StartSaleTime as date) >= @3YearSDate 
						  and CAST(T.StartSaleTime as date) <= @3YearEDate
GROUP BY I.ItemStoreID


Update ItemStore SET YTDQty1 = 0, YTDQty2 = 0, YTDQty3 = 0

Update ItemStore Set YTDQty1 = M.YTDQty1
FROM dbo.ItemStore S WITH (NOLOCK)	INNER JOIN #YTD1 M ON S.ItemStoreID = M.ItemStoreID
Where S.StoreNo = @StoreID
Update ItemStore Set YTDQty2 = M.YTDQty2
FROM dbo.ItemStore S WITH (NOLOCK)	INNER JOIN #YTD2 M ON S.ItemStoreID = M.ItemStoreID
Where S.StoreNo = @StoreID
Update ItemStore Set YTDQty3 = M.YTDQty3
FROM dbo.ItemStore S WITH (NOLOCK)	INNER JOIN #YTD3 M ON S.ItemStoreID = M.ItemStoreID
Where S.StoreNo = @StoreID

DROP TABLE #YTD1
DROP TABLE #YTD2
DROP TABLE #YTD3

PRINT 'Finished YTD 1 2 3'

--***End YTD 1 2 3 ***

PRINT 'Started CustomerSales'

select [Transaction].CustomerID, count(*)as Cont ,sum(debit)as SM,max(dbo.[Transaction].StartSaleTime)as StartSaleTime Into #Cust
from dbo.[Transaction]  WITH (NOLOCK) 
where dbo.[Transaction].Status>0
group by dbo.[Transaction].customerid


Update Customer Set CountSales = L.Cont, SumSales = L.SM, LastSaleDate = L.StartSaleTime
From dbo.Customer C WITH(NOLOCK) INNER JOIN #Cust AS L ON C.CustomerID = L.CustomerID
Where C.Status > 0

PRINT 'Finished CustomerSales'

PRINT 'All Finished'
GO