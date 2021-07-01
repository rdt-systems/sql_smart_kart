SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_CustomerMemberCardsUpdate]
(@CardID uniqueidentifier,
@CustomerID uniqueidentifier,
@CardNumber varchar(200),
@HolderName nvarchar(200),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS


Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

update  CustomerMemberCards
set 	
	CustomerID=@CustomerID,
	CardNumber=@CardNumber,
	HolderName=@HolderName,
	Status=@Status,
	DateModified= @UpdateTime,
	UserModified=@ModifierID

where  (CardID=@CardID)
	and (DateModified = @DateModified OR DateModified IS NULL)

Update Customer Set LoyaltyMembertype =1, DateModified =dbo.GetLocalDATE() Where CustomerID = @CustomerID AND ISNULL(LoyaltyMembertype,0) =0

select @UpdateTime as DateModified
GO