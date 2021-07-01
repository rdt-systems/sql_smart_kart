SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetStoreChilds](@ID uniqueidentifier,@ItemStoreId uniqueidentifier)
AS

SELECT     dbo.ItemStoreView.*
FROM         dbo.ItemStoreView INNER JOIN
                      dbo.ItemMainView ON dbo.ItemStoreView.ItemNo = dbo.ItemMainView.ItemID
WHERE     (dbo.ItemMainView.LinkNo = @ID OR dbo.ItemMainView.ItemID=@ID)
and  dbo.ItemStoreView.itemStoreid !=@ItemStoreId
GO