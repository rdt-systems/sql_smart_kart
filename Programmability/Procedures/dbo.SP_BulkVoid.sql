SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_BulkVoid](
	@CustomerID uniqueidentifier
	)
AS

Declare @TransID uniqueidentifier
DECLARE S CURSOR FOR Select TransactionID From [Transaction] Where CustomerID = @CustomerID and Status > 0

OPEN S

FETCH NEXT FROM S INTO @TransID
WHILE @@FETCH_STATUS = 0
BEGIN
Exec SP_TransactionVoid @TransID, '',NULL

FETCH NEXT FROM S INTO @TransID
END

CLOSE S

DEALLOCATE S
GO