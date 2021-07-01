SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MatrixValuesUpdate]
	@MatrixValueID uniqueidentifier,
	@DisplayValue nvarchar(50),
	@SortOrder int,
	@MatrixColumnNo uniqueidentifier,
	@Status smallint,
	@DateModified datetime,
	@ModifierID uniqueidentifier
AS
IF ISNULL(@DisplayValue,'') <> ''
Begin
update dbo.MatrixValues
set MatrixColumnNo = @MatrixColumnNo,
	DisplayValue = @DisplayValue,
	SortValue = @SortOrder,
	Status = @Status
where MatrixValueID = @MatrixValueID
End
update dbo.MatrixTable
set DateModified = dbo.GetLocalDATE(),
	UserModified = @ModifierID
where MatrixTableID = 
	(select MatrixNo from dbo.MatrixColumn 
	where MatrixColumnID = @MatrixColumnNo)
GO