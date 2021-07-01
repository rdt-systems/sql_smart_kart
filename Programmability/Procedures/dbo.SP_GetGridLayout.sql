SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetGridLayout]
(@LayoutName nvarchar(50))

as

select LayoutFileName,LayoutXMLContent
from dbo.GridsLayouts
where LayoutFileName=@LayoutName
GO