SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ReceiveToPOView]
AS
SELECT     dbo.ReceiveToPO.*
FROM         dbo.ReceiveToPO
GO