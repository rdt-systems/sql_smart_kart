SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE   VIEW [dbo].[SavedFiltersView]
AS
SELECT     dbo.SavedFilters.*
FROM         dbo.SavedFilters
GO