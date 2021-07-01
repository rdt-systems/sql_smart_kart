SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_LookAccountInsert]
(@LookAccountID uniqueidentifier,
@CustomerID nvarchar(50),
@DaysOver nvarchar(50),
@Ammount money,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.LookAccount
                      (LookAccountID, CustomerID, DaysOver, Ammount, Status, DateModified, UserModified)
VALUES     (@LookAccountID, @CustomerID, @DaysOver, @Ammount, 1, dbo.GetLocalDATE(), @ModifierID)
GO