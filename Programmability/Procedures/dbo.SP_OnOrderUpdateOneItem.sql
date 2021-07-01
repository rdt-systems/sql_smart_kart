SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




-- =============================================
-- Author:		<Moshe Freund>
-- Create date: <1/29/2015>
-- Description:	<Update Items OnOrder>
-- =============================================
CREATE PROCEDURE [dbo].[SP_OnOrderUpdateOneItem](@ItemStoreID Uniqueidentifier)

AS
BEGIN
UPDATE       ItemStore
SET                OnOrder = ISNULL(RecvOrder.OnOrder, 0)
FROM            ItemStore LEFT OUTER JOIN
                             (SELECT        PurchaseOrderEntryView.ItemNo, SUM(PurchaseOrderEntryView.OrderDeficit) AS OnOrder
                               FROM            PurchaseOrderEntryView INNER JOIN
                                                         PurchaseOrdersView ON PurchaseOrderEntryView.PurchaseOrderNo = PurchaseOrdersView.PurchaseOrderId
                               WHERE        (PurchaseOrdersView.POStatus <> 2) AND (PurchaseOrdersView.Status > 0) AND (PurchaseOrderEntryView.Status > 0)
                               GROUP BY PurchaseOrderEntryView.ItemNo) AS RecvOrder ON ItemStore.ItemStoreID = RecvOrder.ItemNo
WHERE        (ItemStore.ItemStoreID = @ItemStoreID)
END
GO