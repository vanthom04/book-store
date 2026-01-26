USE BOOK_STORE;
GO

-- ============================= FUNCTION =============================
-- 1. Function tính tổng tiền đơn hàng
CREATE FUNCTION fn_CalculateOrderTotal (@OrderID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Total DECIMAL(18,2);
    
    SELECT @Total = SUM(od.QUANTITY * od.PRICE)
    FROM ORDER_DETAILS od
    WHERE od.ORDER_ID = @OrderID;
    
    -- Nếu không có dữ liệu, trả về 0
    IF @Total IS NULL
        SET @Total = 0;
    
    RETURN @Total;
END;
GO

-- 2. Function kiểm tra tồn kho khi có phát sinh đơn
CREATE FUNCTION fn_CheckStockForOrder (@OrderID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @IsAvailable BIT = 1;
    
    -- Kiểm tra xem có sách nào không đủ số lượng không
    IF EXISTS (
        SELECT 1
        FROM ORDER_DETAILS od
        INNER JOIN BOOKS b ON od.BOOK_ID = b.BOOK_ID
        WHERE od.ORDER_ID = @OrderID
          AND b.QUANTITY < od.QUANTITY
    )
    BEGIN
        SET @IsAvailable = 0;
    END
    
    RETURN @IsAvailable;
END;
GO

-- 3. Function tính doanh thu theo ngày
CREATE FUNCTION fn_CalculateDailyRevenue (@Date DATE)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(18,2);
    
    SELECT @Revenue = SUM(od.QUANTITY * od.PRICE)
    FROM ORDERS o
    INNER JOIN ORDER_DETAILS od ON o.ORDER_ID = od.ORDER_ID
    WHERE CAST(o.ORDER_DATE AS DATE) = @Date
      AND o.STATUS = 'Completed';
    
    -- Nếu không có doanh thu, trả về 0
    IF @Revenue IS NULL
        SET @Revenue = 0;
    
    RETURN @Revenue;
END;
GO

-- ============================= TRIGGER =============================
-- 1. Quản lý tồn kho: Trừ khi mua (Pending -> Processing) và Hoàn khi hủy
CREATE TRIGGER TRG_InventoryManagement
ON ORDERS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Trừ kho khi đơn hàng được xác nhận (Chuyển từ Pending sang Processing)
    IF UPDATE(STATUS)
    BEGIN
        UPDATE B
        SET B.QUANTITY = B.QUANTITY - OD.QUANTITY
        FROM BOOKS B
        INNER JOIN ORDER_DETAILS OD ON B.BOOK_ID = OD.BOOK_ID
        INNER JOIN inserted I ON OD.ORDER_ID = I.ORDER_ID
        INNER JOIN deleted D ON I.ORDER_ID = D.ORDER_ID
        WHERE I.STATUS = 'Processing' AND D.STATUS = 'Pending';

        -- 3. Hoàn kho khi đơn hàng bị hủy (Chuyển sang Cancelled)
        UPDATE B
        SET B.QUANTITY = B.QUANTITY + OD.QUANTITY
        FROM BOOKS B
        INNER JOIN ORDER_DETAILS OD ON B.BOOK_ID = OD.BOOK_ID
        INNER JOIN inserted I ON OD.ORDER_ID = I.ORDER_ID
        INNER JOIN deleted D ON I.ORDER_ID = D.ORDER_ID
        WHERE I.STATUS = 'Cancelled' AND D.STATUS <> 'Cancelled';
    END
END
GO

-- 2. Kiểm tra tồn kho trước khi cho phép thêm vào đơn hàng
CREATE TRIGGER TRG_CheckStockBeforeOrder
ON ORDER_DETAILS
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM inserted i 
        JOIN BOOKS b ON i.BOOK_ID = b.BOOK_ID 
        WHERE i.QUANTITY > b.QUANTITY
    )
    BEGIN
        RAISERROR(N'Sách không đủ tồn kho để thực hiện giao dịch!', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- Nếu KHÔNG có dòng nào vi phạm (tất cả đều thỏa mãn Mua <= Tồn)
        INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE)
        SELECT ORDER_ID, BOOK_ID, QUANTITY, PRICE FROM inserted;
    END;
END;
GO

-- 3. Không cho xóa danh mục nếu đang có sách
CREATE TRIGGER TRG_PreventDeleteCategory
ON CATEGORIES
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM BOOKS WHERE CATEGORY_ID IN (SELECT CATEGORY_ID FROM deleted))
    BEGIN
        RAISERROR(N'Lỗi: Danh mục này đang chứa sách, không thể xóa!', 16, 1);
    END;
    ELSE
    BEGIN
        DELETE FROM CATEGORIES WHERE CATEGORY_ID IN (SELECT CATEGORY_ID FROM deleted)
    END;
END;
GO

-- 4. Không cho xóa sách nếu đã từng phát sinh đơn hàng
CREATE TRIGGER TRG_PreventDeleteBook
ON BOOKS
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ORDER_DETAILS WHERE BOOK_ID IN (SELECT BOOK_ID FROM deleted))
    BEGIN
        RAISERROR(N'Lỗi: Sách đã có trong lịch sử đơn hàng, không thể xóa!', 16, 1);
    END;
    ELSE
    BEGIN
        DELETE FROM BOOKS WHERE BOOK_ID IN (SELECT BOOK_ID FROM deleted);
    END;
END;
GO

-- 5. Tự động tạo 1 giỏ hàng duy nhất khi tạo User mới
CREATE TRIGGER TRG_AutoCreateCart
ON USERS
AFTER INSERT
AS
BEGIN
    INSERT INTO CARTS (USER_ID)
    SELECT USER_ID FROM inserted;
END
GO

-- 6. Cập nhật updated_at của giỏ hàng khi thêm/xóa sản phẩm trong giỏ
CREATE TRIGGER TRG_UpdateCartTimestamp
ON CART_ITEMS
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE CARTS
    SET UPDATED_AT = GETDATE()
    WHERE CART_ID IN (SELECT CART_ID FROM inserted UNION SELECT CART_ID FROM deleted);
END;
GO

-- ============================= STORED PROCEDURE =============================
-- 1. Stored Procedure đăng ký tài khoản mới
CREATE PROC sp_RegisterUser (
    @FullName NVARCHAR(100),
    @Email VARCHAR(100),
    @PasswordHash VARCHAR(255),
    @Phone VARCHAR(15) = NULL,
    @Address VARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON

    -- Kiểm tra nếu email đã tồn tại
    IF EXISTS (SELECT 1 FROM USERS WHERE EMAIL = @Email)
    BEGIN
        RAISERROR(N'Email đã được sử dụng', 16, 1);
        RETURN;
    END;

    -- Nếu chưa có thì tạo mới user
    INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS) VALUES (@FullName, @Email, @PasswordHash, @Phone, @Address);

    -- Trả về thông báo thành công
    SELECT N'Đăng ký tài khoản thành công!' AS Message, SCOPE_IDENTITY() AS NewUserID;
END;
GO

