SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--Get Back One ItemStore Row 
CREATE PROCEDURE [dbo].[SP_GetItemStoreByItemStoreID]
(@ItemStoreID uniqueidentifier)
As 


select * from dbo.ItemStoreView
where ItemStoreID=@ItemStoreID
GO