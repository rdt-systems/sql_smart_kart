SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionEntryItem](@ItemStoreID uniqueidentifier)
AS SELECT     dbo.[Transaction].TransactionNo, dbo.[Transaction].TransactionType, dbo.[Transaction].TransactionID, dbo.[Transaction].StartSaleTime, 
                      dbo.TransactionEntryView.ItemStoreID, dbo.TransactionEntryView.Qty, dbo.TransactionEntryView.Total, 
	         (dbo.TransactionEntryView.UOMPrice/IsNull(TransactionEntryView.Qty,1)*IsNull(TransactionEntryView.UOMQty,1))as Price,
                      dbo.TransactionEntryView.Status
FROM         dbo.[Transaction] INNER JOIN
                      dbo.TransactionEntryView ON dbo.[Transaction].TransactionID = dbo.TransactionEntryView.TransactionID
WHERE     (dbo.[Transaction].TransactionType = 0) AND (dbo.TransactionEntryView.ItemStoreID = @ItemStoreID)
GO