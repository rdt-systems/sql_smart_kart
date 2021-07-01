SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemMainCustomFieldsDelete]
(@CustomFieldValueID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.CustomFieldValues
SET              Status = -1, 
                      DateModified = dbo.GetLocalDATE()
WHERE	CustomFieldValueID = @CustomFieldValueID
GO