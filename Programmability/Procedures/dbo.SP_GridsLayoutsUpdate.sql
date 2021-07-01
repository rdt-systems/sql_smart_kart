SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GridsLayoutsUpdate]
	(@LayoutName 	nvarchar(50),
	 @LayoutFileName 	nvarchar(50),
	 @LayoutXMLContent 	ntext)

AS UPDATE dbo.GridsLayouts 

SET  LayoutFileName	 = @LayoutFileName,
	 LayoutXMLContent	 = @LayoutXMLContent 

WHERE 
	(LayoutName= @LayoutName)
GO