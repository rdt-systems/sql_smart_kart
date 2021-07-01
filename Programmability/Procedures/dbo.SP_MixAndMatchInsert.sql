SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MixAndMatchInsert]
(@MixAndMatchID uniqueidentifier,
@Name nvarchar(50),
@Qty int,
@Amount money,
@AssignDate bit,
@StartDate datetime,
@EndDate datetime,
@MinTotalSale money,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.MixAndMatch
                      (MixAndMatchID, [Name], Qty,Amount,AssignDate,StartDate,EndDate,MinTotalSale, Status, DateCreated, UserCreated, 
                      DateModified, UserModified)
VALUES     (@MixAndMatchID, @Name, @Qty, @Amount,@AssignDate,@StartDate,@EndDate,@MinTotalSale, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO