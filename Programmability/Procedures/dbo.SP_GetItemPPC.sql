SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--********************************************************************
-- Modified by Moshe Freund on 12-03-2015
-- It kept on giving errors for some clients when updating them and their
-- Mobile PC didn't want to handle the SP
--********************************************************************

CREATE procedure [dbo].[SP_GetItemPPC]
(
@UPC nvarchar(20),
@StoreID uniqueidentifier
)
as 

BEGIN
IF (SELECT COUNT(*) From ItemsForMobil Where StoreID = @StoreID And UPC = @UPC) > 0 --First try direct barcode
SELECT * FROM ItemsForMobil WHERE upc = @upc and StoreID = @StoreID

ELSE

If Len(@upc)> 5 AND  (SELECT COUNT(*) From ItemsForMobil Where StoreID = @StoreID And UPC = SubString(@upc, 1, Len(@upc)-1)) > 0 -- Try removing one digit at the end
SELECT * FROM ItemsForMobil WHERE upc = SubString(@upc, 1, Len(@upc)-1) and StoreID = @StoreID
ELSE

If Len(@upc)> 5 AND (SELECT COUNT(*) From ItemsForMobil Where StoreID = @StoreID And UPC = SubString(@upc, 2, Len(@upc)-2)) > 0 -- Try removing first and last digit
SELECT * FROM ItemsForMobil WHERE upc = SubString(@upc, 2, Len(@upc)-2) and StoreID = @StoreID

ELSE

If Len(@upc)> 5 AND (SELECT COUNT(*) From ItemsForMobil Where StoreID = @StoreID And UPC = SubString(@upc, 2, Len(@upc)-1)) > 0 -- Try removing  last digit
SELECT * FROM ItemsForMobil WHERE upc = SubString(@upc, 2, Len(@upc) -1) and StoreID = @StoreID

ELSE

If Len(@upc)> 5 AND  (SELECT COUNT(*) From ItemsForMobil Where StoreID = @StoreID And SubString(UPC, 1, Len(UPC)-1) = @upc) > 0 -- Try adding one digit at the end
SELECT * FROM ItemsForMobil WHERE SubString(UPC, 1, Len(UPC)-1) = @upc and StoreID = @StoreID
ELSE

IF (SELECT COUNT(*) From ItemsForMobil Where StoreID = @StoreID And ItemCode = @UPC) >0 --try with item code (modal number)
SELECT * FROM ItemsForMobil WHERE ItemCode = @upc and StoreID = @StoreID

ELSE

 
IF (SELECT COUNT(*) From ItemsForMobil Where StoreID = @StoreID And AliesUPC = @UPC) >0 --Check Alies UPC
SELECT * FROM ItemsForMobil WHERE AliesUPC = @upc and StoreID = @StoreID

ELSE
If Len(@upc)> 5 AND  (SELECT COUNT(*) From ItemsForMobil Where StoreID = @StoreID And AliesUPC = SubString(@upc, 1, Len(@upc)-1)) > 0 -- Try removing one digit at the end  By Alies UPC
SELECT * FROM ItemsForMobil WHERE AliesUPC = SubString(@upc, 1, Len(@upc)-1) and StoreID = @StoreID
Else

SELECT * FROM ItemsForMobil WHERE upc = @upc and StoreID = @StoreID --if none of the above works just return an empty row of the view, removing that line makes an error on the label program.
END


/*
/*Declare @VMobileType varchar(10)
SET @VMobileType =(Select TOP(1) OptionValue from SetUpValues Where OptionID = 300 AND StoreID = @StoreID)

Declare @MobileType Int
if  IsNull(@VMobileType,'')=''
  SET @MobileType = 0
ELSE
  SET @MobileType = CAST(@VMobileType  As Int)
--**************************************************************
-- List Of Mbile Types:
-- No Mobile = 0
-- Motorola  = 1
-- Honeywall = 2 
--**************************************************************
IF @MobileType = 2
*/


IF @MobileType = 0

BEGIN
if len(@upc) > 5 

BEGIN

SELECT TOP(1) * FROM 
(
SELECT 1 as Pref, * FROM ItemsForMobil WHERE upc = @upc and StoreID = @StoreID 
UNION ALL SELECT 3 as Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID and upc = SubString(@upc, 2, Len(@upc)-2) and len(@upc)>=10 --remove first and last
UNION ALL SELECT 3 as Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID and upc = SubString(@upc, 2, Len(@upc)-1) and len(@upc)>=11
UNION ALL SELECT 3 as Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID and upc = SubString(@upc, 1, Len(@upc)-1) and len(@upc)>=11
UNION ALL SELECT 7 as Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID and upc = SubString(@upc, 1, Len(@upc)-2) 
UNION ALL SELECT 7 as Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID and upc = SubString(@upc, 1, Len(@upc)-0)
UNION ALL SELECT 7 as Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID and upc = SubString(@upc, 1, Len(@upc)-1) 
UNION ALL SELECT 7 as Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID and upc = LEFT(@upc, LEN(@upc) - 1)
UNION All SELECT 5 AS Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID and UPC = SUBSTRING (@upc, 6, Len(@upc)-6) and Left(@UPC, 5) = '0' and LEN(@upc) > 5
UNION All SELECT 6 AS Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID and UPC = RIGHT(@upc,6) and lEFT(@UPC,6) = '0' and LEN(@upc) > 5
UNION ALL SELECT 1 as Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID AND ItemID in(SELECT ItemNo from ItemAlias where BarcodeNumber =@UPC and Status>0)
UNION ALL SELECT 2 as Pref, * FROM ItemsForMobil WHERE StoreID = @StoreID and upc = LEFT(@upc, LEN(@upc) - 1))
X ORDER BY Pref ASC

if @@ROWCOUNT > 0  return

end

END

IF @MobileType = 1
BEGIN
  SELECT * FROM ItemsForMobil WHERE upc = @upc and StoreID = @StoreID
END
ELSE
  SELECT * FROM ItemsForMobil WHERE upc = @upc and StoreID = @StoreID 
  */
GO