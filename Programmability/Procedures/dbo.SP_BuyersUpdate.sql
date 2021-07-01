SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_BuyersUpdate]
(@BuyerID uniqueidentifier,
@UserID uniqueidentifier,
@SupplierID uniqueidentifier,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE [dbo].[Buyers]
   SET [UserID] = @UserID
      ,[SupplierID] = @SupplierID
      ,[Status] = ISNULL(@Status,1)
      ,[DateModified] = @DateModified
      ,[UserModified] = @ModifierID
 WHERE BuyerID = @BuyerID
GO