-- 2. Stored Procedure mua hàng (tạo đơn hàng mới)
CREATE PROC sp_CreateOrder (
    @UserId INT,
    @ReceiverName NVARCHAR(100),
    @ReceiverPhone VARCHAR(15),
    @ShippingAddress NVARCHAR(255),
    @PaymentMethod VARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @CartId INT;
        DECLARE @NewOrderId INT;
        DECLARE @TotalAmount DECIMAL(12, 2);

        -- Lấy CartId của user
        SELECT @CartId = CART_ID FROM CARTS WHERE USER_ID = @UserId;

        IF @CartId IS NULL
        BEGIN
            RAISERROR(N'Người dùng chưa có giỏ hàng', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Kiểm tra giỏ hàng rỗng
        IF NOT EXISTS (SELECT 1 FROM CART_ITEMS WHERE CART_ID = @CartId)
        BEGIN
            RAISERROR(N'Giỏ hàng của bạn đang trống.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Tạo đơn hàng
        INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, ORDER_DATE, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD) VALUES (@UserID, @ReceiverName, @ReceiverPhone, @ShippingAddress, GETDATE(), 0, 'Pending', @PaymentMethod);

        -- Lấy ID của đơn hàng vừa tạo
        SET @NewOrderID = SCOPE_IDENTITY();

        -- Tạo chi tiết đơn hàng
        INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE)
        SELECT @NewOrderID, ci.BOOK_ID, ci.QUANTITY, b.PRICE
        FROM CART_ITEMS ci
        JOIN BOOKS b ON ci.BOOK_ID = b.BOOK_ID
        WHERE ci.CART_ID = @CartId;

        -- (Lúc này, Trigger TRG_CheckStockBeforeOrder sẽ chạy. 
        -- Nếu thiếu hàng, nó sẽ RAISERROR và nhảy xuống CATCH để Rollback)

        -- Cập nhật lại TOTAL_AMOUNT cho đơn hàng
        SET @TotalAmount = dbo.fn_CalculateOrderTotal(@NewOrderID);

        UPDATE ORDERS
        SET TOTAL_AMOUNT = @TotalAmount
        WHERE ORDER_ID = @NewOrderID;

        -- Xóa các các sản phẩm trong giỏ hàng sau khi đặt hàng thành công
        DELETE FROM CART_ITEMS WHERE CART_ID = @CartID;

        COMMIT TRANSACTION;

        -- Trả về thông báo thành công
        SELECT 
            @NewOrderID AS OrderID,
            N'Đặt hàng thành công' AS Message,
            @TotalAmount AS TotalAmount;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        -- Trả về lỗi
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 3. Stored Procedure
CREATE PROC sp_GetUserOrderHistory (
    @UserID INT,
    @Status VARCHAR(20) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ORDER_ID,
        ORDER_DATE,
        TOTAL_AMOUNT,
        STATUS,
        PAYMENT_METHOD,
        RECEIVER_NAME,
        SHIPPING_ADDRESS,
        (SELECT COUNT(*) FROM ORDER_DETAILS WHERE ORDER_ID = o.ORDER_ID) AS TotalItems
    FROM ORDERS o
    WHERE USER_ID = @UserID
    ORDER BY  ORDER_DATE DESC;
END;
GO

-- 4. Stored Procedure Thống kê doanh thu hàng tháng
CREATE PROC sp_GetMonthlyRevenue (
    @Year INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Tạo một table tạm chứa 12 tháng
    WITH MonthList AS (
        SELECT 1 AS MonthNum
        UNION ALL
        SELECT MonthNum + 1 FROM MonthList WHERE MonthNum < 12
    )
    -- Join với table ORDERS để tính tổng doanh thu
    SELECT
        m.MonthNum AS [Month],
        COALESCE(SUM(o.TOTAL_AMOUNT), 0) AS TotalRevenue,
        COUNT(o.ORDER_ID) AS TotalOrders
    FROM MonthList m
    LEFT JOIN ORDERS o
        ON MONTH(o.ORDER_DATE) = m.MonthNum
        AND YEAR(o.ORDER_DATE) = @Year
        AND o.STATUS = 'Completed'
    GROUP BY m.MonthNum
    ORDER BY m.MonthNum;
END;
GO

-- 5. Stored Procedure top sách bán chạy
CREATE PROC sp_GetBestSellingBooks (
    @Year INT,
    @Month INT = NULL,
    @TopN INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopN)
        b.BOOK_ID,
        b.BOOK_NAME,
        a.AUTHOR_NAME,
        b.PRICE,
        b.IMAGE,
        SUM(od.QUANTITY) AS TotalSold,
        SUM(od.QUANTITY * od.PRICE) AS RevenueGenerated
    FROM ORDER_DETAILS od
    JOIN ORDERS o ON od.ORDER_ID = o.ORDER_ID
    JOIN BOOKS b ON od.BOOK_ID = b.BOOK_ID
    JOIN AUTHORS a ON b.AUTHOR_ID = a.AUTHOR_ID
    WHERE o.STATUS <> 'Cancelled'
        AND YEAR(o.ORDER_DATE) = @Year
        AND (@Month IS NULL OR MONTH(o.ORDER_DATE) = @Month)
    GROUP BY b.BOOK_ID, b.BOOK_NAME, b.IMAGE, b.PRICE, a.AUTHOR_NAME
    ORDER BY TotalSold DESC;
END;
GO

-- 6. Stored Procedure cập nhật thông tin sách 
CREATE PROC sp_UpdateBookInfo (
    @BookID INT,
    @BookName NVARCHAR(255),
    @Slug VARCHAR(255),
    @PublishYear INT,
    @Language NVARCHAR(50),
    @Pages INT,
    @Image VARCHAR(255),
    @Quantity INT,
    @Price DECIMAL(12, 2),
    @CategoryID INT,
    @PublisherID INT,
    @AuthorID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra xem sách có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM BOOKS WHERE BOOK_ID = @BookID)
        BEGIN
            RAISERROR(N'Sách không tồn tại!', 16, 1);
            RETURN;
        END;

        -- Kiểm tra SLUG có bị trùng với sách khác không
        IF EXISTS (SELECT 1 FROM BOOKS WHERE SLUG = @Slug AND BOOK_ID <> @BookID)
        BEGIN
            RAISERROR(N'Slug này đã tồn tại cho một sách khác!', 16, 1);
            RETURN;
        END;

        -- Cập nhật thông tin sách
        UPDATE BOOKS
        SET
            BOOK_NAME = @BookName,
            SLUG = @Slug,
            PUBLISH_YEAR = @PublishYear,
            LANGUAGE = @Language,
            PAGES = @Pages,
            IMAGE = @Image,
            QUANTITY = @Quantity,
            PRICE = @Price,
            CATEGORY_ID = @CategoryID,
            PUBLISHER_ID = @PublisherID,
            AUTHOR_ID = @AuthorID,
            UPDATED_AT = GETDATE()
        WHERE BOOK_ID = @BookID;

        -- Trả về thông báo thành công
        SELECT N'Cập nhật sách thành công' AS Message, @BookID AS BookID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 7. Stored Procedure lấy ngẫu nhiên sách
CREATE PROCEDURE sp_GetRandomBooks
    @CurrentBookID INT,
    @TopN INT = 3
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopN)
        b.BOOK_ID,
        b.BOOK_NAME,
        b.SLUG,
        b.IMAGE,
        b.PRICE,
        a.AUTHOR_NAME
    FROM BOOKS b
    JOIN AUTHORS a ON b.AUTHOR_ID = a.AUTHOR_ID
    WHERE b.BOOK_ID <> @CurrentBookID AND (b.IS_DELETED IS NULL OR b.IS_DELETED = 0)
    ORDER BY NEWID();
END;
GO

-- 8. Stored Procedure thống kê trang dashboard admin
CREATE PROC sp_GetAdminDashboardStats
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartOfCurrentMonth DATETIME = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
    DECLARE @StartOfLastMonth DATETIME = DATEADD(MONTH, -1, @StartOfCurrentMonth);

    -- Thống kê doanh thu (Chỉ tính đơn Completed)
    DECLARE @CurrentRevenue DECIMAL(18, 2) = 0;
    DECLARE @LastMonthRevenue DECIMAL(18, 2) = 0;

    -- Doanh thu tháng này
    SELECT @CurrentRevenue = ISNULL(SUM(TOTAL_AMOUNT), 0)
    FROM ORDERS 
    WHERE STATUS = 'Completed' AND ORDER_DATE >= @StartOfCurrentMonth;

    -- Doanh thu tháng trước
    SELECT @LastMonthRevenue = ISNULL(SUM(TOTAL_AMOUNT), 0)
    FROM ORDERS 
    WHERE STATUS = 'Completed' 
        AND ORDER_DATE >= @StartOfLastMonth 
        AND ORDER_DATE < @StartOfCurrentMonth;

    -- Thống kê số đơn hàng (Trừ đơn Cancelled)
    DECLARE @CurrentOrders INT = 0;
    DECLARE @LastMonthOrders INT = 0;

    -- Số đơn tháng này
    SELECT @CurrentOrders = COUNT(*)
    FROM ORDERS 
    WHERE STATUS <> 'Cancelled' AND ORDER_DATE >= @StartOfCurrentMonth;

    -- Số đơn tháng trước
    SELECT @LastMonthOrders = COUNT(*)
    FROM ORDERS 
    WHERE STATUS <> 'Cancelled' 
        AND ORDER_DATE >= @StartOfLastMonth 
        AND ORDER_DATE < @StartOfCurrentMonth;

    -- Thống kê số khách hàng
    DECLARE @TotalUsers INT = 0;
    DECLARE @TotalUsersLastMonth INT = 0;

    -- Tổng số khách hàng hiện tại
    SELECT @TotalUsers = COUNT(*) FROM USERS;

    -- Tổng user tính đến cuối tháng trước
    SELECT @TotalUsersLastMonth = COUNT(*) 
    FROM USERS 
    WHERE CREATED_AT < @StartOfCurrentMonth;

    SELECT 
        -- Doanh thu
        @CurrentRevenue AS RevenueValue,
        CASE 
            WHEN @LastMonthRevenue = 0 THEN 100
            ELSE CAST(((@CurrentRevenue - @LastMonthRevenue) * 100.0 / @LastMonthRevenue) AS DECIMAL(10, 2))
        END AS RevenueGrowth,

        -- Đơn hàng
        @CurrentOrders AS OrdersValue,
        CASE 
            WHEN @LastMonthOrders = 0 THEN 100 
            ELSE CAST(((@CurrentOrders - @LastMonthOrders) * 100.0 / @LastMonthOrders) AS DECIMAL(10, 2))
        END AS OrdersGrowth,

        -- Người dùng
        @TotalUsers AS UsersValue,
        CASE 
            WHEN @TotalUsersLastMonth = 0 THEN 100 
            ELSE CAST(((@TotalUsers - @TotalUsersLastMonth) * 100.0 / @TotalUsersLastMonth) AS DECIMAL(10, 2))
        END AS UsersGrowth;
END;
GO

-- ============================= CURSOR =============================

-- 1. Báo cáo hiệu quả kinh doanh theo Danh mục (Category Performance)

DECLARE @CategoryReport TABLE (
    CATEGORY_ID INT,
    CATEGORY_NAME NVARCHAR(100),
    BOOK_COUNT INT,         -- Số đầu sách có trong danh mục
    TOTAL_SOLD_QTY INT,     -- Tổng số lượng sách đã bán
    TOTAL_REVENUE DECIMAL(12,2) -- Tổng doanh thu
);

DECLARE @CatID INT;
DECLARE @CatName NVARCHAR(100);

DECLARE CatCursor CURSOR FOR 
SELECT CATEGORY_ID, CATEGORY_NAME FROM CATEGORIES;

OPEN CatCursor;
FETCH NEXT FROM CatCursor INTO @CatID, @CatName;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @CountBooks INT;
    DECLARE @SoldQty INT;
    DECLARE @Revenue DECIMAL(12,2);

    SELECT @CountBooks = COUNT(*) FROM BOOKS WHERE CATEGORY_ID = @CatID;

    SELECT 
        @SoldQty = SUM(OD.QUANTITY),
        @Revenue = SUM(OD.QUANTITY * OD.PRICE)
    FROM ORDER_DETAILS OD
    JOIN BOOKS B ON OD.BOOK_ID = B.BOOK_ID
    JOIN ORDERS O ON OD.ORDER_ID = O.ORDER_ID
    WHERE B.CATEGORY_ID = @CatID AND O.STATUS = 'Completed'; -- Chỉ tính đơn thành công

    INSERT INTO @CategoryReport (CATEGORY_ID, CATEGORY_NAME, BOOK_COUNT, TOTAL_SOLD_QTY, TOTAL_REVENUE)
    VALUES (@CatID, @CatName, @CountBooks, ISNULL(@SoldQty, 0), ISNULL(@Revenue, 0));

    FETCH NEXT FROM CatCursor INTO @CatID, @CatName;
END;

CLOSE CatCursor;
DEALLOCATE CatCursor;

-- Xuất báo cáo
SELECT * FROM @CategoryReport ORDER BY TOTAL_REVENUE DESC;


-- 2. Phân hạng khách hàng thân thiết
-- Tính tổng tiền họ đã chi tiêu. Dựa vào tổng tiền, xếp hạng họ theo quy tắc:
-- Trên 1.000.000 VNĐ: VIP
-- Trên 500.000 VNĐ: GOLD
-- Còn lại: STANDARD

-- Khai báo bảng tạm chứa kết quả
DECLARE @CustomerRankReport TABLE (
    USER_ID INT,
    FULL_NAME NVARCHAR(100),
    TOTAL_SPENT DECIMAL(12,2),
    RANKING_LEVEL VARCHAR(20),  -- VIP, GOLD, STANDARD
    LAST_ORDER_DATE DATETIME
);

DECLARE @CurUserID INT;
DECLARE @CurUserName NVARCHAR(100);
DECLARE @CurTotalSpent DECIMAL(12,2);
DECLARE @CurLastOrder DATETIME;
DECLARE @Rank VARCHAR(20);

-- Khai báo Cursor lấy danh sách User (chỉ lấy những người đã mua hàng)
DECLARE CustomerCursor CURSOR FOR 
SELECT DISTINCT U.USER_ID, U.FULL_NAME 
FROM USERS U
JOIN ORDERS O ON U.USER_ID = O.USER_ID;

OPEN CustomerCursor;
FETCH NEXT FROM CustomerCursor INTO @CurUserID, @CurUserName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT 
        @CurTotalSpent = SUM(TOTAL_AMOUNT),
        @CurLastOrder = MAX(ORDER_DATE)
    FROM ORDERS 
    WHERE USER_ID = @CurUserID AND STATUS <> 'Cancelled'; -- Không tính đơn hủy

    SET @Rank = CASE 
        WHEN @CurTotalSpent >= 1000000 THEN 'VIP'
        WHEN @CurTotalSpent >= 500000 THEN 'GOLD'
        ELSE 'STANDARD'
    END;

    INSERT INTO @CustomerRankReport (USER_ID, FULL_NAME, TOTAL_SPENT, RANKING_LEVEL, LAST_ORDER_DATE)
    VALUES (@CurUserID, @CurUserName, ISNULL(@CurTotalSpent, 0), @Rank, @CurLastOrder);

    FETCH NEXT FROM CustomerCursor INTO @CurUserID, @CurUserName;
END;

CLOSE CustomerCursor;
DEALLOCATE CustomerCursor;

-- Xuất báo cáo
SELECT * FROM @CustomerRankReport ORDER BY TOTAL_SPENT DESC;
