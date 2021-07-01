SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetOneItemStore](@ID uniqueidentifier,
@StoreID uniqueidentifier)
AS SELECT     dbo.ItemStoreView.*
FROM         dbo.ItemStoreView
WHERE     (ItemStoreID = @ID) AND (StoreNo = @StoreID)
GO