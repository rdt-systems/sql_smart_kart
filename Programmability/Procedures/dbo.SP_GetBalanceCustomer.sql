SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetBalanceCustomer]
(@asDate datetime = NULL)
AS

-- Add by Nathan 6/6/2010
--IF @asDate IS NULL BEGIN


SELECT  C.CustomerID, C.CustomerNo, C.Name, C.BalanceDoe AS Debit,C.PhoneNumber1,C.PhoneNumber2,C.Email,
--120 
--CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END AS From120,
----90
--CASE WHEN ISNULL(D90.Debit90,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D90.Debit90,0) >= (ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END)) THEN 
--ISNULL(D90.Debit90,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END ) ELSE 0 END ELSE 0 END AS From90,
----60
--CASE WHEN ISNULL(D60.Debit60,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D60.Debit60,0) >= (ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D90.Debit90,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D90.Debit90,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D90.Debit90,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END)) THEN 
--ISNULL(D60.Debit60,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D90.Debit90,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D90.Debit90,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D90.Debit90,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END AS From60,
----30
--CASE WHEN ISNULL(D30.Debit30,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D30.Debit30,0) >= (ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D60.Debit60,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D60.Debit60,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D60.Debit60,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D90.Debit90,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D90.Debit90,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D90.Debit90,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END)) THEN 
--ISNULL(D30.Debit30,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D60.Debit60,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D60.Debit60,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D60.Debit60,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D90.Debit90,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D90.Debit90,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D90.Debit90,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END AS From30, 
----Till 30
--Case WHEN ISNULL(Balance.Balance,0) >0 AND ISNULL(Balance.Balance,0) > = (CASE WHEN ISNULL(D30.Debit30,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D30.Debit30,0) >= (ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D60.Debit60,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D60.Debit60,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D60.Debit60,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D90.Debit90,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D90.Debit90,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D90.Debit90,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END)) THEN 
--ISNULL(D30.Debit30,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D60.Debit60,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D60.Debit60,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D60.Debit60,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D90.Debit90,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D90.Debit90,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D90.Debit90,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) THEN ISNULL(Balance.Balance,0) - CASE WHEN ISNULL(D30.Debit30,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D30.Debit30,0) >= (ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D60.Debit60,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D60.Debit60,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D60.Debit60,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D90.Debit90,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D90.Debit90,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D90.Debit90,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END)) THEN 
--ISNULL(D30.Debit30,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D60.Debit60,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D60.Debit60,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D60.Debit60,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D90.Debit90,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D90.Debit90,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D90.Debit90,0) - ISNULL(Balance.Credit,0) - (CASE WHEN ISNULL(D120.Debit120,0) >0 AND ISNULL(Balance.Credit,0) > 0 THEN CASE WHEN ISNULL(D120.Debit120,0) >= ISNULL(Balance.Credit,0) THEN 
--ISNULL(D120.Debit120,0) - ISNULL(Balance.Credit,0) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END) ELSE 0 END ELSE 0 END ELSE 0 END AS Till30

--Modified by Alex
--5/30/2016
--120 
ISNULL(C.Over120,0) AS From120,
--90
ISNULL(C.Over90,0) AS From90,
--60
ISNULL(C.Over60,0) AS From60,
--30
ISNULL(C.Over30,0) AS From30, 
--Till 30
ISNULL(C.Over0,0) AS Till30,
case when c.BalanceDoe<0 then c.BalanceDoe  else 0 end as credit

