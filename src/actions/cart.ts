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
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error query:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi truy xuất giỏ hàng."
      }
    }
  })
}

export async function addToCart(bookId: number, quantity: number) {
  const user = await getCurrentUser()

  return withTiming(async () => {
    const queryText = `EXEC sp_AddToCart
    @UserID = ${user.USER_ID},
    @BookID = ${bookId},
    @Quantity = ${quantity};
`
    try {
      const pool = await getPool()
      const result = await pool.request().query(queryText)

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi thêm vào giỏ hàng."
      }
    }
  })
}
