SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[InvoicesView]
AS
SELECT    Type, DateT, Num, DueDate, OpenBalance, AmountPay, IDc, PID, Amount, Name, CustomerNo, Status, Debit, Credit, TransactionType, StartSaleTime, 
                      TimeT,StoreID, StoreName,UserCreated,UserName--,CustomerType,CustomerGroupID,PriceLevelID,Zip,DiscountID,TaxExempt
FROM         dbo.TransactionLivesView
WHERE     (TransactionType = 0 OR
                      TransactionType = 2 OR
                      TransactionType = 4) AND (PID IS NULL) OR
                      (TransactionType = 0 OR
                      TransactionType = 2 OR
                      TransactionType = 4) AND (StartSaleTime >= dbo.GetCustomerDateStartBalance(PID))
GO