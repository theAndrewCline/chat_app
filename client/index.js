// const author = prompt('What is your username?')
// alert(`Welcome, ${author}`)
const author = 'Andrew'

const ws = new WebSocket('ws://localhost:9001')
ws.addEventListener('message', evt => {
  const messageObject = JSON.parse(evt.data)
  if (messageObject.type === 'history') {
    renderHistory(messageObject.history)
  }
  if (messageObject.type === 'message') {
    renderNewMessage(messageObject.message)
  }
})

sendMessage.addEventListener('click', evt => {
  const newMessage = {
    type: 'message',
    message: {
      author,
      timestamp: new Date(),
      text: messageInput.value
    }
  }

  ws.send(JSON.stringify(newMessage))
  // ws.send(JSON.stringify(newMessage))
  messageInput.value = ''
  messageInput.focus()
})

const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
const renderTimestamp = dateString => {
  const date = new Date(dateString)
  const dayOfWeek = daysOfWeek[date.getDay()]
  const hours = date.getHours() % 12 || 12
  const minutes = date.getMinutes().toString().padStart(2, '0')
  const ampm = date.getHours() >= 12 ? 'pm' : 'am'
  return `${dayOfWeek} ${hours}:${minutes}${ampm}`
}

const renderMessageHTML = message => `
  <li>
    <div class="line"></div>
    <div>
      <span class="author">${message.author}</span>
      <span class="timestamp">${renderTimestamp(message.timestamp)}</span>
    </div>
    <div>${message.text}</div>
  </li>
`

const renderNewMessage = newMessage => {
  messageHistory.insertAdjacentHTML('beforeend', renderMessageHTML(newMessage))
}

const renderHistory = history => {
  messageHistory.innerHTML = history
    .map(x => x.message)
    .map(renderMessageHTML)
    .join('')
}