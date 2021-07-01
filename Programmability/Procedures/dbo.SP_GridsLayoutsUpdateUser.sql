SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GridsLayoutsUpdateUser]
	(@LayoutName 	nvarchar(50),
	 @LayoutFileName 	nvarchar(50),
	 @LayoutXMLContent 	ntext,
	 @UserCreated uniqueidentifier)

AS UPDATE dbo.GridsLayoutsUser 

SET  LayoutFileName	 = @LayoutFileName,
	 LayoutXMLContent	 = @LayoutXMLContent 

WHERE 
	(LayoutName= @LayoutName and UserCreated = @UserCreated)
GO