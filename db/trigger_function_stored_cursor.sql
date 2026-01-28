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
CREATE FUNCTION fn_GetBestSellingBooks (@Top INT)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (@Top)
        b.BOOK_ID,
        b.BOOK_NAME,
        b.PRICE,
        b.IMAGE,
        SUM(od.QUANTITY) AS TotalSold
    FROM BOOKS b
    JOIN ORDER_DETAILS od ON b.BOOK_ID = od.BOOK_ID
    JOIN ORDERS o ON od.ORDER_ID = o.ORDER_ID
    WHERE o.STATUS = 'Completed' -- Chỉ tính các đơn đã bán thành công
    GROUP BY b.BOOK_ID, b.BOOK_NAME, b.PRICE, b.IMAGE
    ORDER BY TotalSold DESC
);
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
-- 1. Quản lý tồn kho: Trừ khi mua (Pending -> Delivering) và Hoàn khi hủy (Cancelled)
CREATE TRIGGER TRG_InventoryManagement
ON ORDERS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Trừ kho khi đơn hàng được xác nhận (Chuyển từ Pending sang Delivering)
    IF UPDATE(STATUS)
    BEGIN
        UPDATE B
        SET B.QUANTITY = B.QUANTITY - OD.QUANTITY
        FROM BOOKS B
        INNER JOIN ORDER_DETAILS OD ON B.BOOK_ID = OD.BOOK_ID
        INNER JOIN inserted I ON OD.ORDER_ID = I.ORDER_ID
        INNER JOIN deleted D ON I.ORDER_ID = D.ORDER_ID
        WHERE I.STATUS = 'Delivering' AND D.STATUS = 'Pending';

        -- Hoàn kho khi đơn hàng bị hủy (Chuyển sang Cancelled)
        -- Chỉ hoàn kho nếu trạng thái cũ là 'Delivering' hoặc 'Completed'
        UPDATE B
        SET B.QUANTITY = B.QUANTITY + OD.QUANTITY
        FROM BOOKS B
        INNER JOIN ORDER_DETAILS OD ON B.BOOK_ID = OD.BOOK_ID
        INNER JOIN inserted I ON OD.ORDER_ID = I.ORDER_ID
        INNER JOIN deleted D ON I.ORDER_ID = D.ORDER_ID
        WHERE I.STATUS = 'Cancelled' AND (D.STATUS = 'Delivering' OR D.STATUS = 'Completed');
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
    SELECT SCOPE_IDENTITY() AS NewUserID, N'Đăng ký tài khoản thành công!' AS [Thông báo];
END;
GO

