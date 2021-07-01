SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetMainChilds](@ID uniqueidentifier)
AS SELECT     dbo.ItemMainView.*
FROM         dbo.ItemMainView
WHERE     (LinkNo = @ID)
GO