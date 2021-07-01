SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[DistributeRequestView]
AS
SELECT        dbo.Users.UserName, dbo.Store.StoreName, dbo.Store.StoreNumber, dbo.DistributeRequest.DistributeRequestID, dbo.DistributeRequest.DistributeRequestNo, 
                         dbo.DistributeRequest.DistributeRequestDate, dbo.DistributeRequest.StoreID, dbo.DistributeRequest.Status, dbo.DistributeRequest.UserCreated
FROM            dbo.DistributeRequest INNER JOIN
                         dbo.Store ON dbo.DistributeRequest.StoreID = dbo.Store.StoreID LEFT OUTER JOIN
                         dbo.Users ON dbo.DistributeRequest.UserCreated = dbo.Users.UserId
WHERE        (ISNULL(dbo.DistributeRequest.Status, 1) > 0)
GO