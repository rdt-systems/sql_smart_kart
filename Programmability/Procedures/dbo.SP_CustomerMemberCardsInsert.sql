SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_CustomerMemberCardsInsert]
(@CardID uniqueidentifier,
@CustomerID uniqueidentifier,
@CardNumber varchar(200),
@HolderName nvarchar(200),
@Status smallint,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

	INSERT INTO CustomerMemberCards
           (CardID,CustomerID,CardNumber,HolderName
           ,Status,DateCreated,UserCreated,DateModified,UserModified)
     VALUES
           (@CardID ,@CustomerID ,@CardNumber ,@HolderName
           ,1,@UpdateTime,@ModifierID,@UpdateTime,@ModifierID)

Update Customer Set LoyaltyMembertype =1, DateModified =dbo.GetLocalDATE() Where CustomerID = @CustomerID AND ISNULL(LoyaltyMembertype,0) =0

select @UpdateTime as DateModified
GO