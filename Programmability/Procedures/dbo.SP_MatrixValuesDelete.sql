SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MatrixValuesDelete]
	@MatrixValueID uniqueidentifier,
	@ModifierID uniqueidentifier
AS
 UPDATE  dbo.MatrixValues
  SET    status=-1
where MatrixValueID=@MatrixValueID
GO