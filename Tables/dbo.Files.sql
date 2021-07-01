CREATE TABLE [dbo].[Files] (
  [FileID] [uniqueidentifier] NOT NULL,
  [File] [image] NULL,
  CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED ([FileID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO