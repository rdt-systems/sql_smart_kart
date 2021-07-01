SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create procedure [dbo].[SP_OnePHOForPickSheet]

@PHOID uniqueidentifier

as

Select * from PhoneOrderPickSheet
where PhoneOrderID = @PHOID
GO