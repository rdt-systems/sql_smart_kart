SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemMainCustomFieldsUpdate]
(@CustomFieldValueID uniqueidentifier,
@CustomFieldNo uniqueidentifier,
@RowNo uniqueidentifier,
@FieldValue nvarchar(4000),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.CustomFieldValues
SET              CustomFieldNo = @CustomFieldNo, RowNo = @RowNo, FieldValue = @FieldValue, Status = @Status, 
                      @DateModified = @UpdateTime

WHERE	(CustomFieldValueID = @CustomFieldValueID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)



select @UpdateTime as DateModified
GO