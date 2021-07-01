SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetOnePhoneOrder]
(@ID uniqueidentifier)
as
	SELECT        PhoneOrder.*, [Transaction].TransactionNo
FROM            PhoneOrder LEFT OUTER JOIN
                         [Transaction] ON PhoneOrder.TransactionID = [Transaction].TransactionID
	WHERE     (PhoneOrder.Status > -1) and (PhoneOrderID=@ID)
GO