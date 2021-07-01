SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CanDeleteDepartment]
(@ID uniqueidentifier)

as
declare @I as bit
SET @I=0
IF (select Count(1) from DepartmentStore where ParentDepartmentID = @ID and Status >-1)=0
  SET @I = 1
if @I=1 
BEGIN
  IF (select Count(1) from dbo.ItemStoreView where DepartmentID=@ID AND Status>-1)>0
	SET @I = 1
END
SELECT @I
GO