import { useState, useEffect } from "react"

import { Button } from "@/components/ui/button"
import { getOrdersHistory } from "@/actions/order"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from "@/components/ui/table"
import {
  Dialog,
  DialogHeader,
  DialogTitle,
  DialogContent,
  DialogDescription
} from "@/components/ui/dialog"

interface Props {
  isOpen: boolean
  onClose: () => void
  onAction: (orderId: string) => void
}

export const CancelOrderModal = ({ isOpen, onClose, onAction }: Props) => {
  const [orders, setOrders] = useState<any>([])

  useEffect(() => {
    const fetchOrders = async () => {
      const res = await getOrdersHistory("Pending")
      if (res.success) {
        setOrders(res.result || [])
      }
    }

    fetchOrders()
  }, [isOpen])

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-5xl! h-[85vh]!">
        <DialogHeader>
          <DialogTitle>Hủy đơn hàng</DialogTitle>
          <DialogDescription>Chọn đơn hàng muốn hủy</DialogDescription>
        </DialogHeader>
        <div className="max-h-[75vh] overflow-auto relative">
          <Table className="border rounded-md">
            <TableHeader>
              <TableRow>
                <TableHead className="text-center">Order ID</TableHead>
                <TableHead>Người nhận</TableHead>
                <TableHead>Địa chỉ giao hàng</TableHead>
                <TableHead className="text-center">Tổng tiền</TableHead>
                <TableHead className="text-center">Trạng thái</TableHead>
                <TableHead className="text-center">Ngày đặt hàng</TableHead>
                <TableHead className="text-center">Thao tác</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {orders.map((order: any) => (
                <TableRow key={order.OrderID}>
                  <TableCell className="text-center">{order.OrderID}</TableCell>
                  <TableCell className="max-w-42 truncate" title={order["Tên người nhận"]}>
                    {order["Tên người nhận"]}
                  </TableCell>
                  <TableCell className="max-w-42 truncate" title={order["Địa chỉ giao hàng"]}>
                    {order["Địa chỉ giao hàng"]}
                  </TableCell>
                  <TableCell className="text-center">
                    {order["Tổng tiền"].toLocaleString("vi-VN", {
                      style: "currency",
                      currency: "VND"
                    })}
                  </TableCell>
                  <TableCell className="text-center">{order["Trạng thái"]}</TableCell>
                  <TableCell className="text-center">
                    {order["Ngày đặt hàng"].toLocaleString("vi-VN")}
                  </TableCell>
                  <TableCell className="flex items-center justify-center">
                    <Button
                      variant="outline"
                      onClick={() => onAction(order.OrderID)}
                      className="hover:bg-red-50 hover:text-red-600"
                    >
                      Hủy đơn hàng
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </DialogContent>
    </Dialog>
  )
}
