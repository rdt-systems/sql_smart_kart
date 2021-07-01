SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE View [dbo].[MatrixOnhand]
AS
SELECT       ItemMain.ItemID, ItemMain.Matrix1 AS Color, ItemMain.Matrix2 AS Size, CAST(ItemStore.OnHand as Int) AS OnHand, ItemStore.StoreNo AS StoreID, ItemMain.LinkNo
FROM            ItemStore INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
						 where  ItemMain.status >0
GO