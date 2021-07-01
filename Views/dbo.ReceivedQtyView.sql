SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  VIEW [dbo].[ReceivedQtyView]
AS
SELECT     dbo.ReceiveEntry.Qty, dbo.PurchaseOrderEntry.ItemNo
FROM         dbo.ReceiveEntry INNER JOIN
                      dbo.PurchaseOrderEntry ON dbo.ReceiveEntry.PurchaseOrderEntryNo = dbo.PurchaseOrderEntry.PurchaseOrderEntryId
WHERE     (dbo.ReceiveEntry.Status = 1) AND (dbo.PurchaseOrderEntry.Status = 1)
GO