SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_UpdateResellerAddress] 
( @ResellerID uniqueidentifier,
  @Address1 nvarchar(50),
  @Address2 nvarchar(50),
  @City nvarchar(50),
  @State nvarchar(50),
  @Phone nvarchar(50),
  @Zip nvarchar(50))
AS
	
update resellers 
set 
Address1=@Address1,
Address2=@Address2,
City=@City,
StateID=@State,
Phone=@Phone,
ZipCode=@Zip
where resellerid=@ResellerID
GO