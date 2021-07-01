CREATE TABLE [dbo].[Users] (
  [UserId] [uniqueidentifier] NOT NULL,
  [UserName] [nvarchar](50) NULL,
  [Password] [nvarchar](50) NULL,
  [UserFName] [nvarchar](50) NULL,
  [UserLName] [nvarchar](50) NULL,
  [Address] [nvarchar](4000) NULL,
  [HomePhoneNumber] [nvarchar](50) NULL,
  [WorkPhoneNumber] [nvarchar](50) NULL,
  [Fax] [nvarchar](50) NULL,
  [Email] [nvarchar](50) NULL,
  [ZipCode] [nvarchar](50) NULL,
  [IsSuperAdmin] [bit] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [ScanID] [nvarchar](20) NULL,
  [IsLogIn] [bit] NULL CONSTRAINT [DF_Users_IsLogIn] DEFAULT (0),
  CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId])
)
GO

CREATE INDEX [_dta_index_Users_7_1349579846__K1_2]
  ON [dbo].[Users] ([UserId])
  INCLUDE ([UserName])
GO

CREATE UNIQUE INDEX [idx_UserName]
  ON [dbo].[Users] ([UserName])
  WHERE ([Status]>(-1))
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
Create trigger [Tr_ChangeUsers] on [dbo].[Users]
for  update , insert , delete
as

 declare @UserId nvarchar(500) ,@ModifierID uniqueidentifier
 select  @UserId =inserted.UserId,@ModifierID=UserModified
 from inserted 


 
 declare @UserIdDelete nvarchar(500) ,@ModifierIDDelete uniqueidentifier
 select  @UserIdDelete =deleted.UserId,@ModifierIDDelete=deleted.UserModified
 from deleted 

if (select count(0) from inserted ) >0 and   (select count(0) from deleted ) <=0 
begin 
 exec SP_SaveRecentActivity 25,'Users',1,@UserId,1,'UserId',@ModifierID,null
end 


else if Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
begin 
exec SP_SaveRecentActivity 26,'Users',1,@UserId,1,'UserId',@ModifierID,null
end 

else if
 (select count(0) from inserted ) >0 and   (select count(0) from deleted ) >=0

begin 
exec SP_SaveRecentActivity 26,'Users',1,@UserId,1,'UserId',@ModifierID,null
end 


else if
 (select count(0) from inserted ) =0 and   (select count(0) from deleted ) >=0

begin 
exec SP_SaveRecentActivity 26,'Users',1,@UserId,1,'UserId',@ModifierIDDelete,null
end
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeletetUser] on [dbo].[Users]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT UserID, 'UserQuery' , Status, dbo.GetLocalDATE() , 1,'UserID' FROM      inserted
  end
GO