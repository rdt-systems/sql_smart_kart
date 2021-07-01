SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[SP_GetLastTransactionByItem] 
(@ItemID uniqueidentifier,
 @LastTrans Integer =5)
AS
	SELECT        TOP (@LastTrans)[Transaction].TransactionID, [Transaction].TransactionNo, [Transaction].StartSaleTime AS SaleTime,  TransactionEntry.Qty, [TransactionEntry].Total AS Total
	FROM            [Transaction] INNER JOIN
							 TransactionEntry ON [Transaction].TransactionID = TransactionEntry.TransactionID INNER JOIN
							 ItemStore ON TransactionEntry.ItemStoreID = ItemStore.ItemStoreID
	WHERE        ([Transaction].Status > 0) AND (ItemStore.ItemNo = @ItemID) AND (TransactionEntry.Status > 0)
	ORDER BY SaleTime DESC
GO