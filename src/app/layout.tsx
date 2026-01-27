import { type Metadata } from "next"
import { Inter } from "next/font/google"

import { Toaster } from "@/components/ui/sonner"

import "@/app/globals.css"

const inter = Inter({ subsets: ["vietnamese"] })

export const metadata: Metadata = {
  title: "Book Store",
  description: "A book store built with Next.js",
  icons: [{ rel: "icon", url: "/logo.svg" }]
}

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="vi" suppressHydrationWarning>
      <body className={`${inter.className} antialiased`} suppressHydrationWarning>
        {children}
        <Toaster richColors />
      </body>
    </html>
  )
}
