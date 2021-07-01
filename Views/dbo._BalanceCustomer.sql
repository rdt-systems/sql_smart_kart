SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE      VIEW [dbo].[_BalanceCustomer]
AS
SELECT     CustomerID, CustomerNo AS Name, ISNULL
                          ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS Debit, ISNULL
                          ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.StartSaleTime > DATEADD(day, - 30, dbo.GetLocalDATE()) AND LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS Till30, 
                      ISNULL
                          ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.StartSaleTime <= DATEADD(day, - 30, dbo.GetLocalDATE()) AND LeftDebitsView.StartSaleTime > DATEADD(day, - 60, dbo.GetLocalDATE()) 
                                                    AND LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS From30, ISNULL
                          ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.StartSaleTime <= DATEADD(day, - 60, dbo.GetLocalDATE()) AND LeftDebitsView.StartSaleTime > DATEADD(day, - 90, dbo.GetLocalDATE()) 
                                                    AND LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS From60, ISNULL
                          ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.StartSaleTime <= DATEADD(day, - 90, dbo.GetLocalDATE()) AND LeftDebitsView.StartSaleTime > DATEADD(day, - 120, dbo.GetLocalDATE()) 
                                                    AND LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS From90, ISNULL
                          ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.StartSaleTime <= DATEADD(day, - 120, dbo.GetLocalDATE()) AND LeftDebitsView.CustomerID = Customer.CustomerID), 0) 
                      AS From120
FROM         dbo.Customer
WHERE     (Status > - 1)
GO