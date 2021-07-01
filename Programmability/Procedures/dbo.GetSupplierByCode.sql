SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetSupplierByCode]
(
	@Code nvarchar(20))
as
BEGIN
  IF (SELECT COUNT(1)FROM SupplierView WHERE SupplierNo = @Code)=1
  BEGIN
    SELECT * from SupplierView	where SupplierNo =  @Code 
  END 
  ELSE BEGIN
    SELECT * from SupplierView	where SupplierNo LIKE  @Code+'%'
  END
end
GO