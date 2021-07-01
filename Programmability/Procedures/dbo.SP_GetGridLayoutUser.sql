SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create procedure [dbo].[SP_GetGridLayoutUser]
(@LayoutName nvarchar(50), @UserCreated Uniqueidentifier)

as

select LayoutFileName,LayoutXMLContent
from dbo.GridsLayoutsUser
where LayoutFileName=@LayoutName and UserCreated = @UserCreated
GO