SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SetUpValuesUpdate]
(@OptionID int,
 @CategoryID smallint,
 @OptionName varchar(50),
 @StoreID uniqueidentifier,
 @OptionValue varchar(4000),
 @OptionValueHe varchar(4000),
 @Status smallint,
 @DateModified datetime,
 @ModifierID uniqueidentifier=null ,
 @SaveAll bit)

as
 
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


if @SaveAll=1
	
	update dbo.SetUpValues
	set 
		CategoryID=@CategoryID,
		OptionValue=@OptionValue,
		OptionValueHe=@OptionValueHe,
		Status = @Status ,
		DateModified =@UpdateTime,
		UserModified =@ModifierID
	Where 
		OptionName=@OptionName 


else
	update dbo.SetUpValues
	set 
		CategoryID=@CategoryID,
		OptionValue=@OptionValue,
		OptionValueHe=@OptionValueHe,
		Status = @Status ,
		DateModified =@UpdateTime,
		UserModified =@ModifierID
	Where 
		OptionName=@OptionName and StoreID=@StoreID -- and  
--		(DateModified = @DateModified or DateModified is NULL)

select @UpdateTime as DateModified
GO