import Image from "next/image"

import { useEffect, useState } from "react"

import { getBooks } from "@/actions/book"
import { Button } from "@/components/ui/button"
import { Dialog, DialogHeader, DialogTitle, DialogContent } from "@/components/ui/dialog"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  TableHeader
} from "@/components/ui/table"
import { Trash2 } from "lucide-react"

interface Props {
  isOpen: boolean
  onClose: () => void
  onAction: (bookId: number) => void
}

export const HardDeleteBookModal = ({ isOpen, onClose, onAction }: Props) => {
  const [books, setBooks] = useState<any>([])

  useEffect(() => {
    const fetchBooks = async () => {
      const res = await getBooks(true)
      if (res.success) {
        setBooks(res.result)
      }
    }

    fetchBooks()
  }, [isOpen])

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent aria-describedby={undefined} className="max-w-6xl! h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Xóa sách</DialogTitle>
        </DialogHeader>
        <div className="h-full overflow-auto">
          {books.length > 0 && (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>ID</TableHead>
                  <TableHead>Thông tin</TableHead>
                  <TableHead>Thể loại</TableHead>
                  <TableHead>Giá</TableHead>
                  <TableHead>Nhà xuất bản</TableHead>
                  <TableHead className="text-center">Tồn kho</TableHead>
                  <TableHead className="text-center">Hành động</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {books.map((book: any) => (
                  <TableRow key={book.ID}>
                    <TableCell>{book.ID}</TableCell>
                    <TableCell className="flex items-center gap-2">
                      <div className="w-10 aspect-2/3 relative border rounded overflow-hidden">
                        <Image
                          fill
                          className="object-cover"
                          src={book["URL ảnh bìa"]}
                          alt={book["Tên sách"]}
                        />
                      </div>
                      <div className="flex flex-col flex-1">
                        <p className="text-sm font-medium truncate">{book["Tên sách"]}</p>
                        <p className="text-xs truncate">{book["Tác giả"]}</p>
                      </div>
                    </TableCell>
                    <TableCell>{book["Thể loại"]}</TableCell>
                    <TableCell>
                      {book["Giá"].toLocaleString("vi-VN", { style: "currency", currency: "VND" })}
                    </TableCell>
                    <TableCell>{book["Nhà xuất bản"]}</TableCell>
                    <TableCell className="text-center">{book["Số lượng"]}</TableCell>
                    <TableCell className="flex-1 flex items-center justify-center">
                      <Button
                        size="sm"
                        variant="destructive"
                        onClick={() => onAction(book.ID)}
                      >
                        <Trash2 className="h-4 w-4" />
                        Xóa vĩnh viễn
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </div>
      </DialogContent>
    </Dialog>
  )
}
