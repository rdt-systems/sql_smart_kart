SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ShipViaView]
AS
SELECT     dbo.ShipVia.*
FROM         dbo.ShipVia
GO