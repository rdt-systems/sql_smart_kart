SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SpecialCustomerGroupUpdate]
(@SpecialCustomerGroupID Int,
@ItemStoreID uniqueidentifier ,
@CustomerGroupID uniqueidentifier ,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE [dbo].[SpecialCustomerGroup]
   SET [ItemStoreID] = @ItemStoreID
      ,[CustomerGroupID] = @CustomerGroupID
      ,[Status] = ISNULL(@Status,1)
      ,[DateModified] = @UpdateTime
      ,[UserModified] = @ModifierID
 WHERE SpecialCustomerGroupID = @SpecialCustomerGroupID

Update ItemStore set DateModified = dbo.GetLocalDATE() where ItemStoreID = @ItemStoreID

select @UpdateTime as DateModified
GO