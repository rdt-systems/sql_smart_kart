SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaleToClubUpdate]
(
@SaleToClubID	uniqueidentifier,
@SaleID	uniqueidentifier,	
@ClubID	uniqueidentifier,	
@Status	smallint,	
@DateModified datetime,	
@ModifierID uniqueidentifier
)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.SaleToClub
SET           
SaleToClubID=@SaleToClubID	,
SaleID=@SaleID	,	
ClubID=@ClubID	,	
Status=@Status,
DateModified =@UpdateTime,
UserModified = @ModifierID	
                    
WHERE     
(SaleToClubID = @SaleToClubID) AND 
(DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO