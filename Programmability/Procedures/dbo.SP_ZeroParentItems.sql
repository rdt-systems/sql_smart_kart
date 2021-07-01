SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- Create date: <10/13/2014>
-- Description:	<Make Sure Parent Items Are Zero>
-- =============================================
CREATE PROCEDURE [dbo].[SP_ZeroParentItems] 

AS
BEGIN
UPDATE    AdjustInventory
SET              Status = - 11, AdjustReason = ISNULL(AdjustReason,'') + ' [PARENT ITEM]'
WHERE     (ItemStoreNo IN
                          (SELECT     ItemStore.ItemStoreID
                            FROM          dbo.ItemStore WITH (NOLOCK) INNER JOIN
                                                   dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
                            WHERE      (ItemMain.ItemType = 2) AND (ItemStore.OnHand <> 0)))

UPDATE    TransactionEntry
SET              Status = - 11, Note = ISNULL(Note, '') + ' [PARENT ITEM]'
WHERE     (ItemStoreID IN
                          (SELECT     ItemStore.ItemStoreID
                            FROM          dbo.ItemStore WITH (NOLOCK) INNER JOIN
                                                   dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
                            WHERE      (ItemMain.ItemType = 2) AND (ItemStore.OnHand <> 0)))

UPDATE    ReceiveEntry
SET              Status = - 11, Note = ISNULL(Note, '') + ' [PARENT ITEM]'
WHERE     (ItemStoreNo IN
                          (SELECT     ItemStore.ItemStoreID
                            FROM          dbo.ItemStore WITH (NOLOCK) INNER JOIN
                                                   dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
                            WHERE      (ItemMain.ItemType = 2) AND (ItemStore.OnHand <> 0)))

UPDATE    TransferEntry
SET              Status = - 11, Note = ISNULL(Note, '') + ' [PARENT ITEM]'
WHERE     (ItemStoreNo IN
                          (SELECT     ItemStore.ItemStoreID
                            FROM          dbo.ItemStore WITH (NOLOCK) INNER JOIN
                                                   dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
                            WHERE      (ItemMain.ItemType = 2) AND (ItemStore.OnHand <> 0)))

UPDATE    ReceiveTransferEntry
SET              Status = - 11
WHERE     (ItemStoreID IN
                          (SELECT     ItemStore.ItemStoreID
                            FROM          dbo.ItemStore WITH (NOLOCK) INNER JOIN
                                                   dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
                            WHERE      (ItemMain.ItemType = 2) AND (ItemStore.OnHand <> 0)))

UPDATE    ItemStore
SET              OnHand = 0
                            FROM          dbo.ItemStore WITH (NOLOCK) INNER JOIN
                                                   dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
WHERE     (ItemMain.ItemType = 2) AND (ItemStore.OnHand <> 0)

END
GO