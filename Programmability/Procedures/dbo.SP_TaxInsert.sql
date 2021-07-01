SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TaxInsert]
(@TaxID uniqueidentifier,
@TaxName nvarchar(50),
@TaxDescription nvarchar(4000),
@TaxRate decimal(19,4),
@FromAmount	money =null,
@Amount2	money	=null,
@TaxRate2	decimal(18, 4)	=null,
@Status smallint,
@ModifierID uniqueidentifier)

AS INSERT INTO dbo.Tax
                      (TaxID, TaxName, TaxDescription, TaxRate, FromAmount,Amount2,TaxRate2,Status,     DateCreated, UserCreated, DateModified, UserModified)
	    

VALUES         (@TaxID, dbo.CheckString(@TaxName), dbo.CheckString(@TaxDescription), @TaxRate, @FromAmount,@Amount2,@TaxRate2, 1,     dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO