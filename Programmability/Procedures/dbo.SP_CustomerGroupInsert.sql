SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerGroupInsert]
(@CustomerGroupID uniqueidentifier,
@CustomerGroupName nvarchar(50),
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.CustomerGroup
                      (CustomerGroupID, CustomerGroupName,  Status, DateModified)
VALUES     (@CustomerGroupID, dbo.CheckString(@CustomerGroupName),1, dbo.GetLocalDATE())
GO