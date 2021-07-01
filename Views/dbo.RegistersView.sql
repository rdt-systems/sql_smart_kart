SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






CREATE view [dbo].[RegistersView]
AS
SELECT        RegisterID, CompName, StoreID, RegisterNo, ReceiptPrinter, RecieptPrinterType, DeliveryLabelPrinter, ShelfLabelPrinter, PoleDisplayType, PoleDisplayPort, PDPortBaudRate, ScannerType, ScannerPort, 
                         SCBitsPerSec, SCDataBits, SCParity, SCStopBits, ScalePort, SLBitsPerSec, SLDataBits, SLParity, SLStopBits, PinPadType, PinPadPort, DrawerType, DrawerCom, DelayTicks, ScaleType, Status, DateCreated, 
                         UserCreated, DateModified, UserModified, CoinDispenser, CoinDispenserPort, LocalIPAdddress, ShowWhight, MainScreen, SerialSwiper, SwiperPort, Version, UseGateway, VerifonePort, VerifoneModal, 
                         ISNULL(ReciptType, 0) AS ReciptType, DeviceIP, IsTouchScreen, HideButtons, PrintTwoReceipts, USAePayDevice, USAePayAPI, ReciptType AS Expr1
FROM            Registers
WHERE        (Status > - 1)
GO