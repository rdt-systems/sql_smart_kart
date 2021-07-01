SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[EmailView]
AS
SELECT     dbo.Email.*
FROM         dbo.Email
GO