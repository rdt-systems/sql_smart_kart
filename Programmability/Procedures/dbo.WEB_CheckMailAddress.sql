SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[WEB_CheckMailAddress]
(@Password nvarchar(50),
@Email nvarchar(50))
as

select CustomerID from customer c
where customertype=4 and
 status > 0
and [password]=@Password





and exists(select * from  dbo.CustomerToEmail
inner join email on customertoemail.emailid=email.emailid
where CustomerToEmail.CustomerID=c.customerid
and email.EmailAddress=@Email)
GO