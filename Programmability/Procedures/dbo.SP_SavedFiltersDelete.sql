SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SavedFiltersDelete]
(@FilterID uniqueidentifier,
@ModifierID uniqueidentifier)
AS update dbo.SavedFilters
set

Status =-1
where FilterID=@FilterID
GO