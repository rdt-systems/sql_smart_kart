SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[MatrixColumnView]
AS
SELECT     TOP 100 PERCENT dbo.MatrixColumn.MatrixColumnID, dbo.MatrixColumn.ColumnName, dbo.MatrixColumn.MatrixNo, dbo.MatrixColumn.SortOrder, 
                      dbo.MatrixColumn.Status, dbo.MatrixTable.DateModified
FROM         dbo.MatrixColumn INNER JOIN
                      dbo.MatrixTable ON dbo.MatrixColumn.MatrixNo = dbo.MatrixTable.MatrixTableID
ORDER BY dbo.MatrixColumn.MatrixColumnID
GO