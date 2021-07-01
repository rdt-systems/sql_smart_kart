SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSearchView]
(@Filter nvarchar(4000))

AS
Declare @MySelect  nvarchar (3888)
Set @MySelect = '
                   SELECT DISTINCT ItemID,Name,Description,ModalNumber,Department,Quantization,Unit,ParentID,MatrixName,LinkNo,BarcodeNumber,BarcodeType,ItemTypeName,ItemTypeName,ItemType,IsTemplate,IsSerial,StoreNo,ItemStoreID,
                   IsTaxable,IsDiscount,IsFoodStampable,Cost,ListPrice,Price,PriceA,PriceB,PriceC,PriceD,CaseQty,CaseDescription,CaseBarcodeNumber,ProfitCalculation,ProfitCalculation,CommissionQty,CommissionType,
                   OnOrder,OnHand,ReorderPoint,RestockLevel,BinLocation,OnWorkOrder,DaysForReturn,MainSuplierID,Status,DateCreated,UserCreated,MainDateModified,MatrixTableNo,LastReceive,CostByCase
                     FROM         dbo.SearchView
                     WHERE 1=1'

 Execute (@MySelect + @Filter )
GO