"use server"

import { getPool } from "@/lib/db"
import { withTiming } from "@/lib/utils"

import { getCurrentUser } from "./user"

export async function getCartDetails() {
  const user = await getCurrentUser()

  return withTiming(async () => {
    const queryText = `SELECT
    B.BOOK_NAME AS [Tên Sách],
    B.PRICE AS [Giá Gốc],
    CI.QUANTITY AS [Số Lượng],
    (B.PRICE * CI.QUANTITY) AS [Thành Tiền]
FROM CART_ITEMS CI
INNER JOIN BOOKS B ON CI.BOOK_ID = B.BOOK_ID
INNER JOIN CARTS C ON CI.CART_ID = C.CART_ID
WHERE C.USER_ID = ${user.USER_ID}  
`
    try {
      const pool = await getPool()
      const result = await pool.request().query(queryText)
      return {
        sqlText: queryText,
        result: result.recordset,
        success: true
      }
    } catch (error) {
      console.error("Error query:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: "Lỗi khi truy xuất giỏ hàng."
      }
    }
  })
}
