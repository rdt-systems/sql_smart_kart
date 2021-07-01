SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemStoreByStore]
(@ItemID uniqueidentifier,@StoreID uniqueidentifier)
As 


select ItemStoreID from dbo.ItemStore
where StoreNo=@StoreID and ItemNo=@ItemID
GO