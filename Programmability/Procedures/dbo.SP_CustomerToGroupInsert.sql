SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerToGroupInsert]
(@CustomerToGroupID uniqueidentifier,
@CustomerGroupID uniqueidentifier,
@CustomerID uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier)

AS INSERT INTO dbo.CustomerToGroup
                      (CustomerToGroupID,     CustomerGroupID,     CustomerID,   Status,DateModified )
VALUES          (@CustomerToGroupID, @CustomerGroupID, @CustomerID, 1,        dbo.GetLocalDATE())
GO