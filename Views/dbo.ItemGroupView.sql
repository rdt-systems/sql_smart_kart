SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





CREATE VIEW [dbo].[ItemGroupView]
AS
SELECT     ItemGroupID, ItemGroupName, ParentID, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.ItemGroup
Where Status >0 AND LEN(ItemGroupName) >=1 
And ISNULL(ItemGroupName,'') <> ''
GO