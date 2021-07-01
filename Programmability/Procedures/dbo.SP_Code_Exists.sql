SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_Code_Exists]
(@ItemID uniqueidentifier,
 @Code nvarchar(50))
As 

declare @msg nvarchar(50)
declare @vMsg nvarchar(50)
Set @msg =''
if (select Count(1) from dbo.ItemMain WHERE ItemID <> @ItemID AND (ModalNumber = @Code or BarcodeNumber=@Code or CaseBarcodeNumber=@Code or CaseBarcode=@Code) and Status>-1 AND ItemID <>@ItemID)>0
BEGIN
	if (select Count(1) from dbo.ItemMain WHERE ItemID <> @ItemID AND ( BarcodeNumber=@Code and status=0))>0
	  set @msg ='Upc '+@Code+' Exist and it is Inactive'
	Else if (select Count(1) from dbo.ItemMain WHERE ItemID <> @ItemID AND  BarcodeNumber=@Code)>0
	  set @msg ='Upc '+@Code+' Exist'
	else if (select Count(1) from dbo.ItemMain WHERE ItemID <> @ItemID AND  ModalNumber=@Code)>0
	  set @msg ='Model Number '+@Code+' Exist'
	else if (select Count(1) from dbo.ItemMain WHERE ItemID <> @ItemID AND  CaseBarcodeNumber=@Code)>0
	  set @msg ='Case Code '+@Code+' Exist'
END
ELSE
  IF (select Count(1) from dbo.ItemAlias where ( ItemNo <> @ItemID AND (BarcodeNumber = @Code and Status>-1)))>0
  BEGIN
    set @vMsg =(select top(1) BarcodeNumber from ItemMain where ItemID <> @ItemID AND ( Status>-1 and ItemID in(select ItemNo from dbo.ItemAlias where (BarcodeNumber = @Code and Status>-1))))
    IF @vMsg is not null
		set @msg ='Alias '+@Code+' Exist In item '+@vMsg
  END
  ELSE IF (select Count(1) from dbo.Discounts where (UPCDiscount = @Code and Status>-1)) >0
    set @msg ='Discount '+@Code+' Exist'
  ELSE
    Set @msg =''

-- make sure the item was created without ItemStore
if @msg <>''
  DELETE FROM ItemMain where ItemID not in(Select ItemNo From ItemStore)
	
SELECT IsNull(@msg,'')
GO