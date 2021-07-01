CREATE TABLE [dbo].[Groups] (
  [GroupID] [uniqueidentifier] NOT NULL,
  [GroupName] [nvarchar](50) NOT NULL,
  [IsSystem] [bit] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED ([GroupID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO