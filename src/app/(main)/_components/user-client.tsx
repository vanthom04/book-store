"use client"

import { toast } from "sonner"
import { useState } from "react"

import { getBooks } from "@/actions/book"
import { Button } from "@/components/ui/button"
import { Separator } from "@/components/ui/separator"
import { getCartDetails, addToCart } from "@/actions/cart"
import { SqlResultViewer } from "@/components/sql-result-viewer"

import { AddToCartModal } from "./add-to-cart-modal"

export const UserClient = () => {
  const [isPending, setIsPending] = useState(false)
  const [showAddToCartModal, setShowAddToCartModal] = useState(false)
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
      setShowAddToCartModal(false)
    }
  }

  return (
    <>
      <AddToCartModal
        isOpen={showAddToCartModal}
        onClose={() => setShowAddToCartModal(false)}
        onAction={(bookId) =>
          handleAction("Thêm vào giỏ hàng", () =>
            addToCart(bookId, Number(prompt("Số lượng sách muốn thêm vào giỏ hàng?", "1")))
          )
        }
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
            onClick={() => alert("Chức năng đang phát triển")}
          >
            Tạo đơn hàng
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => alert("Chức năng đang phát triển")}
          >
            Hủy đơn hàng
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => alert("Chức năng đang phát triển")}
          >
            Lịch sử mua hàng
          </Button>
        </div>
        <Separator orientation="vertical" className="mx-4" />
        <div className="w-3/4 overflow-y-auto">
          <h2 className="text-xl font-bold mb-4">⚡DEMO: SQL Server Response</h2>
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
