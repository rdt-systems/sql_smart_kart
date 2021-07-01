SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GridsLayoutsInsert]
(@LayoutName nvarchar(50),
@LayoutFileName nvarchar(50),
@LayoutXMLContent ntext)
as
insert into dbo.GridsLayouts(LayoutName,LayoutFileName,LayoutXMLContent)
		values(@LayoutName,@LayoutFileName,@LayoutXMLContent)
GO