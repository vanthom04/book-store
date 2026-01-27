import Link from "next/link"

import { getCurrentUser } from "@/actions/user"

import { Header } from "./_components/header"
import { AdminClient } from "./_components/admin-client"
import { UserClient } from "./_components/user-client"

export const dynamic = "force-dynamic"

export default async function HomePage() {
  const user = await getCurrentUser()

  if (!user) {
    return (
      <div className="flex-1 flex flex-col items-center justify-center min-h-screen gap-3">
        <p className="text-muted-foreground">Người dùng không tồn tại</p>
        <Link href="/sign-in" className="ml-2 text-blue-500 underline">
          Đăng nhập
        </Link>
      </div>
    )
  }

  return (
    <div className="flex flex-col flex-1 min-h-screen">
      <Header user={user} />
      <main className="flex flex-1">
        {user.ROLE === "USER" && <UserClient />}
        {user.ROLE === "ADMIN" && <AdminClient />}
      </main>
    </div>
  )
}
