SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_SetCustomerDetails]
(@CustomerID uniqueidentifier,@Password nvarchar(50)=null,@Email nvarchar(50)=null,@Name nvarchar(50)=null)
AS
	if @Password is not null
	begin
	update customer
set	password=@Password, datemodified=dbo.GetLocalDATE()
where customerid=@CustomerID
and status>0
	end
	if @Name is not null
	begin
	update customer

set lastname=@Name,
customerno=@Name, datemodified=dbo.GetLocalDATE()
where customerid=@CustomerID
and status>0
	end
if @Email is not null
begin
update email
set EmailAddress =@Email
where emailid=(select emailid from customertoemail where customertoemail.customerid=@CustomerID)
and status>0
end
GO