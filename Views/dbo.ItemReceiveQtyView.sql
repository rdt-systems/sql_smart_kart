SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  VIEW [dbo].[ItemReceiveQtyView]
AS
SELECT     SUM(dbo.ReceiveEntry.Qty) AS QtySum, dbo.ReceiveEntry.ItemStoreNo
FROM         dbo.ReceiveEntry INNER JOIN
                      dbo.ReceiveOrder ON dbo.ReceiveEntry.ReceiveNo = dbo.ReceiveOrder.ReceiveID
GROUP BY dbo.ReceiveEntry.ItemStoreNo
GO