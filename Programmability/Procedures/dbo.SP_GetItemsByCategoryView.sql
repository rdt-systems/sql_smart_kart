SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemsByCategoryView]
( @refreshTime  datetime output)
AS 
--SELECT     dbo.ItemsByCategoryView.*
--FROM         dbo.ItemsByCategoryView
--WHERE     (Status > - 1)
--set @refreshTime = dbo.GetLocalDATE()
GO