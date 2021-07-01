SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ItemQty]
AS
SELECT     SUM(QtySum) AS TotalQty, ItemID,
                          (SELECT     DateCreated
                            FROM          dbo.itemstore
                            WHERE      itemstoreid = ItemSalesView.itemID AND itemstore.Status > - 1) AS DateCreated
FROM         dbo.ItemSalesView
GROUP BY ItemID
GO