SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[GetPicturesItem]
(@ItemID uniqueidentifier)
as

SELECT  ItemPicture,
		ItemPicture2,
		ItemPicture3
FROM	dbo.ItemMain
WHERE   ItemID=@ItemID
GO