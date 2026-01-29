import { useState, useEffect } from "react"

import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"
import { getAuthors, getCategories, getPublishers } from "@/actions/book"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue
} from "@/components/ui/select"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@/components/ui/dialog"

const INITIAL_BOOK_FORM = {
  bookName: "",
  authorId: 1,
  categoryId: 1,
  price: "",
  quantity: "",
  description: "",
  pages: "",
  language: "",
  publishYear: "",
  publisherId: 1,
  image: ""
}

interface Props {
  isOpen: boolean
  onClose: () => void
  onAction: (data: any) => void
}

export const CreateBookModal = ({ isOpen, onClose, onAction }: Props) => {
  const [authors, setAuthors] = useState<any[]>([])
  const [categories, setCategories] = useState<any[]>([])
  const [publishers, setPublishers] = useState<any[]>([])
  const [bookForm, setBookForm] = useState<any>(INITIAL_BOOK_FORM)

  useEffect(() => {
    const fetchData = async () => {
      const [authorsRes, categoriesRes, publishersRes] = await Promise.all([
        getAuthors(),
        getCategories(),
        getPublishers()
      ])

      if (authorsRes.success) {
        setAuthors(authorsRes.result)
      }

      if (categoriesRes.success) {
        setCategories(categoriesRes.result)
      }

      if (publishersRes.success) {
        setPublishers(publishersRes.result)
      }
    }

    fetchData()
  }, [])

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()

    const payload = {
      ...bookForm,
      price: Number(bookForm.price),
      quantity: Number(bookForm.quantity),
      pages: Number(bookForm.pages),
      publishYear: Number(bookForm.publishYear)
    }

    onAction(payload)
    setBookForm(INITIAL_BOOK_FORM)
    onClose()
  }

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-4xl! h-[90vh] flex flex-col p-0">
        <form className="flex flex-col h-full" onSubmit={handleSubmit}>
          <DialogHeader className="p-6 pb-2">
            <DialogTitle>Thêm sách mới</DialogTitle>
            <DialogDescription>Thêm một cuốn sách mới vào kho</DialogDescription>
          </DialogHeader>
          <div className="flex-1 overflow-y-auto px-6 pb-4 space-y-4">
            <div className="space-y-2">
              <Label htmlFor="name">Tên sách</Label>
              <Input
                required
                id="name"
                autoComplete="off"
                value={bookForm.bookName}
                onChange={(e) => setBookForm({ ...bookForm, bookName: e.target.value })}
                placeholder="Nhập tên sách..."
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="author">Tác giả</Label>
                <Select
                  required
                  value={bookForm.authorId.toString()}
                  defaultValue={bookForm.authorId.toString()}
                  onValueChange={(value) => setBookForm({ ...bookForm, authorId: Number(value) })}
                >
                  <SelectTrigger className="w-full">
                    <SelectValue placeholder="Chọn tác giả" />
                  </SelectTrigger>
                  <SelectContent>
                    {authors.map((author) => (
                      <SelectItem key={author.ID} value={author.ID.toString()}>
                        {author["Tên tác giả"]}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="category">Thể loại</Label>
                <Select
                  required
                  value={bookForm.categoryId.toString()}
                  defaultValue={bookForm.categoryId.toString()}
                  onValueChange={(value) => setBookForm({ ...bookForm, categoryId: Number(value) })}
                >
                  <SelectTrigger className="w-full">
                    <SelectValue placeholder="Chọn thể loại" />
                  </SelectTrigger>
                  <SelectContent>
                    {categories.map((category) => (
                      <SelectItem key={category.ID} value={category.ID.toString()}>
                        {category["Tên thể loại"]}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="language">Ngôn ngữ</Label>
                <Input
                  required
                  id="language"
                  value={bookForm.language}
                  onChange={(e) => setBookForm({ ...bookForm, language: e.target.value })}
                  placeholder="Nhập ngôn ngữ..."
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="pages">Số trang</Label>
                <Input
                  required
                  id="pages"
                  type="number"
                  value={bookForm.pages}
                  onChange={(e) => setBookForm({ ...bookForm, pages: e.target.value })}
                  placeholder="Nhập số trang..."
                />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="publishYear">Năm xuất bản</Label>
                <Input
                  required
                  type="number"
                  id="publishYear"
                  value={bookForm.publishYear}
                  onChange={(e) => setBookForm({ ...bookForm, publishYear: e.target.value })}
                  placeholder="Nhập năm xuất bản..."
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="publisher">Nhà xuất bản</Label>
                <Select
                  required
                  value={bookForm.publisherId.toString()}
                  defaultValue={bookForm.publisherId.toString()}
                  onValueChange={(value) =>
                    setBookForm({ ...bookForm, publisherId: Number(value) })
                  }
                >
                  <SelectTrigger className="w-full">
                    <SelectValue placeholder="Chọn nhà xuất bản" />
                  </SelectTrigger>
                  <SelectContent>
                    {publishers.map((publisher) => (
                      <SelectItem key={publisher.ID} value={publisher.ID.toString()}>
                        {publisher["Tên nhà xuất bản"]}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="price">Giá</Label>
                <Input
                  required
                  id="price"
                  type="number"
                  value={bookForm.price}
                  onChange={(e) => setBookForm({ ...bookForm, price: e.target.value })}
                  placeholder="Nhập giá..."
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="quantity">Số lượng</Label>
                <Input
                  required
                  type="number"
                  id="quantity"
                  value={bookForm.quantity}
                  onChange={(e) => setBookForm({ ...bookForm, quantity: e.target.value })}
                  placeholder="Nhập số lượng..."
                />
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="image">URL Ảnh bìa (Không bắt buộc)</Label>
              <Input
                id="image"
                type="url"
                value={bookForm.image}
                onChange={(e) => setBookForm({ ...bookForm, image: e.target.value })}
                placeholder="Nhập URL ảnh bìa..."
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="description">Mô tả</Label>
              <Textarea
                required
                id="description"
                className="min-h-24"
                value={bookForm.description}
                onChange={(e) => setBookForm({ ...bookForm, description: e.target.value })}
                placeholder="Nhập mô tả..."
              />
            </div>
          </div>
          <DialogFooter className="p-6 pt-2 border-t">
            <Button type="button" variant="outline" onClick={onClose}>
              Hủy
            </Button>
            <Button type="submit">Thêm sách</Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}
