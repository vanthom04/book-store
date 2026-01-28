import Link from "next/link"

import { Header } from "@/components/header"
import { getCurrentUser } from "@/actions/user"

import { UserDashboardView } from "@/features/user/components/user-dashboard-view"
import { AdminDashboardView } from "@/features/admin/components/admin-dashboard-view"

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
        {user.ROLE === "USER" && <UserDashboardView />}
        {user.ROLE === "ADMIN" && <AdminDashboardView />}
      </main>
    </div>
  )
}
