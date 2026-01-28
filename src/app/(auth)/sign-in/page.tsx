"use client"

import Link from "next/link"

import { toast } from "sonner"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"

import { signIn } from "@/actions/auth"
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

export default function SignInPage() {
  const router = useRouter()

  const [isPending, setIsPending] = useState(false)
  const [demoSql, setDemoSql] = useState<{ sql: string; data: any[] } | null>(null)

  useEffect(() => {
    const urlParams = new URLSearchParams(window.location.search)
    if (urlParams.get("registered") === "true") {
      toast.success("Đăng ký thành công! Vui lòng đăng nhập.")
    }
  }, [])

  const handleLogin = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()

    setIsPending(true)
    try {
      const formData = new FormData(e.currentTarget)
      const email = formData.get("email") as string
      const password = formData.get("pwd") as string

      const res = await signIn(email, password)
      console.log(res)

      if (res?.error) {
        return toast.error(res.error)
      }

      if (res.success) {
        toast.success("Đăng nhập thành công")
        setDemoSql({ sql: res.sqlText, data: res.result || [] })
      }
    } catch (error) {
      console.error("Error:", error)
      toast.error("Đăng nhập thất bại. Vui lòng thử lại!")
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
              ⚡DEMO: Đăng nhập
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
        onSubmit={handleLogin}
        className="bg-card m-auto h-fit w-full max-w-sm rounded-md border p-0.5 shadow-md"
      >
        <div className="space-y-6 p-8 pb-6">
          <div>
            <h1 className="mb-1 text-xl font-semibold">Đăng nhập vào BookStore</h1>
            <p className="text-sm">Chào mừng quay lại. Đăng nhập để tiếp tục</p>
          </div>

          <div className="flex flex-col border p-2 rounded-md">
            <h3 className="font-semibold mb-1">Tài khoản admin demo:</h3>
            <p className="text-sm">Email: ADMIN@BOOKSTORE.COM</p>
            <p className="text-sm">Mật khẩu: 123456</p>
          </div>

          <div className="space-y-4">
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
              Đăng nhập
            </Button>
          </div>
        </div>

        <div className="pb-3">
          <p className="text-accent-foreground text-center text-sm">
            Chưa có tài khoản?
            <Button asChild variant="link" className="px-2">
              <Link href="/sign-up">Đăng ký</Link>
            </Button>
          </p>
        </div>
      </form>
    </>
  )
}
