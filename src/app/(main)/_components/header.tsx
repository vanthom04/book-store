"use client"

import Link from "next/link"
import Image from "next/image"

import { signOut } from "@/actions/auth"
import { Button } from "@/components/ui/button"

export const Header = ({ user }: any) => {
  return (
    <header className="h-16 flex items-center justify-between px-4 lg:px-6 border-b border-gray-200">
      <Link href="/" className="flex items-center gap-2">
        <Image src="/logo.svg" alt="Logo" width={38} height={38} />
        <h1 className="text-2xl font-bold">BookStore</h1>
      </Link>
      <div className="text-center">
        <h1 className="text-base font-medium">Xin chào, {user.FULL_NAME}</h1>
        <p className="text-base font-normal">
          Role: {user.ROLE} {user.ROLE === "ADMIN" ? "(Quản trị viên)" : "(Khách hàng)"}
        </p>
      </div>
      <Button variant="destructive" onClick={async () => await signOut()}>
        Đăng xuất
      </Button>
    </header>
  )
}
