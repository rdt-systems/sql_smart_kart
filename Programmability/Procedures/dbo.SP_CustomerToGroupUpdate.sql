SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  



   PROCEDURE [dbo].[SP_CustomerToGroupUpdate]
(@CustomerToGroupID uniqueidentifier,
@CustomerGroupID uniqueidentifier,
@CustomerID uniqueidentifier,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


 Update dbo.CustomerToGroup
   Set CustomerToGroupID = @CustomerGroupID, CustomerID = @CustomerID, Status= @status,DateModified = @UpdateTime

WHere (CustomerToGroupID = @CustomerToGroupID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)




select @UpdateTime as DateModified
GO