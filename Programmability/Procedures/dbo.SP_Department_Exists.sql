SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_Department_Exists]
(@Name nvarchar(50),
@DepartmentStoreID uniqueidentifier = null )
As 

if @DepartmentStoreID is null 
BEGIN 
	if (select Count(1) from dbo.DepartmentStore 
	where (Name  = @Name)and Status>0)>0
		select 1
	
	else
		select 0
END
ELSE
BEGIN
	if (select Count(1) from dbo.DepartmentStore 
	where (Name  = @Name)and Status>0 AND DepartmentStoreID <> @DepartmentStoreID )>0
		select 1
	
	else
		select 0
END
GO