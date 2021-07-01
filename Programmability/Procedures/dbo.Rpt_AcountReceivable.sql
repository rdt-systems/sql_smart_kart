SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_AcountReceivable] 
(@FromDate datetime,
@ToDate datetime,
@StoreID uniqueidentifier =null)
AS

SELECT     ISNULL(CustomerView.LastName, '') + ' ' + ISNULL(CustomerView.FirstName, '') AS Name, CustomerView.BalanceDoe, CustomerView.FirstName, 
                      CustomerView.CustomerID, CustomerView.CustomerNo, CustomerView.LastName, CustomerView.Address, CustomerView.Phone, [Transaction].TransactionNo, 
                      [Transaction].Debit AS Sale, [Transaction].Credit AS AmountPayments, Actions.ActionID, Actions.BatchID, Users.UserName, Actions.ActionSum AS AmountSales, 
                      [Transaction].EndSaleTime AS SaleTime
FROM         Actions INNER JOIN
                      [Transaction] ON Actions.TransactionID = [Transaction].TransactionID LEFT OUTER JOIN
                      CustomerView ON [Transaction].CustomerID = CustomerView.CustomerID LEFT OUTER JOIN
                      Users ON Actions.UserID = Users.UserId
WHERE     (Actions.ActionType = 17) AND (dbo.GetDay([Transaction].StartSaleTime) >= @FromDate) AND (dbo.GetDay([Transaction].StartSaleTime) <= @ToDate) AND ([Transaction].StoreID = @StoreID OR
                      @StoreID IS NULL)
GO