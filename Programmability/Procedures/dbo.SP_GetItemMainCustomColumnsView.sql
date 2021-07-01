SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemMainCustomColumnsView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS
 SELECT     dbo.ItemMainCustomColumnsView.*
FROM         dbo.ItemMainCustomColumnsView
set @refreshTime = dbo.GetLocalDATE()
GO