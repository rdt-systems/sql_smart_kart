SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPaymentForCenter]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.PaymentsForCenter.*
                FROM         dbo.PaymentsForCenter
	        WHERE     '
Execute (@MySelect + @Filter )
GO