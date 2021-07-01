SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemDetailsByID](@ItemID uniqueidentifier)
AS SELECT     dbo.ItemMainView.*
FROM         dbo.ItemMainView
WHERE     (ItemID = @ItemID)
GO