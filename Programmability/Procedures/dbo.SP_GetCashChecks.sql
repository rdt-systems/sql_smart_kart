SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCashChecks](
	@FromDate dateTime,
	@ToDate dateTime)

AS

SELECT        CASE WHEN ISNULL(Customer.LastName, '') <> '' THEN ISNULL(Customer.LastName, '') + ', ' ELSE '' END + ISNULL(Customer.FirstName, '') AS CustomerName, Customer.CustomerNo, CashCheck.Amount, 
                         Users.UserName, CashCheck.CashCheckID, CashCheck.Date AS CashedCheckDate, Batch.BatchNumber AS BatchNo, Registers.RegisterNo
FROM            CashCheck INNER JOIN
                         Batch ON CashCheck.BatchID = Batch.BatchID INNER JOIN
                         Registers ON Batch.RegisterID = Registers.RegisterID LEFT OUTER JOIN
                         Users ON CashCheck.UserID = Users.UserId LEFT OUTER JOIN
                         Customer ON CashCheck.CustomerID = Customer.CustomerID
WHERE        (CashCheck.Date >= @FromDate) AND (CashCheck.Date < @ToDate +1)
and CashCheck.Status >-1
GO