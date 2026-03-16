const http = require("http")
const { Pool } = require("pg")

const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || "piaca_db",
  user: process.env.DB_USER || "piaca_user",
  password: process.env.DB_PASSWORD || "piaca_pass"
})

const server = http.createServer(async (req, res) => {
  if (req.url !== "/" && req.url !== "/example") {
    res.writeHead(404, { "Content-Type": "application/json" })
    res.end(JSON.stringify({ message: "route not found" }))
    return
  }

  try {
    const result = await pool.query(
      "SELECT id, name, created_at FROM test_table ORDER BY id"
    )

    res.writeHead(200, { "Content-Type": "application/json" })
    res.end(
      JSON.stringify({
        message: "example module running",
        total: result.rows.length,
        data: result.rows
      })
    )
  } catch (error) {
    res.writeHead(500, { "Content-Type": "application/json" })
    res.end(
      JSON.stringify({
        message: "failed to query database",
        error: error.message
      })
    )
  }
})

server.listen(3005)