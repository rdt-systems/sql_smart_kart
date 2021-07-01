SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerDelete]
(@CustomerID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE dbo.Customer

 SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID

WHERE CustomerID =@CustomerID
GO