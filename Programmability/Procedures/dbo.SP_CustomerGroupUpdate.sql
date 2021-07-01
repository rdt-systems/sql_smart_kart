SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerGroupUpdate]
(@CustomerGroupID uniqueidentifier,
@CustomerGroupName nvarchar(50),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.CustomerGroup
              
SET    CustomerGroupName=dbo.CheckString(@CustomerGroupName), Status=@Status,DateModified= @UpdateTime

WHERE (CustomerGroupID=@CustomerGroupID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)


select @UpdateTime as DateModified
GO