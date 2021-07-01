SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_UpdateResellerEmail]
(@ResellerID uniqueidentifier,@NewMail nvarchar(50),@OnlyText bit=0)
AS
	update resellers
	set email=@NewMail,
	     onlytext=@OnlyText
	where resellerid=@ResellerID
	and status>0
GO