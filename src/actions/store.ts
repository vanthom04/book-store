"use server"

import { withTiming } from "@/lib/utils"
import { executeSP, getPool } from "@/lib/db"

import { getCurrentUser } from "./user"

export async function getDailyRevenue(date: any) {
  const user = await getCurrentUser()

  if (!user || user.ROLE !== "ADMIN") {
    return { success: false, error: "Unauthorized!" }
  }

  return withTiming(async () => {
    const queryText = `SELECT dbo.fn_CalculateDailyRevenue('${date}') AS [Doanh thu];`

    try {
      const pool = await getPool()
      const result = await pool.query(queryText)

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error getting daily revenue: ", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy doanh thu hàng ngày."
      }
    }
  })
}

export async function getMonthlyRevenue(year: number) {
  const user = await getCurrentUser()

  return withTiming(async () => {
    const queryText = `EXEC sp_GetMonthlyRevenue
    @RequestUserID = ${user.USER_ID},
    @Year = ${year}
`

    try {
      const result = await executeSP("sp_GetMonthlyRevenue", {
        RequestUserID: user.USER_ID,
        Year: year
      })

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error getting monthly revenue: ", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy doanh thu hàng tháng."
      }
    }
  })
}

export async function getBestSellingBooks(year: number, month?: number | string, topN = 10) {
  const user = await getCurrentUser()

  return withTiming(async () => {
    const queryText = `EXEC sp_GetBestSellingBooks
    @RequestUserID = ${user.USER_ID},
    @Year = ${year},
    @Month = ${month === "all" ? "NULL" : month},
    @TopN = ${topN}
`

    try {
      const result = await executeSP("sp_GetBestSellingBooks", {
        RequestUserID: user.USER_ID,
        Year: year,
        ...(month !== "all" && (month || month === 0) && { Month: month }),
        TopN: topN
      })

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error getting best selling books: ", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy sách bán chạy."
      }
    }
  })
}

export async function getCategoryReport() {
  const user = await getCurrentUser()

  if (!user || user.ROLE !== "ADMIN") {
    return { success: false, error: "Unauthorized!" }
  }

  return withTiming(async () => {
    const queryText = `DECLARE @CategoryReport TABLE (
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
    WHERE B.CATEGORY_ID = @CatID AND O.STATUS = 'Completed'; -- Chỉ tính đơn thành công

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
`

    try {
      const pool = await getPool()
      const result = await pool.query(queryText)

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error getting category report:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy báo cáo danh mục."
      }
    }
  })
}

export async function getCustomerRankingReport() {
  const user = await getCurrentUser()

  if (!user || user.ROLE !== "ADMIN") {
    return { success: false, error: "Unauthorized!" }
  }

  return withTiming(async () => {
    const queryText = `DECLARE @CustomerRankReport TABLE (
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
`

    try {
      const pool = await getPool()
      const result = await pool.query(queryText)

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error getting customer ranking report:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy báo cáo xếp hạng khách hàng."
      }
    }
  })
}
