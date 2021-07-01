SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SupplierAddressView]
AS
SELECT     AddressID, Name, Line1, Line2, Quarter, City, State, Zip, Country, AddressType, CCRT, PhoneNumber1, Ext1, PhoneNumber2, PhoneNumber3, Ext2, SortOrder, Status, 
                      DateModified, UserModified, UserCreated, Ext3, cellphone
FROM         dbo.SupplierAddresses
GO