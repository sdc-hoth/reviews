// require ('newrelic');

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
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

app.use(bodyParser())
app.options('*', cors());

app.get('/', (req, res) => {
  'loaderio-8bea9c84652f2a644d8450c9cb4bf64c'
})

app.get('*/meta', controllers.meta)

app.get('/reviews*', controllers.reviews)

app.post('/reviews*', controllers.post)

app.put('*/helpful', controllers.helpful)

app.put('*/report', controllers.report)

app.listen(port, () => {
  console.log(`example app listening on port ${port}`)
})