-- 2. Stored Procedure thêm sản phẩm vào giỏ hàng
CREATE PROC sp_AddToCart (
    @UserID INT,
    @BookID INT,
    @Quantity INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra user hợp lệ
        IF NOT EXISTS (SELECT 1 FROM USERS WHERE USER_ID = @UserID AND IS_ACTIVE = 1)
        BEGIN
            RAISERROR(N'Người dùng không hợp lệ hoặc đã bị khóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra số lượng hợp lệ
        IF @Quantity <= 0
        BEGIN
            RAISERROR(N'Số lượng phải lớn hơn 0.', 16, 1);
            RETURN;
        END;

        DECLARE @CartID INT;
        DECLARE @CurrentStock INT;
        DECLARE @ExistingInCart INT;

        -- Kiểm tra sách tồn tại, chưa bị xóa và lấy tồn kho hiện tại
        SELECT @CurrentStock = QUANTITY FROM BOOKS WHERE BOOK_ID = @BookID AND IS_DELETED = 0;

        IF @CurrentStock IS NULL
        BEGIN
            RAISERROR(N'Sách không tồn tại hoặc đã bị xóa.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Lấy CartID của user
        SELECT @CartID = CART_ID FROM CARTS WHERE USER_ID = @UserID;

        IF @CartID IS NULL
        BEGIN
            INSERT INTO CARTS (USER_ID)
            VALUES (@UserID);

            SET @CartID = SCOPE_IDENTITY();
        END;
        
        SELECT @ExistingInCart = QUANTITY
        FROM CART_ITEMS
        WHERE CART_ID = @CartID AND BOOK_ID = @BookID;

        IF (@ExistingInCart + @Quantity) > @CurrentStock
        BEGIN
            RAISERROR(N'Số lượng tồn kho không đủ.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Nếu sách đã có trong giỏ → update số lượng
        IF @ExistingInCart > 0
        BEGIN
            UPDATE CART_ITEMS
            SET QUANTITY = QUANTITY + @Quantity, ADDED_AT = GETDATE()
            WHERE CART_ID = @CartID AND BOOK_ID = @BookID;
        END
        ELSE
        BEGIN
            -- Nếu chưa có → insert mới
            INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY)
            VALUES (@CartID, @BookID, @Quantity);
        END;

        COMMIT TRANSACTION;

        -- Trả kết quả
        SELECT 
            @CartID AS CartID,
            @BookID AS BookID,
            @Quantity AS [Số lượng đã thêm],
            N'Thêm sản phẩm vào giỏ hàng thành công' AS [Thông báo];
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 3. Stored Procedure mua hàng (tạo đơn hàng mới)
CREATE PROC sp_CreateOrder (
    @UserID INT,
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

        DECLARE @CartID INT;
        DECLARE @NewOrderID INT;
        DECLARE @TotalAmount DECIMAL(12, 2);

        -- Lấy CartID của user
        SELECT @CartID = CART_ID FROM CARTS WHERE USER_ID = @UserID;

        IF @CartID IS NULL
        BEGIN
            RAISERROR(N'Người dùng chưa có giỏ hàng', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Kiểm tra giỏ hàng rỗng
        IF NOT EXISTS (SELECT 1 FROM CART_ITEMS WHERE CART_ID = @CartID)
        BEGIN
            RAISERROR(N'Giỏ hàng của bạn đang trống.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Tạo đơn hàng
        INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, PAYMENT_METHOD) VALUES (@UserID, @ReceiverName, @ReceiverPhone, @ShippingAddress, 0, @PaymentMethod);

        -- Lấy ID của đơn hàng vừa tạo
        SET @NewOrderID = SCOPE_IDENTITY();

        -- Tạo chi tiết đơn hàng
        INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE)
        SELECT @NewOrderID, ci.BOOK_ID, ci.QUANTITY, b.PRICE
        FROM CART_ITEMS ci
        JOIN BOOKS b ON ci.BOOK_ID = b.BOOK_ID
        WHERE ci.CART_ID = @CartID;

        -- Trigger TRG_CheckStockBeforeOrder sẽ kiểm tra tồn kho và chặn nếu không đủ

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
            N'Đặt hàng thành công' AS [Thông báo],
            @TotalAmount AS [Tổng số tiền];
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        -- Trả về lỗi
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 4. Stored Procedure
CREATE PROC sp_GetUserOrderHistory (
    @UserID INT,
    @Status VARCHAR(20) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ORDER_ID AS OrderID,
        RECEIVER_NAME AS [Tên người nhận],
        SHIPPING_ADDRESS AS [Địa chỉ giao hàng],
        TOTAL_AMOUNT AS [Tổng tiền],
        PAYMENT_METHOD AS [Phương thức thanh toán],
        STATUS AS [Trạng thái],
        ORDER_DATE AS [Ngày đặt hàng],
        (SELECT COUNT(*) FROM ORDER_DETAILS WHERE ORDER_ID = o.ORDER_ID) AS [Số lượng sản phẩm]
    FROM ORDERS o
    WHERE USER_ID = @UserID AND (@Status IS NULL OR STATUS = @Status)
    ORDER BY ORDER_DATE DESC;
END;
GO

-- 5. Stored Procedure Thống kê doanh thu hàng tháng
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
        m.MonthNum AS [Tháng],
        COALESCE(SUM(o.TOTAL_AMOUNT), 0) AS [Tổng doanh thu],
        COUNT(o.ORDER_ID) AS [Tổng số đơn đặt hàng]
    FROM MonthList m
    LEFT JOIN ORDERS o
        ON MONTH(o.ORDER_DATE) = m.MonthNum
        AND YEAR(o.ORDER_DATE) = @Year
        AND o.STATUS = 'Completed'
    GROUP BY m.MonthNum
    ORDER BY m.MonthNum;
END;
GO

-- 6. Stored Procedure top sách bán chạy
CREATE PROC sp_GetBestSellingBooks (
    @Year INT,
    @Month INT = NULL,
    @TopN INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopN)
        b.BOOK_ID AS BookID,
        b.BOOK_NAME AS [Tên sách],
        a.AUTHOR_NAME AS [Tác giả],
        b.PRICE AS [Giá bán],
        b.IMAGE AS [Hình ảnh],
        SUM(od.QUANTITY) AS [Tổng số đã bán],
        SUM(od.QUANTITY * od.PRICE) AS [Tổng doanh thu]
    FROM ORDER_DETAILS od
    JOIN ORDERS o ON od.ORDER_ID = o.ORDER_ID
    JOIN BOOKS b ON od.BOOK_ID = b.BOOK_ID
    JOIN AUTHORS a ON b.AUTHOR_ID = a.AUTHOR_ID
    WHERE o.STATUS = 'Completed'
        AND YEAR(o.ORDER_DATE) = @Year
        AND (@Month IS NULL OR MONTH(o.ORDER_DATE) = @Month)
    GROUP BY b.BOOK_ID, b.BOOK_NAME, b.IMAGE, b.PRICE, a.AUTHOR_NAME
    ORDER BY [Tổng số đã bán] DESC;
END;
GO

-- 7. Stored Procedure cập nhật thông tin sách 
CREATE PROC sp_UpdateBookInfo (
    @BookID INT,
    @BookName NVARCHAR(255),
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

        -- Cập nhật thông tin sách
        UPDATE BOOKS
        SET
            BOOK_NAME = @BookName,
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
        SELECT @BookID AS BookID, N'Cập nhật sách thành công' AS [Thông báo];
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 8. Stored Procedure hủy đơn hàng
CREATE PROCEDURE sp_CancelOrder
    @UserID INT,
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra đơn hàng có thuộc về user này không
    IF NOT EXISTS (SELECT 1 FROM ORDERS WHERE ORDER_ID = @OrderID AND USER_ID = @UserID)
    BEGIN
        RAISERROR(N'Không tìm thấy đơn hàng hoặc không tồn tại.', 16, 1);
        RETURN;
    END

    -- Kiểm tra trạng thái đơn hàng chỉ cho phép hủy đơn hàng khi đang ở trạng thái 'Pending'
    DECLARE @CurrentStatus VARCHAR(20);
    SELECT @CurrentStatus = STATUS FROM ORDERS WHERE ORDER_ID = @OrderID;

    IF @CurrentStatus <> 'Pending'
    BEGIN
        RAISERROR(N'Chỉ có thể hủy đơn hàng đang ở trạng thái Pending.', 16, 1);
        RETURN;
    END

    -- Cập nhật trạng thái đơn hàng thành 'Cancelled'
    UPDATE ORDERS SET STATUS = 'Cancelled' WHERE ORDER_ID = @OrderID;

    -- Trả về thông báo thành công
    SELECT
        ORDER_ID AS OrderID,
        STATUS AS [Trạng thái mới],
        N'Đơn hàng đã được hủy thành công.' AS [Thông báo]
    FROM ORDERS
    WHERE ORDER_ID = @OrderID;
END;
GO

-- 9. Stored Procedure thống kê trang dashboard admin
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
