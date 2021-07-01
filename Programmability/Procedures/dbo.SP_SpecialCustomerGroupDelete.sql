SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SpecialCustomerGroupDelete]
(@SpecialCustomerGroupID Int,
@ModifierID uniqueidentifier)
AS 
Update dbo.SpecialCustomerGroup
   Set Status=-1,
   DateModified = dbo.GetLocalDATE()

WHere SpecialCustomerGroupID = @SpecialCustomerGroupID



Update ItemStore Set DateModified = dbo.GetLocalDATE() Where ItemStoreID IN (SELECT ItemStoreID From SpecialCustomerGroup Where SpecialCustomerGroupID = @SpecialCustomerGroupID)
GO