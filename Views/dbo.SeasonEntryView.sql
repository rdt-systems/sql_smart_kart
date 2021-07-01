SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SeasonEntryView]
AS
SELECT     dbo.SeasonEntry.*
FROM         dbo.SeasonEntry
GO