SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE Procedure [dbo].[SP_ClearGenPurchaseOrder]
as
Truncate table GenPurchaseOrder
GO