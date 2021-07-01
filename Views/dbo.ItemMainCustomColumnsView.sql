SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ItemMainCustomColumnsView]
AS
SELECT     TOP 100 PERCENT CustomFieldID, CustomFieldName, CustomFieldType, SortOrder
FROM         dbo.CustomFields
WHERE     (LinkToTable = 'ItemMain')
ORDER BY SortOrder
GO