USE [master];
GO

-- Tạo Login (Tài khoản cấp Server)
-- Thay đổi 'BookStoreAdmin' và 'BookStore@2025' theo ý thích
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'BookStoreAdmin')
BEGIN
    CREATE LOGIN [BookStoreAdmin]
    WITH PASSWORD = 'BookStore@2025',
    DEFAULT_DATABASE = [BOOK_STORE],
    CHECK_EXPIRATION = OFF,
    CHECK_POLICY = OFF;
END
GO

USE [BOOK_STORE];
GO

-- Tạo User (Map Login vào Database cụ thể)
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'BookStoreAdmin')
BEGIN
    CREATE USER [BookStoreAdmin] FOR LOGIN [BookStoreAdmin];
END
GO

-- Cấp quyền (Permissions)
-- Cho phép Xem, Thêm, Sửa, Xóa dữ liệu
ALTER ROLE [db_datareader] ADD MEMBER [BookStoreAdmin];
ALTER ROLE [db_datawriter] ADD MEMBER [BookStoreAdmin];

-- Cấp quyền cho phép chạy Stored Procedure
GRANT EXECUTE TO [BookStoreAdmin];

GO
