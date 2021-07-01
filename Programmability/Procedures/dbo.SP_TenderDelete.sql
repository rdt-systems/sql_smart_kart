SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TenderDelete]
(@TenderId int,
@ModifierID uniqueidentifier)

AS 

UPDATE dbo.Tender
                    

SET   
	Status = -1,   
	DateModified = dbo.GetLocalDATE(), 
	UserModified  =@ModifierID
                   
WHERE   TenderId  = @TenderId
GO