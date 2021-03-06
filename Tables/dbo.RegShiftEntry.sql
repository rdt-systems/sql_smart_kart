CREATE TABLE [dbo].[RegShiftEntry] (
  [RegDetailID] [uniqueidentifier] NOT NULL,
  [LogOnTime] [datetime] NULL,
  [LogOutTime] [datetime] NULL,
  [RegShiftID] [uniqueidentifier] NULL,
  [UserID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_RegShiftEntry] PRIMARY KEY CLUSTERED ([RegDetailID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [RegShiftEntry_ix1]
  ON [dbo].[RegShiftEntry] ([UserID])
  INCLUDE ([LogOutTime], [RegDetailID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO