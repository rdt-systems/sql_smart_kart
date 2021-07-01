SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GridLayout_Exists]
(@Name nvarchar(50))

AS

SELECT    LayoutName 
FROM         dbo.GridsLayouts
WHERE     (LayoutFileName = @Name)
GO