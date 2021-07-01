SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[CODView]
AS

SELECT        C.CustomerNo, C.Name, C.Address, C.CityStateAndZip, C.Phone, CC.SaleDate AS DateOfSale, CC.CODAmount, CC.AmountPaid
FROM            CustomerView AS C INNER JOIN
                             (SELECT        COD.CustomerID, COD.SaleDate, COD.Amount AS CODAmount, CAST(CASE WHEN (SUM(T .Credit) - SUM(T .Debit)) > 0 THEN SUM(T .Credit) - SUM(T .Debit) ELSE 0 END AS money) 
                                                         AS AmountPaid
                               FROM            (SELECT        C.CustomerID, MAX(T.StartSaleTime) AS SaleDate, TE.Amount
                                                         FROM            Customer AS C INNER JOIN
                                                                                   [Transaction] AS T ON C.CustomerID = T.CustomerID AND T.Status > 0 INNER JOIN
                                                                                   TenderEntry AS TE ON T.TransactionID = TE.TransactionID AND TE.Status > 0 INNER JOIN
                                                                                   Tender AS TN ON TE.TenderID = TN.TenderID AND TN.Status > 0
                                                         WHERE        (TN.TenderGroup = 13)
                                                         GROUP BY C.CustomerID, TE.Amount) AS COD INNER JOIN
                                                         [Transaction] AS T ON COD.CustomerID = T.CustomerID AND T.StartSaleTime > COD.SaleDate AND T.Status > 0
                               GROUP BY COD.CustomerID, COD.Amount, COD.SaleDate) AS CC ON C.CustomerID = CC.CustomerID
GO