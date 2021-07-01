SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <9/10/2015>
-- Description:	<Lock Acounts For Landaus>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LockAccountsForLandaus]

AS
BEGIN



--Lock Acounts Over 14 Days
Print 'Start Lock Acounts Over 14 Days'
UPDATE       Customer
SET                LockAccount = 1, DateModified = dbo.GetLocalDATE()
FROM            Customer LEFT OUTER JOIN
                             (SELECT        Trans.CustomerID, MIN(Trans.StartSaleTime) AS Days
                               FROM            [Transaction] AS Trans LEFT OUTER JOIN
                                                             (SELECT        MAX(StartSaleTime) AS LastDate, CustomerID
                                                               FROM            [Transaction]
                                                               WHERE        (Status > 0) AND (CurrBalance < 0.01)
                                                               GROUP BY CustomerID
                                                               HAVING         (CustomerID IS NOT NULL)) AS LastZeroBalance ON Trans.CustomerID = LastZeroBalance.CustomerID
                               WHERE        (Trans.Status > 0) AND (Trans.StartSaleTime > LastZeroBalance.LastDate)
                               GROUP BY Trans.CustomerID) AS LastClearBalance ON Customer.CustomerID = LastClearBalance.CustomerID
WHERE        (Customer.CustomerID NOT IN
                             (SELECT        CustomerID
                               FROM            CustomerToGroup
                               WHERE        (Status > 0) AND (CustomerGroupID IN
                                                             (SELECT        CustomerGroupID
                                                               FROM            CustomerGroup
                                                               WHERE        (CustomerGroupName IN ('LOCK BY 30', 'LOCK BY 60', 'NO LOCK ACCOUNT')))))) AND (DATEDIFF(D, LastClearBalance.Days, dbo.GetLocalDATE()) > 14) AND (ISNULL(Customer.LockAccount, 0) 
                         <> 1) AND (Customer.BalanceDoe > 0)
Print 'Finish Lock Acounts Over 14 Days'

--Unlock Acounts Under 14 Days
Print 'Start Unlock Acounts Under 14 Days'
UPDATE       Customer
SET                LockAccount = 0, DateModified = dbo.GetLocalDATE()
FROM            Customer LEFT OUTER JOIN
                             (SELECT        Trans.CustomerID, MIN(Trans.StartSaleTime) AS Days
                               FROM            [Transaction] AS Trans LEFT OUTER JOIN
                                                             (SELECT        MAX(StartSaleTime) AS LastDate, CustomerID
                                                               FROM            [Transaction]
                                                               WHERE        (Status > 0) AND (CurrBalance < 0.01)
                                                               GROUP BY CustomerID
                                                               HAVING         (CustomerID IS NOT NULL)) AS LastZeroBalance ON Trans.CustomerID = LastZeroBalance.CustomerID
                               WHERE        (Trans.Status > 0) AND (Trans.StartSaleTime > LastZeroBalance.LastDate)
                               GROUP BY Trans.CustomerID) AS LastClearBalance ON Customer.CustomerID = LastClearBalance.CustomerID
WHERE        (Customer.CustomerID NOT IN
                             (SELECT        CustomerID
                               FROM            CustomerToGroup
                               WHERE        (Status > 0) AND (CustomerGroupID IN
                                                             (SELECT        CustomerGroupID
                                                               FROM            CustomerGroup
                                                               WHERE        (CustomerGroupName IN ('LOCK BY 30', 'LOCK BY 60', 'NO LOCK ACCOUNT')))))) AND (DATEDIFF(D, LastClearBalance.Days, dbo.GetLocalDATE()) <= 14) AND (ISNULL(Customer.LockAccount, 
                         0) <> 0)
Print 'Finish Unlock Acounts Under 14 Days'

--Lock Over 30
Print 'Start UnLock Over 30'
UPDATE       Customer
SET                LockAccount = 0, DateModified = dbo.GetLocalDATE()
WHERE        (LockAccount <> 0) AND (CustomerID IN
                             (SELECT        CustomerID
                               FROM            CustomerToGroup
                               WHERE        (Status > 0) AND (CustomerGroupID IN
                                                             (SELECT        CustomerGroupID
                                                               FROM            CustomerGroup
                                                               WHERE        (CustomerGroupName IN ('LOCK BY 30')))))) AND (Over30 <= 0)
Print 'Finish UnLock Over 30'

Print 'Start Lock Over 30'
UPDATE       Customer
SET                LockAccount = 1, DateModified = dbo.GetLocalDATE()
WHERE        (LockAccount <> 1) AND (CustomerID IN
                             (SELECT        CustomerID
                               FROM            CustomerToGroup
                               WHERE        (Status > 0) AND (CustomerGroupID IN
                                                             (SELECT        CustomerGroupID
                                                               FROM            CustomerGroup
                                                               WHERE        (CustomerGroupName IN ('LOCK BY 30')))))) AND (Over30 > 0)
Print 'Finish Lock Over 30'

--Lock Over 60
Print 'Start UnLock Over 60'
UPDATE       Customer
SET                LockAccount = 0, DateModified = dbo.GetLocalDATE()
WHERE        (LockAccount <> 0) AND (CustomerID IN
                             (SELECT        CustomerID
                               FROM            CustomerToGroup
                               WHERE        (Status > 0) AND (CustomerGroupID IN
                                                             (SELECT        CustomerGroupID
                                                               FROM            CustomerGroup
                                                               WHERE        (CustomerGroupName IN ('LOCK BY 60')))))) AND (Over60 <= 0)
Print 'Finish UnLock Over 60'

Print 'Start Lock Over 60'
UPDATE       Customer
SET                LockAccount = 1, DateModified = dbo.GetLocalDATE()
WHERE        (LockAccount <> 1) AND (CustomerID IN
                             (SELECT        CustomerID
                               FROM            CustomerToGroup
                               WHERE        (Status > 0) AND (CustomerGroupID IN
                                                             (SELECT        CustomerGroupID
                                                               FROM            CustomerGroup
                                                               WHERE        (CustomerGroupName IN ('LOCK BY 60')))))) AND (Over60 > 0)
Print 'Finish Lock Over 60'

--Unlock No Lock Account Group
Print 'Start Unlock No Lock Account Group'
UPDATE       Customer
SET                LockAccount = 0, DateModified = dbo.GetLocalDATE()
WHERE        (LockAccount <> 0) AND (CustomerID IN
                             (SELECT        CustomerID
                               FROM            CustomerToGroup
                               WHERE        (Status > 0) AND (CustomerGroupID IN
                                                             (SELECT        CustomerGroupID
                                                               FROM            CustomerGroup
                                                               WHERE        (CustomerGroupName IN ('NO LOCK ACCOUNT'))))))
Print 'Finish Unlock No Lock Account Group'
END
GO