SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TenderUpdate]
(@TenderId int,
@TenderGroup int,
@SortOrder smallint,
@TenderType int,
@TenderName nvarchar(50),
@TenderNameHe nvarchar(50)=null,
@TenderDescription varchar(4000),
@RequiresCustomer bit,
@AllowDiscount bit,
@FillByPressEnter bit,
@OpenDrawer bit,
@MinimumAmount varchar(30),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@GivePoints bit,
@OverTender bit,
@AllowMinus bit,
@NoChange bit,
@ShowOnPhoneOrder bit)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.Tender
                    

SET   
	SortOrder = @SortOrder, 
	TenderGroup = @TenderGroup, 
	TenderType = @TenderType, 
	TenderName =  dbo.CheckString(@TenderName), 
	@TenderName=@TenderNameHe,
    TenderDescription = dbo.CheckString(@TenderDescription),
	RequiresCustomer=@RequiresCustomer ,
	AllowDiscount=@AllowDiscount ,
	FillByPressEnter=@FillByPressEnter ,
	OpenDrawer=@OpenDrawer,
             MinimumAmount =@MinimumAmount, 
	Status = @Status,   
	DateModified = @UpdateTime, 
	UserModified  =@ModifierID,
    GivePoints   =@GivePoints,
OverTender =@OverTender,
AllowMinus =@AllowMinus,
NoChange = @NoChange,
ShowOnPhoneOrder = @ShowOnPhoneOrder 
                   
WHERE   (TenderId  = @TenderId) --and  (DateModified = @DateModified or DateModified is NULL)


select @UpdateTime as DateModified
GO