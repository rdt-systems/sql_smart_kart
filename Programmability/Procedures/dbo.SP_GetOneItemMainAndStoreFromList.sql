SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetOneItemMainAndStoreFromList](@UserID uniqueidentifier)
AS 
SELECT        ItemMainAndStoreView.*
FROM            ItemStoreIDs INNER JOIN
                         ItemMainAndStoreView ON ItemStoreIDs.ItemStoreID = ItemMainAndStoreView.ItemStoreID
WHERE        (ItemStoreIDs.UserID =@UserID )
GO