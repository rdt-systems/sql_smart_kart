SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CoustomFiledsCombo]
AS
SELECT     CustomFieldName, CustomFieldID
FROM         dbo.CustomFields
GO