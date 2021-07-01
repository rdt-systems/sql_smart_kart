SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_GetItemPrice]
(@ItemID uniqueidentifier)
AS SELECT    Price
FROM         dbo.Itemstore
WHERE     (ItemStoreID = @ItemID)
and status>0
GO