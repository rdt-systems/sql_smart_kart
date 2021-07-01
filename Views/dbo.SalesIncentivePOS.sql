SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SalesIncentivePOS]
AS
SELECT        dbo.SalesIncentive.SalesIncentiveID, dbo.SalesIncentive.ItemMainID, dbo.SalesIncentive.DateModified, ISNULL(dbo.SalesIncentive.Status, 1) AS Status, 
                         SalesIncentiveHeader_1.FromDate, SalesIncentiveHeader_1.ToDate, SalesIncentiveHeader_1.IncentiveAmount AS IncentiveValueAmount, 
                         SalesIncentiveHeader_1.IncentivePercent AS IncentiveValuePercent
FROM            dbo.SalesIncentive INNER JOIN
                             (SELECT        MIN(dbo.SalesIncentiveHeader.ToDate) AS ToDate, SalesIncentive_1.ItemMainID
                               FROM            dbo.SalesIncentive AS SalesIncentive_1 INNER JOIN
                                                         dbo.SalesIncentiveHeader ON SalesIncentive_1.SalesIncentiveHeaderID = dbo.SalesIncentiveHeader.SalesIncentiveHeaderID
                               WHERE        (SalesIncentive_1.Status > 0) AND (dbo.SalesIncentiveHeader.ToDate >= dbo.GetDay(dbo.GetLocalDATE()))
                               GROUP BY SalesIncentive_1.ItemMainID) AS NewDate ON dbo.SalesIncentive.ItemMainID = NewDate.ItemMainID INNER JOIN
                         dbo.SalesIncentiveHeader AS SalesIncentiveHeader_1 ON dbo.SalesIncentive.SalesIncentiveHeaderID = SalesIncentiveHeader_1.SalesIncentiveHeaderID AND 
                         NewDate.ToDate = SalesIncentiveHeader_1.ToDate
GO