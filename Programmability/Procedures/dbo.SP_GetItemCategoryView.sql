SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemCategoryView]
( @refreshTime  datetime output)
 AS
--select ItemCategoryID, StoreItemNo, CategoryNo
--from ItemCategoryView
--set @refreshTime = dbo.GetLocalDATE()
GO