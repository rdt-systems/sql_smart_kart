SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[DiscountItemView]
AS
SELECT        dbo.ItemMain.Name, dbo.ItemMain.ModalNumber, dbo.DiscountItem.*, dbo.ItemMain.BarcodeNumber AS UPC
FROM            dbo.DiscountItem INNER JOIN
                         dbo.ItemMain ON dbo.DiscountItem.ItemID = dbo.ItemMain.ItemID
						 Where dbo.DiscountItem.Status >-1
GO