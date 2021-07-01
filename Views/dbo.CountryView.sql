SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CountryView]
AS
SELECT     dbo.Country.*
FROM         dbo.Country
GO