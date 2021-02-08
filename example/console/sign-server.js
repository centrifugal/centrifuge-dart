const express = require('express')
const bodyParser = require('body-parser')
const jwt = require('jsonwebtoken')

const app = express()
const PORT = process.env.PORT || 5000

app.use(bodyParser.json())

app.post('/auth', (req, res) => {
  const channels = []

  for (const channel of req.body.channels) {
    const token = jwt.sign({
      client: req.body.client,
      channel,
    }, 'secret')
    channels.push({ channel, token })
  }

  res.json({ channels })
})

app.listen(PORT, () => {
  console.log(`Sign server listening on port: ${ PORT }`)
})