"use server"

import { executeSP } from "@/lib/db"
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
    @UserID = ${user.USER_ID},
    @OrderID = ${orderId}
`

    try {
      const result = await executeSP("sp_CancelOrder", {
        UserID: user.USER_ID,
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

export async function getOrdersHistory(status?: string | null): Promise<any> {
  const user = await getCurrentUser()

  return withTiming(async () => {
    const queryText = `EXEC sp_GetUserOrderHistory
    @UserID = ${user.USER_ID},
    @Status = ${status ? `'${status}'` : "NULL"}
`

    try {
      const result = await executeSP("sp_GetUserOrderHistory", {
        UserID: user.USER_ID,
        ...(status && { Status: status })
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
        error: error.message || "Lỗi khi lấy lịch sử mua hàng."
      }
    }
  })
}
