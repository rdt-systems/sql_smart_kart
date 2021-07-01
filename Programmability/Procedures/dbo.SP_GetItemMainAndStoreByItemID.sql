SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetItemMainAndStoreByItemID]
(@ItemID uniqueidentifier,
@StoreID uniqueidentifier)
As 

	select * from dbo.ItemMainAndStoreView where ItemNo=@ItemID AND StoreNo = @StoreID
GO