"use client"

import Link from "next/link"

import { toast } from "sonner"
import { useState } from "react"
import { useRouter } from "next/navigation"

import { signUp } from "@/actions/auth"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Button } from "@/components/ui/button"
import { SqlResultViewer } from "@/components/sql-result-viewer"
import {
  AlertDialog,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogFooter,
  AlertDialogContent
} from "@/components/ui/alert-dialog"

export default function SignUpPage() {
  const router = useRouter()

  const [isPending, setIsPending] = useState(false)
  const [demoSql, setDemoSql] = useState<{ sql: string; data: any[] } | null>(null)

  const handleRegister = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()

    setIsPending(true)
    try {
      const formData = new FormData(e.currentTarget)
      const fullName = formData.get("fullName") as string
      const email = formData.get("email") as string
      const password = formData.get("pwd") as string

      const res = await signUp(fullName, email, password)

      if (res?.error) {
        return toast.error(res.error)
      }

      if (res?.success) {
        toast.success("Tạo tài khoản thành công!")
        setDemoSql({ sql: res.sqlText, data: res.result || [] })
      }
    } catch (error) {
      console.error("Error:", error)
      toast.error("Đăng ký thất bại. Vui lòng thử lại!")
    } finally {
      setIsPending(false)
    }
  }

  return (
    <>
      <AlertDialog open={!!demoSql} onOpenChange={(open) => !open && setDemoSql(null)}>
        <AlertDialogContent
          className="max-w-6xl! max-h-[90vh] overflow-y-auto"
          aria-describedby={undefined}
        >
          <AlertDialogHeader>
            <AlertDialogTitle className="text-green-600 font-bold">
              ⚡DEMO: SQL Server Response
            </AlertDialogTitle>
          </AlertDialogHeader>

          <div>{demoSql && <SqlResultViewer query={demoSql.sql} data={demoSql.data} />}</div>

          <AlertDialogFooter>
            <Button variant="outline" onClick={() => setDemoSql(null)}>
              Đóng
            </Button>
            <Button onClick={() => router.push("/")} className="bg-green-600 hover:bg-green-700">
              Đi tới Trang chủ
            </Button>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <form
        onSubmit={handleRegister}
        className="bg-card m-auto h-fit w-full max-w-sm rounded-md border p-0.5 shadow-md"
      >
        <div className="space-y-6 p-8 pb-6">
          <div>
            <h1 className="mb-1 text-xl font-semibold">Tạo tài khoản mới</h1>
            <p className="text-sm">Chào mừng! Hãy tạo tài khoản để bắt đầu!</p>
          </div>

          <div className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="fullName" className="block text-sm">
                Họ và tên
              </Label>
              <Input
                required
                type="text"
                id="fullName"
                name="fullName"
                placeholder="Nguyen Van A"
                disabled={isPending}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="email" className="block text-sm">
                Email
              </Label>
              <Input
                required
                id="email"
                type="email"
                name="email"
                placeholder="your-email@example.com"
                disabled={isPending}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="pwd" className="text-sm">
                Password
              </Label>
              <Input
                required
                id="pwd"
                name="pwd"
                type="password"
                disabled={isPending}
                placeholder="•••••••••"
                className="input sz-md variant-mixed"
              />
            </div>

            <Button type="submit" className="w-full" disabled={isPending}>
              Đăng ký
            </Button>
          </div>
        </div>

        <div className="pb-3">
          <p className="text-accent-foreground text-center text-sm">
            Đã có tài khoản?
            <Button asChild variant="link" className="px-2">
              <Link href="/sign-in">Đăng nhập</Link>
            </Button>
          </p>
        </div>
      </form>
    </>
  )
}
