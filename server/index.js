const express = require('express');
const cors = require('cors');
const app = express();
const cf = require('../config.js')

const controllers = require('./controllers/controllers.js')
// const meta = require('./controllers/meta.js')

const port = cf.port;


// app.use(cors);
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  next();
});

app.get('/', (req, res) => {
  res.send('hello world');
})

app.get('*/meta', controllers.meta)

app.get('/reviews*', controllers.reviews)

app.listen(port, () => {
  console.log(`example app listening on port ${port}`)
})