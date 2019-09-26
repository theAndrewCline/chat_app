import { Elm } from './src/Main.elm'

let author = prompt('what is your name?')

const app = Elm.Main.init({
  node: document.querySelector('main'),
  flags: author
})

const ws = new WebSocket('ws://localhost:9001')
ws.addEventListener('message', (message) => {
  const json = JSON.parse(message.data)
  if (json.type === 'history') {
    app.ports.history.send(json.history)
  }
})

app.ports.sendWSMsg.subscribe((message) => {
  const newMessage = { ...message, timestamp: Date.now() }
  ws.send(JSON.stringify(newMessage))
})


