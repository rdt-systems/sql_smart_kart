SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[ItemsLastTansactionView]
AS
	SELECT F.*, ISNULL(C.FirstName,'')+' '+ISNULL(C.LastName,'') AS NAME,CONVERT(varchar(100), Cast(Number as decimal(38, 0)))+F.BarcodeNumber AS ID,I.DateModified,1 AS Status FROM(
	SELECT      ROW_NUMBER() OVER (PARTITION BY ItemID
		  ORDER BY StartSaleTime desc,ItemID  ) AS Number,  [Transaction].CustomerID, TransactionEntry.UOMPrice AS Price, TransactionEntry.UOMQty AS Qty, [Transaction].StartSaleTime, [Transaction].TransactionNo, ItemMain.ItemID, ItemMain.BarcodeNumber, 
                         [Transaction].TransactionID
FROM            dbo.ItemMain INNER JOIN
                         dbo.ItemStore ON ItemMain.ItemID = ItemStore.ItemNo INNER JOIN
                         dbo.TransactionEntry WITH (NOLOCK) ON ItemStore.ItemStoreID = TransactionEntry.ItemStoreID INNER JOIN
                         dbo.[Transaction] WITH (NOLOCK)  ON TransactionEntry.TransactionID = [Transaction].TransactionID
WHERE        ([Transaction].Status > 0) AND (TransactionEntry.Status > 0)) AS F LEFT JOIN
							 dbo.Customer AS C ON F.CustomerID = C.CustomerID
	INNER JOIN
	  (SELECT        ItemNo, MAX(DateModified) AS DateModified
FROM            dbo.ItemStore
WHERE        (Status > 0)
GROUP BY ItemNo) AS I ON F.ItemID = I.ItemNo
	WHERE Number <6
GO