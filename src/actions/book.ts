"use server"

import { getPool } from "@/lib/db"
import { withTiming } from "@/lib/utils"

export async function getBooks() {
  return withTiming(async () => {
    const queryText = `SELECT
      BOOK_ID,
      BOOK_NAME,
      AUTHOR_NAME,
      CATEGORY_NAME,
      PRICE,
      QUANTITY,
      IMAGE
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
