SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetDepartmentById](@DepartmentID uniqueidentifier)
AS SELECT     dbo.DepartmentstoreView.*
FROM         dbo.DepartmentstoreView
WHERE     (DepartmentStoreID = @DepartmentID)
GO