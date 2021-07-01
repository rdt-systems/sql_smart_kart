SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[MatrixValueView]
AS
SELECT        TOP (100) PERCENT MatrixValues.MatrixValueID, MatrixValues.DisplayValue, MatrixValues.SortValue AS SortOrder, MatrixValues.MatrixColumnNo, MatrixValues.Status, MatrixTable.DateModified
FROM            MatrixValues INNER JOIN
                         MatrixColumn ON MatrixValues.MatrixColumnNo = MatrixColumn.MatrixColumnID INNER JOIN
                         MatrixTable ON MatrixColumn.MatrixNo = MatrixTable.MatrixTableID
WHERE        (MatrixValues.Status > - 1) AND (MatrixColumn.Status > - 1) AND (ISNULL(MatrixValues.DisplayValue, N'') <> '')
ORDER BY MatrixValues.MatrixColumnNo, SortOrder
GO