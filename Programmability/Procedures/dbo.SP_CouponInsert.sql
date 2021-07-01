SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CouponInsert]
(@CouponID uniqueidentifier,
@CouponNo nvarchar(50),
@CustomerID uniqueidentifier=null,
@Amount money,
@CouponIssueDate datetime,
@ExpDate datetime,
@CouponDate datetime,
@PurchaseWeek datetime=null,
@Status smallint=1,
@Notes nvarchar(500)=null,
@CouponType int,
@TransactionID uniqueidentifier=null)
AS

SET XACT_ABORT ON;
	BEGIN TRANSACTION
	declare @OldID uniqueidentifier
	set @OldID=  @CouponID
	if ((select Count(*) from [Coupon] where [CouponNo]=@CouponNo and Status>-1 AND [CouponType]=@CouponType)> 0)
	BEGIN
		UPDATE [dbo].[Coupon]
		   SET [Amount] = [Amount]+@Amount
			  ,[ExpDate] = @ExpDate
			  ,[CouponIssueDate] = @CouponIssueDate
			  ,[Status] = 1
			  --,[Notes] = [Notes]+' '+@Notes
			  ,[TransactionID] = @TransactionID
              ,[DateModified]  = dbo.GetLocalDATE()
		WHERE [CouponNo]= @CouponNo
		set @OldID= (select Top(1) Couponid from Coupon where [CouponNo]=@CouponNo AND [CouponType]=@CouponType)
	END 
	ELSE BEGIN
		INSERT INTO [dbo].[Coupon]
				   ([Amount]
				   ,[CouponNo]
				   ,[ExpDate]
				   ,[CouponIssueDate]
				   ,[CouponID]
				   ,[CustomerID]
				   ,[PurchaseWeek]
				   ,[Status]
				   ,[Notes]
				   ,[CouponDate]
				   ,[CouponType]
				   ,[TransactionID])
			 VALUES
				   (@Amount, 
					@CouponNo,
					@ExpDate, 
					@CouponIssueDate, 
					@CouponID, 
					@CustomerID,
					@PurchaseWeek,
					@Status, 
					@Notes,
					@CouponDate,
					@CouponType,
					@TransactionID)
	END

	INSERT INTO [CouponUsed]
	   ([CouponUsedID]  
	   ,[CouponID]      
	   ,[TransactionID] 
	   ,[Amount] 
	   ,[AmountAdd]        
	   ,[UsedDate]      
	   ,[Status]        
	   ,[DateCreated])  
	VALUES       
		  (NEWID()
		  ,@OldID
		  ,@TransactionID
		  ,0
		  ,@Amount
		  ,@CouponDate
		  ,1
		  ,dbo.GetLocalDATE())
	COMMIT TRANSACTION;
GO