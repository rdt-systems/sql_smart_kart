SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierContactInsert]
(@ContactNameID uniqueidentifier,
@TitleContactID uniqueidentifier,
@FirstName nvarchar(20),
@MiddleName nvarchar(20),
@LastName nvarchar(30),
@SuffixID uniqueidentifier,
@SupplierNo uniqueidentifier,
@JobTitle nvarchar(20),
@Department nvarchar(50),
@Description nvarchar(4000),
@SortOrder smallint,
@Status smallint,
@ModifierID uniqueidentifier)

AS
--INSERT INTO dbo.ContactName
--                      (ContactNameID, TitleContactID , FirstName, MiddleName, LastName, SuffixID, Status, DateCREATE, UserCREATE,DateModified, UserModified)
--VALUES     (@ContactNameID, @TitleContactID , @FirstName, @MiddleName, @LastName, @SuffixID, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)


INSERT INTO dbo.SupplierContact
                      (SuplierContactID, SupplierNo, ContactNo, JobTitle, Department, [Description], SortOrder, Status, DateModified)
VALUES     (NEWID(), @SupplierNo, @ContactNameID, @JobTitle, @Department, @Description, @SortOrder, 1, dbo.GetLocalDATE())
GO