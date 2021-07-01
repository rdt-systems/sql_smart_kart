SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetLayaway](@Filter nvarchar(4000))
AS

DECLARE @MySelect nvarchar(2000)
SET @MySelect ='SELECT     [Transaction].TransactionNo, Store.StoreName, [Transaction].TransactionID,[Transaction].Credit+ IsNull(SumPaid,0) As Paid, [Transaction].Debit, [Transaction].StartSaleTime As SaleDate, 
                      (CASE WHEN TransactionType= 14 THEN ''Layaway''WHEN TransactionType= 15 
                      THEN ''Void layaway'' WHEN TransactionType= 16 THEN ''Close layaway'' END)AS [Type]
                      , IsNull(Customer.LastName,'''')+'' ''+IsNull(Customer.FirstName,'''')As Name,  Customer.CustomerNo, [Transaction].Status, [Transaction].Note
FROM         [Transaction] INNER JOIN
                      Customer ON [Transaction].CustomerID = Customer.CustomerID INNER JOIN
                      Store ON [Transaction].StoreID = Store.StoreID
                      LEFT OUTER JOIN
                          (SELECT     SUM(Amount) AS SumPaid, TransactionPayedID
                            FROM          PaymentDetails
                            GROUP BY TransactionPayedID
                            HAVING      (SUM(DISTINCT Status) > 0)) AS SumPaid ON [Transaction].TransactionID = SumPaid.TransactionPayedID
WHERE  [Transaction].Status >0'
exec (@MySelect+@Filter)
GO