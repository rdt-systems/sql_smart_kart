SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomerBalanceByDate]
(@asDate datetime = NULL)
AS
SELECT isnull([Transaction].CurrBalance,0)as CurrBalance, LastBalance.CustomerID, LastBalance.StartSaleTime, Customer.CustomerNo, Customer.FirstName, Customer.LastName
FROM [Transaction] INNER JOIN
                             (SELECT CustomerID, MAX(StartSaleTime) AS StartSaleTime
                               FROM [Transaction] AS Transaction_1
                               WHERE (dbo.GetDay(StartSaleTime) <= @asDate) AND (Status > 0)
                               GROUP BY CustomerID) AS LastBalance ON [Transaction].CustomerID = LastBalance.CustomerID AND [Transaction].StartSaleTime = LastBalance.StartSaleTime INNER JOIN
                         Customer ON [Transaction].CustomerID = Customer.CustomerID
GO