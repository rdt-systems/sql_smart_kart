SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[ItemToGroupView]
AS
SELECT     dbo.ItemToGroup.*,StoreNo as StoreID
FROM         dbo.ItemToGroup INNER JOIN ItemStore On ItemStore.ItemStoreID=ItemToGroup.ItemStoreID
Where ItemGroupID IN (Select ItemGroupID From ItemGroup)
GO