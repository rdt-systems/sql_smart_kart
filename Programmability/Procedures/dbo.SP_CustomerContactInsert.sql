SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerContactInsert]
(@CustomerContactID uniqueidentifier,
@CustomerID uniqueidentifier,
@FirstName nvarchar(50),
@LastName nvarchar(50),
@SortOrder smallint,
@Password nvarchar(50),
@CardMember nvarchar(50),
@Phone1 nvarchar(20),
@Phone2 nvarchar(20),
@Emeil nvarchar(20),
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.CustomerContact
                      (CustomerContactID, CustomerID,    FirstName,    LastName,    SortOrder,   Password,    CardMember,      Phone1,    Phone2,    Emeil, Status, DateModified)
VALUES     (@CustomerContactID, @CustomerID, dbo.CheckString(@FirstName), dbo.CheckString(@LastName), @SortOrder, @Password, @CardMember,  @Phone1, @Phone2, @Emeil, 1,    dbo.GetLocalDATE())
GO