SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerInActive]
(
@CustomerID uniqueidentifier,
@Reason nvarchar(4000), 
@ModifierID uniqueidentifier,
@Active bit = 0
)
AS UPDATE dbo.Customer

 SET    status=@Active,InActiveReason=@Reason, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID

WHERE CustomerID =@CustomerID
GO