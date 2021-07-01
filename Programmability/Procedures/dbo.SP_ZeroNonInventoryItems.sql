SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <1/29/2015>
-- Description:	<Zero Servic Items>
-- =============================================
CREATE PROCEDURE [dbo].[SP_ZeroNonInventoryItems] 

AS
BEGIN
Delete From dbo.AdjustInventory where ItemStoreNo in (
SELECT        ItemStore.ItemStoreID
FROM            dbo.ItemStore WITH (NOLOCK) INNER JOIN
                         dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemMain.ItemType IN (3, 5, 7, 9)))

UPDATE       ItemStore
SET                OnHand = 0, DateModified = dbo.GetLocalDATE()
FROM            dbo.ItemStore WITH (NOLOCK) INNER JOIN
                         dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemMain.ItemType IN (3, 5, 7, 9))

END
GO