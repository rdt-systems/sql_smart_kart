SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftInsert]
( @GiftID uniqueidentifier,
@GiftNumber nvarchar(50),
@CustomerID uniqueidentifier,
@Amount money,
@GiftType int,
@GiftDate datetime,
@Status smallint,
@ModifierID uniqueidentifier)
AS
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

INSERT INTO dbo.Gift
            (GiftID, GiftNumber, CustomerID, Amount, GiftType ,GiftDate, 
			Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@GiftID, @GiftNumber, @CustomerID, @Amount, @GiftType , @GiftDate, 
			1, @UpdateTime, @ModifierID, @UpdateTime, @ModifierID)


select @UpdateTime as DateModified
GO