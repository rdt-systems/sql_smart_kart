SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionWithCustomer]

AS SELECT     dbo.TransactionWithCustomerView.*
FROM       dbo.TransactionWithCustomerView
WHERE     (Status > - 1)
GO