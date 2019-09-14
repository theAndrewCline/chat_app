const http = require('http')
const path = require('path')

const express = require('express')
const app = express()
app.use(express.static(path.resolve(__dirname, '../client')))

const WebSocket = require('ws')
const server = http.createServer(app)
const wsServer = new WebSocket.Server({ server })

const validMessage = message => true
const history = []

const addMessageToHistory = message => {
  history.push(message)
}

wsServer.on('connection', socket => {
  socket.on('message', message => {
    if (validMessage(message)) {
      addMessageToHistory(JSON.parse(message))

      wsServer.clients.forEach(client => {
        client.send(message)
      })
    }
  })

  socket.send(JSON.stringify({ type: 'history', history }))
})


server.listen(9001, () => { console.log('server is over 9000')})
