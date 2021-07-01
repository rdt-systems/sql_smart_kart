SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerContactView]
AS
SELECT     dbo.CustomerContact.*
FROM         dbo.CustomerContact
GO