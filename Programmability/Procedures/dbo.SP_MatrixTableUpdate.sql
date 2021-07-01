SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MatrixTableUpdate]
(@MatrixTableID uniqueidentifier,
@MatrixName nvarchar(50),
@MatrixDescription nvarchar(4000),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.MatrixTable
SET              MatrixName = @MatrixName, MatrixDescription = @MatrixDescription, Status = @Status,   DateModified = @UpdateTime, 

UserModified = @ModifierID
WHERE     (MatrixTableID = @MatrixTableID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO