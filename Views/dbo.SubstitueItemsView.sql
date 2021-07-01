SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SubstitueItemsView]
AS
SELECT     dbo.SubstitueItems.*, dbo.ItemStore.StoreNo
FROM         dbo.SubstitueItems INNER JOIN
                      dbo.ItemMain ON dbo.SubstitueItems.ItemNo = dbo.ItemMain.ItemID INNER JOIN
                      dbo.ItemStore ON dbo.ItemMain.ItemID = dbo.ItemStore.ItemNo
GO