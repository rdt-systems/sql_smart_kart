SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[LocalTransaction]
AS
SELECT        [Transaction].Status, [Transaction].TransactionID, [Transaction].Credit AS SaleAmount, [Transaction].Debit AS PaidAmount, [Transaction].Tax, [Transaction].TransactionNo, [Transaction].ShipTo, [Transaction].StartSaleTime, 
                         Registers.RegisterNo, [Transaction].EndSaleTime, [Transaction].CustomerID, ISNULL(Customer.LastName, '') + ' ' + ISNULL(Customer.FirstName, '') AS CustomerName, Customer.CustomerNo, Users.UserName AS CashierName,
                          [Transaction].TransactionType, TotalQty.TotalQty,  
						  CONVERT(nvarchar(500), STUFF((SELECT ','+ cast(T.TenderName as varchar(30))+' $'+CAST(CONVERT(DECIMAL(30,2),Sum(E.Amount)) AS varchar(20))
	   FROM Tender AS T INNER JOIN TenderEntry AS E ON T.TenderID = E.TenderID 
	   WHERE E.TransactionID = [Transaction].TransactionID And  (E.Status > 0) 
	   GROUP BY E.TenderID, E.TransactionID,T.TenderName FOR xml PATH ('')), 1, 1, '')) AS Tender,
	   CONVERT(nvarchar(500), STUFF((SELECT ','+ E.Common1 FROM TenderEntry AS E WHERE E.TransactionID = [Transaction].TransactionID And  (E.Status > 0) GROUP BY E.TenderID, E.TransactionID, E.Common1 FOR xml PATH ('')), 1, 1, '')) AS CheckNoOrCC,
	   ISNULL([Transaction].DateModified, [Transaction].DateCreated) AS DateModified, CASE WHEN ISNULL(Returns.TotalReturn, 0) = 0 THEN 0 WHEN ISNULL(Returns.TotalReturn, 
                         0) < ISNULL(Returns.TotalSale, 0) THEN 2 ELSE 1 END AS Returned, [Transaction].StoreID
FROM            [Transaction] LEFT OUTER JOIN
                             (SELECT        TransactionID, SUM(Qty) AS TotalQty
                               FROM            TotalQtyView
                               GROUP BY TransactionID) AS TotalQty ON [Transaction].TransactionID = TotalQty.TransactionID LEFT OUTER JOIN
                         Customer ON [Transaction].CustomerID = Customer.CustomerID LEFT OUTER JOIN
                         Registers ON [Transaction].RegisterID = Registers.RegisterID LEFT OUTER JOIN
                         Users ON [Transaction].UserCreated = Users.UserId LEFT OUTER JOIN
                             (SELECT TransactionID, SUM(ISNULL(Qty,0)) AS TotalSale , SUM(ISNULL(ReturnedQty,0)) AS TotalReturn From ReturnedQtyView
GROUP BY TransactionID) AS [Returns] ON [Transaction].TransactionID = [Returns].TransactionID
WHERE        ([Transaction].Status > 0) AND (DATEDIFF(DAY, [Transaction].StartSaleTime, dbo.GetLocalDate()) < 60)
GO