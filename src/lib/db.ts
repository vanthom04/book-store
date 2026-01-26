import sql from "mssql"

const sqlConfig: sql.config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  server: process.env.DB_SERVER || "localhost",
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  },
  options: {
    encrypt: false,
    trustServerCertificate: true
  }
}

declare global {
  var pool: sql.ConnectionPool | undefined
}

export async function getPool() {
  if (process.env.NODE_ENV === "development") {
    if (!global.pool) {
      global.pool = await sql.connect(sqlConfig)
    }
    return global.pool
  }
  return await sql.connect(sqlConfig)
}

export async function executeSP(procName: string, inputs: Record<string, any> = {}) {
  const pool = await getPool()
  const request = pool.request()

  Object.keys(inputs).forEach((key) => {
    request.input(key, inputs[key])
  })

  const result = await request.execute(procName)
  return result
}
