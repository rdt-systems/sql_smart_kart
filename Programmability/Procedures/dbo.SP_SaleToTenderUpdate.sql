SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaleToTenderUpdate]
(
@SaleToTenderID	uniqueidentifier,
@SaleID	uniqueidentifier,	
@TenderID	int,	
@Status	smallint,	
@DateModified datetime,	
@ModifierID uniqueidentifier
)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.SaleToTender
SET           
SaleToTenderID=@SaleToTenderID	,
SaleID=@SaleID	,	
TenderID=@TenderID	,	
Status=@Status,
DateModified =@UpdateTime,
UserModified = @ModifierID	
                    
WHERE     
(SaleToTenderID = @SaleToTenderID) AND 
(DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO