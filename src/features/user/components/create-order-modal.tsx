import { useState } from "react"

import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"
import {
  Dialog,
  DialogHeader,
  DialogTitle,
  DialogContent,
  DialogDescription
} from "@/components/ui/dialog"
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectItem,
  SelectContent
} from "@/components/ui/select"

interface Props {
  isOpen: boolean
  onClose: () => void
  onAction: (data: any) => void
}

export const CreateOrderModal = ({ isOpen, onClose, onAction }: Props) => {
  const [orderForm, setOrderForm] = useState({
    name: "",
    phone: "",
    address: "",
    payment: "COD"
  })

  const handleClose = () => {
    onClose()
    setOrderForm({ name: "", phone: "", address: "", payment: "" })
  }

  return (
    <Dialog open={isOpen} onOpenChange={handleClose}>
      <DialogContent className="max-w-3xl! max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Tạo đơn hàng</DialogTitle>
          <DialogDescription>Nhập thông tin người nhận để hoàn tất đơn hàng.</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="name" className="text-right">
              Người nhận
            </Label>
            <Input
              id="name"
              className="col-span-3"
              placeholder="Nguyễn Văn A"
              value={orderForm.name}
              onChange={(e) => setOrderForm({ ...orderForm, name: e.target.value })}
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="phone" className="text-right">
              Số điện thoại
            </Label>
            <Input
              id="phone"
              className="col-span-3"
              placeholder="09xxx..."
              value={orderForm.phone}
              onChange={(e) => setOrderForm({ ...orderForm, phone: e.target.value })}
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="address" className="text-right">
              Địa chỉ nhận hàng
            </Label>
            <Textarea
              rows={3}
              id="address"
              className="col-span-3"
              placeholder="Số nhà, đường..."
              value={orderForm.address}
              onChange={(e) => setOrderForm({ ...orderForm, address: e.target.value })}
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="payment" className="text-right">
              Phương thức thanh toán
            </Label>
            <div className="col-span-3">
              <Select
                defaultValue="COD"
                value={orderForm.payment}
                onValueChange={(value) => setOrderForm({ ...orderForm, payment: value })}
              >
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="Chọn phương thức thanh toán" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="COD">Thanh toán khi nhận hàng (COD)</SelectItem>
                  <SelectItem value="BANK_TRANSFER">Chuyển khoản ngân hàng (Qua mã QR)</SelectItem>
                  <SelectItem value="VNPAY">Ví điện tử VNPAY (Thẻ ATM/QR-Pay)</SelectItem>
                  <SelectItem value="MOMO">Ví điện tử MoMo</SelectItem>
                  <SelectItem value="ZALOPAY">Ví điện tử ZaloPay</SelectItem>
                  <SelectItem value="CASH">Thanh toán tiền mặt tại cửa hàng</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </div>
        <div className="flex justify-end space-x-2">
          <Button variant="outline" onClick={handleClose}>Hủy</Button>
          <Button onClick={() => onAction(orderForm)}>Tạo đơn hàng</Button>
        </div>
      </DialogContent>
    </Dialog>
  )
}
