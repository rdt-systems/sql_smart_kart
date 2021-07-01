SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierAddressUpdate]
(@AddressID uniqueidentifier,
@Name nvarchar(50),
@Line1 nvarchar(50),
@Line2 nvarchar(50),
@Quarter nvarchar(20),
@City nvarchar(20),
@State nvarchar(10),
@Zip nvarchar(15),
@Country nvarchar(15),
@AddressType int,
@CCRT nvarchar (20),
@PhoneNumber1  nvarchar (20),
@Ext1  nvarchar (20),
@PhoneNumber2  nvarchar (20),
@Ext2  nvarchar (20),
@PhoneNumber3  nvarchar (20),
@Ext3  nvarchar (20),
@cellphone nvarchar (20),
@SortOrder smallint,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE    dbo.SupplierAddresses
   SET           [Name] = dbo.CheckString(@Name), Line1 = dbo.CheckString(@Line1),Line2=dbo.CheckString(@Line2), [Quarter] = @Quarter, City = dbo.CheckString(@City), State = @State, Zip = dbo.CheckString(@Zip), Country = @Country, 
                    AddressType = @AddressType, CCRT=@CCRT,  SortOrder = @SortOrder,
                    PhoneNumber1 =@PhoneNumber1,Ext1=@Ext1,PhoneNumber2 =@PhoneNumber2,Ext2=@Ext2,PhoneNumber3 =@PhoneNumber3,Ext3=@Ext3,cellphone=@cellphone , Status = @Status, DateModified = @UpdateTime
WHERE (AddressID = @AddressID) and  (DateModified = @DateModified or DateModified is NULL)



select @UpdateTime as DateModified
GO