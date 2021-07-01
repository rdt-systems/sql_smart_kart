SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemStoreByItemID]
(@ItemID uniqueidentifier,
@StoreID uniqueidentifier = null)
As 

IF @StoreID IS NULL
	select * from dbo.ItemStore where ItemNo=@ItemID
ELSE
	select * from dbo.ItemStore where ItemNo=@ItemID AND StoreNo = @StoreID
GO