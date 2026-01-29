"use client"

import { toast } from "sonner"
import { useState } from "react"

import { getBooks } from "@/actions/book"
import { Button } from "@/components/ui/button"
import { Separator } from "@/components/ui/separator"
import { getCartDetails, addToCart } from "@/actions/cart"
import { SqlResultViewer } from "@/components/sql-result-viewer"
import { createOrder, getOrdersHistory, cancelOrder } from "@/actions/order"

import { AddToCartModal } from "./add-to-cart-modal"
import { CreateOrderModal } from "./create-order-modal"
import { CancelOrderModal } from "./cancel-order-modal"

export const UserDashboardView = () => {
  const [isPending, setIsPending] = useState(false)
  const [showCancelOrderModal, setShowCancelOrderModal] = useState(false)
  const [showAddToCartModal, setShowAddToCartModal] = useState(false)
  const [showCreateOrderModal, setShowCreateOrderModal] = useState(false)
  const [actionName, setActionName] = useState<string | null>(null)
  const [demoSql, setDemoSql] = useState<{
    query: string
    data: any[]
    error?: string
    executionTime?: string
  }>({
    query: "SELECT * FROM ...",
    data: []
  })

  const handleAction = async (actionName: string, actionFn: () => Promise<any>) => {
    toast.loading(`Đang thực hiện ${actionName}...`, { id: actionName })
    setIsPending(true)

    try {
      const res = await actionFn()

      setActionName(actionName)
      setDemoSql({
        query: res.sqlText,
        data: res.result || [],
        executionTime: res.executionTime
      })

      if (res.success) {
        toast.success(`Thực hiện ${actionName} thành công`, { id: actionName })
      } else {
        toast.error(res.error, { id: actionName })
        setDemoSql({ query: res.sqlText, data: [], error: res.error })
      }
    } catch (error) {
      console.error(error)
    } finally {
      setIsPending(false)
    }
  }

  return (
    <>
      <AddToCartModal
        isOpen={showAddToCartModal}
        onClose={() => setShowAddToCartModal(false)}
        onAction={(bookId) => {
          setShowAddToCartModal(false)
          handleAction("Thêm vào giỏ hàng", () =>
            addToCart(bookId, Number(prompt("Số lượng sách muốn thêm vào giỏ hàng?", "1")))
          )
        }}
      />
      <CreateOrderModal
        isOpen={showCreateOrderModal}
        onClose={() => setShowCreateOrderModal(false)}
        onAction={(orderData) => handleAction("Tạo đơn hàng", () =>
          createOrder(orderData.name, orderData.phone, orderData.address, orderData.payment)
        )}
      />
      <CancelOrderModal
        isOpen={showCancelOrderModal}
        onClose={() => setShowCancelOrderModal(false)}
        onAction={(orderId) => {
          setShowCancelOrderModal(false)
          handleAction("Hủy đơn hàng", () => cancelOrder(orderId))
        }}
      />
      <div className="flex flex-1 px-4 lg:px-6 py-4 items-stretch">
        <div className="w-1/4 space-y-4 overflow-y-auto">
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => handleAction("Lấy danh sách sản phẩm", getBooks)}
          >
            Danh sách sản phẩm
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => handleAction("Xem thông tin giỏ hàng", getCartDetails)}
          >
            Xem giỏ hàng
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => setShowAddToCartModal(true)}
          >
            Thêm vào giỏ hàng
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => setShowCreateOrderModal(true)}
          >
            Tạo đơn hàng
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => setShowCancelOrderModal(true)}
          >
            Hủy đơn hàng
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() =>
              handleAction("Xem lịch sử mua hàng", () =>
                getOrdersHistory(
                  prompt(
                    "Nhập trạng thái đơn hàng (Pending, Completed, Cancelled).",
                    "Pending"
                  )?.trim()
                )
              )
            }
          >
            Xem lịch sử mua hàng
          </Button>
        </div>
        <Separator orientation="vertical" className="mx-4" />
        <div className="w-3/4 overflow-y-auto">
          <h2 className="text-xl font-bold mb-4">⚡DEMO: {actionName || "SQL Server Response"}</h2>
          <SqlResultViewer
            query={demoSql.query}
            data={demoSql.data}
            error={demoSql.error}
            executionTime={demoSql.executionTime ? `${demoSql.executionTime} ms` : undefined}
          />
        </div>
      </div>
    </>
  )
}
