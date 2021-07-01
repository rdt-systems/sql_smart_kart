SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MatrixTableInsert]
(@MatrixTableID uniqueidentifier,
@MatrixName nvarchar(50),
@MatrixDescription nvarchar(4000),
@Status smallint,
@ModifierID uniqueidentifier)

AS INSERT INTO dbo.MatrixTable
                      (MatrixTableID, MatrixName, MatrixDescription, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@MatrixTableID, @MatrixName, @MatrixDescription , 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO