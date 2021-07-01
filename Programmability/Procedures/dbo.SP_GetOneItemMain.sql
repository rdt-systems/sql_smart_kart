SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOneItemMain](@ID uniqueidentifier)
AS SELECT     dbo.ItemMainView.*
FROM         dbo.ItemMainView
WHERE     (ItemID = @ID)
GO