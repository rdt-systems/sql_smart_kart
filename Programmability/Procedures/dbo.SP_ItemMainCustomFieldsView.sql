SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemMainCustomFieldsView]
AS SELECT     dbo.ItemMainCustomFieldsView.*
FROM         dbo.ItemMainCustomFieldsView
WHERE     (Status > - 1)
GO