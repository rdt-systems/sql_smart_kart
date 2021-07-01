SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[MatrixTableView]
WITH SCHEMABINDING 
AS
SELECT        MatrixTableID, MatrixName, MatrixDescription, Status, DateCreated, UserCreated, DateModified, UserModified
FROM           dbo.MatrixTable
GO