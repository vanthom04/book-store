import { useEffect, useState } from "react"

import { Button } from "@/components/ui/button"
import { getOrdersForAdmin } from "@/actions/order"
import { Dialog, DialogHeader, DialogTitle, DialogContent } from "@/components/ui/dialog"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from "@/components/ui/table"
import { CheckCircle, Package, TruckIcon, XCircle } from "lucide-react"
import { Badge } from "@/components/ui/badge"

interface Props {
  isOpen: boolean
  onClose: () => void
  onAction: (orderId: number, status: string) => void
}

export const OrdersForAdmin = ({ isOpen, onClose, onAction }: Props) => {
  const [orders, setOrders] = useState<any[]>([])

  useEffect(() => {
    const fetchOrders = async () => {
      const result = await getOrdersForAdmin()
      if (result.success) {
        setOrders(result.result)
      }
    }
    fetchOrders()
  }, [isOpen])

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "Pending":
        return <Badge className="bg-yellow-500 hover:bg-yellow-600">{status}</Badge>
      case "Delivering":
        return <Badge className="bg-blue-600 hover:bg-blue-700">{status}</Badge>
      case "Completed":
        return <Badge className="bg-green-600 hover:bg-green-700">{status}</Badge>
      case "Cancelled":
        return <Badge variant="destructive">{status}</Badge>
      default:
        return <Badge variant="outline">{status}</Badge>
    }
  }

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent aria-describedby={undefined} className="max-w-6xl! h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Quản lý đơn hàng</DialogTitle>
        </DialogHeader>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="text-center">ID</TableHead>
              <TableHead>Tên người nhận</TableHead>
              <TableHead>Số điện thoại</TableHead>
              <TableHead>Địa chỉ giao hàng</TableHead>
              <TableHead className="text-center">Tổng tiền</TableHead>
              <TableHead className="text-center">Trạng thái</TableHead>
              <TableHead className="text-center">Ngày đặt hàng</TableHead>
              <TableHead className="text-center">Hành động</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {orders.map((order) => (
              <TableRow key={order.ID}>
                <TableCell className="text-center">{order.ID}</TableCell>
                <TableCell className="max-w-50 truncate" title={order["Tên người nhận"]}>
                  {order["Tên người nhận"]}
                </TableCell>
                <TableCell>{order["Số điện thoại"]}</TableCell>
                <TableCell className="max-w-50 truncate" title={order["Địa chỉ giao hàng"]}>
                  {order["Địa chỉ giao hàng"]}
                </TableCell>
                <TableCell className="text-center">
                  {order["Tổng tiền"].toLocaleString("vi-VN", {
                    style: "currency",
                    currency: "VND"
                  })}
                </TableCell>
                <TableCell className="text-center">{getStatusBadge(order["Trạng thái"])}</TableCell>
                <TableCell className="text-center">
                  {new Date(order["Ngày đặt hàng"]).toLocaleDateString("vi-VN")}
                </TableCell>
                <TableCell className="text-right space-x-2">
                  {order["Trạng thái"] === "Pending" && (
                    <>
                      <Button
                        size="sm"
                        className="bg-blue-600 hover:bg-blue-700"
                        onClick={() => onAction(order.ID, "Delivering")}
                      >
                        <TruckIcon className="w-4 h-4 mr-1" /> Giao
                      </Button>
                      <Button
                        size="sm"
                        variant="destructive"
                        onClick={() => onAction(order.ID, "Cancelled")}
                      >
                        <XCircle className="w-4 h-4" /> Hủy
                      </Button>
                    </>
                  )}
                  {order["Trạng thái"] === "Delivering" && (
                    <>
                      <Button
                        size="sm"
                        className="bg-green-600 hover:bg-green-700"
                        onClick={() => onAction(order.ID, "Completed")}
                      >
                        <CheckCircle className="w-4 h-4 mr-1" /> Xong
                      </Button>
                      <Button
                        size="sm"
                        variant="destructive"
                        onClick={() => onAction(order.ID, "Cancelled")}
                      >
                        <XCircle className="w-4 h-4" /> Hủy
                      </Button>
                    </>
                  )}
                  {["Completed", "Cancelled"].includes(order["Trạng thái"]) && (
                    <Button size="sm" variant="ghost" disabled>
                      <Package className="w-4 h-4 mr-1" /> Đã chốt
                    </Button>
                  )}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </DialogContent>
    </Dialog>
  )
}
