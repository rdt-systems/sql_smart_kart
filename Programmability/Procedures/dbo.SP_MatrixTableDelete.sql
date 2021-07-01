SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MatrixTableDelete]
	@MatrixTableID uniqueidentifier,
	@ModifierID uniqueidentifier
AS
	update dbo.MatrixTable
	set Status = -1, DateModified = dbo.GetLocalDATE(),
		UserModified = @ModifierID
	where MatrixTableID = @MatrixTableID

update dbo.MatrixColumn
	set Status = -1
	where MatrixNo = @MatrixTableID

UPDATE dbo.MatrixValues
	set status=-1
	Where MatrixColumnNo in (select MatrixColumnID
                                  from dbo.MatrixColumn
                                  where MatrixNo = @MatrixTableID)
GO