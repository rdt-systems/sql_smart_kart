SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_GetForPriceVerifier]

(@UPC  nvarchar(50),
@PrintLabel bit = 0,
@StoreID uniqueidentifier )

AS

Declare @ItemStoreID uniqueidentifier
 
IF @UPC like '55%' or @UPC like '19%'
--start gift card
BEGIN
  Select ISNULL(C.FirstName, '')  + ' ' + ISNULL(C.LastName,'') As Name,  SUM(l.AvailPoints) AS Points from CustomerMemberCards cm 
  Inner join Loyalty l on cm.CustomerID = l.CustomerID inner join customer c on c.CustomerID = l.CustomerID
  Where cm.CardNumber = @upc AND cm.Status > 0
  Group by c.LastName, c.FirstName
  Return
END
--end gift card
SELECT * Into #Alies From ItemAlias Where Status > 0 and (BarcodeNumber = @UPC OR BarcodeNumber LIKE '%' + CASE WHEN LEN(@UPC) <=3 THEN @UPC ELSE  SUBSTRING(@UPC, 2, LEN(@UPC) - 2) END + '%')

SELECT  LEFT(Name, 50) AS Name, Price, SaleType, SaleStartDate, SaleEndDate, M.BarcodeNumber, S.ItemStoreID,
(CASE WHEN (SaleType = 0) THEN 0 ELSE CASE WHEN   ISNULL(AssignDate, 0) > 0 THEN CASE WHEN dbo.GetDay(SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE()) AND 
                         dbo.GetDay(SaleStartDate) <= dbo.GetDay(dbo.GetLocalDATE()) AND dbo.GetDay(SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE()) THEN SalePrice ELSE 0 END ELSE SalePrice END END) AS SalePrice,
 (CASE WHEN (SaleType = 0) THEN 0 ELSE CASE WHEN  ISNULL(AssignDate, 0) > 0 THEN CASE WHEN dbo.GetDay(SaleEndDate) 
  >= dbo.GetDay(dbo.GetLocalDATE()) AND dbo.GetDay(SaleStartDate) <= dbo.GetDay(dbo.GetLocalDATE())
   THEN SpecialPrice ELSE 0 END ELSE SpecialPrice END END) AS SpecialPrice,
  SpecialBuy, AssignDate, ListPrice, A.BarcodeNumber AS AliasBarcode Into #ItemList
  From ItemStore S INNER JOIN ItemMain M ON S.ItemNo = M.ItemID LEFT OUTER JOIN #Alies AS A ON M.ItemID = A.ItemNo
Where M.Status > 0 and S.Status > 0 and S.StoreNo = @StoreID and ((M.BarcodeNumber = @UPC OR M.BarcodeNumber LIKE '%' + CASE WHEN LEN(@UPC) <=3 THEN @UPC ELSE  SUBSTRING(@UPC, 2, LEN(@UPC) - 2) END + '%') OR(A.BarcodeNumber = @UPC OR A.BarcodeNumber LIKE '%' + CASE WHEN LEN(@UPC) <=3 THEN @UPC ELSE  SUBSTRING(@UPC, 2, LEN(@UPC) - 2) END + '%'))

IF (SELECT COUNT(*) FROM #ItemList WHERE ((BarcodeNumber =@UPC)OR(AliasBarcode=@UPC))) >0
BEGIN
SELECT  LEFT(Name, 50) AS Name, Price, SaleType, SaleStartDate, SaleEndDate,
(CASE WHEN (SaleType = 0) THEN 0 ELSE CASE WHEN   ISNULL(AssignDate, 0) > 0 THEN CASE WHEN dbo.GetDay(SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE()) AND 
                         dbo.GetDay(SaleStartDate) <= dbo.GetDay(dbo.GetLocalDATE()) AND dbo.GetDay(SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE()) THEN SalePrice ELSE 0 END ELSE SalePrice END END) AS SalePrice,
 (CASE WHEN (SaleType = 0) THEN 0 ELSE CASE WHEN  ISNULL(AssignDate, 0) > 0 THEN CASE WHEN dbo.GetDay(SaleEndDate) 
  >= dbo.GetDay(dbo.GetLocalDATE()) AND dbo.GetDay(SaleStartDate) <= dbo.GetDay(dbo.GetLocalDATE())
   THEN SpecialPrice ELSE 0 END ELSE SpecialPrice END END) AS SpecialPrice,
  SpecialBuy, AssignDate, ListPrice

FROM            #ItemList
WHERE        ((BarcodeNumber =@UPC)OR(AliasBarcode=@UPC))
							  
							  IF @PrintLabel = 1 
							  Begin
							  set @ItemStoreID = (Select TOP(1) ItemStoreID FROM #ItemList  WHERE (BarcodeNumber =@UPC))
							  END

END                                

ELSE BEGIN
    
IF LEN(@upc) < 3 begin Return end

SELECT        LEFT(Name, 50) AS Name, Price, SaleType, SaleStartDate, SaleEndDate, (CASE WHEN (SaleType = 0) THEN 0 ELSE CASE WHEN   ISNULL(AssignDate, 0) > 0 THEN CASE WHEN dbo.GetDay(SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE()) AND 
                         dbo.GetDay(SaleStartDate) <= dbo.GetDay(dbo.GetLocalDATE()) AND dbo.GetDay(SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE()) THEN SalePrice ELSE 0 END ELSE SalePrice END END) AS SalePrice, 
						 (CASE WHEN (SaleType = 0) THEN 0 ELSE CASE WHEN   ISNULL(AssignDate, 0) > 0 THEN CASE WHEN dbo.GetDay(SaleEndDate) 
                         >= dbo.GetDay(dbo.GetLocalDATE()) AND dbo.GetDay(SaleStartDate) <= dbo.GetDay(dbo.GetLocalDATE()) THEN SpecialPrice ELSE 0 END ELSE SpecialPrice END END) AS SpecialPrice, SpecialBuy, AssignDate, ListPrice
FROM            #ItemList
WHERE        (BarcodeNumber LIKE '%' + CASE WHEN LEN(@UPC) <=3 THEN @UPC ELSE  SUBSTRING(@UPC, 2, LEN(@UPC) - 2) END + '%') AND (LEN(BarcodeNumber) > 1)
					 
					IF @PrintLabel = 1 
					Begin
					set @ItemStoreID = (Select TOP (1) ItemStoreID FROM #ItemList WHERE (BarcodeNumber LIKE '%'+SubString(@UPC,2,Len(@UPC)-2)+'%') AND Len(barcodenumber) > 1)
					end
END 

IF @PrintLabel = 1 AND @ItemStoreID <> '00000000-0000-0000-0000-000000000000'
Begin
    INSERT INTO dbo.PrintLabels
           (PrintLabelsID, ItemStoreID ,Qty, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (NewID(),@ItemStoreID, 1, 1, dbo.GetLocalDATE(), '00000000-0000-0000-0000-000000000000', dbo.GetLocalDATE(), '00000000-0000-0000-0000-000000000000')
End

DROP TABLE #Alies
DROP TABLE #ItemList
GO