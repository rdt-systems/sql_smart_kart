SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  

 PROCEDURE [dbo].[SP_CustomerToPhoneUpdate]
(@CostumerToPhoneID uniqueidentifier,
@CostumerID uniqueidentifier,
@PhoneType  int,
@PhoneNumber  nvarchar (20),
@SortOrder smallint,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


 UPDATE dbo.CustomerToPhone
                      
SET    CostumerID= @CostumerID, Status=@Status, DateModified=@UpdateTime

WHERE (CostumerToPhoneID=@CostumerToPhoneID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)

UPDATE  dbo.phone
	
SET	  PhoneType= @PhoneType, PhoneNumber=@PhoneNumber, SortOrder=@SortOrder, Status=@Status,     DateModified= @UpdateTime

WHERE  phoneID=(SELECT phoneID FROM  dbo.CustomerToPhone WHERE CostumerToPhoneID=@CostumerToPhoneID) 




select @UpdateTime as DateModified
GO