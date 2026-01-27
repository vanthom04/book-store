USE [master];
GO

-- ==========================================================================
-- 1. XÁC THỰC (AUTHENTICATION): TẠO TÀI KHOẢN TRUY CẬP
-- ==========================================================================

-- Tạo Login cho Quản trị viên (Admin)
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'BookStoreAdmin')
BEGIN
    CREATE LOGIN [BookStoreAdmin]
    WITH PASSWORD = 'BookStore@2025',
    DEFAULT_DATABASE = [BOOK_STORE],
    CHECK_EXPIRATION = OFF,
    CHECK_POLICY = OFF;
END
GO

-- Tạo Login cho Nhân viên (Staff) - Quyền hạn hạn chế hơn
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'BookStoreStaff')
BEGIN
    CREATE LOGIN [BookStoreStaff]
    WITH PASSWORD = 'StaffPassword@123',
    DEFAULT_DATABASE = [BOOK_STORE],
    CHECK_EXPIRATION = OFF,
    CHECK_POLICY = OFF;
END
GO

USE [BOOK_STORE];
GO

-- Tạo User Admin và Staff trong database BOOK_STORE
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'BookStoreAdmin')
BEGIN
    CREATE USER [BookStoreAdmin] FOR LOGIN [BookStoreAdmin];
END
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'BookStoreStaff')
BEGIN
    CREATE USER [BookStoreStaff] FOR LOGIN [BookStoreStaff];
END
GO

-- ==========================================================================
-- 2. PHÂN QUYỀN (AUTHORIZATION): GÁN QUYỀN TRÊN ĐỐI TƯỢNG 
-- ==========================================================================

-- A. Cấp quyền cho Admin: Toàn quyền đọc/ghi và thực thi
ALTER ROLE [db_datareader] ADD MEMBER [BookStoreAdmin];
ALTER ROLE [db_datawriter] ADD MEMBER [BookStoreAdmin];
GRANT EXECUTE TO [BookStoreAdmin];

-- B. Cấp quyền cho Nhân viên: Chỉ xem sách và quản lý đơn hàng
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'StaffRole' AND type = 'R')
BEGIN
    CREATE ROLE [StaffRole];
END
GO

GRANT SELECT ON BOOKS TO [StaffRole];
GRANT SELECT, UPDATE ON ORDERS TO [StaffRole];
GRANT SELECT, INSERT, UPDATE ON ORDER_DETAILS TO [StaffRole];
GRANT EXECUTE ON sp_GetUserOrderHistory TO [StaffRole];

ALTER ROLE [StaffRole] ADD MEMBER [BookStoreStaff];
GO
