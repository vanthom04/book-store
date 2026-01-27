"use server"

import { getPool } from "@/lib/db"
import { withTiming } from "@/lib/utils"

export async function getBooks() {
  return withTiming(async () => {
    const queryText = `SELECT
    BOOK_ID AS ID,
    BOOK_NAME AS [Tên Sách],
    AUTHOR_NAME AS [Tác Giả],
    CATEGORY_NAME AS [Thể Loại],
    PRICE AS [Giá],
    QUANTITY AS [Số Lượng],
    IMAGE AS [URL Ảnh Bìa],
    CREATED_AT AS [Ngày Tạo]
FROM BOOKS
JOIN AUTHORS ON BOOKS.AUTHOR_ID = AUTHORS.AUTHOR_ID
JOIN CATEGORIES ON CATEGORIES.CATEGORY_ID = BOOKS.CATEGORY_ID
WHERE IS_DELETED = 0
ORDER BY CREATED_AT DESC
`

    try {
      const pool = await getPool()
      const result = await pool.request().query(queryText)
      return {
        success: true,
        sqlText: queryText,
        result: result.recordset,
        error: null
      }
    } catch (error) {
      console.error("Error fetching books: ", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: "Lỗi khi lấy danh sách sản phẩm."
      }
    }
  })
}
