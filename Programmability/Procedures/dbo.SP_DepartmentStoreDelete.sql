SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DepartmentStoreDelete]
(@DepartmentStoreID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 

UPDATE dbo.DepartmentStore             
SET     status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
WHERE DepartmentStoreID=@DepartmentStoreID

---- Update The Parent Department Table
--IF EXISTS(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ParentDepartmentList')
--drop table ParentDepartmentList
--Begin
--WITH CTE AS
--( SELECT DepartmentStoreID,ParentDepartmentID,Name, 0 [Level]
--FROM DepartmentStore 
--UNION ALL
--SELECT CTE.DepartmentStoreID, DepartmentStore.ParentDepartmentID, CTE.Name, Level+1 
--FROM CTE
--INNER JOIN DepartmentStore
--ON CTE.ParentDepartmentID = DepartmentStore.DepartmentStoreID
--WHERE DepartmentStore.ParentDepartmentID IS NOT NULL AND DepartmentStore.ParentDepartmentID<>'00000000-0000-0000-0000-000000000000' and Status >0 
--) 

--SELECT c.DepartmentStoreID, c.Name, c.ParentDepartmentID,c.Level,c.MaxLevel,DepartmentStore.Name As ParentName into ParentDepartmentList
--FROM ( SELECT *, MAX([Level]) OVER (PARTITION BY DepartmentStoreID) [MaxLevel]
--FROM
--  CTE
--        ) c INNER JOIN DepartmentStore On C.ParentDepartmentID=DepartmentStore.DepartmentStoreID 
--End
GO