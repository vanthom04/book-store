"use client"

import { toast } from "sonner"
import { useState } from "react"

import { Button } from "@/components/ui/button"
import { Separator } from "@/components/ui/separator"
import { createBook, updateBook } from "@/actions/book"
import { SqlResultViewer } from "@/components/sql-result-viewer"
import { getMonthlyRevenue, getBestSellingBooks } from "@/actions/dashboard"

import { CreateBookModal } from "./create-book-modal"
import { UpdateBookModal } from "./update-book-modal"
import { BestSellingBooksModal } from "./best-selling-books-modal"

export const AdminDashboardView = () => {
  const [isPending, setIsPending] = useState(false)
  const [showUpdateBookModal, setShowUpdateBookModal] = useState(false)
  const [showCreateBookModal, setShowCreateBookModal] = useState(false)
  const [showBestSellingBooksModal, setShowBestSellingBooksModal] = useState(false)
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
      <BestSellingBooksModal
        isOpen={showBestSellingBooksModal}
        onClose={() => setShowBestSellingBooksModal(false)}
        onAction={(data) => {
          setShowBestSellingBooksModal(false)
          handleAction("Top sách bán chạy", () =>
            getBestSellingBooks(data.year, data.month, data.topN)
          )
        }}
      />
      <CreateBookModal
        isOpen={showCreateBookModal}
        onClose={() => setShowCreateBookModal(false)}
        onAction={(data) => handleAction("Thêm sách", () => createBook(data))}
      />
      <UpdateBookModal
        isOpen={showUpdateBookModal}
        onClose={() => setShowUpdateBookModal(false)}
        onAction={(data) => handleAction("Cập nhật sách", () => updateBook(data))}
      />
      <div className="flex flex-1 px-4 lg:px-6 py-4 items-stretch">
        <div className="w-1/4 space-y-4 overflow-y-auto">
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() =>
              handleAction("Doanh thu hàng tháng", () =>
                getMonthlyRevenue(Number(prompt("Nhập năm: ", new Date().getFullYear().toString())))
              )
            }
          >
            Doanh thu hàng tháng
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => setShowBestSellingBooksModal(true)}
          >
            Top sách bán chạy
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => setShowCreateBookModal(true)}
          >
            Thêm sách
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => setShowUpdateBookModal(true)}
          >
            Cập nhật sách
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => alert("Chức năng đang phát triển")}
          >
            Xóa sách
          </Button>
          <Button
            size="lg"
            className="w-full"
            variant="secondary"
            disabled={isPending}
            onClick={() => alert("Chức năng đang phát triển")}
          >
            Xem đơn
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
