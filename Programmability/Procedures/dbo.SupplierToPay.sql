SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SupplierToPay]
AS
SELECT    Name,SupplierNo,Balance,SupplierID
FROM        dbo.SupplierGridView
where Balance>0 and Status>0
GO