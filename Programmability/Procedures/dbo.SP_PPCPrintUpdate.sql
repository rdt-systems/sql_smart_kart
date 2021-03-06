SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_PPCPrintUpdate]
(@PrintType	int,	
@IsSystem	bit	,
@RowsNumberInPage	int,	
@LetterSize	decimal(19,3),
@LeftMargin	decimal(19,3),
@RightMargin	decimal(19,3),
@TopMargin	decimal(19,3),
@BottomMargin	decimal(19,3),
@PageBreak	bit	,
@LogoSizeHeight	decimal(19,3),
@LogoSizeWidth	decimal(19,3),
@HeightLine	decimal(19,3),
@QtyCaption	nvarchar(50),
@ItemCodeCaption	nvarchar(50),
@ItemNameCaption	nvarchar(50),
@PicesOrCasesCaption	nvarchar(50),
@PriceCaption	nvarchar(50),
@TotalCaption	nvarchar(50),
@PrintLogo bit,
@Logo image,
@LogoX	decimal(19,3),
@LogoY	decimal(19,3),
@StoreNameFontSize	decimal(19,3),
@StoreNameX	decimal(19,3),
@StoreNameY	decimal(19,3),
@PropertiesAddressFontSize	decimal(19,3),
@PropertiesAddressX	decimal(19,3),
@ItemsTableY	decimal(19,3),
@QtyX	decimal(19,3),
@QtyLettersNumber	int	,
@ItemCodeX	decimal(19,3),
@ItemCodeLettersNumber	int	,
@ItemNameX	decimal(19,3),
@ItemNameLettersNumber	int,
@PicesOrCasesX	decimal(19,3),
@PicesOrCasesLettersNumber	int	,
@PriceX	decimal(19,3),
@PriceLettersNumber	int	,
@TotalX	decimal(19,3),
@TotalLettersNumber	int	,
@TotalsX	decimal(19,3),
@Line1V	decimal(19,3),
@Line2V	decimal(19,3),
@Line3V	decimal(19,3),
@Line4V	decimal(19,3),
@Line5V	decimal(19,3),
@Line6V	decimal(19,3),
@Line7V	decimal(19,3),
@LinesHorizontalStart decimal(19,3),
@LinesHorizontalEnd decimal(19,3),
@Line1H	decimal(19,3),
@Line2H	decimal(19,3),
@PaymentLine1V	decimal(19, 3),
@PaymentLine2V	decimal(19, 3),	
@PaymentLine3V	decimal(19, 3),	
@PaymentLine4V	decimal(19, 3),	
@PaymentLine5V	decimal(19, 3),	
@PaymentLine6V	decimal(19, 3),	
@PaymentLinesHorizontalStart	decimal(19, 3),
@PaymentLinesHorizontalEnd	decimal(19, 3)	,
@PaymentLine1H	decimal(19, 3)	,
@PaymentLine2H	decimal(19, 3)	,
@DateCaption	nvarchar(50)	,
@DateX	decimal(19, 3)	,
@DateLettersNumber	int	,
@NoCaption	nvarchar(50),	
@NoX	decimal(19, 3)	,
@NoLettersNumber	int	,
@DebitCaption	nvarchar(50),	
@DebitX	decimal(19, 3)	,
@DebitLettersNumber	int	,
@ApplyAmountCaption	nvarchar(50)	,
@ApplyAmountX	decimal(19, 3)	,
@ApplyAmountLettersNumber	int,
@BalanceCaption	nvarchar(50),	
@BalanceX	decimal(19, 3),
@BalanceLettersNumber int,
@PrintSignature	bit	,
@SignatureX	decimal(19, 3),
@SignatureY	decimal(19, 3)	,
@SignatureHeight	decimal(19, 3)	,
@SignatureWidth	decimal(19, 3)	,
@Status	smallint,
@DateModified datetime,
@ModifierID	uniqueidentifier)

as 
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

