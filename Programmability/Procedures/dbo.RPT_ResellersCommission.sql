SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[RPT_ResellersCommission]
(@FromDate datetime,
 @ToDate datetime,
 @ResellerID uniqueidentifier = null )

AS 

SELECT     CommissionID,[Name],CompanyName,Email,Address1,Phone, SentDate, CheckDate,CheckNo,CheckBank,CheckSubsidiary,Amount
FROM        dbo.ResellersView Left outer JOIN
            dbo.ResellersCommissions ON dbo.ResellersView.ResellerID = dbo.ResellersCommissions.ResellerID and dbo.ResellersCommissions.Status >0   
WHERE       dbo.ResellersView.Status>0 and (dbo.ResellersCommissions.SentDate >= @FromDate) AND 
            (dbo.ResellersCommissions.SentDate < @ToDate)-- And (@ResellerID=null Or dbo.Reseller.ResellerID=@ResellerID)
GO