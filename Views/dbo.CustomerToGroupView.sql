SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerToGroupView]
AS
SELECT     dbo.CustomerToGroup.*
FROM         dbo.CustomerToGroup
GO