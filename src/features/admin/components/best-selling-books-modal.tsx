import { useState } from "react"

import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Button } from "@/components/ui/button"
import {
  Select,
  SelectValue,
  SelectItem,
  SelectContent,
  SelectTrigger
} from "@/components/ui/select"
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogDescription
} from "@/components/ui/dialog"

interface Props {
  isOpen: boolean
  onClose: () => void
  onAction: (data: any) => void
}

export const BestSellingBooksModal = ({ isOpen, onClose, onAction }: Props) => {
  const [form, setForm] = useState<any>({
    year: new Date().getFullYear(),
    month: "all",
    topN: 10
  })

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-xl!">
        <DialogHeader>
          <DialogTitle>Top sách bán chạy</DialogTitle>
          <DialogDescription>Chọn năm và tháng để xem top sách bán chạy</DialogDescription>
        </DialogHeader>
        <div className="grid grid-cols-3 gap-4">
          <div className="space-y-2">
            <Label htmlFor="year">Năm</Label>
            <Select
              value={form.year.toString()}
              onValueChange={(value) => setForm({ ...form, year: Number(value) })}
            >
              <SelectTrigger className="w-full">
                <SelectValue placeholder="Chọn năm" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={new Date().getFullYear().toString()}>
                  {new Date().getFullYear()}
                </SelectItem>
                <SelectItem value={(new Date().getFullYear() - 1).toString()}>
                  {new Date().getFullYear() - 1}
                </SelectItem>
                <SelectItem value={(new Date().getFullYear() - 2).toString()}>
                  {new Date().getFullYear() - 2}
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label htmlFor="month">Tháng</Label>
            <Select
              value={form.month?.toString() || "all"}
              onValueChange={(value) =>
                setForm({ ...form, month: value === "all" ? "all" : Number(value) })
              }
            >
              <SelectTrigger className="w-full">
                <SelectValue placeholder="Chọn tháng" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Tất cả</SelectItem>
                {[...Array(12)].map((_, i) => (
                  <SelectItem key={i} value={(i + 1).toString()}>
                    Tháng {i + 1}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label htmlFor="topN">Top N</Label>
            <Input
              required
              type="number"
              id="topN"
              value={form.topN}
              onChange={(e) => setForm({ ...form, topN: Number(e.target.value) })}
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>
            Hủy
          </Button>
          <Button onClick={() => onAction(form)} disabled={!form.year || !form.topN}>
            Xác nhận
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
