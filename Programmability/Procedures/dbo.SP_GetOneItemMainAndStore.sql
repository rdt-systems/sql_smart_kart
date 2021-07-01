SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetOneItemMainAndStore](@ID uniqueidentifier,
@StoreID uniqueidentifier)
AS SELECT     dbo.ItemMainAndStoreView.*
FROM         dbo.ItemMainAndStoreView
WHERE     (ItemStoreID = @ID) AND (StoreNo = @StoreID)
GO