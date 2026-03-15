const http = require("http")

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" })
  res.end(JSON.stringify({ message: "example module running" }))
})

server.listen(3005)