SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetItemMainAndStoreRow]
(
@ItemStoreID uniqueidentifier)
AS 



            SELECT     dbo.ItemMainAndStoreView.*
			FROM         dbo.ItemMainAndStoreView
			WHERE     (ItemStoreID = @ItemStoreID)
GO