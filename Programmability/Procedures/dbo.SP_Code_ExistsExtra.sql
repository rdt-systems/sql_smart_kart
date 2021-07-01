SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_Code_ExistsExtra]
(@Result nvarchar(2),
 @Code nvarchar(50))
As 

if @Result = 'OK'
Begin
	Update itemMain set status = 1 where BarcodeNumber = @Code
End
else
if @Result = 'NO'
Begin
	Update itemMain set BarcodeNumber = BarcodeNumber + 'X', Description = Description + 'X' where BarcodeNumber = @Code
End
GO