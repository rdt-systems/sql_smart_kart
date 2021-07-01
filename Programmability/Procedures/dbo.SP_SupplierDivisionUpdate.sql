SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierDivisionUpdate]
(@TransactionID uniqueidentifier,
@ApplyAmount money,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier
)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.SupplierDivision
SET             ApplyAmount = @ApplyAmount,
                Status = @Status,
                DateModified = @UpdateTime, 
                UserModified = @ModifierID
WHERE     (TransactionID = @TransactionID) AND (DateModified = @DateModified OR
                      DateModified IS NULL)

select @UpdateTime as DateModified
GO