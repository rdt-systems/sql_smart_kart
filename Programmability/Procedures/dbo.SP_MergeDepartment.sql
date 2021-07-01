SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MergeDepartment]
	(@FromDepartmentID Uniqueidentifier,
	 @ToDepartmentID Uniqueidentifier,
	 @ModifierID Uniqueidentifier)

AS

IF NOT @FromDepartmentID = @ToDepartmentID

BEGIN

Update ItemStore Set DepartmentID = @ToDepartmentID, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
Where DepartmentID = @FromDepartmentID

Update DepartmentStore set Status = -2, Description = Description + ' Merged Into DepartmentID ' + CONVERT(nvarchar(50),@ToDepartmentID),
  DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID where DepartmentStoreID = @FromDepartmentID


END
GO