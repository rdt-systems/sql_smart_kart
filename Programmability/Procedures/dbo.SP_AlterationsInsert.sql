SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		@Nathan Ehrenthal 
-- ALTER date: @10/20/1215 
-- Description:	@Inset into Alterations table 
-- =============================================
CREATE procedure [dbo].[SP_AlterationsInsert]
           @AlterationNo nvarchar(20),
           @TransactionID uniqueidentifier,
           @TransactionEntryID uniqueidentifier, 
           @AlterationStatus smallint, 
           @AlterationType int, 
           @Note ntext, 
           @ExpectedDate datetime, 
           @ConveyorID int =null,
		   @StoreID uniqueidentifier= NULL,
		   @Rack int = null,
		   @Row int =null,
           @Status smallint, 
		   @ModifierID uniqueidentifier
AS

DECLARE @UpdateTime datetime
DECLARE @newId int
DECLARE @vConveyorID int
	set  @UpdateTime =dbo.GetLocalDATE()
	if @ConveyorID is null 
	BEGIN
	  IF @StoreID IS NULL BEGIN
	    SET @vConveyorID =(SELECT TOP(1) ConveyorID FROM Conveyor WHERE RackNo =@Rack AND RowNo =@Row)
      END 
	  ELSE
	    SET @vConveyorID =(SELECT ConveyorID FROM Conveyor WHERE RackNo =@Rack AND RowNo =@Row AND StoreID=@StoreID)
	END  
	ELSE
      SET @vConveyorID =@ConveyorID 


INSERT INTO [dbo].[Alterations]
           ([AlterationNo]
		   ,[TransactionID]
           ,[TransactionEntryID]
           ,[AlterationStatus]
           ,[AlterationType]
           ,[Note]
           ,[ExpectedDate]
           ,[ConveyorID]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated])
     VALUES
           (@AlterationNo
		   ,@TransactionID
           ,@TransactionEntryID
           ,@AlterationStatus
           ,@AlterationType
           ,@Note
           ,@ExpectedDate
           ,@vConveyorID
           ,@Status
		   ,@UpdateTime
		   ,@ModifierID
        )

select @newId = Scope_Identity()
GO