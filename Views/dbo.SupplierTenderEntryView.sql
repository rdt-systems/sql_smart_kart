SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SupplierTenderEntryView]
AS
SELECT        dbo.SupplierTenderEntry.SuppTenderEntryID, dbo.SupplierTenderEntry.SuppTenderNo, dbo.SupplierTenderEntry.StoreID, dbo.SupplierTenderEntry.SupplierID, dbo.SupplierTenderEntry.TenderID, 
                         dbo.SupplierTenderEntry.Amount, dbo.SupplierTenderEntry.Common1, dbo.SupplierTenderEntry.Common2, dbo.SupplierTenderEntry.Common3, dbo.SupplierTenderEntry.Common4, 
                         dbo.SupplierTenderEntry.Common5, dbo.SupplierTenderEntry.Common6, dbo.SupplierTenderEntry.TenderDate, dbo.SupplierTenderEntry.Status, dbo.SupplierTenderEntry.DateCreated, 
                         dbo.SupplierTenderEntry.UserCreated, dbo.SupplierTenderEntry.DateModified, dbo.SupplierTenderEntry.UserModified, dbo.SupplierTenderEntry.TransferedToBookkeeping, 
                         Visa.SystemValueName COLLATE HEBREW_CI_AS AS VisaType, dbo.Supplier.Name, dbo.Tender.TenderName, dbo.Tender.TenderID AS Type
FROM            dbo.SupplierTenderEntry INNER JOIN
                         dbo.Supplier ON dbo.SupplierTenderEntry.SupplierID = dbo.Supplier.SupplierID INNER JOIN
                         dbo.Tender ON dbo.SupplierTenderEntry.TenderID = dbo.Tender.TenderID LEFT OUTER JOIN
                             (SELECT        CASE WHEN
                                                             (SELECT        TOP 1 OptionValue
                                                               FROM            SetupValues
                                                               WHERE        OptionName = 'Language' AND StoreID = '00000000-0000-0000-0000-000000000000') = 0 THEN SystemValueName ELSE SystemValueNameHe END AS SystemValueName, 
                                                         SystemValueNo
                               FROM            dbo.SysVisaType) AS Visa ON dbo.SupplierTenderEntry.Common3 = Visa.SystemValueNo
GO