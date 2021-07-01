SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierContactUpdate]
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
@DateModified datetime,
@ModifierID uniqueidentifier)

AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


--UPDATE dbo.ContactName
--SET	TitleContactID = @TitleContactID , FirstName = @FirstName, MiddleName = @MiddleName, LastName = @LastName, SuffixID = @SuffixID , Status = @Status, DateModified = @UpdateTime, UserModified = @ModifierID
--WHERE ContactNameID = @ContactNameID


UPDATE dbo.SupplierContact
SET	SupplierNo = @SupplierNo, JobTitle = @JobTitle, Department = @Department, Description = @Description, SortOrder = @SortOrder, Status = @Status, DateModified = @UpdateTime
WHERE (ContactNo = @ContactNameID) and  (DateModified = @DateModified or DateModified is NULL)

select @UpdateTime as DateModified
GO