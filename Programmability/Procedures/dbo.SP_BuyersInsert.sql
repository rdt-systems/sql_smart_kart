SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_BuyersInsert]
(@BuyerID uniqueidentifier,
@UserID uniqueidentifier,
@SupplierID uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier)

AS 
Insert Into [Buyers]
(
			[BuyerID]
           ,[UserID]
           ,[SupplierID]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated]
           ,[DateModified]
           ,[UserModified]
		   )
 VALUES
           (@BuyerID
           ,@UserID
           ,@SupplierID
           ,ISNULL(@Status,1)
           ,dbo.GetLocalDate()
           ,@ModifierID
           ,dbo.GetLocalDate()
           ,@ModifierID)
GO