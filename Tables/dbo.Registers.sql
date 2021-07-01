﻿CREATE TABLE [dbo].[Registers] (
  [RegisterID] [uniqueidentifier] NOT NULL,
  [CompName] [nvarchar](50) NULL,
  [StoreID] [uniqueidentifier] NULL,
  [RegisterNo] [nvarchar](50) NULL,
  [ReceiptPrinter] [nvarchar](1000) NULL,
  [RecieptPrinterType] [smallint] NULL,
  [DeliveryLabelPrinter] [nvarchar](1000) NULL,
  [ShelfLabelPrinter] [nvarchar](1000) NULL,
  [PoleDisplayType] [int] NULL,
  [PoleDisplayPort] [int] NULL,
  [PDPortBaudRate] [int] NULL,
  [ScannerType] [int] NULL,
  [ScannerPort] [int] NULL,
  [SCBitsPerSec] [int] NULL,
  [SCDataBits] [int] NULL,
  [SCParity] [int] NULL,
  [SCStopBits] [decimal] NULL,
  [ScalePort] [int] NULL,
  [SLBitsPerSec] [int] NULL,
  [SLDataBits] [int] NULL,
  [SLParity] [int] NULL,
  [SLStopBits] [decimal] NULL,
  [PinPadType] [int] NULL,
  [PinPadPort] [int] NULL,
  [DrawerType] [int] NULL,
  [DrawerCom] [int] NULL,
  [DelayTicks] [int] NULL,
  [ScaleType] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [CoinDispenser] [int] NULL,
  [CoinDispenserPort] [int] NULL,
  [LocalIPAdddress] [nvarchar](30) NULL,
  [ShowWhight] [smallint] NULL,
  [MainScreen] [smallint] NULL,
  [SerialSwiper] [int] NULL,
  [SwiperPort] [int] NULL,
  [Version] [nvarchar](15) NULL,
  [UseGateway] [int] NULL,
  [VerifonePort] [nvarchar](10) NULL,
  [VerifoneModal] [nvarchar](10) NULL,
  [ReciptType] [int] NULL CONSTRAINT [DF_Registers_ReciptType] DEFAULT (0),
  [PrintTwoReceipts] [int] NULL CONSTRAINT [DF__Registers__Print__52F166F1] DEFAULT (0),
  [DeviceIP] [nvarchar](100) NULL,
  [IsTouchScreen] [int] NULL,
  [LastTimeFullSync] [datetime] NULL,
  [ResetID] [bit] NULL,
  [HideButtons] [int] NULL,
  [USAePayDevice] [nvarchar](250) NULL,
  [USAePayAPI] [int] NULL,
  CONSTRAINT [PK_Registers] PRIMARY KEY CLUSTERED ([RegisterID])
)
GO

CREATE UNIQUE INDEX [Reg_RegNo]
  ON [dbo].[Registers] ([RegisterNo])
  WHERE ([Status]>(0))
GO