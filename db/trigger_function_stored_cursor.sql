USE BOOK_STORE;
GO

-- ============================= FUNCTION =============================
-- 1. Function tính tổng tiền đơn hàng
CREATE FUNCTION fn_CalculateOrderTotal (@OrderID INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @Total DECIMAL(18, 2);
    
    SELECT @Total = SUM(od.QUANTITY * od.PRICE)
    FROM ORDER_DETAILS od
    WHERE od.ORDER_ID = @OrderID;
    
    -- Nếu không có dữ liệu, trả về 0
    IF @Total IS NULL
        SET @Total = 0;
    
    RETURN @Total;
END;
GO

-- 2. Function xác định hạng thành viên dựa trên tổng chi tiêu
CREATE FUNCTION fn_GetUserRank (@UserID INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @TotalSpent DECIMAL(18, 2);
    DECLARE @Rank VARCHAR(20);

    -- Tính tổng tiền các đơn hàng đã hoàn thành
    SELECT @TotalSpent = SUM(TOTAL_AMOUNT)
    FROM ORDERS
    WHERE USER_ID = @UserID AND STATUS = 'Completed';

    SET @TotalSpent = ISNULL(@TotalSpent, 0);

    -- Logic xếp hạng
    IF @TotalSpent >= 1000000
        SET @Rank = 'VIP';
    ELSE IF @TotalSpent >= 500000
        SET @Rank = 'GOLD';
    ELSE
        SET @Rank = 'STANDARD';

    RETURN @Rank;
END;
GO

-- 3. Function tính doanh thu theo ngày
CREATE FUNCTION fn_CalculateDailyRevenue (@Date DATE)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(18, 2);
    
    SELECT @Revenue = SUM(od.QUANTITY * od.PRICE)
    FROM ORDERS o
    INNER JOIN ORDER_DETAILS od ON o.ORDER_ID = od.ORDER_ID
    WHERE CAST(o.CREATED_AT AS DATE) = @Date
        AND o.STATUS = 'Completed';
    
    -- Nếu không có doanh thu, trả về 0
    IF @Revenue IS NULL
        SET @Revenue = 0;
    
    RETURN @Revenue;
END;
GO

-- ============================= TRIGGER =============================
-- 1. Quản lý tồn kho hoàn lại khi hủy đơn hàng (Cancelled)
CREATE TRIGGER trg_InventoryManagement
ON ORDERS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Xử lý khi trạng thái (Status) chuyển sang 'Cancelled'
    IF UPDATE(STATUS)
    BEGIN
        UPDATE b
        SET b.QUANTITY = b.QUANTITY + od.QUANTITY
        FROM BOOKS b
        INNER JOIN ORDER_DETAILS od ON b.BOOK_ID = od.BOOK_ID
        INNER JOIN inserted i ON od.ORDER_ID = i.ORDER_ID
        WHERE i.STATUS = 'Cancelled'
            AND i.STATUS <> (SELECT STATUS FROM deleted WHERE ORDER_ID = i.ORDER_ID)
    END
END
GO

-- 2. Không cho xóa danh mục nếu đang có sách
CREATE TRIGGER trg_PreventDeleteCategory
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

-- 3. Không cho xóa sách nếu đã từng phát sinh đơn hàng
CREATE TRIGGER trg_PreventDeleteBook
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

-- 4. Tự động tạo 1 giỏ hàng duy nhất khi có người dùng đăng ký mới
CREATE TRIGGER trg_AutoCreateCart
ON USERS
AFTER INSERT
AS
BEGIN
    INSERT INTO CARTS (USER_ID)
    SELECT USER_ID
    FROM inserted
    WHERE ROLE = 'USER';
END
GO

-- 5. Cập nhật updated_at của giỏ hàng khi thêm/xóa sản phẩm trong giỏ
CREATE TRIGGER trg_UpdateCartTimestamp
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
    END

    -- Nếu chưa có thì tạo mới user
    INSERT INTO USERS (
        FULL_NAME,
        EMAIL,
        PASSWORD_HASH,
        PHONE,
        ADDRESS
    ) VALUES (
        @FullName,
        LOWER(@Email),
        @PasswordHash,
        @Phone,
        @Address
    );

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

        DECLARE @UserRole VARCHAR(20);
        SELECT @UserRole = USER_ID FROM USERS WHERE USER_ID = @UserID AND IS_ACTIVE = 1

        IF @UserRole IS NULL
        BEGIN
            RAISERROR(N'Người dùng không hợp lệ hoặc đã bị khóa.', 16, 1);
            RETURN;
        END

        IF @UserRole = 'ADMIN'
        BEGIN
            RAISERROR(N'Tài khoản Admin không được sử dụng chức năng này!', 16, 1);
            RETURN;
        END

        -- Kiểm tra số lượng hợp lệ
        IF @Quantity <= 0
        BEGIN
            RAISERROR(N'Số lượng phải lớn hơn 0.', 16, 1);
            RETURN;
        END

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
        END

        -- Lấy CartID của user
        SELECT @CartID = CART_ID FROM CARTS WHERE USER_ID = @UserID;

        IF @CartID IS NULL
        BEGIN
            RAISERROR(N'Không tìm thấy giỏ hàng của người dùng.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        SELECT @ExistingInCart = QUANTITY
        FROM CART_ITEMS
        WHERE CART_ID = @CartID AND BOOK_ID = @BookID;

        IF (@ExistingInCart + @Quantity) > @CurrentStock
        BEGIN
            RAISERROR(N'Số lượng tồn kho không đủ.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Nếu sách đã có trong giỏ -> update số lượng
        IF @ExistingInCart > 0
        BEGIN
            UPDATE CART_ITEMS
            SET QUANTITY = QUANTITY + @Quantity, ADDED_AT = GETDATE()
            WHERE CART_ID = @CartID AND BOOK_ID = @BookID;
        END
        ELSE
        BEGIN
            -- Nếu chưa có -> insert mới
            INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY)
            VALUES (@CartID, @BookID, @Quantity);
        END

        COMMIT TRANSACTION;

        -- Trả kết quả
        SELECT 
            @CartID AS CartID,
            @BookID AS BookID,
            BOOK_NAME AS [Tên sách],
            @Quantity AS [Số lượng],
            N'Thêm sản phẩm vào giỏ hàng thành công' AS [Thông báo]
        FROM BOOKS
        WHERE BOOK_ID = @BookID;
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

        DECLARE @UserRole VARCHAR(20);
        SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @UserID;

        IF @UserRole IS NULL
        BEGIN 
            RAISERROR(N'Không tìm thấy người dùng!', 16, 1);
            RETURN;
        END

        IF @UserRole = 'ADMIN'
        BEGIN
            RAISERROR(N'Tài khoản Admin không được sử dụng chức năng này!', 16, 1);
            RETURN;
        END

        DECLARE @CartID INT;
        DECLARE @NewOrderID INT;
        DECLARE @TotalAmount DECIMAL(18, 2);

        -- Lấy CartID của user
        SELECT @CartID = CART_ID FROM CARTS WHERE USER_ID = @UserID;

        IF @CartID IS NULL
        BEGIN
            RAISERROR(N'Người dùng chưa có giỏ hàng', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Kiểm tra giỏ hàng rỗng
        IF NOT EXISTS (SELECT 1 FROM CART_ITEMS WHERE CART_ID = @CartID)
        BEGIN
            RAISERROR(N'Giỏ hàng của bạn đang trống.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Kiểm tra tồn kho
        IF EXISTS (
            SELECT 1
            FROM CART_ITEMS ci
            JOIN BOOKS b ON ci.BOOK_ID = b.BOOK_ID
            WHERE ci.CART_ID = @CartID AND ci.QUANTITY > b.QUANTITY
        )
        BEGIN
            RAISERROR(N'Số lượng sản phẩm trong giỏ hàng vượt quá số lượng tồn kho!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Tạo đơn hàng
        INSERT INTO ORDERS (
            USER_ID,
            RECEIVER_NAME,
            RECEIVER_PHONE,
            SHIPPING_ADDRESS,
            TOTAL_AMOUNT,
            PAYMENT_METHOD
        ) VALUES (
            @UserID,
            @ReceiverName,
            @ReceiverPhone,
            @ShippingAddress,
            0,
            @PaymentMethod
        );

        -- Lấy ID của đơn hàng vừa tạo
        SET @NewOrderID = SCOPE_IDENTITY();

        -- Tạo chi tiết đơn hàng
        INSERT INTO ORDER_DETAILS (
            ORDER_ID,
            BOOK_ID,
            QUANTITY,
            PRICE
        )
        SELECT 
            @NewOrderID,
            ci.BOOK_ID,
            ci.QUANTITY,
            b.PRICE
        FROM CART_ITEMS ci
        JOIN BOOKS b ON ci.BOOK_ID = b.BOOK_ID
        WHERE ci.CART_ID = @CartID;
        
        -- Cập nhật tồn kho
        UPDATE b
        SET b.QUANTITY = b.QUANTITY - ci.QUANTITY
        FROM BOOKS b
        JOIN CART_ITEMS ci ON b.BOOK_ID = ci.BOOK_ID
        WHERE ci.CART_ID = @CartID;

        -- Tính tổng tiền đơn hàng
        SET @TotalAmount = dbo.fn_CalculateOrderTotal(@NewOrderID);

        -- Cập nhật lại TOTAL_AMOUNT cho đơn hàng
        UPDATE ORDERS
        SET TOTAL_AMOUNT = @TotalAmount
        WHERE ORDER_ID = @NewOrderID;

        -- Xóa các các sản phẩm trong giỏ hàng sau khi đặt hàng thành công
        DELETE FROM CART_ITEMS WHERE CART_ID = @CartID;

        COMMIT TRANSACTION;

        -- Trả về thông báo thành công
        SELECT 
            @NewOrderID AS OrderID,
            @TotalAmount AS [Tổng tiền],
            N'Đặt hàng thành công' AS [Thông báo]
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        -- Trả về lỗi
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 4. Stored Procedure lịch sử mua hàng
CREATE PROC sp_GetUserOrderHistory (
    @RequestUserID INT,
    @TargetUserID INT,
    @Status VARCHAR(20) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RequestUserRole VARCHAR(20);
    SELECT @RequestUserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF (@RequestUserRole <> 'ADMIN' AND @RequestUserID <> @TargetUserID)
    BEGIN
        RAISERROR(N'Bạn không có quyền xem lịch sử đơn hàng của người khác!', 16, 1);
        RETURN;
    END

    SELECT 
        ORDER_ID AS OrderID,
        RECEIVER_NAME AS [Tên người nhận],
        SHIPPING_ADDRESS AS [Địa chỉ giao hàng],
        TOTAL_AMOUNT AS [Tổng tiền],
        PAYMENT_METHOD AS [Phương thức thanh toán],
        STATUS AS [Trạng thái],
        CREATED_AT AS [Ngày đặt hàng],
        (SELECT COUNT(*) FROM ORDER_DETAILS WHERE ORDER_ID = o.ORDER_ID) AS [Số lượng]
    FROM ORDERS o
    WHERE USER_ID = @TargetUserID
        AND (@Status IS NULL OR STATUS = @Status)
    ORDER BY CREATED_AT DESC;
END;
GO

-- 5. Stored Procedure Thống kê doanh thu hàng tháng
CREATE PROC sp_GetMonthlyRevenue (
    @RequestUserID INT,
    @Year INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserRole VARCHAR(20);
    SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF @UserRole IS NULL OR @UserRole <> 'ADMIN'
    BEGIN
        RAISERROR(N'Bạn không có quyền thực hiện thao tác này!', 16, 1);
        RETURN;
    END;

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
        ON MONTH(o.CREATED_AT) = m.MonthNum
        AND YEAR(o.CREATED_AT) = @Year
        AND o.STATUS = 'Completed'
    GROUP BY m.MonthNum
    ORDER BY m.MonthNum;
END;
GO

-- 6. Stored Procedure top sách bán chạy
CREATE PROC sp_GetBestSellingBooks (
    @RequestUserID INT,
    @Year INT,
    @Month INT = NULL,
    @TopN INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserRole VARCHAR(20);
    SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF @UserRole IS NULL OR @UserRole <> 'ADMIN'
    BEGIN
        RAISERROR(N'Bạn không có quyền thực hiện thao tác này!', 16, 1);
        RETURN;
    END

    SELECT TOP (@TopN)
        b.BOOK_ID AS BookID,
        b.BOOK_NAME AS [Tên sách],
        a.AUTHOR_NAME AS [Tác giả],
        b.PRICE AS [Giá bán],
        b.IMAGE AS [Hình ảnh],
        SUM(od.QUANTITY) AS [Tổng số đã bán],
        ISNULL(SUM(od.QUANTITY * od.PRICE), 0) AS [Tổng doanh thu]
    FROM ORDER_DETAILS od
    JOIN ORDERS o ON od.ORDER_ID = o.ORDER_ID
    JOIN BOOKS b ON od.BOOK_ID = b.BOOK_ID
    JOIN AUTHORS a ON b.AUTHOR_ID = a.AUTHOR_ID
    WHERE o.STATUS = 'Completed'
        AND YEAR(o.CREATED_AT) = @Year
        AND (@Month IS NULL OR MONTH(o.CREATED_AT) = @Month)
    GROUP BY b.BOOK_ID, b.BOOK_NAME, b.IMAGE, b.PRICE, a.AUTHOR_NAME
    ORDER BY [Tổng số đã bán] DESC;
END;
GO

-- 7. Stored Procedure thêm sách mới
CREATE PROC sp_CreateBook (
    @RequestUserID INT,
    @BookName NVARCHAR(255),
    @AuthorID INT,
    @Price DECIMAL(18, 2),
    @Quantity INT,
    @Description NVARCHAR(MAX),
    @CategoryID INT,
    @Pages INT,
    @Language NVARCHAR(50),
    @PublishYear INT,
    @PublisherID INT,
    @Image VARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserRole VARCHAR(20);
    SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF @UserRole IS NULL OR @UserRole <> 'ADMIN'
    BEGIN
        RAISERROR(N'Bạn không có quyền thực hiện thao tác này!', 16, 1);
        RETURN;
    END

    IF @Price <= 0
    BEGIN
        RAISERROR(N'Giá sách phải lớn hơn 0!', 16, 1);
        RETURN;
    END

    IF @Quantity < 0
    BEGIN
        RAISERROR(N'Số lượng không được âm!', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM BOOKS WHERE BOOK_NAME = @BookName AND IS_DELETED = 0)
    BEGIN
        RAISERROR(N'Sách này đã tồn tại trong kho!', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM AUTHORS WHERE AUTHOR_ID = @AuthorID)
    BEGIN
        RAISERROR(N'Tác giả không tồn tại!', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM CATEGORIES WHERE CATEGORY_ID = @CategoryID)
    BEGIN
        RAISERROR(N'Danh mục không tồn tại!', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM PUBLISHERS WHERE PUBLISHER_ID = @PublisherID)
    BEGIN
        RAISERROR(N'Nhà xuất bản không tồn tại!', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO BOOKS (
            BOOK_NAME,
            AUTHOR_ID,
            PRICE,
            QUANTITY,
            DESCRIPTION,
            CATEGORY_ID,
            PAGES,
            LANGUAGE,
            PUBLISH_YEAR,
            PUBLISHER_ID,
            IMAGE
        )
        VALUES (
            @BookName,
            @AuthorID,
            @Price,
            @Quantity,
            @Description,
            @CategoryID,
            @Pages,
            @Language,
            @PublishYear,
            @PublisherID,
            @Image
        );

        -- Trả về thông tin sách vừa tạo
        SELECT * FROM BOOKS WHERE BOOK_ID = SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 8. Stored Procedure cập nhật thông tin sách
CREATE PROC sp_UpdateBookInfo (
    @RequestUserID INT,
    @BookID INT,
    @BookName NVARCHAR(255),
    @AuthorID INT,
    @Price DECIMAL(18, 2),
    @Quantity INT,
    @Description NVARCHAR(MAX),
    @CategoryID INT,
    @Pages INT,
    @Language NVARCHAR(50),
    @PublishYear INT,
    @PublisherID INT,
    @Image VARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserRole VARCHAR(20);
    SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF @UserRole IS NULL OR @UserRole <> 'ADMIN'
    BEGIN
        RAISERROR(N'Bạn không có quyền thực hiện thao tác này!', 16, 1);
        RETURN;
    END

    BEGIN TRY
        -- Kiểm tra xem sách có tồn tại và có bị xóa không
        IF NOT EXISTS (SELECT 1 FROM BOOKS WHERE BOOK_ID = @BookID AND IS_DELETED = 0)
        BEGIN
            RAISERROR(N'Sách không tồn tại!', 16, 1);
            RETURN;
        END

        -- Cập nhật thông tin sách
        UPDATE BOOKS
        SET
            BOOK_NAME = @BookName,
            AUTHOR_ID = @AuthorID,
            PRICE = @Price,
            QUANTITY = @Quantity,
            DESCRIPTION = @Description,
            CATEGORY_ID = @CategoryID,
            PAGES = @Pages,
            LANGUAGE = @Language,
            PUBLISH_YEAR = @PublishYear,
            PUBLISHER_ID = @PublisherID,
            IMAGE = @Image,
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

-- 9. Stored Procedure hủy đơn hàng
CREATE PROCEDURE sp_CancelOrder
    @RequestUserID INT,
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentStatus VARCHAR(20);
    DECLARE @OrderOwnerID INT;
    DECLARE @UserRole VARCHAR(20);

    -- Lấy thông tin đơn hàng và quyền hạn người dùng
    SELECT
        @CurrentStatus = STATUS,
        @OrderOwnerID = USER_ID 
    FROM ORDERS
    WHERE ORDER_ID = @OrderID;

    SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF @CurrentStatus IS NULL
    BEGIN
        RAISERROR(N'Đơn hàng không tồn tại!', 16, 1);
        RETURN;
    END

    -- Logic phân quyền hủy đơn hàng
    IF @UserRole = 'ADMIN'
    BEGIN
        IF @CurrentStatus NOT IN ('Pending', 'Delivering')
        BEGIN
            RAISERROR(N'Admin chỉ có thể hủy đơn khi đang Pending hoặc Delivering!', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        IF @OrderOwnerID <> @RequestUserID
        BEGIN
            RAISERROR(N'Bạn không có quyền hủy đơn hàng này!', 16, 1);
            RETURN;
        END

        IF @CurrentStatus <> 'Pending'
        BEGIN
            RAISERROR(N'Bạn chỉ có thể hủy đơn khi chưa giao hàng (Pending)!', 16, 1);
            RETURN;
        END
    END

    -- Cập nhật trạng thái đơn hàng thành 'Cancelled'
    UPDATE ORDERS
    SET
        STATUS = 'Cancelled',
        UPDATED_AT = GETDATE()
    WHERE ORDER_ID = @OrderID;

    -- Trả về thông báo thành công
    SELECT
        ORDER_ID AS OrderID,
        STATUS AS [Trạng thái mới],
        N'Đơn hàng đã được hủy thành công.' AS [Thông báo]
    FROM ORDERS
    WHERE ORDER_ID = @OrderID;
END;
GO

-- 10. Stored Procedure chuyển đơn hàng sang thái thái giao hàng (Delivering)
CREATE PROC sp_StartDelivery (
    @RequestUserID INT,
    @OrderID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check quyền Admin
    DECLARE @UserRole VARCHAR(20);
    SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF @UserRole IS NULL OR @UserRole <> 'ADMIN'
    BEGIN
        RAISERROR(N'Bạn không có quyền thực hiện thao tác này!', 16, 1);
        RETURN;
    END

    -- Check trạng thái hiện tại của đơn hàng
    DECLARE @CurrentStatus VARCHAR(20);
    SELECT @CurrentStatus = STATUS FROM ORDERS WHERE ORDER_ID = @OrderID;

    IF @CurrentStatus IS NULL
    BEGIN
        RAISERROR(N'Đơn hàng không tồn tại!', 16, 1);
        RETURN;
    END

    IF @CurrentStatus <> 'Pending'
    BEGIN
        RAISERROR(N'Chỉ có thể chuyển đơn hàng sang trạng thái Đang giao (Delivering) khi đơn hàng đang ở trạng thái Chờ xử lý (Pending)!', 16, 1);
        RETURN;
    END

    -- Cập nhật trạng thái đơn hàng thành 'Delivering'
    UPDATE ORDERS
    SET
        STATUS = 'Delivering',
        UPDATED_AT = GETDATE()
    WHERE ORDER_ID = @OrderID;

    -- Trả về thông báo thành công
    SELECT 
        ORDER_ID AS OrderID,
        STATUS as [Trạng thái mới], 
        N'Đã chuyển sang giao hàng (Delivering)' as [Thông báo] 
    FROM ORDERS 
    WHERE ORDER_ID = @OrderID;
END;
GO

-- 11. Stored Procedure hoàn thành đơn hàng
CREATE PROC sp_CompleteOrder (
    @RequestUserID INT,
    @OrderID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserRole VARCHAR(20);
    SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF @UserRole IS NULL OR @UserRole <> 'ADMIN'
    BEGIN
        RAISERROR(N'Bạn không có quyền thực hiện thao tác này!', 16, 1);
        RETURN;
    END

    DECLARE @CurrentStatus VARCHAR(20);
    SELECT @CurrentStatus = STATUS FROM ORDERS WHERE ORDER_ID = @OrderID;

    IF @CurrentStatus <> 'Delivering'
    BEGIN
        RAISERROR(N'Chỉ có thể hoàn thành đơn hàng đang ở trạng thái Delivering!', 16, 1);
        RETURN;
    END

    -- Cập nhật trạng thái đơn hàng thành 'Completed'
    UPDATE ORDERS
    SET
        STATUS = 'Completed',
        UPDATED_AT = GETDATE()
    WHERE ORDER_ID = @OrderID;

    -- Trả về thông báo thành công
    SELECT 
        ORDER_ID AS OrderID,
        STATUS as [Trạng thái mới], 
        N'Đã hoàn thành đơn hàng!' as [Thông báo] 
    FROM ORDERS 
    WHERE ORDER_ID = @OrderID;
END;
GO

-- 12. Stored Procedure xóa mềm sách
CREATE PROC sp_SoftDeleteBook (
    @RequestUserID INT,
    @BookID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check quyền Admin
    DECLARE @UserRole VARCHAR(20);
    SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF @UserRole IS NULL OR @UserRole <> 'ADMIN'
    BEGIN
        RAISERROR(N'Bạn không có quyền thực hiện thao tác này!', 16, 1);
        RETURN;
    END

    -- Kiểm tra sách có tồn tài hay không
    IF NOT EXISTS (SELECT 1 FROM BOOKS WHERE BOOK_ID = @BookID)
    BEGIN
        RAISERROR(N'Sách không tồn tại!', 16, 1);
        RETURN;
    END

    -- Xóa mềm sách
    UPDATE BOOKS
    SET
        IS_DELETED = 1,
        UPDATED_AT = GETDATE()
    WHERE BOOK_ID = @BookID;

    -- Trả về thông báo thành công
    SELECT 
        BOOK_ID AS BookID,
        BOOK_NAME AS [Tên sách],
        IS_DELETED AS [Trạng thái xóa],
        N'Sách đã được xóa mềm thành công!' AS [Thông báo]
    FROM BOOKS
    WHERE BOOK_ID = @BookID;
END;
GO

-- 13. Stored Procedure xóa vĩnh viễn sách
CREATE PROC sp_HardDeleteBook (
    @RequestUserID INT,
    @BookID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check quyền Admin
    DECLARE @UserRole VARCHAR(20);
    SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF @UserRole IS NULL OR @UserRole <> 'ADMIN'
    BEGIN
        RAISERROR(N'Bạn không có quyền thực hiện thao tác này!', 16, 1);
        RETURN;
    END

    -- Kiểm tra sách có tồn tài hay không
    IF NOT EXISTS (SELECT 1 FROM BOOKS WHERE BOOK_ID = @BookID)
    BEGIN
        RAISERROR(N'Sách không tồn tại!', 16, 1);
        RETURN;
    END

    -- Thực hiện xóa vĩnh viễn
    BEGIN TRY
        DELETE FROM BOOKS WHERE BOOK_ID = @BookID;
        
        SELECT
            @BookID AS BookID,
            N'Đã xóa vĩnh viễn sách khỏi cơ sở dữ liệu!' AS [Thông báo];
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 14. Stored Procedure Xóa danh mục sách
CREATE PROC sp_DeleteCategory (
    @RequestUserID INT,
    @CategoryID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check quyền Admin
    DECLARE @UserRole VARCHAR(20);
    SELECT @UserRole = ROLE FROM USERS WHERE USER_ID = @RequestUserID;

    IF @UserRole IS NULL OR @UserRole <> 'ADMIN'
    BEGIN
        RAISERROR(N'Bạn không có quyền thực hiện thao tác này!', 16, 1);
        RETURN;
    END

    -- Thực hiện xóa danh mục (trigger hoạt động)
    BEGIN TRY
        DELETE FROM CATEGORIES WHERE CATEGORY_ID = @CategoryID;
        
        -- Trả về thông báo thành công
        SELECT
            @CategoryID AS CategoryID,
            N'Xóa danh mục thành công!' AS [Thông báo];
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END;
GO

-- ============================= CURSOR =============================

-- 1. Báo cáo hiệu quả kinh doanh theo Danh mục (Category Performance)

DECLARE @CategoryReport TABLE (
    CATEGORY_ID INT,
    CATEGORY_NAME NVARCHAR(100),
    BOOK_COUNT INT,         -- Số đầu sách có trong danh mục
    TOTAL_SOLD_QTY INT,     -- Tổng số lượng sách đã bán
    TOTAL_REVENUE DECIMAL(18, 2) -- Tổng doanh thu
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
    DECLARE @Revenue DECIMAL(18, 2);

    SELECT @CountBooks = COUNT(*) FROM BOOKS WHERE CATEGORY_ID = @CatID;

    SELECT 
        @SoldQty = SUM(OD.QUANTITY),
        @Revenue = SUM(OD.QUANTITY * OD.PRICE)
    FROM ORDER_DETAILS OD
    JOIN BOOKS B ON OD.BOOK_ID = B.BOOK_ID
    JOIN ORDERS O ON OD.ORDER_ID = O.ORDER_ID
    WHERE B.CATEGORY_ID = @CatID AND O.STATUS = 'Completed';

    INSERT INTO @CategoryReport (CATEGORY_ID, CATEGORY_NAME, BOOK_COUNT, TOTAL_SOLD_QTY, TOTAL_REVENUE)
    VALUES (@CatID, @CatName, @CountBooks, ISNULL(@SoldQty, 0), ISNULL(@Revenue, 0));

    FETCH NEXT FROM CatCursor INTO @CatID, @CatName;
END;

CLOSE CatCursor;
DEALLOCATE CatCursor;

-- Xuất báo cáo
SELECT
    CATEGORY_ID AS CategoryID,
    CATEGORY_NAME AS [Tên danh mục],
    BOOK_COUNT AS [Số đầu sách],
    TOTAL_SOLD_QTY AS [Tổng số lượng đã bán],
    TOTAL_REVENUE AS [Tổng doanh thu]
FROM @CategoryReport
ORDER BY TOTAL_REVENUE DESC;


-- 2. Phân hạng khách hàng thân thiết
-- Tính tổng tiền họ đã chi tiêu. Dựa vào tổng tiền, xếp hạng họ theo quy tắc:
-- Trên 1.000.000 VNĐ: VIP
-- Trên 500.000 VNĐ: GOLD
-- Còn lại: STANDARD

-- Khai báo bảng tạm chứa kết quả
DECLARE @CustomerRankReport TABLE (
    USER_ID INT,
    FULL_NAME NVARCHAR(100),
    TOTAL_SPENT DECIMAL(18, 2),
    RANKING_LEVEL VARCHAR(20),  -- VIP, GOLD, STANDARD
    LAST_ORDER_DATE DATETIME
);

DECLARE @CurUserID INT;
DECLARE @CurUserName NVARCHAR(100);
DECLARE @CurTotalSpent DECIMAL(18, 2);
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
        @CurLastOrder = MAX(CREATED_AT)
    FROM ORDERS
    WHERE USER_ID = @CurUserID AND STATUS = 'Completed';

    -- Gọi function để lấy hạng thành viên
    SET @Rank = dbo.fn_GetUserRank(@CurUserID);

    INSERT INTO @CustomerRankReport (USER_ID, FULL_NAME, TOTAL_SPENT, RANKING_LEVEL, LAST_ORDER_DATE)
    VALUES (@CurUserID, @CurUserName, ISNULL(@CurTotalSpent, 0), @Rank, @CurLastOrder);

    FETCH NEXT FROM CustomerCursor INTO @CurUserID, @CurUserName;
END;

CLOSE CustomerCursor;
DEALLOCATE CustomerCursor;

-- Xuất báo cáo
SELECT
    USER_ID AS UserID,
    FULL_NAME AS [Tên khách hàng],
    TOTAL_SPENT AS [Tổng chi tiêu],
    RANKING_LEVEL AS [Hạng thành viên],
    LAST_ORDER_DATE AS [Lần mua gần nhất]
FROM @CustomerRankReport
ORDER BY TOTAL_SPENT DESC;
