SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSavedFiltersView] as
select * from dbo.SavedFiltersView
where status>-1
GO