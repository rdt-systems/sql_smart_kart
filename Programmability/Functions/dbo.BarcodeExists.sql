SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE function [dbo].[BarcodeExists](@Barcode nvarchar(50), @ItemID uniqueidentifier) returns bit as
begin
return
    case when exists (
    select * from itemmain
    where itemid <> @ItemId and barcodenumber = @barcode and (status > -1 Or Status is null))
    then 1
     else 0
   end
end
 --
GO