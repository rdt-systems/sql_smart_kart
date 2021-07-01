SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ItemSeasonView]
AS
SELECT     dbo.ItemSeason.*
FROM         dbo.ItemSeason
GO