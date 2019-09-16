import { Elm } from './Main.elm'

let history = [{
  author: "Andrew",
  content: "I'm Hungry",
  timestamp: Date.now()
}]

const app = Elm.Main.init({
  node: document.querySelector('main'),
  flags: history
})

setTimeout(() => {
  history.push({
    author: "Jacob",
    content: "Me Too...",
    timestamp: Date.now()
  })
  app.ports.history.send(history)
}, 4000)

// const ws = new WebSocket('ws://localhost9001')
// ws.addEventListener('message', (json) => {
  // app.ports.history.send(json)
// })
