SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WEB_GetItemDetailsByID](@ItemID uniqueidentifier)
AS SELECT     dbo.ItemMainAndStoreView.*
FROM         dbo.ItemMainAndStoreView
WHERE     (ItemStoreID = @ItemID)
GO