﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RegistersUpdate]
(@RegisterID uniqueidentifier,
@CompName nvarchar(50),
@StoreID uniqueidentifier,
@RegisterNo nvarchar(50),
@ReceiptPrinter nvarchar(1000),
@RecieptPrinterType smallint,
@DeliveryLabelPrinter nvarchar(1000),
@ShelfLabelPrinter nvarchar(1000),
@PoleDisplayType int,
@PoleDisplayPort int,
@PDPortBaudRate int,
@ScannerType int,
@ScannerPort int,
@SCBitsPerSec int,
@SCDataBits int,
@SCParity int,
@SCStopBits decimal,
@ScalePort int,
@SLBitsPerSec int,
@SLDataBits int,
@SLParity int,
@SLStopBits decimal,
@PinPadType int,
@PinPadPort int,
@DrawerType int,
@DrawerCom int,
@DelayTicks int,
@ScaleType int,
@CoinDispenser int,
@CoinDispenserPort Int,
@ReciptType int =0,
@IsTouchScreen int =0,
@DeviceIP nvarchar(200) = NULL,
@USAePayDevice nvarchar = NULL,
@USAePayAPI	bit = 0,
@HideButtons int = 0,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

as update  registers set
CompName=@CompName,
StoreID=@StoreID,
RegisterNo=@RegisterNo,
ReceiptPrinter=@ReceiptPrinter,
RecieptPrinterType=@RecieptPrinterType,
DeliveryLabelPrinter=@DeliveryLabelPrinter,
ShelfLabelPrinter=@ShelfLabelPrinter,
PoleDisplayType=@PoleDisplayType,
PoleDisplayPort=@PoleDisplayPort,
PDPortBaudRate=@PDPortBaudRate,
ScannerType=@ScannerType,
ScannerPort=@ScannerPort,
SCBitsPerSec=@SCBitsPerSec,
SCDataBits=@SCDataBits,
SCParity=@SCParity,
SCStopBits=@SCStopBits,
ScalePort=@ScalePort,
SLBitsPerSec=@SLBitsPerSec,
SLDataBits=@SLDataBits,
SLParity=@SLParity,
SLStopBits=@SLStopBits,
PinPadType=@PinPadType,
PinPadPort=@PinPadPort,
DrawerType=@DrawerType,
DrawerCom=@DrawerCom,
DelayTicks=@DelayTicks,
ScaleType=@ScaleType,
CoinDispenser = @CoinDispenser,
CoinDispenserPort=@CoinDispenserPort,
IsTouchScreen = @IsTouchScreen,
ReciptType = @ReciptType,
DeviceIP = @DeviceIP,
USAePayDevice =@USAePayDevice,
USAePayAPI =@USAePayAPI,
HideButtons = @HideButtons,
[Status]=@Status,
DateModified=dbo.GetLocalDATE(),
UserModified=@ModifierID

where RegisterID=@RegisterID and (DateModified=@dateModified or @DateModified is null)
GO