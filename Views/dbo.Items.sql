SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[Items]
AS
SELECT     TOP 100 PERCENT dbo.ItemMain.BarcodeNumber, dbo.ItemMain.Name, dbo.ItemStore.Price, dbo.ItemStore.StoreNo
FROM         dbo.ItemMain INNER JOIN
                      dbo.ItemStore ON dbo.ItemMain.ItemID = dbo.ItemStore.ItemNo
WHERE     (dbo.ItemMain.Status = 1) AND (dbo.ItemStore.Status = 1)
ORDER BY dbo.ItemMain.BarcodeNumber
GO