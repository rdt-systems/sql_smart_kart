SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[LookAccountView]
AS
SELECT     dbo.LookAccount.*
FROM         dbo.LookAccount
GO