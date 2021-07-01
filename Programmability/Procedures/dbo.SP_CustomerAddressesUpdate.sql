SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_CustomerAddressesUpdate]
(@CustomerAddressID uniqueidentifier,
@CustomerID uniqueidentifier,
@Name nvarchar(50),
@Street1 nvarchar(50),
@Street2 nvarchar(50),
@City nvarchar(20),
@State nvarchar(100),
@Zip nvarchar(50),
@Country nvarchar(15),
@AddressType int,
@CCRT nvarchar (20),
@PhoneNumber1  nvarchar (20),
@Ext1  nvarchar (20)='',
@PhoneNumber2  nvarchar (20),
@Ext2  nvarchar (20),
@SortOrder smallint,
@IsTextable bit =null,
@UseSMS bit = null,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)


AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE    dbo.CustomerAddresses
SET        
	CustomerID=@CustomerID,
	[Name]=dbo.CheckString(@Name), 
	Street1=dbo.CheckString(@Street1),
	Street2=dbo.CheckString(@Street2),
	City=dbo.CheckString(@City),
	State=@State,
	Zip=dbo.CheckString(@Zip),
	Country=@Country,
	AddressType=@AddressType,
	CCRT=@CCRT,
	PhoneNumber1=@PhoneNumber1,
	Ext1=@Ext1,
	PhoneNumber2=@PhoneNumber2,
	Ext2=@Ext2,
	SortOrder=@SortOrder,
	IsTextable=@IsTextable,
	Status=@Status,
	UseSMS=@UseSMS,
	DateModified=@UpdateTime,
	UserModified=@ModifierID

WHERE  (CustomerAddressID = @CustomerAddressID) 
--AND (DateModified = @DateModified OR DateModified IS NULL) 





select @UpdateTime as DateModified
GO