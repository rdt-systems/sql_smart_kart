SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TenderInsert]
(
@TenderId int,
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
@Status smallint =1,
@ModifierID uniqueidentifier = NULL,
@GivePoints bit,
@OverTender bit,
@AllowMinus bit,
@NoChange bit,
@ShowOnPhoneOrder bit,
@ShowOnShift bit=1
)
AS 
If (Select Count(*) From Tender) >0
Begin
Insert Into  dbo.Tender(
	TenderId,
	SortOrder , 
	TenderGroup, 
	TenderType , 
	TenderName   , 
    TenderNameHe ,
    TenderDescription  ,
	RequiresCustomer ,
	AllowDiscount,
	FillByPressEnter ,
	OpenDrawer,
    MinimumAmount , 
	Status  ,   
	DateCreated,
	UserCreated,
	DateModified, 
	UserModified,
    GivePoints,
	OverTender,
	AllowMinus,
	NoChange,
	ShowOnPhoneOrder,
	ShowOnShift)

	(Select Max(TenderID)+1 ,
	max(SortOrder)+1, 
	@TenderGroup, 
	@TenderType, 
	@TenderName, 
    @TenderNameHe,
    @TenderDescription,
	@RequiresCustomer ,
	@AllowDiscount ,
	@FillByPressEnter ,
	@OpenDrawer,
    @MinimumAmount, 
	1,   
	dbo.GetLocalDATE(), 
	@ModifierID,
	dbo.GetLocalDATE(), 
	@ModifierID,
    @GivePoints,
	@OverTender,
	@AllowMinus,
	@NoChange,
	@ShowOnPhoneOrder,
	@ShowOnShift from Tender)
End
Else
Begin
Insert Into  dbo.Tender(
	TenderId,
	SortOrder , 
	TenderGroup, 
	TenderType , 
	TenderName   , 
    TenderNameHe ,
    TenderDescription  ,
	RequiresCustomer ,
	AllowDiscount,
	FillByPressEnter ,
	OpenDrawer,
    MinimumAmount , 
	Status  ,   
	DateCreated,
	UserCreated,
	DateModified, 
	UserModified,
    GivePoints,
	OverTender,
	AllowMinus,
	NoChange,
	ShowOnPhoneOrder,
	ShowOnShift)

	Values
	(@TenderId,
	@SortOrder,
	@TenderGroup, 
	@TenderType, 
	@TenderName, 
    @TenderNameHe,
    @TenderDescription,
	@RequiresCustomer ,
	@AllowDiscount ,
	@FillByPressEnter ,
	@OpenDrawer,
    @MinimumAmount, 
	1,   
	dbo.GetLocalDATE(), 
	@ModifierID,
	dbo.GetLocalDATE(), 
	@ModifierID,
    @GivePoints,
	@OverTender,
	@AllowMinus,
	@NoChange,
	@ShowOnPhoneOrder,
	@ShowOnShift)
End

select max(tenderid) from tender
GO