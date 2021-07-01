SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GridsLayoutsInsertUser]
(@LayoutName nvarchar(50),
@LayoutFileName nvarchar(50),
@LayoutXMLContent ntext,
@UserCreated uniqueidentifier,
@ComputerName nvarchar(150) = NULL)
as

Delete from GridsLayoutsUser where LayoutName = @LayoutName and UserCreated = @UserCreated

insert into dbo.GridsLayoutsUser(LayoutName,LayoutFileName,LayoutXMLContent,UserCreated,ComputerName)
		values(@LayoutName,@LayoutFileName,@LayoutXMLContent,@UserCreated,@ComputerName)
GO