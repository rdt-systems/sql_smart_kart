SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierTenderEntryInsert]
(@SuppTenderEntryID uniqueidentifier,
@SuppTenderNo nvarchar(50),
@StoreID uniqueidentifier,
@SupplierID uniqueidentifier,
@TenderID int,
@Amount money,
@Common1 nvarchar(50),
@Common2 nvarchar(50),
@Common3 nvarchar(50),
@Common4 nvarchar(50),
@Common5 nvarchar(50),
@Common6 nvarchar(50),
@TenderDate datetime,
@Status smallint,
@ModifierID uniqueidentifier)
 as INSERT INTO dbo.SupplierTenderEntry
                      (SuppTenderEntryID,SuppTenderNo,StoreID,SupplierID, TenderID, Amount, Common1, Common2, Common3, Common4, Common5, Common6, TenderDate, Status, DateCreated, 
                      UserCreated, DateModified, UserModified)
VALUES     (@SuppTenderEntryID,@SuppTenderNo,@StoreID,@SupplierID, @TenderID, @Amount, @Common1, @Common2, @Common3, @Common4, @Common5, @Common6, @TenderDate, 
                      1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO