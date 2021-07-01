SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



-- =============================================
-- Author:		<Moshe Freund>
-- Create date: <1/29/2015>
-- Description:	<Update Items OnOrder>
-- =============================================
CREATE PROCEDURE [dbo].[SP_OnOrderUpdate] 

AS
BEGIN
UPDATE       ItemStore
SET                OnOrder = ISNULL(RecvOrder.OnOrder, 0)
FROM            dbo.ItemStore WITH (NOLOCK) LEFT OUTER JOIN
                             (SELECT        PurchaseOrderEntryView.ItemNo, SUM(PurchaseOrderEntryView.OrderDeficit) AS OnOrder
                               FROM            dbo.PurchaseOrderEntryView WITH (NOLOCK) INNER JOIN
                                                         PurchaseOrdersView ON PurchaseOrderEntryView.PurchaseOrderNo = PurchaseOrdersView.PurchaseOrderId
                               WHERE        (PurchaseOrdersView.POStatus <> 2) AND (PurchaseOrdersView.Status > 0) AND (PurchaseOrderEntryView.Status > 0)
                               GROUP BY PurchaseOrderEntryView.ItemNo) AS RecvOrder ON ItemStore.ItemStoreID = RecvOrder.ItemNo
WHERE        (ItemStore.ItemNo IN
                             (SELECT        ItemID
                               FROM           dbo.ItemMain WITH (NOLOCK)
                               WHERE        (ItemType <> 3) AND (ItemType <> 5) AND (ItemType <> 7) AND (ItemType <> 9)))
END

UPDATE       ItemStore
SET                OnOrder = 0
FROM            dbo.ItemStore WITH (NOLOCK) INNER JOIN
                         dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemMain.ItemType = 2) And ItemStore.OnOrder <> 0
GO