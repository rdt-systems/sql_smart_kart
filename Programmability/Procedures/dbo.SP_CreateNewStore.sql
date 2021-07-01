SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CreateNewStore]
(@NewStoreID uniqueidentifier,
@StoreID uniqueidentifier,
@UserID uniqueidentifier,
@MySymbol varchar(50),
@IsWarehouse Bit) 

AS

--Items
INSERT INTO ItemStore (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, 
                      CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, OnHand, OnOrder, ReorderPoint, 
                      RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, 
                      SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, DateCreated, UserCreated, DateModified, 
                      UserModified, NewPrice, NewPriceDate)
SELECT 	    NEWID(),ItemNo, @NewStoreID, DepartmentID, IsDiscount, IsTaxable, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, 
                      CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, 0, 0, ReorderPoint, 
                      RestockLevel, BinLocation, 0, DaysForReturn, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, 
                      SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, dbo.GetLocalDATE(), @UserID, dbo.GetLocalDATE(), 
                      @UserID, NewPrice, NewPriceDate
from ItemStore 
WHERE (StoreNo=@StoreID) AND (Status>-1)


--Supplier
INSERT INTO dbo.ItemSupply (ItemSupplyID,ItemStoreNo,SupplierNo,TotalCost,MinimumQty,QtyPerCase,IsOrderedOnlyInCase,AverageDeliveryDelay,
				ItemCode,IsMainSupplier,SortOrder, Status, DateCreated, UserCreated, DateModified, 
                                UserModified)
SELECT 	 NEWID(),ItemStoreNew.ItemStoreID,SupplierNo,TotalCost,MinimumQty,QtyPerCase,IsOrderedOnlyInCase,AverageDeliveryDelay,
				ItemCode,IsMainSupplier,SortOrder,ItemSupply.Status, dbo.GetLocalDATE(), @UserID, dbo.GetLocalDATE(), 
                                @UserID 
from ItemSupply Inner Join ItemStore
  	on ItemSupply.ItemStoreNo=ItemStore.ItemStoreID  and ItemStore.StoreNo=@StoreID inner join itemStore ItemStoreNew
  	on ItemStoreNew.ItemNo=ItemStore.ItemNo and ItemStoreNew.StoreNo=@NewStoreID
WHERE  ItemSupply.Status>0


--Note
INSERT INTO dbo.ItemNotes (NoteID,TypeOfNote,ItemStoreNo,NoteValue,Status, DateCreated, UserCreated, DateModified, 
                                UserModified)
SELECT 	 NEWID(),TypeOfNote,ItemStoreNew.ItemStoreID,NoteValue,ItemNotes.Status, dbo.GetLocalDATE(), @UserID, dbo.GetLocalDATE(), 
                                @UserID 
from ItemNotes Inner Join ItemStore
  	on ItemNotes.ItemStoreNo=ItemStore.ItemStoreID  and ItemStore.StoreNo=@StoreID inner join itemStore ItemStoreNew
  	on ItemStoreNew.ItemNo=ItemStore.ItemNo and ItemStoreNew.StoreNo=@NewStoreID
WHERE  ItemNotes.Status>0


--Group
INSERT INTO dbo.ItemToGroup (ItemToGroupID,ItemGroupID,ItemStoreID,Status, DateModified)
SELECT 	 NEWID(),ItemGroupID,ItemStoreNew.ItemStoreID,ItemToGroup.Status, dbo.GetLocalDATE()
from ItemToGroup Inner Join ItemStore
  	on ItemToGroup.ItemStoreID=ItemStore.ItemStoreID  and ItemStore.StoreNo=@StoreID inner join itemStore ItemStoreNew
  	on ItemStoreNew.ItemNo=ItemStore.ItemNo and ItemStoreNew.StoreNo=@NewStoreID
WHERE  ItemToGroup.Status>0

--Attachment
INSERT INTO dbo.Attachments (AttachmentID,ItemStoreID,[Description],[FileName],Attachment, Status, DateCreated, UserCreated, DateModified, 
                                UserModified)
SELECT 	 NEWID(),ItemStoreNew.ItemStoreID,[Description],[FileName],Attachment,Attachments.Status, dbo.GetLocalDATE(), @UserID, dbo.GetLocalDATE(), 
                                @UserID 
from Attachments Inner Join ItemStore
  	on Attachments.ItemStoreID=ItemStore.ItemStoreID  and ItemStore.StoreNo=@StoreID inner join itemStore ItemStoreNew
  	on ItemStoreNew.ItemNo=ItemStore.ItemNo and ItemStoreNew.StoreNo=@NewStoreID
WHERE  Attachments.Status>0

--Extra Charge
INSERT INTO dbo.ExtraCharge (ExtraChargeID,ExtraChargeName,ExtraChargeDescription,ExtraChargeType,ExtraChargeQty,
			    IsExtraChargeIncluded ,ExtraChargeAccount,ItemStoreNo,Status, DateModified)
SELECT 	 NEWID(),ExtraChargeName,ExtraChargeDescription,ExtraChargeType,ExtraChargeQty,
			    IsExtraChargeIncluded ,ExtraChargeAccount,ItemStoreNew.ItemStoreID,ExtraCharge.Status,dbo.GetLocalDATE() 
from ExtraCharge Inner Join ItemStore
  	on ExtraCharge.ItemStoreNo=ItemStore.ItemStoreID  and ItemStore.StoreNo=@StoreID inner join itemStore ItemStoreNew
  	on ItemStoreNew.ItemNo=ItemStore.ItemNo and ItemStoreNew.StoreNo=@NewStoreID
WHERE  ExtraCharge.Status>0


--Season
INSERT INTO dbo.ItemSeason (ItemStoreSeasonId,ItemStoreNo,SeasonNo,Status, DateModified)
SELECT 	 NEWID(),ItemStoreNew.ItemStoreID,SeasonNo,ItemSeason.Status, dbo.GetLocalDATE() 
from ItemSeason Inner Join ItemStore
  	on ItemSeason.ItemStoreNo=ItemStore.ItemStoreID  and ItemStore.StoreNo=@StoreID inner join itemStore ItemStoreNew
  	on ItemStoreNew.ItemNo=ItemStore.ItemNo and ItemStoreNew.StoreNo=@NewStoreID
WHERE  ItemSeason.Status>0


--SetUp
INSERT INTO SetUpValues (OptionID,CategoryID,StoreID,OptionName,OptionValue,Status,DateCreated,
			 UserCreated,DateModified,UserModified) 
SELECT OptionID,CategoryID,@NewStoreID,OptionName,OptionValue,Status,dbo.GetLocalDATE()
			,@UserID,dbo.GetLocalDATE(),@UserID 
from SetUpValues 
WHERE StoreID='00000000-0000-0000-0000-000000000000'

--NumberSettings
 
INSERT INTO NumberSettings(StoreSymbol,TableName,SeqNumber,StartNum,[Desc],StoreID) 
Select @MySymbol,TableName,0,0,[Desc],@NewStoreID
From NumberSettings
where StoreID=@StoreID

--if @IsWarehouse = 1
--exec SP_CreateNewWareHouse @NewStoreID ,@StoreID , @UserID
GO