CREATE TABLE [dbo].[PPCUsers] (
  [PPCUserID] [uniqueidentifier] NOT NULL,
  [UserName] [nvarchar](50) NULL,
  [Password] [nvarchar](50) NULL,
  [AssociatedUserID] [uniqueidentifier] NULL,
  [AssociatedResellerID] [uniqueidentifier] NULL,
  [Type] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_PPCUsers] PRIMARY KEY CLUSTERED ([PPCUserID])
)
GO