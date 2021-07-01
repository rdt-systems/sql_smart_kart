SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSupplierCenter] 
(@FilterOrder nvarchar(4000),
@FilterPayment nvarchar(4000),
@FilterReceive nvarchar(4000))
as
--Declare @a nvarchar
--set @a=
--'insert into dbo.SupplierCenter([ID],Number,Type,[Date],Amount,Status,SupplierNo)
--(select * From dbo.OrderForCenter Where '
--PRINT (@a+@FilterOrder)
--exec (@a+@FilterOrder)

--Declare @b nvarchar
--set @b=
--'insert into dbo.SupplierCenter([ID],Number,Type,[Date],Amount,Status,SupplierNo)
--(select * From dbo.PaymentsForCenter Where '
--PRINT (@b+@FilterPayment)
--exec (@b+@FilterPayment)

--Declare @c nvarchar
--set @c=
--'insert into dbo.SupplierCenter([ID],Number,Type,[Date],Amount,Status,SupplierNo)
--(select * From dbo.ReceiveForCenter Where  '
--PRINT (@c+@FilterReceive)
--exec (@c+@FilterReceive)

--Declare @F nvarchar
--set @F=
--'select * from dbo.SupplierCenter'

--Exec (@F)
GO