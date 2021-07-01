SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_StoreInsert]
(@StoreID uniqueidentifier, @StoreName nvarchar(50), @StoreDescription nvarchar(4000), @ParentStore uniqueidentifier, @DefaultMarkup numeric(28,3),
@DefaultMarkupA numeric(28,3), @DefaultMarkupB numeric(28,3), @DefaultMarkupC numeric(28,3), @DefaultMarkupD numeric(28,3), @RoundUp int, @RoundValue decimal(9, 3),
@DefaultCogsAccount int, @DefaultIncomeAccount int, @DefaultTaxNo uniqueidentifier, @IsDefaultTaxInclude bit, @DefaultProfitCalculation int, @StoreEmail nvarchar (50),
@StoreNumber nvarchar(20) =NULL,@Address nvarchar(50)= NULL,@CityStateZip nvarchar(50)= NULL,@Country nchar(10) =NULL,@Phone1 nvarchar(50)= NULL,@Fax nvarchar(20)= NULL,
@Phone2 nvarchar(20) =NULL, @CashDiscount decimal(18,4) = NULL,@DistrictID uniqueidentifier =NULL,@RegionID uniqueidentifier =NULL,@DateOpened datetime = NULL,@DateClosed datetime =NULL,@Logo image = null, @LogoPath nvarchar(500) = NULL,
@IsMainStore bit = null,@Status smallint,@ModifierID uniqueidentifier)

AS 

INSERT INTO dbo.Store(StoreID, StoreName, StoreDescription, ParentStore, DefaultMarkup,
DefaultMarkupA,DefaultMarkupB,DefaultMarkupC,DefaultMarkupD, RoundUp, RoundValue, 
DefaultCogsAccount, DefaultIncomeAccount, DefaultTaxNo, IsDefaultTaxInclude, DefaultProfitCalculation,StoreEmail,
StoreNumber,Address ,CityStateZip ,Country , Phone1 , Fax ,
Phone2 , CashDiscount, DistrictID , RegionID , DateOpened , DateClosed , Logo ,LogoPath,
IsMainStore , Status,  DateCreated, UserCreated, DateModified, UserModified)
                  
                      
VALUES (@StoreID, dbo.CheckString(@StoreName), @StoreDescription, @ParentStore, @DefaultMarkup,@DefaultMarkupA,@DefaultMarkupB,@DefaultMarkupC,@DefaultMarkupD, @RoundUp,@RoundValue, @DefaultCogsAccount, @DefaultIncomeAccount, 
                      @DefaultTaxNo, @IsDefaultTaxInclude, @DefaultProfitCalculation,@StoreEmail,
                      @StoreNumber, @Address , @CityStateZip , @Country , @Phone1 , @Fax ,
                      @Phone2 , @CashDiscount, @DistrictID , @RegionID , @DateOpened , @DateClosed , @Logo , @LogoPath, @IsMainStore ,
                       1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO