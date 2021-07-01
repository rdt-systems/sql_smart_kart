SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Moshe Freund>
-- Create date: <1/29/2015>
-- Description:	<Update Items OnTransfer>
-- =============================================
CREATE PROCEDURE [dbo].[SP_OnTransferUpdateOneItem](@ItemStoreID Uniqueidentifier)

AS
BEGIN
 
 declare @ItemID Uniqueidentifier
 declare @StoreID Uniqueidentifier
  select @StoreID=storeNo,@ItemID=Itemno from ItemStore where ItemStoreID =@ItemStoreID
  print @StoreID

UPDATE       ItemStore
SET                ItemStore.OnTransferOrder = SumTransfer.Qty
FROM            ItemStore INNER JOIN
                             (SELECT        ItemID, SUM(Qty-ReceiveQty) AS Qty, ToStoreID
                               FROM            TransferEntryView Where ItemID = @ItemID and ToStoreID=@StoreID and Status >0 AND Status <25
                               GROUP BY ItemID, ToStoreID ) AS SumTransfer ON ItemStore.StoreNo = SumTransfer.ToStoreID 
							   AND ItemStore.ItemNo = SumTransfer.ItemID
							   Where ItemStore.ItemStoreID = @ItemStoreID
END
GO