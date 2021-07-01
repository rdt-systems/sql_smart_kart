SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetMixMatchItems]
(@MixMatchID uniqueidentifier)
as
	/*AND (ItemStoreNO IS NOT NULL)*/
SELECT     ItemMain.Name, ItemMain.BarcodeNumber, ItemMain.ModalNumber, ItemStore.Price
FROM         MixAndMatch INNER JOIN
                      ItemStore ON MixAndMatch.MixAndMatchID = ItemStore.MixAndMatchID INNER JOIN
                      ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
WHERE     (ItemStore.Status > 0) AND (MixAndMatch.MixAndMatchID = @MixMatchID)
GO