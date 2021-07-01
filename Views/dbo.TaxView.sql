SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[TaxView]
AS
SELECT        TOP (100) PERCENT TaxID, TaxName, TaxDescription, TaxRate, Status, DateCreated, UserCreated, DateModified, UserModified, ISNULL(FromAmount, 0) AS FromAmount, ISNULL(Amount2, 0) AS Amount2, 
                         ISNULL(TaxRate2, 0) AS TaxRate2
FROM            Tax
GO