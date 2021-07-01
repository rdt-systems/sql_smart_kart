CREATE TABLE [dbo].[PayOut] (
  [PayOutID] [uniqueidentifier] NOT NULL,
  [Amount] [money] NULL,
  [Reason] [nvarchar](4000) NULL,
  [RegisterID] [uniqueidentifier] NULL,
  [ChasierID] [uniqueidentifier] NULL,
  [PayOutDate] [datetime] NULL,
  [BatchID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [RegShiftID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_PayOut] PRIMARY KEY CLUSTERED ([PayOutID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_PayOut_5_2098106515__K13_K8_2]
  ON [dbo].[PayOut] ([RegShiftID], [Status])
  INCLUDE ([Amount])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO