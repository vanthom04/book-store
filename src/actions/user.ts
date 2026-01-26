"use server"

import { cookies } from "next/headers"

import { getPool } from "@/lib/db"

export const getCurrentUser = async () => {
  try {
    const cookieStore = await cookies()
    const sessionCookie = cookieStore.get("user_session")

    if (!sessionCookie) {
      return null
    }

    const sessionData = JSON.parse(sessionCookie.value)

    if (!sessionData.USER_ID) {
      return null
    }

    const pool = await getPool()
    const result = await pool.request()
      .query`SELECT * FROM USERS WHERE USER_ID = ${sessionData.USER_ID} AND IS_ACTIVE = 1`

    const user = result.recordset[0]

    if (!user) {
      return null
    }

    return user
  } catch (error) {
    console.error("Error fetching current user: ", error)
    return null
  }
}
