"use server"

import { executeSP, getPool } from "@/lib/db"
import { withTiming } from "@/lib/utils"

import { getCurrentUser } from "./user"

export async function createOrder(
  receiverName: string,
  receiverPhone: string,
  shippingAddress: string,
  paymentMethod: string
): Promise<any> {
  const user = await getCurrentUser()

  return withTiming(async () => {
    const queryText = `EXEC sp_CreateOrder
    @UserID = ${user.USER_ID},
    @ReceiverName = N'${receiverName}',
    @ReceiverPhone = '${receiverPhone}',
    @ShippingAddress = N'${shippingAddress}',
    @PaymentMethod = '${paymentMethod}'
`

    try {
      const result = await executeSP("sp_CreateOrder", {
        UserID: user.USER_ID,
        ReceiverName: receiverName,
        ReceiverPhone: receiverPhone,
        ShippingAddress: shippingAddress,
        PaymentMethod: paymentMethod
      })

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error creating order:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi tạo đơn hàng."
      }
    }
  })
}

export async function cancelOrder(orderId: any) {
  const user = await getCurrentUser()
  
  return withTiming(async () => {
    const queryText = `EXEC sp_CancelOrder
    @RequestUserID = ${user.USER_ID},
    @OrderID = ${orderId}
`

    try {
      const result = await executeSP("sp_CancelOrder", {
        RequestUserID: user.USER_ID,
        OrderID: orderId
      })

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error creating order:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi hủy đơn hàng."
      }
    }
  })
}

export async function startDelivery(orderId: number) {
  const user = await getCurrentUser()

  return withTiming(async () => {
    const queryText = `EXEC sp_StartDelivery
    @RequestUserID = ${user.USER_ID},
    @OrderID = ${orderId}
`

    try {
      const result = await executeSP("sp_StartDelivery", {
        RequestUserID: user.USER_ID,
        OrderID: orderId
      })

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error creating order:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi bắt đầu giao hàng."
      }
    }
  })
}

export async function completeOrder(orderId: number) {
  const user = await getCurrentUser()

  return withTiming(async () => {
    const queryText = `EXEC sp_CompleteOrder
    @RequestUserID = ${user.USER_ID},
    @OrderID = ${orderId}
`

    try {
      const result = await executeSP("sp_CompleteOrder", {
        RequestUserID: user.USER_ID,
        OrderID: orderId
      })

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error completing order:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi hoàn thành đơn hàng."
      }
    }
  })
}

export async function getOrdersHistory(status?: string | null): Promise<any> {
  const user = await getCurrentUser()

  return withTiming(async () => {
    const queryText = `EXEC sp_GetUserOrderHistory
    @RequestUserID = ${user.USER_ID},
    @TargetUserID = ${user.USER_ID},
    @Status = ${status ? `'${status}'` : "NULL"}
`

    try {
      const result = await executeSP("sp_GetUserOrderHistory", {
        RequestUserID: user.USER_ID,
        TargetUserID: user.USER_ID,
        ...(status && { Status: status })
      })

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error getting order history:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy lịch sử mua hàng."
      }
    }
  })
}

export async function getOrdersForAdmin(): Promise<any> {
  const user = await getCurrentUser()

  if (!user || user.ROLE !== "ADMIN") {
    return { success: false, error: "Unauthorized!" }
  }

  return withTiming(async () => {
    const queryText = `SELECT
    ORDER_ID AS [ID],
    RECEIVER_NAME AS [Tên người nhận],
    RECEIVER_PHONE AS [Số điện thoại],
    TOTAL_AMOUNT AS [Tổng tiền],
    STATUS AS [Trạng thái],
    CREATED_AT AS [Ngày đặt hàng],
    SHIPPING_ADDRESS AS [Địa chỉ giao hàng]
FROM ORDERS
ORDER BY CREATED_AT DESC
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
      console.error("Error getting orders for admin:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy danh sách đơn hàng."
      }
    }
  })
}
