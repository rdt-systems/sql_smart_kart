SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SetUpValuesPOS]
(@OptionID int,
 @CategoryID smallint,
 @OptionName varchar(50),
 @StoreID uniqueidentifier,
 @OptionValue varchar(4000),
 @OptionValueHe varchar(4000)='',
 @Status smallint=1,
 @ModifierID uniqueidentifier,
 @SaveAll bit)

as


declare @vStoreID uniqueidentifier
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

if @SaveAll =1
BEGIN
	declare B cursor  for select StoreID from Store
	OPEN B
	fetch next from B into @vStoreID
	while @@fetch_status = 0 begin
		if (SELECT COUNT(*) from SetUpValues Where StoreID =@vStoreID and OptionID =@OptionID)>0 
		BEGIN
			update dbo.SetUpValues
			set	 OptionValue=@OptionValue,
				DateModified =@UpdateTime
			Where OptionID=@OptionID and StoreID = @vStoreID
		END
		ELSE BEGIN
		  insert into SetUpValues (OptionID,CategoryID,OptionName,StoreID,OptionValue,OptionValueHe,Status,DateCreated,UserCreated,DateModified,UserModified)
		 values (@OptionID,@CategoryID,@OptionName,@vStoreID,@OptionValue,@OptionValueHe,1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID)

		END
		fetch next from B into @vStoreID
	end
	close B
	deallocate B
END
ELSE BEGIN
	if (SELECT COUNT(*) from SetUpValues Where StoreID =@StoreID and OptionID =@OptionID)>0 
	BEGIN
		update dbo.SetUpValues
				set	 OptionValue=@OptionValue,
				DateModified =@UpdateTime
		Where OptionID=@OptionID and StoreID = @StoreID
	END
	ELSE BEGIN
		insert into SetUpValues (OptionID,CategoryID,OptionName,StoreID,OptionValue,OptionValueHe,Status,DateCreated,UserCreated,DateModified,UserModified)
		values (@OptionID,@CategoryID,@OptionName,@StoreID,@OptionValue,@OptionValueHe,1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID)

	END
END
GO