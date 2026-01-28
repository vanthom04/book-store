"use server"

import { getPool } from "@/lib/db"
import { withTiming } from "@/lib/utils"

export async function getBooks(): Promise<any> {
  return withTiming(async () => {
    const queryText = `SELECT
    BOOK_ID AS ID,
    BOOK_NAME AS [Tên sách],
    AUTHOR_NAME AS [Tác giả],
    CATEGORY_NAME AS [Thể loại],
    PRICE AS [Giá],
    QUANTITY AS [Số lượng],
    IMAGE AS [URL ảnh bìa],
    DESCRIPTION AS [Mô tả],
    CREATED_AT AS [Ngày tạo]
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
      }
    } catch (error: any) {
      console.error("Error fetching books: ", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy danh sách sản phẩm."
      }
    }
  })
}
