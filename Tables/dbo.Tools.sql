CREATE TABLE [dbo].[Tools] (
  [ToolID] [int] IDENTITY,
  [Path] [nvarchar](550) NULL,
  [ToolName] [nvarchar](50) NULL,
  CONSTRAINT [PK_Tools] PRIMARY KEY CLUSTERED ([ToolID])
)
GO