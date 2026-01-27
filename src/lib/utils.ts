import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export async function withTiming<T>(fn: () => Promise<T>) {
  const start = performance.now()

  try {
    const result = await fn()
    const end = performance.now()
    const duration = (end - start).toFixed(2)
    return { ...result, executionTime: duration }
  } catch (error: any) {
    const end = performance.now()
    return {
      success: false,
      error: error.message,
      sql: "ERROR",
      executionTime: (end - start).toFixed(2)
    }
  }
}
