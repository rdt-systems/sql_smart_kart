SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[InactiveItem]
(@ItemID uniqueidentifier,
 @StoreID uniqueidentifier=null,
 @Status smallint,
 @ModifierID uniqueidentifier,
 @VoidReason nvarchar(50)=null)
AS

Update ItemStore Set Status = @Status, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID Where ItemNo = @ItemID And Status>-1 
Update ItemMain Set Status = @Status, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID Where ItemID = @ItemID And Status>-1 



IF (Select ItemType from ItemMain Where ItemID =@ItemID) = 2
BEGIN
Update ItemMain Set Status = @Status, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID Where LinkNo = @ItemID And Status>-1 
Update ItemStore Set Status = @Status, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID Where ItemNo IN (Select ItemID From ItemMain Where LinkNo = @ItemID) And Status>-1 
END

if @status> 0
BEGIN
	declare @S nvarchar(2000)
	declare @T nvarchar(50)
	SET @S= ' '
	declare B cursor  for select ItemStoreID from ItemStore WHERE ItemNo = @ItemID
	OPEN B
	fetch next from B into @StoreID
	while @@fetch_status = 0 begin
		SET @T= CONVERT(uniqueidentifier,@StoreID)
		SET @S= @S + ''''+@T+''','
		fetch next from B into @StoreID
	end
	close B
	deallocate B
    
	SET @S= 'DELETE FROM DeleteRecordes where TableID IN('+LEFT(@S,Len(@S)-1)+')'
	exec(@S)
END

--Declare @ActivityID Uniqueidentifier
--Declare @ActivityNo int
--Declare @TableName int

--Set @ActivityID = NewID()
--set @ActivityNo = 1
--set @TableName = 1

----Alex Abreu
----Insert the Activity 
--INSERT INTO [dbo].[Activity]
--           ([ActivityID]
--           ,[ActivityNo]
--           ,[TableName]
--           ,[UserID]
--           ,[Status]
--           ,[Description]
--		   ,[RowID])
--     VALUES
--           (@ActivityID,@ActivityNo,@TableName,@ModifierID,@Status,@VoidReason,@ItemID)
GO