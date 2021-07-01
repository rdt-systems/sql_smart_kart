SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TenderEntryInsert]
(@TenderEntryId uniqueidentifier,
@TenderID int,
@TransactionID uniqueidentifier,
@Amount money,
@Common1 nvarchar(50),
@Common2 nvarchar(50),
@Common3 nvarchar(50),
@Common4 nvarchar(50),
@Common5 nvarchar(50),
@Common6 nvarchar(50),
@TenderDate datetime,
@Status smallint,
@ModifierID uniqueidentifier,
@TransactionType int = 0)
AS

declare @date datetime
set @date=dbo.GetLocalDATE()
 
IF (SELECT COUNT(*) FROM TenderEntry WHERE TenderEntryID=@TenderEntryId)>0
RETURN
INSERT INTO dbo.TenderEntry
                      (TenderEntryID, TenderID, TransactionID, Amount, Common1, Common2, Common3, Common4, Common5, Common6,TenderDate, Status, DateCreated, 
                      UserCreated, DateModified, UserModified, TransactionType)
VALUES     (@TenderEntryID, @TenderID, @TransactionID, @Amount, @Common1, @Common2, @Common3, @Common4, @Common5, @Common6,@TenderDate, 1, 
                      @date, @ModifierID, @date, @ModifierID, @TransactionType)


--INSERT INTO dbo.W_TenderEntry
--                      (TenderEntryID, TenderID, TransactionID, Amount, Common1, Common2, Common3, Common4, Common5, Common6,TenderDate, Status, DateCreated, 
--                      UserCreated, DateModified, UserModified, TransactionType)
--VALUES     (@TenderEntryID, @TenderID, @TransactionID, @Amount, @Common1, @Common2, @Common3, @Common4, @Common5, @Common6,@TenderDate, 1, 
--                      @date, @ModifierID, @date, @ModifierID, @TransactionType)
GO