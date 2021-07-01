SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PPCPrintView]
AS
SELECT     PrintType, IsSystem, RowsNumberInPage, LetterSize, LeftMargin, RightMargin, TopMargin, BottomMargin, PageBreak, HeightLine, PrintLogo, Logo, 
                      LogoX, LogoY, LogoSizeHeight, LogoSizeWidth, StoreNameFontSize, StoreNameX, StoreNameY, PropertiesAddressFontSize, PropertiesAddressX, 
                      ItemsTableY, QtyCaption, QtyX, QtyLettersNumber, ItemCodeCaption, ItemCodeX, ItemCodeLettersNumber, ItemNameCaption, ItemNameX, 
                      ItemNameLettersNumber, PicesOrCasesCaption, PicesOrCasesX, PicesOrCasesLettersNumber, PriceCaption, PriceX, PriceLettersNumber, 
                      TotalCaption, TotalX, TotalLettersNumber, Line1V, Line2V, Line3V, Line4V, Line5V, Line6V, Line7V, LinesHorizontalStart, LinesHorizontalEnd, Line1H, 
                      Line2H, TotalsX, PaymentLine1V, PaymentLine2V, PaymentLine3V, PaymentLine4V, PaymentLine5V, PaymentLine6V, PaymentLinesHorizontalStart, 
                      PaymentLinesHorizontalEnd, PaymentLine1H, PaymentLine2H, DateCaption, DateX, DateLettersNumber, NoCaption, NoX, NoLettersNumber, 
                      DebitCaption, DebitX, DebitLettersNumber, ApplyAmountCaption, ApplyAmountX, ApplyAmountLettersNumber, BalanceCaption, BalanceX, 
                      BalanceLettersNumber, PrintSignature, SignatureX, SignatureY, SignatureHeight, SignatureWidth, Status, DateCreated, UserCreated, DateModified, 
                      UserModified
FROM         dbo.PPCPrint
GO