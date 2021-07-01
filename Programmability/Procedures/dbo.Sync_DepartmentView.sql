SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_DepartmentView]
(@FromDate DateTime)

AS

SELECT DepartmentStoreID as ID,
	   [Name]
	 
FROM DepartmentStore
Where Status>-1 And
	  (DateCreated>@FromDate Or DateModified>@FromDate)
GO