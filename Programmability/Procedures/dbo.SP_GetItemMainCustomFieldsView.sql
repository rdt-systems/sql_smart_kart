SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemMainCustomFieldsView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS SELECT     dbo.ItemMainCustomFieldsView.*
FROM         dbo.ItemMainCustomFieldsView
set @refreshTime = dbo.GetLocalDATE()
GO