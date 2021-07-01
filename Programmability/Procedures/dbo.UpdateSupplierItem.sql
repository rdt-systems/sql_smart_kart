SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateSupplierItem]
(@ItemStoreID uniqueidentifier,
 @SupplierID uniqueidentifier,
 @MainSupplier bit,
 @ModifierID uniqueidentifier)
AS

--if nothing is Main Set this Main
IF (Select count(*) From ItemSupply Where ItemStoreNo=@ItemStoreID And Status>-1 and IsMainSupplier = 1)=0
SET @MainSupplier=1 

--Check If ItemSupply Exists
If (Select count(*) From ItemSupply Where ItemStoreNo=@ItemStoreID AND SupplierNo=@SupplierID And Status>-1)>0

 

 begin

if @MainSupplier=1 
		begin

		update ItemStore
		Set MainSupplierID=(Select Top 1 ItemSupplyID
							From ItemSupply
							Where ItemStoreNo=@ItemStoreID AND SupplierNo=@SupplierID And Status>0),DateModified=dbo.GetLocalDATE(),UserModified=@ModifierID
		where ItemStoreID=@ItemStoreID
		
		Update ItemSupply Set IsMainSupplier=0,	DateModified=dbo.GetLocalDATE(),UserModified=@ModifierID
		where ItemStoreNo=@ItemStoreID

		Update ItemSupply Set IsMainSupplier=1
		where ItemStoreNo=@ItemStoreID And SupplierNo=@SupplierID And Status>0
		end
end

else

begin

declare @ID uniqueidentifier
set @ID=NEWID()

INSERT INTO ItemSupply (ItemSupplyID, ItemStoreNo, SupplierNo, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@ID, @ItemStoreID, @SupplierID, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)

if @MainSupplier =1
		begin
		
		Update ItemSupply
		Set IsMainSupplier=0,
			DateModified=dbo.GetLocalDATE(),
			UserModified=@ModifierID
		where ItemStoreNo=@ItemStoreID

		Update ItemSupply
		Set IsMainSupplier=1
		where ItemSupplyID=@ID

		Update ItemStore
		Set MainSupplierID=@ID,
			DateModified=dbo.GetLocalDATE(),
			UserModified=@ModifierID

		where ItemStoreID=@ItemStoreID
		end
end
GO