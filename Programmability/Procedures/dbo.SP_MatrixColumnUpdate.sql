SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MatrixColumnUpdate]
	@MatrixColumnID uniqueidentifier,
	@MatrixNo uniqueidentifier,
                @ColumnName nvarchar(50),
	@SortOrder int,
	@Status smallint,
                @DateModified datetime,
	@ModifierID uniqueidentifier


AS
update dbo.MatrixColumn
set MatrixNo = @MatrixNo,
	ColumnName = @ColumnName,
                SortOrder  =@SortOrder,
	Status=@Status
where MatrixColumnID = @MatrixColumnID

Update MatrixTable
 Set  DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
 Where MatrixTableID= @MatrixNo
GO