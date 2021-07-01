SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_OnePHOEntryForPickSheet]

@PHOID uniqueidentifier

as

If (Select Count(*) From Store Where StoreID = 'CECE2869-DEC8-4B9E-BE8B-D74CC24661A6') >0 --Shlomies
Begin
Select * from PhoneOrderEntryPickSheet
where PhoneOrderID = @PHOID and status > -1
Order by ManufacturerPartNo, ModalNumber
End
ELSE IF (Select Count(*) From Store Where StoreID = '1596C497-519F-4809-A5A6-B9117BB89000') >0 --Yellow Basket
Begin
Select * from PhoneOrderEntryPickSheet
where PhoneOrderID = @PHOID and status > -1
Order by Department
End
Else Begin
Select * from PhoneOrderEntryPickSheet
where PhoneOrderID = @PHOID and status > -1
Order by SortOrder
End
GO