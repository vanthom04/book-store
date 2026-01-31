USE [master];
GO

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

USE [BOOK_STORE];
GO

-- Tạo User Admin trong database BOOK_STORE
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'BookStoreAdmin')
BEGIN
    CREATE USER [BookStoreAdmin] FOR LOGIN [BookStoreAdmin];
END
GO

-- Cấp quyền cho Admin: Toàn quyền đọc/ghi và thực thi stored procedure
ALTER ROLE [db_datareader] ADD MEMBER [BookStoreAdmin];
ALTER ROLE [db_datawriter] ADD MEMBER [BookStoreAdmin];
GRANT EXECUTE TO [BookStoreAdmin];
GO
