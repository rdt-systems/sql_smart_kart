SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TaxUpdate]
(@TaxID uniqueidentifier,
@TaxName nvarchar(50),
@TaxDescription nvarchar(4000),
@TaxRate decimal(19,4),
@FromAmount	money =null,
@Amount2	money	=null,
@TaxRate2	decimal(18, 4)	=null,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Update dbo.Tax
               
SET  TaxName=dbo.CheckString(@TaxName),TaxDescription=  dbo.CheckString(@TaxDescription), TaxRate =@TaxRate,FromAmount=@FromAmount,Amount2=@Amount2,TaxRate2=@TaxRate2,  Status =@Status,   DateModified =@UpdateTime,  UserModified =@ModifierID

Where (TaxID = @TaxID) and  (DateModified = @DateModified or DateModified is NULL)


select @UpdateTime as DateModified
GO