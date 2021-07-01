SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PhoneUpdate]
(@PhoneID uniqueidentifier,
@PhoneType int,
@PhoneNumber nvarchar(50),
@SortOrder smallint,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.Phone
SET              PhoneType = @PhoneType, PhoneNumber = @PhoneNumber, SortOrder = @SortOrder, 
                      Status = @Status, DateModified = @UpdateTime
WHERE (PhoneID = @PhoneID) and  (DateModified = @DateModified or DateModified is NULL)




select @UpdateTime as DateModified
GO