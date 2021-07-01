CREATE TABLE [dbo].[RegShift] (
  [RegShiftID] [uniqueidentifier] NOT NULL,
  [CloseBy] [uniqueidentifier] NULL,
  [RegID] [uniqueidentifier] NULL,
  [ShiftCloseDate] [datetime] NULL,
  [ShiftNO] [nvarchar](50) NOT NULL,
  [ShiftOpenDate] [datetime] NULL,
  [Status] [int] NULL,
  [OpeningAmount] [money] NULL,
  [ClosingAmount] [money] NULL,
  [OpenHunderdBills] [int] NULL,
  [OpenFiftyBills] [int] NULL,
  [OpenTwentyBills] [int] NULL,
  [OpenTenBills] [int] NULL,
  [OpenFiveBills] [int] NULL,
  [OpenSingels] [int] NULL,
  [OpenQuarter] [int] NULL,
  [OpenDimes] [int] NULL,
  [OpenNickels] [int] NULL,
  [OpenPennies] [int] NULL,
  [OpenOther] [decimal] NULL,
  [CloseHunderdBills] [int] NULL,
  [CloseFiftyBills] [int] NULL,
  [CloseTwentyBills] [int] NULL,
  [CloseTenBills] [int] NULL,
  [CloseFiveBills] [int] NULL,
  [CloseSingels] [int] NULL,
  [CloseQuarter] [int] NULL,
  [CloseDimes] [int] NULL,
  [CloseNickels] [int] NULL,
  [ClosePennies] [int] NULL,
  [CloseOther] [decimal] NULL,
  CONSTRAINT [PK_RegShift] PRIMARY KEY CLUSTERED ([RegShiftID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_RegShift_ShiftNO]
  ON [dbo].[RegShift] ([ShiftNO])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO