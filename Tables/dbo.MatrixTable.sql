CREATE TABLE [dbo].[MatrixTable] (
  [MatrixTableID] [uniqueidentifier] NOT NULL,
  [MatrixName] [nvarchar](50) NULL,
  [MatrixDescription] [nvarchar](4000) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_MatrixTable] PRIMARY KEY CLUSTERED ([MatrixTableID])
)
GO