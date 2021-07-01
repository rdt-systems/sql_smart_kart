SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ItemMainCustomFieldsView]
AS
SELECT     TOP 100 PERCENT dbo.CustomFieldValues.CustomFieldValueID, dbo.CustomFieldValues.CustomFieldNo, dbo.CustomFieldValues.RowNo, 
                      dbo.CustomFieldValues.FieldValue, dbo.CustomFieldValues.Status, dbo.CustomFieldValues.DateModified
FROM         dbo.CustomFieldValues INNER JOIN
                      dbo.CustomFields ON dbo.CustomFieldValues.CustomFieldNo = dbo.CustomFields.CustomFieldID
WHERE     (dbo.CustomFields.LinkToTable = 'ItemMain')
ORDER BY dbo.CustomFieldValues.CustomFieldNo
GO