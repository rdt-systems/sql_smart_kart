SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerGroupView]
AS
SELECT     CustomerGroupID, CustomerGroupName, Status, DateModified
FROM         dbo.CustomerGroup
GO