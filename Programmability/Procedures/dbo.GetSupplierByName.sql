SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetSupplierByName]
(
	@Name nvarchar(20))
as
BEGIN
  IF (SELECT COUNT(1)FROM SupplierView WHERE Name  LIKE @Name and Status>0 )=1
  BEGIN
    SELECT * from SupplierView	where Name=  @Name and Status>0 
  END 
  ELSE BEGIN
    SELECT * from SupplierView	where Name LIKE  @Name+'%'and Status>0 
  END
end
GO