CREATE TABLE [dbo].[DatabaseVersionHistory] (
  [VersionNumber] [int] NOT NULL,
  [VersionDate] [datetime] NOT NULL,
  [ChangePackage] [nvarchar](50) NOT NULL,
  CONSTRAINT [PK__DatabaseVersionH__1647800D] PRIMARY KEY CLUSTERED ([VersionNumber]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO