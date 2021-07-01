SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCategorySavedFilters]
(@CategoryID int)

AS 
select * from SavedFiltersView
where Category=@CategoryID
GO