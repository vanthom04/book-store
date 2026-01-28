"use server"

import { executeSP } from "@/lib/db"
import { withTiming } from "@/lib/utils"

export async function getMonthlyRevenue(year: number) {
  return withTiming(async () => {
    const queryText = `EXEC sp_GetMonthlyRevenue
    @Year = ${year}
`

    try {
      const result = await executeSP("sp_GetMonthlyRevenue", {
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
  return withTiming(async () => {
    const queryText = `EXEC sp_GetBestSellingBooks
    @Year = ${year},
    @Month = ${month === "all" ? "NULL" : month},
    @TopN = ${topN}
`

    try {
      const result = await executeSP("sp_GetBestSellingBooks", {
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
