SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PayTenderInsert]
(@PayTenderID uniqueidentifier,
@AccountPaymentID uniqueidentifier,
@Amount money,
@PayType int,
@PayNo nvarchar(50),
@AccountNO nvarchar(50),
@CodeNO nvarchar(50),
@CodeNO2 nvarchar(50),
@PayDate DateTime,
@SortOrder smallint,
@Note  nvarchar(4000),
@Status smallint,
@ModifierID uniqueidentifier)



AS INSERT INTO dbo.PayTender
                     (PayTenderID, AccountPaymentID,    Amount,      PayType,        PayNo,    AccountNO,     CodeNO,        CodeNO2,      PayDate,     SortOrder,   Note,    Status, DateCreated, UserCreated, DateModified, UserModified)

VALUES     (@PayTenderID, @AccountPaymentID, @Amount, @PayType,    @PayNo,      @AccountNO,     @CodeNO,  @CodeNO2,    @PayDate, @SortOrder, @Note,     1,          dbo.GetLocalDATE(),     @ModifierID,    dbo.GetLocalDATE(),       @ModifierID)
GO