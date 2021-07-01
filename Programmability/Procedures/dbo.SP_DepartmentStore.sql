SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_DepartmentStore]
(
@DateModified datetime=null
)
AS 
SELECT [DepartmentStore].*  FROM [DepartmentStore]  WHERE (DateModified >@DateModified) AND Status>0
GO