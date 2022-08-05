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

app.use((req, res, next) => {
  if (req.originalUrl === '/loaderio-cd219dc698df43f549da9a9fb14ef27b.txt') {
    res.send('loaderio-cd219dc698df43f549da9a9fb14ef27b')
  }
  next();
})

app.use(bodyParser())
app.options('*', cors());

app.get('*/meta', controllers.meta)

app.get('/reviews*', controllers.reviews)

app.post('/reviews*', controllers.post)

app.put('*/helpful', controllers.helpful)

app.put('*/report', controllers.report)

app.listen(port, () => {
  console.log(`example app listening on port ${port}`)
})
