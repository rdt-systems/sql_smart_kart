SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[UpdateParent]
(@ItemStoreID  uniqueidentifier,
@ModifierID Uniqueidentifier,
@UOnHand bit,
@UOnOrder bit,
@UOnWorkOrder bit,
@UItemSummeries bit=0,
@UReturnSummeries bit=0)
AS


Declare @ParentMainID uniqueidentifier
set @ParentMainID=(select LinkNo from ItemMainAndStoreView where ItemStoreID=@ItemStoreID)


if (@ParentMainID is not null)
begin

    Declare @StoreNo uniqueidentifier
    Set @StoreNo=(Select StoreNo from ItemStore where ItemStoreID=@ItemStoreID)
	Declare @ParentStoreID uniqueidentifier
	Set @ParentStoreID=(	Select ItemStoreID 
				from ItemStore
				where 	(StoreNo = @StoreNo)and(ItemNo=@ParentMainID))
			
	Declare @OnHand decimal(19,3)
	Declare @OnOrder decimal(19,3)
	Declare @OnWorkOrder decimal(19,3)
	Declare @MTDQty decimal(19,3)
	Declare @PTDQty decimal(19,3)
	Declare @YTDQty decimal(19,3)
	Declare	@MTDDollar money
	Declare @PTDDollar money
	Declare @YTDDollar money
	Declare @MTDReturnQty decimal
	Declare	@PTDReturnQty decimal
	Declare	@YTDReturnQty decimal


	if @UOnHand=1
	begin
		Set @OnHand=(	select sum(OnHand)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
	end
	
	if @UOnOrder=1
	begin
		Set @OnOrder=(	select sum(OnOrder)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
	end
	
	if @UOnWorkOrder=1
	begin
		Set @OnWorkOrder=(select sum(OnWorkOrder)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
	end
	
	if @UItemSummeries=1
	begin
		Set @MTDQty=(	select sum(MTDQty)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
		Set @PTDQty=(	select sum(PTDQty)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
		Set @YTDQty=(	select sum(YTDQty)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
		Set @MTDDollar=(select sum(MTDDollar)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
		Set @MTDDollar=(select sum(PTDDollar)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
		Set @MTDDollar=(select sum(YTDDollar)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
	end

	if @UReturnSummeries=1
	begin
		Set @MTDReturnQty=(select sum(MTDReturnQty)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
		Set @PTDReturnQty=(select sum(PTDReturnQty)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
		Set @YTDReturnQty=(select sum(YTDReturnQty)
				from ItemsForUpdateParent
				where (StoreNo=@StoreNo) and (LinkNo=@ParentMainID))
	end
	

	Update ItemStore
	Set 	OnHand=ISNULL(@OnHand,OnHand),
		OnOrder=ISNULL(@OnOrder,OnOrder),
		OnWorkOrder=ISNULL(@OnWorkOrder,OnWorkOrder),
 		MTDQty =ISNULL(@MTDQty,MTDQty),
		PTDQty =ISNULL(@PTDQty,PTDQty),
		YTDQty =ISNULL(@YTDQty,YTDQty),
		MTDDollar =ISNULL(@MTDDollar,MTDDollar),
	 	PTDDollar =ISNULL(@PTDDollar,PTDDollar),
	 	YTDDollar =ISNULL(@YTDDollar,YTDDollar),
		MTDReturnQty=ISNULL(@MTDReturnQty,MTDReturnQty),
		PTDReturnQty=ISNULL(@PTDReturnQty,PTDReturnQty),
		YTDReturnQty=ISNULL(@YTDReturnQty,YTDReturnQty),
		DateModified = dbo.GetLocalDATE(), 
		UserModified = @ModifierID
 	WHERE ItemStoreID = @ParentStoreID
end
GO