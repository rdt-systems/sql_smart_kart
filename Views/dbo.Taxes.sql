SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[Taxes]
AS
SELECT     TOP 100 PERCENT dbo.Tax.TaxID, dbo.Tax.TaxName, dbo.TaxAmmount.Percents, dbo.TaxAmmount.FromSum, dbo.TaxAmmount.ToSum, 
                      dbo.Tax.DateModified
FROM         dbo.Tax INNER JOIN
                      dbo.TaxAmmount ON dbo.Tax.TaxID = dbo.TaxAmmount.TaxNo
WHERE     (dbo.Tax.Status = 1)
ORDER BY dbo.TaxAmmount.ToSum
GO