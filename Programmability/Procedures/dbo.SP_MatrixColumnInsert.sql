SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MatrixColumnInsert]
	@MatrixColumnID uniqueidentifier,
	@MatrixNo uniqueidentifier,
                @ColumnName nvarchar(50),
	@SortOrder int,
	@Status smallint,
	@ModifierID uniqueidentifier
AS
Insert  into dbo.MatrixColumn
	(MatrixColumnID, MatrixNo, ColumnName, SortOrder, Status)
values (@MatrixColumnID, @MatrixNo,  @ColumnName, @SortOrder, 1)


Update MatrixTable
 Set  DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
 Where MatrixTableID= @MatrixNo
GO