From CustomerWithAddressView AS C --INNER JOIN
--(SELECT        CustomerID, SUM(Debit - Credit) AS Balance, Sum(Credit) AS Credit
--FROM            [Transaction]
--WHERE        (CustomerID IS NOT NULL) AND (Status > 0) AND (dbo.GetDay(StartSaleTime) <= @asDate)
--Group By CustomerID) AS Balance On C.CustomerID = Balance.CustomerID LEFT OUTER JOIN
--                          (SELECT    case when SUM(Debit)>SUM(Credit) then SUM(Debit)-SUM(Credit) else 0 end AS Debit120, CustomerID
--                            FROM          dbo.[Transaction]
--                            WHERE      (StartSaleTime < =@asDate - 120) AND (Status > 0)
--                            GROUP BY CustomerID) AS D120 ON C.CustomerID = D120.CustomerID LEFT OUTER JOIN
--                          (SELECT    case when SUM(Debit)>SUM(Credit) then SUM(Debit)-SUM(Credit) else 0 end AS Debit60, CustomerID
--                            FROM          dbo.[Transaction] AS Transaction_3
--                            WHERE      (StartSaleTime < =@asDate - 60) AND (StartSaleTime >= @asDate - 90) AND (Status > 0)
--                            GROUP BY CustomerID) AS D60 ON C.CustomerID = D60.CustomerID LEFT OUTER JOIN
--                          (SELECT     case when SUM(Debit)>SUM(Credit) then SUM(Debit)-SUM(Credit) else 0 end AS Debit90, CustomerID
--                            FROM          dbo.[Transaction] AS Transaction_4
--                            WHERE      (StartSaleTime < =@asDate - 90) AND (StartSaleTime >= @asDate - 120) AND (Status > 0)
--                            GROUP BY CustomerID) AS D90 ON C.CustomerID = D90.CustomerID LEFT OUTER JOIN
--                          (SELECT     case when SUM(Debit)>SUM(Credit) then SUM(Debit)-SUM(Credit) else 0 end AS Debit30, CustomerID
--                            FROM          dbo.[Transaction] AS Transaction_2
--                            WHERE      (StartSaleTime < =@asDate - 30) AND (StartSaleTime >= @asDate - 60) AND (Status > 0)
--                            GROUP BY CustomerID) AS D30 ON C.CustomerID = D30.CustomerID LEFT OUTER JOIN
--                          (SELECT     case when SUM(Debit)>SUM(Credit) then SUM(Debit)-SUM(Credit) else 0 end AS Debit0, CustomerID
--                            FROM          dbo.[Transaction] AS Transaction_1
--                            WHERE      (StartSaleTime >= @asDate - 30) AND (Status > 0)
--                            GROUP BY CustomerID) AS D0 ON C.CustomerID = D0.CustomerID
							Where C.Status >0

/*
(SELECT        TR.CurrBalance AS Bal, TR.CustomerID
FROM            [Transaction] AS TR INNER JOIN
                             (SELECT        CustomerID, MAX(StartSaleTime) AS D
                               FROM            [Transaction] AS T
                               WHERE        (dbo.GetDay(StartSaleTime) >= @asDate - 30) AND (dbo.GetDay(StartSaleTime) <= @asDate) AND (Status > 0) AND (TransactionType = 0)
                               GROUP BY CustomerID) AS T1 ON TR.CustomerID = T1.CustomerID AND TR.StartSaleTime = T1.D)*/

	--SELECT     CustomerID, CustomerNo,ISNULL(dbo.Customer.LastName,'') + ISNULL(', '+dbo.Customer.FirstName,'')  AS Name, BalanceDoe As Debit, 
	--Over0 As Till30, Over30 as From30, Over60 as From60, Over90 as From90, Over120 as From120
	--FROM         Customer
	--where status>0 and BalanceDoe>0 
--END
--ELSE BEGIN 
---- And Add By Nathan
--
--	SELECT   customerID ,dbo.GetAgingDiff(IsNull(duedate,StartSaleTime),@asDate) AS MonthDif,  SUM(isnull(LeftDebit,debit)) AS DebitByDays
--	INTO #MyTemp
--	FROM  [transaction]
--	where (transactionType=0 or TransactionType=2  or TransactionType=4) and LeftDebit>0 and status>0 And StartSaleTime>=dbo.GetCustomerDateStartBalance([Transaction].CustomerID)
--	group by customerID,dbo.GetAgingDiff(IsNull(duedate,StartSaleTime),@asDate) having SUM(isnull(LeftDebit,debit))>0
--
--	select CustomerID,ISNULL(dbo.Customer.LastName,'') + ISNULL(', '+dbo.Customer.FirstName,'')  AS Name,Status,CustomerNo
--			,isnull((select sum(DebitByDays) from #MyTemp where CUSTOMERID=CUSTOMER.CUSTOMERID ),0)	as debit
--			,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=-1 AND CUSTOMERID=CUSTOMER.CUSTOMERID),0) as Currentc
--			,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=0 AND CUSTOMERID=CUSTOMER.CUSTOMERID),0) as Till30
--			,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=1 AND CUSTOMERID=CUSTOMER.CUSTOMERID),0) as From30
--			,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=2 AND CUSTOMERID=CUSTOMER.CUSTOMERID),0) as From60
--			,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=3 AND CUSTOMERID=CUSTOMER.CUSTOMERID),0) as From90
--			,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=4 AND CUSTOMERID=CUSTOMER.CUSTOMERID),0) as From120,
--			isnull(StartBalance,0)StartBalance
--	FROM --CustomerView 
--	CUSTOMER where status>0 and --isnull((select sum(leftdebit) from [transaction] where (transactiontype=0 or transactiontype=2  or TransactionType=4) and leftdebit>0 and status>0-- and startsaletime<dateadd(day,1,convert(varchar,@asDate,111)) 
--					 isnull((select sum(DebitByDays) from #MyTemp 
--						where CUSTOMERID=CUSTOMER.CUSTOMERID ),0)<>0           
--	drop TABLE #MyTemp
--
--END
GO