import { useEffect, useState } from "react"

import { getCategories } from "@/actions/book"
import { Button } from "@/components/ui/button"
import { Dialog, DialogHeader, DialogTitle, DialogContent } from "@/components/ui/dialog"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from "@/components/ui/table"
import { Trash2 } from "lucide-react"

interface Props {
  isOpen: boolean
  onClose: () => void
  onAction: (bookId: number) => void
}

export const DeleteCategoryModal = ({ isOpen, onClose, onAction }: Props) => {
  const [categories, setCategories] = useState<any>([])

  useEffect(() => {
    const fetchCategories = async () => {
      const res = await getCategories()
      if (res.success) {
        setCategories(res.result)
      }
    }

    fetchCategories()
  }, [isOpen])

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent
        aria-describedby={undefined}
        className="max-w-3xl! h-[90vh] overflow-y-auto flex flex-col"
      >
        <DialogHeader>
          <DialogTitle>Xóa thể loại sách</DialogTitle>
        </DialogHeader>
        <div className="h-full overflow-auto">
          {categories.length > 0 && (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>ID</TableHead>
                  <TableHead>Tên thể loại</TableHead>
                  <TableHead className="text-center">Hành động</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {categories.map((category: any) => (
                  <TableRow key={category.ID}>
                    <TableCell>{category.ID}</TableCell>
                    <TableCell>{category["Tên thể loại"]}</TableCell>
                    <TableCell className="flex-1 flex items-center justify-center">
                      <Button size="sm" variant="destructive" onClick={() => onAction(category.ID)}>
                        <Trash2 className="h-4 w-4" />
                        Xóa mềm
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
