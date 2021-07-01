SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MatrixColumnDelete]
	@MatrixColumnID uniqueidentifier,
	@ModifierID uniqueidentifier
AS
if 
(select count(*) 
from dbo.MatrixValues
where MatrixColumnNo = @MatrixColumnID) = 0
begin
	update dbo.MatrixColumn
	set Status = -1
	where MatrixColumnID = @MatrixColumnID

	update dbo.ItemMain
	set DateModified = dbo.GetLocalDATE(),
		UserModified = @ModifierID
	where ItemID = (select MatrixNo from dbo.MatrixColumn
		where MatrixColumnID = @MatrixColumnID)
end
GO