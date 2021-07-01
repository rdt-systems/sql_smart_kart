SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemIDByStore]
(@ItemStoreID uniqueidentifier)
As 

select ItemNo from dbo.ItemStore
where  ItemStoreID=@ItemStoreID
GO