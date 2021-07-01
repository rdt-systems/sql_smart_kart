SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_GetItemImage](@ItemID uniqueidentifier)
AS 
SELECT     ItemPicture,itemid,itemstoreid,ItemPicture2,ItemPicture3
FROM         dbo.ItemMain inner join dbo.ItemStore 
ON dbo.ItemMain.ItemID=dbo.ItemStore.ItemNo
WHERE     
 dbo.ItemMain.status>0
and


(dbo.ItemStore.ItemStoreID = @ItemID)
GO