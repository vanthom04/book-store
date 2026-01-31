"use server"

import bcrypt from "bcryptjs"

import { cookies } from "next/headers"
import { redirect } from "next/navigation"

import { withTiming } from "@/lib/utils"
import { getPool, executeSP } from "@/lib/db"

export async function signIn(email: string, password: string): Promise<any> {
  return withTiming(async () => {
    const sqlDisplay = `SELECT * FROM USERS WHERE EMAIL = '${email}' AND IS_ACTIVE = 1`

    try {
      if (!email || !password) {
        return {
          success: false,
          error: "Vui lòng điền đầy đủ thông tin.",
          sqlText: sqlDisplay,
          result: null
        }
      }

      const pool = await getPool()
      const result = await pool.query`SELECT * FROM USERS WHERE EMAIL = ${email} AND IS_ACTIVE = 1`

      const user = result.recordset[0]

      if (!user) {
        return {
          success: false,
          error: "Người dùng không tồn tại",
          sqlText: sqlDisplay,
          result: null
        }
      }

      const isMatch = await bcrypt.compare(password, user.PASSWORD_HASH)

      if (!isMatch) {
        return {
          success: false,
          error: "Mật khẩu không chính xác",
          sqlText: sqlDisplay,
          result: null
        }
      }

      ;(await cookies()).set("user_session", JSON.stringify(user), {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        maxAge: 60 * 60 * 24, // 1 ngày
        path: "/"
      })

      return {
        success: true,
        sqlText: sqlDisplay,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Sign-in error:", error)
      return {
        error: error.message || "Lỗi hệ thống. Vui lòng thử lại sau.",
        sqlText: sqlDisplay,
        result: null
      }
    }
  })
}

export async function signUp(fullName: string, email: string, password: string): Promise<any> {
  return withTiming(async () => {
    let sqlDisplay = `EXEC sp_RegisterUser
    @FullName = N'${fullName}',
    @Email = '${email}',
    @PasswordHash = '***'
`

    try {
      if (!fullName || !email || !password) {
        return {
          success: false,
          error: "Vui lòng điền đầy đủ thông tin.",
          sqlText: sqlDisplay,
          result: null
        }
      }

      const pool = await getPool()

      const existingUser = await pool.request()
        .query`SELECT TOP 1 1 FROM USERS WHERE EMAIL = ${email}`

      if (existingUser.recordset.length > 0) {
        return {
          success: false,
          error: "Email đã được sử dụng.",
          sqlText: sqlDisplay,
          result: null
        }
      }

      const salt = await bcrypt.genSalt(10)
      const passwordHash = await bcrypt.hash(password, salt)

      sqlDisplay = `EXEC sp_RegisterUser
    @FullName = N'${fullName}',
    @Email = '${email}',
    @PasswordHash = '${passwordHash}'
`

      const result = await executeSP("sp_RegisterUser", {
        FullName: fullName,
        Email: email,
        PasswordHash: passwordHash
      })

      return {
        success: true,
        sqlText: sqlDisplay,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Sign-up error:", error)
      return {
        success: false,
        error: error.message || "Lỗi hệ thống. Vui lòng thử lại sau.",
        sqlText: sqlDisplay,
        result: null
      }
    }
  })
}

export const signOut = async () => {
  const cookieStore = await cookies()
  cookieStore.delete("user_session")
  redirect("/sign-in")
}
