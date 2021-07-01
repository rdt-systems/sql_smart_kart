SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_EmailExists] (
	@TransactionID uniqueidentifier
	)

AS



SELECT COUNT (*) AS Num From Emails where TransactionID = @TransactionID
GO