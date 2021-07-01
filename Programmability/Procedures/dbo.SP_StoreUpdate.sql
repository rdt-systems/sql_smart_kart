SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_StoreUpdate]
(@StoreID uniqueidentifier,
@StoreName nvarchar(50),
@StoreDescription nvarchar(4000),
@ParentStore uniqueidentifier,
@DefaultMarkup numeric(28,3),
@DefaultMarkupA numeric(28,3),
@DefaultMarkupB numeric(28,3),
@DefaultMarkupC numeric(28,3),
@DefaultMarkupD numeric(28,3),
@RoundUp int,
@RoundValue decimal(9, 3),
@DefaultCogsAccount int,
@DefaultIncomeAccount int,
@DefaultTaxNo uniqueidentifier,
@IsDefaultTaxInclude bit,
@DefaultProfitCalculation int,
@StoreEmail nvarchar (50),
@StoreNumber nvarchar(20) =NULL,
@Address nvarchar(50)= NULL,
@CityStateZip nvarchar(50)= NULL,
@Country nchar(10) =NULL,
@Phone1 nvarchar(50)= NULL,
@Fax nvarchar(20)= NULL,
@Phone2 nvarchar(20) =NULL,
@CashDiscount decimal(18,4) = NULL,
@DistrictID uniqueidentifier =NULL,
@RegionID uniqueidentifier =NULL,
@DateOpened datetime = NULL,
@DateClosed datetime =NULL,
@Logo image = null,
@IsMainStore bit = null,
@LogoPath nvarchar(500) = NULL,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier
)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.Store
SET              StoreName=dbo.CheckString(@StoreName),StoreDescription = dbo.CheckString(@StoreDescription), ParentStore = @ParentStore, DefaultMarkup = @DefaultMarkup,DefaultMarkupA = @DefaultMarkupA, DefaultMarkupB = @DefaultMarkupB, DefaultMarkupC = @DefaultMarkupC, DefaultMarkupD = @DefaultMarkupD,  RoundUp = @RoundUp, RoundValue = @RoundValue, 
                      DefaultCogsAccount = @DefaultCogsAccount, DefaultIncomeAccount = @DefaultIncomeAccount, DefaultTaxNo = @DefaultTaxNo, 
                      IsDefaultTaxInclude = @IsDefaultTaxInclude, DefaultProfitCalculation = @DefaultProfitCalculation, StoreEmail = @StoreEmail, Status = @Status, DateModified = @UpdateTime, 
                      UserModified = @ModifierID  , Storenumber =  @StoreNumber, Address = @Address, CityStateZip = @CityStateZip, Country = @Country, Phone1 = @Phone1,
Fax = @Fax ,Phone2 = @Phone2,CashDiscount = @CashDiscount, DistrictID= @DistrictID, RegionID = @RegionID, DateOpened = @DateOpened , DateClosed = @DateClosed , IsMainStore = @IsMainStore , Logo = @Logo, LogoPath = @LogoPath

WHERE    (StoreID=@StoreID) and  (DateModified = @DateModified or DateModified is NULL)

select @UpdateTime as DateModified
GO