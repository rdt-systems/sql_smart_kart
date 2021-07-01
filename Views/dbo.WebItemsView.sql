SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[WebItemsView]
AS
SELECT        I.BarcodeNumber AS UPC, S.Price, S.OnHand
FROM            dbo.ItemMain AS I INNER JOIN
                         dbo.ItemStore AS S ON I.ItemID = S.ItemNo
WHERE        (I.Status > 0) AND (S.Status > 0)
GO