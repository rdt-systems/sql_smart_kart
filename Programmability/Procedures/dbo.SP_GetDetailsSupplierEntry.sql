SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetDetailsSupplierEntry]
@SuppTenderEntryId uniqueidentifier
as
Select *
From Dbo.PayToBill
WHERE  SuppTenderID = @SuppTenderEntryId and Status>0
GO