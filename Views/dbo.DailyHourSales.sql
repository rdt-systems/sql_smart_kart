SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[DailyHourSales]
AS
SELECT     TOP 100 PERCENT dbo.FormatDateTime(T.StartSaleTime, 'SHORTDATE') AS Date,S.StoreID,StoreName, 
                      /*dbo.GetHourFromToFormat(T.StartSaleTime,1) AS Hour,*/ SUM(T.Debit) AS Debit, 
                      SUM(T.Credit) AS Credit, SUM(T.LeftDebit) AS Balance, COUNT(1) 
                      AS CountTransaction, COUNT(DISTINCT T.RegisterID) AS Registers, 


                      ROUND(SUM(T.Debit)
					   /

					   case  (SELECT     SUM(Debit) AS Expr1
                              FROM         dbo.[Transaction]
                              WHERE     (TransactionType = 0) AND (Status > 0) AND (dbo.FormatDateTime(StartSaleTime, 'SHORTDATE') 
                                                    = dbo.FormatDateTime(T.StartSaleTime, 'SHORTDATE'))) when 0 then 1 else 
													

					    CAST
                          ((SELECT     SUM(Debit) AS Expr1
                              FROM         dbo.[Transaction]
                              WHERE     (TransactionType = 0) AND (Status > 0) AND (dbo.FormatDateTime(StartSaleTime, 'SHORTDATE') 
                                                    = dbo.FormatDateTime(T.StartSaleTime, 'SHORTDATE'))) AS float)
													 end 
													
													 * 100, 2) AS SalePrec, 


                      COUNT(DISTINCT T.CustomerID) AS Customers, COUNT(T.CustomerID) 
                      AS TransactionWithCustomer, COUNT(T.CustomerID) / CAST(COUNT(1) AS float) * 100 AS CustomerPrec,
                          (SELECT     SUM(Debit) AS Expr1
                            FROM          dbo.[Transaction] AS Transaction_1
                            WHERE      (TransactionType = 0) AND (Status > 0) AND (CustomerID IS NOT NULL) AND (dbo.FormatDateTime(StartSaleTime, 'SHORTDATE') 
                                                   = dbo.FormatDateTime(T.StartSaleTime, 'SHORTDATE')) AND (dbo.GetHourFromToFormat(StartSaleTime,1) 
                                                   = dbo.GetHourFromToFormat(T.StartSaleTime,1))) AS CustomerDebit, SUM(a.items) AS Items, 
                      MAX(T.StartSaleTime) AS OrderCol
						
FROM         [Transaction] AS T INNER JOIN Store AS S ON T.StoreID = S.StoreID INNER JOIN
                          (SELECT     TransactionID, SUM(Qty) AS items
                            FROM          dbo.TransactionEntry
                            WHERE      (Status > 0)
                            GROUP BY TransactionID) AS a ON T.TransactionID = a.TransactionID
WHERE     (T.TransactionType = 0) AND (T.Status > 0)
GROUP BY dbo.FormatDateTime(T.StartSaleTime, 'SHORTDATE'), 
                      dbo.GetHourFromToFormat(T.StartSaleTime,1),S.StoreID,StoreName
ORDER BY OrderCol
GO