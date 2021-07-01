SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WEB_GetItemDep](@ItemID uniqueidentifier)
AS SELECT   department
FROM         dbo.ItemMainAndStoreView
WHERE     (ItemStoreID = @ItemID)
and status>0
GO