import { useState, useEffect } from "react"

import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"
import { getAuthors, getCategories, getPublishers, getBooks } from "@/actions/book"
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
  bookId: 1,
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

export const UpdateBookModal = ({ isOpen, onClose, onAction }: Props) => {
  const [books, setBooks] = useState<any[]>([])
  const [authors, setAuthors] = useState<any[]>([])
  const [categories, setCategories] = useState<any[]>([])
  const [publishers, setPublishers] = useState<any[]>([])
  const [bookForm, setBookForm] = useState<any>(INITIAL_BOOK_FORM)

  useEffect(() => {
    const fetchData = async () => {
      const [booksRes, authorsRes, categoriesRes, publishersRes] = await Promise.all([
        getBooks(),
        getAuthors(),
        getCategories(),
        getPublishers()
      ])

      if (booksRes.success) {
        setBooks(booksRes.result)

        setBookForm({
          ...bookForm,
          bookId: booksRes.result[0].ID,
          bookName: booksRes.result[0]["Tên sách"],
          authorId: booksRes.result[0].AuthorID,
          categoryId: booksRes.result[0].CategoryID,
          price: booksRes.result[0]["Giá"],
          quantity: booksRes.result[0]["Số lượng"],
          description: booksRes.result[0]["Mô tả"],
          pages: booksRes.result[0]["Số trang"],
          language: booksRes.result[0]["Ngôn ngữ"],
          publishYear: booksRes.result[0]["Năm xuất bản"],
          publisherId: booksRes.result[0].PublisherID,
          image: booksRes.result[0]["URL ảnh bìa"]
        })
      }

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
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isOpen])

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
            <DialogTitle>Cập nhật sách</DialogTitle>
            <DialogDescription>Cập nhật thông tin sách</DialogDescription>
          </DialogHeader>
          <div className="flex-1 overflow-y-auto px-6 pb-4 space-y-4">
            <div className="space-y-2">
              <Label htmlFor="book">Chọn sách muốn cập nhật</Label>
              <Select
                required
                value={bookForm.bookId.toString()}
                defaultValue={bookForm.bookId.toString()}
                onValueChange={(value) => {
                  const book = books.find((book) => book.ID === Number(value))

                  if (book) {
                    setBookForm({
                      ...bookForm,
                      bookId: book.ID,
                      bookName: book["Tên sách"],
                      authorId: book.AuthorID,
                      categoryId: book.CategoryID,
                      price: book["Giá"],
                      quantity: book["Số lượng"],
                      description: book["Mô tả"],
                      pages: book["Số trang"],
                      language: book["Ngôn ngữ"],
                      publishYear: book["Năm xuất bản"],
                      publisherId: book.PublisherID,
                      image: book["URL ảnh bìa"]
                    })
                  }
                }}
              >
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="Chọn sách cần cập nhật" />
                </SelectTrigger>
                <SelectContent>
                  {books.map((book) => (
                    <SelectItem key={book.ID} value={book.ID.toString()}>
                      {book["Tên sách"]}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label htmlFor="bookName">Tên sách</Label>
              <Input
                required
                id="bookName"
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
