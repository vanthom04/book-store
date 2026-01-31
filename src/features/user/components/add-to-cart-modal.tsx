import Image from "next/image"

import { useEffect, useState } from "react"

import { getBooks } from "@/actions/book"
import { Button } from "@/components/ui/button"
import { Dialog, DialogHeader, DialogTitle, DialogContent } from "@/components/ui/dialog"

interface Props {
  isOpen: boolean
  onClose: () => void
  onAction: (bookId: number) => void
}

export const AddToCartModal = ({ isOpen, onClose, onAction }: Props) => {
  const [books, setBooks] = useState<any>([])

  useEffect(() => {
    const fetchBooks = async () => {
      const res = await getBooks()
      if (res.success) {
        setBooks(res.result)
      }
    }

    fetchBooks()
  }, [isOpen])

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent
        aria-describedby={undefined}
        className="max-w-4xl! h-[90vh] overflow-y-auto"
      >
        <DialogHeader>
          <DialogTitle>Thêm sách vào giỏ hàng</DialogTitle>
        </DialogHeader>
        <div className="h-full overflow-y-auto">
          {books.length > 0 &&
            books.map((book: any) => (
              <div key={book.ID} className="flex items-center gap-2 border-b p-2">
                <div className="p-2 text-xs font-medium">{book.ID}</div>
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
                <div className="text-sm text-muted-foreground px-4 lg:px-6">
                  {book["Giá"].toLocaleString("vi-VN", { style: "currency", currency: "VND" })}
                </div>
                <div className="text-sm text-muted-foreground px-4 lg:px-6">
                  Tồn kho: {book["Số lượng"]}
                </div>
                <Button onClick={() => onAction(book.ID)}>Thêm giỏ hàng</Button>
              </div>
            ))}
        </div>
      </DialogContent>
    </Dialog>
  )
}
