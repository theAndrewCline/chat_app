import { Elm } from './Main.elm'

let history = [1, 2, 3]

const app = Elm.Main.init({
  node: document.querySelector('main'),
  flags: history
})

setTimeout(() => {
  app.ports.history.send([10, 11, 12])
}, 4000)

// const ws = new WebSocket('ws://localhost9001')
// ws.addEventListener('message', (json) => {
  // app.ports.history.send(json)
// })
