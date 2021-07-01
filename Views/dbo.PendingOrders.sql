SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PendingOrders]

AS


SELECT     DISTINCT   T.CustomerID, C.CustomerNo, C.LastName, C.FirstName, T.TransactionID, T.TransactionNo, E.Qty, T.Debit AS TotalSale, CASE WHEN ISNULL(RE.Qty, 0) > 0 AND ISNULL(ER.Qty, 0) > 0 AND ISNULL(R.Qty, 0) > 0 AND 
                         E.Qty = R.Qty AND R.Qty = ER.Qty AND ER.Qty = RE.Qty THEN 'Ready' WHEN R.RequestTransferEntryID IS NULL THEN 'Pending' WHEN ISNULL(RE.Qty, 0) = 0 AND ISNULL(ER.Qty, 0) = 0 AND ISNULL(R.Qty, 0) > 0 AND 
                         E.Qty = R.Qty THEN 'Pending Fulfillment'  WHEN ISNULL(RE.Qty, 0) = 0 AND ISNULL(ER.Qty, 0) < ISNULL(R.Qty, 0)  AND ISNULL(R.Qty, 0) > 0 AND
                         E.Qty = R.Qty THEN 'Partially Fulfilled'  WHEN ISNULL(RE.Qty, 0) = 0 AND ISNULL(ER.Qty, 0) > 0 AND ISNULL(R.Qty, 0) > 0 AND E.Qty = R.Qty AND R.Qty = ER.Qty THEN 'In Transit' END AS Status,
						 ST.StoreName AS FromStore, T.EndSaleTime AS SaleDate, T.StoreID, 
						 ISNULL(C.LastName, '') + ISNULL(', ' + CASE WHEN C.FirstName = '' THEN NULL 
                         ELSE C.FirstName END, ' ') AS FullName, A.PhoneNumber1, A.PhoneNumber2,TI.TransferNo
FROM            dbo.ReceiveTransferEntry AS RE WITH (NOLOCK) INNER JOIN
                         dbo.ReceiveTransfer AS RT WITH (NOLOCK)  ON RE.ReceiveTransferID = RT.ReceiveTransferID AND RE.Status > 0 AND RT.Status > 0 RIGHT OUTER JOIN
                         dbo.TransferItems AS TI WITH (NOLOCK)  INNER JOIN
                         dbo.TransferEntry AS ER WITH (NOLOCK)  ON TI.TransferID = ER.TransferID ON RE.TransferEntryID = ER.TransferEntryID AND TI.Status > 0 AND ER.Status > 0 RIGHT OUTER JOIN
                         dbo.TransactionEntry AS E WITH (NOLOCK)  INNER JOIN
                         dbo.[Transaction] AS T WITH (NOLOCK)  ON E.TransactionID = T.TransactionID INNER JOIN
                         dbo.Customer AS C WITH (NOLOCK)  ON T.CustomerID = C.CustomerID INNER JOIN
						 dbo.CustomerAddresses AS  A WITH (NOLOCK) ON C.CustomerID = A.CustomerID AND C.MainAddressID = A.CustomerAddressID LEFT OUTER JOIN
                         dbo.RequestTransfer AS Q WITH (NOLOCK)  INNER JOIN
                         dbo.RequestTransferEntry AS R WITH (NOLOCK)  ON Q.RequestTransferID = R.RequestTransferID AND Q.Status > 0 AND R.Status > 0 ON E.TransactionEntryID = R.TransactionEntryID ON 
                         ER.RequestTransferEntryID = R.RequestTransferEntryID LEFT OUTER JOIN Store ST ON Q.FromStoreID = ST.StoreID
WHERE        (T.Status > 0) AND (E.Status > 0) AND (E.TransactionEntryType = 11)
GO