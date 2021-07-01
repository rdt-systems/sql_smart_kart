SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ReturnVenderToPOView]
AS
SELECT     dbo.ReturnVenderToPO.*
FROM         dbo.ReturnVenderToPO
GO