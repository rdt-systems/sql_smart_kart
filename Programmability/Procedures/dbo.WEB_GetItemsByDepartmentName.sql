SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WEB_GetItemsByDepartmentName]
(@DepartmentName nvarchar(50))



AS SELECT    BarcodeNumber,[Name],Price,ItemStoreID,OnHand,ItemID,
(select 1 from itemmain where itemid=ItemMainAndStoreView.itemid and itempicture is not null)as ItemPicture

FROM         dbo.ItemMainAndStoreView
where department=@DepartmentName
and status>0
and onhand>0
GO