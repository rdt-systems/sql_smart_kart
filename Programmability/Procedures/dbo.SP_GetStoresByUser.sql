SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetStoresByUser]
(@UserID uniqueidentifier,
 @StoreID uniqueidentifier=null)

as

Declare @ThisStoreOnly bit
SELECT @ThisStoreOnly = ISNULL(IsDefault,1) From UsersView Where UserID = @UserID

IF @ThisStoreOnly = 1
SELECT DISTINCT Store.StoreID, Store.StoreName
FROM            UsersView INNER JOIN
                         Store ON Store.StoreID = UsersView.StoreID
WHERE        (UsersView.Status > - 1) AND (UsersView.UserId = @UserID) AND (Store.Status > 0)
Else
SELECT DISTINCT StoreID, StoreName
FROM            Store
WHERE        (Status > 0)
GO