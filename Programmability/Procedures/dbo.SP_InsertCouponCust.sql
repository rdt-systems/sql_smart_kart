SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_InsertCouponCust]


		 @FirstName as nvarchar(50),
		 @LastName as nvarchar(50),
		 @CompanyName as nvarchar(50),
		 @CustomerNo as nvarchar(50),
		 @Street1 as nvarchar(50),
		 @Street2 as nvarchar(50),
		 @City as nvarchar(20),
		 @State as nvarchar(100),
		 @Zip as nvarchar(15),
		 @PhoneNumber1 as nvarchar(20),
		 @Amount as money,
		 @CouponNo as nvarchar(50),
		 @ExpDate as datetime,
		 @CouponIssueDate as datetime,
		 @CouponID as uniqueidentifier,
		 @CustomerID as uniqueidentifier,
		 @PurchaseWeek as datetime,
		 @Status as int,
		 @Notes as nvarchar(max)

AS

BEGIN

		INSERT INTO [dbo].[CouponCust]
						([FirstName], [LastName], [CompanyName], [CustomerNo],
						[Street1], [Street2], [City], [State], [Zip],
						[PhoneNumber1], [Amount], [CouponNo], [ExpDate], 
						[CouponIssueDate], [CouponID], [CustomerID],
						[PurchaseWeek], [Status], [Notes])

			VALUES (@FirstName,@LastName,@CompanyName,@CustomerNo,
					@Street1,@Street2,@City,@State,@Zip,
					@PhoneNumber1, @Amount, @CouponNo, @ExpDate, @CouponIssueDate, 
					@CouponID, @CustomerID, @PurchaseWeek, @Status, @Notes)

END
GO