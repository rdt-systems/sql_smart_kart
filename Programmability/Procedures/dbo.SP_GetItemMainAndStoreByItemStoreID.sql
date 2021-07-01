SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetItemMainAndStoreByItemStoreID]
(@ItemStoreID uniqueidentifier)
As 

	select * from dbo.ItemMainAndStoreView where ItemStoreID=@ItemStoreID
GO