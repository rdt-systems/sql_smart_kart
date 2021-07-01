SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SpecialCustomerGroupInsert]
(	@SpecialCustomerGroupID int = NULL,
	@ItemStoreID uniqueidentifier ,
	@CustomerGroupID uniqueidentifier ,
	@Status int = 1,
	@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

INSERT INTO [dbo].[SpecialCustomerGroup]
           ([ItemStoreID]
           ,[CustomerGroupID]
           ,[Status]
           ,[DateCreated]
           ,[DateModified]
           ,[UserCreated]
           ,[UserModified])
     VALUES
           (@ItemStoreID
           ,@CustomerGroupID
           ,ISNULL(@Status,1)
           ,@UpdateTime
           ,@UpdateTime
           ,@ModifierID
           ,@ModifierID
		   )


Update ItemStore set DateModified = dbo.GetLocalDATE() where ItemStoreID = @ItemStoreID
GO