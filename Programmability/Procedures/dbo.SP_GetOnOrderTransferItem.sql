SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOnOrderTransferItem]
(@ItemID uniqueidentifier,
@ShowClose int,
@StoreID uniqueidentifier)
AS

    SELECT  dbo.TransferOrder.TransferOrderID,
		    dbo.TransferOrder.TransferOrderDate,
		    dbo.TransferOrder.TransferOrderNo, 
		    dbo.TransferOrderEntry.Qty,
			dbo.Store.StoreName as Store

	FROM        dbo.TransferOrder 
		    INNER JOIN
                    dbo.TransferOrderEntry ON dbo.TransferOrder.TransferOrderID = dbo.TransferOrderEntry.TransferOrderID
		    INNER JOIN
                    dbo.Store ON dbo.TransferOrder.FromStoreID = dbo.Store.StoreID
	WHERE TransferOrder.Status>0 And
		  TransferOrder.ToStoreID=@StoreID AND
		  TransferOrderEntry.Status>0 And 
		  TransferOrderEntry.ItemStoreNo=@ItemID
GO