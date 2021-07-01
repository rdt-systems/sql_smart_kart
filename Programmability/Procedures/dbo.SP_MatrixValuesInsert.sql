SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MatrixValuesInsert]
	@MatrixValueID uniqueidentifier,
	@DisplayValue nvarchar(50),
	@SortOrder int,
	@MatrixColumnNo uniqueidentifier,
	@Status smallint,
	@ModifierID uniqueidentifier
AS
IF ISNULL(@DisplayValue,'') <> ''
Begin
insert into dbo.MatrixValues
	(MatrixValueID, MatrixColumnNo, DisplayValue, SortValue, Status)
values (@MatrixValueID, @MatrixColumnNo, @DisplayValue, @SortOrder, 1)
End
update dbo.MatrixTable
set DateModified = dbo.GetLocalDATE(),
	UserModified = @ModifierID
where MatrixTableID = 
	(select MatrixNo from dbo.MatrixColumn 
	where MatrixColumnID = @MatrixColumnNo)
GO