update dbo.PPCPrint
set
PrintType=@PrintType,
IsSystem =@IsSystem	,
RowsNumberInPage =@RowsNumberInPage,
LetterSize =@LetterSize,
LeftMargin =@LeftMargin,
RightMargin =@RightMargin,
TopMargin =@TopMargin,
BottomMargin =@BottomMargin,
PageBreak =@PageBreak,
LogoSizeHeight =@LogoSizeHeight,
LogoSizeWidth =@LogoSizeWidth,
HeightLine =@HeightLine,
QtyCaption =@QtyCaption,
ItemCodeCaption =@ItemCodeCaption,
ItemNameCaption	=@ItemNameCaption,
PicesOrCasesCaption =@PicesOrCasesCaption,
PriceCaption =@PriceCaption,
TotalCaption =@TotalCaption,
PrintLogo=@PrintLogo,
Logo=@Logo,
LogoX =@LogoX,
LogoY =@LogoY,
StoreNameFontSize =@StoreNameFontSize,
StoreNameX =@StoreNameX,
StoreNameY =@StoreNameY,
PropertiesAddressFontSize =@PropertiesAddressFontSize,
PropertiesAddressX =@PropertiesAddressX	,
ItemsTableY  =@ItemsTableY,
QtyX =@QtyX,
QtyLettersNumber =@QtyLettersNumber,
ItemCodeX =@ItemCodeX,
ItemCodeLettersNumber =@ItemCodeLettersNumber,
ItemNameX =@ItemNameX,
ItemNameLettersNumber =@ItemNameLettersNumber,
PicesOrCasesX =@PicesOrCasesX,
PicesOrCasesLettersNumber =@PicesOrCasesLettersNumber,
PriceX =@PriceX,
PriceLettersNumber =@PriceLettersNumber	,
TotalX =@TotalX,
TotalLettersNumber =@TotalLettersNumber,
TotalsX =@TotalsX,
Line1V=@Line1V,
Line2V=@Line2V,
Line3V=@Line3V,
Line4V=@Line4V,
Line5V=@Line5V,
Line6V=@Line6V,
Line7V=@Line7V,
LinesHorizontalStart=@LinesHorizontalStart,
LinesHorizontalEnd=@LinesHorizontalEnd,
Line1H=@Line1H,
Line2H=@Line2H,
PaymentLine1V=@PaymentLine1V,
PaymentLine2V=@PaymentLine2V,
PaymentLine3V=@PaymentLine3V,
PaymentLine4V=@PaymentLine4V,
PaymentLine5V=@PaymentLine5V,
PaymentLine6V=@PaymentLine6V,
PaymentLinesHorizontalStart=@PaymentLinesHorizontalStart,
PaymentLinesHorizontalEnd=@PaymentLinesHorizontalEnd,
PaymentLine1H=@PaymentLine1H,
PaymentLine2H=@PaymentLine2H,
DateCaption=@DateCaption,
DateX=@DateX,
DateLettersNumber=@DateLettersNumber,
NoCaption=@NoCaption,
NoX=@NoX,
NoLettersNumber=@NoLettersNumber,
DebitCaption=@DebitCaption,
DebitX=@DebitX,
DebitLettersNumber=@DebitLettersNumber,
ApplyAmountCaption=@ApplyAmountCaption,
ApplyAmountX=@ApplyAmountX,
ApplyAmountLettersNumber=@ApplyAmountLettersNumber,
BalanceCaption=@BalanceCaption,
BalanceX=@BalanceX,
BalanceLettersNumber=@BalanceLettersNumber,
PrintSignature=@PrintSignature,
SignatureX=@SignatureX,
SignatureY=@SignatureY,
SignatureHeight=@SignatureHeight,
SignatureWidth=@SignatureWidth,
Status =@Status,
DateModified=@UpdateTime,
UserModified=@ModifierID

 WHERE (PrintType=@PrintType)
and(IsSystem =@IsSystem)
and (DateModified=@DateModified or @Datemodified is null)

select @UpdateTime as DateModified
GO