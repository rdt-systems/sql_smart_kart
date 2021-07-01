CREATE TABLE [dbo].[Represents] (
  [RepID] [uniqueidentifier] NOT NULL,
  [StoreID] [uniqueidentifier] NULL,
  [RepName] [nvarchar](50) NULL,
  [Note] [nvarchar](200) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([RepID])
)
GO