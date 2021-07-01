SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_PaymentToSupplierNo_Exists]
(@ID uniqueidentifier,
@Number nvarchar(50)=null)
As 

select Status from dbo.SupplierTenderEntry
where (SuppTenderNo = @Number) and (Status>-1) and (SuppTenderEntryID<>@ID)
GO