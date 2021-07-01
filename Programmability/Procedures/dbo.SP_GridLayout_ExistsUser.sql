SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GridLayout_ExistsUser]
(@Name nvarchar(50),@UserCreated uniqueidentifier)

AS

SELECT    LayoutName 
FROM         dbo.GridsLayoutsUser
WHERE     (LayoutFileName = @Name and UserCreated = @UserCreated)
GO