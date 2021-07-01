SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[FixBalanceView]
AS
SELECT     dbo.Customer.CustomerID, ISNULL(D0.Debit0, 0) AS Debit0, ISNULL(D30.Debit30, 0) AS Debit30, ISNULL(D60.Debit60, 0) AS Debit60, 
                      ISNULL(D90.Debit90, 0) AS Debit90, ISNULL(D120.Debit120, 0) AS Debit120, ISNULL(dbo.Customer.BalanceDoe,0) AS Balance, ISNULL(Credit.Sum_Credit, 0) 
                      AS Credit
FROM         dbo.Customer WITH (NOLOCK) LEFT OUTER JOIN
                          (SELECT     SUM(Credit) AS Sum_Credit, CustomerID
                            FROM          dbo.[Transaction] AS Transaction_5 WITH (NOLOCK)
                            WHERE      (Status > 0)
                            GROUP BY CustomerID) AS Credit ON dbo.Customer.CustomerID = Credit.CustomerID LEFT OUTER JOIN
                          (SELECT     SUM(Debit) AS Debit120, CustomerID
                            FROM          dbo.[Transaction] WITH (NOLOCK)
                            WHERE      (StartSaleTime < dbo.GetLocalDATE() - 120) AND (Status > 0)
                            GROUP BY CustomerID) AS D120 ON dbo.Customer.CustomerID = D120.CustomerID LEFT OUTER JOIN
                          (SELECT     SUM(Debit) AS Debit60, CustomerID
                            FROM          dbo.[Transaction] AS Transaction_3 WITH (NOLOCK)
                            WHERE      (StartSaleTime < dbo.GetLocalDATE() - 60) AND (StartSaleTime >= dbo.GetLocalDATE() - 90) AND (Status > 0)
                            GROUP BY CustomerID) AS D60 ON dbo.Customer.CustomerID = D60.CustomerID LEFT OUTER JOIN
                          (SELECT     SUM(Debit) AS Debit90, CustomerID
                            FROM          dbo.[Transaction] AS Transaction_4 WITH (NOLOCK)
                            WHERE      (StartSaleTime < dbo.GetLocalDATE() - 90) AND (StartSaleTime >= dbo.GetLocalDATE() - 120) AND (Status > 0)
                            GROUP BY CustomerID) AS D90 ON dbo.Customer.CustomerID = D90.CustomerID LEFT OUTER JOIN
                          (SELECT     SUM(Debit) AS Debit30, CustomerID
                            FROM          dbo.[Transaction] AS Transaction_2 WITH (NOLOCK)
                            WHERE      (StartSaleTime < dbo.GetLocalDATE() - 30) AND (StartSaleTime >= dbo.GetLocalDATE() - 60) AND (Status > 0)
                            GROUP BY CustomerID) AS D30 ON dbo.Customer.CustomerID = D30.CustomerID LEFT OUTER JOIN
                          (SELECT     SUM(Debit) AS Debit0, CustomerID
                            FROM          dbo.[Transaction] AS Transaction_1 WITH (NOLOCK)
                            WHERE      (StartSaleTime >= dbo.GetLocalDATE() - 30) AND (Status > 0)
                            GROUP BY CustomerID) AS D0 ON dbo.Customer.CustomerID = D0.CustomerID
GO