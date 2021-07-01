SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSupplierGridView]
(@ShowInActive bit = 1,@DateModified datetime=null, @refreshTime  datetime output)
AS SELECT     dbo.SupplierGridView.*
FROM         dbo.SupplierGridView
WHERE     (Status >= @ShowInActive)
set @refreshTime = dbo.GetLocalDATE()
GO