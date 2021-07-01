SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemMainCustomFieldsInsert]
(@CustomFieldValueID uniqueidentifier,
@CustomFieldNo uniqueidentifier,
@RowNo uniqueidentifier,
@FieldValue nvarchar(4000),
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO    dbo.CustomFieldValues
	(CustomFieldValueID, CustomFieldNo, RowNo, FieldValue, Status, DateModified)
VALUES	(@CustomFieldValueID, @CustomFieldNo, @RowNo, @FieldValue, 1, dbo.GetLocalDATE())
GO