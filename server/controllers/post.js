const { Pool, Client } = require('pg');
const pool = new Pool({
  user: 'postgres',
  host:'localhost',
  port: 5432,
  database: 'reviews'
})

module.exports.post = (req, res) => {
  console.log(req.originalUrl)
  const path = req.originalUrl.split('');
  console.log('request received:', req.body)
  const product_id = req.body.product_id;
  const rating = req.body.rating;
  const summary = req.body.summary;
  const body = req.body.body;
  const recommend = req.body.recommend;
  const name = req.body.name;
  const email = req.body.email;
  const photos = req.body.photos;
  const characteristics = req.body.characteristics;

  function postReview() {
    const query = (`
      insert into reviews (product_id, rating, summary, body, recommend, reviewer_name, reviewer_email)
      values ($1, $2, $3, $4, $5, $6, $7)
    `)
    const values = [product_id, rating, summary, body, recommend, name, email]
    pool.query(query, values, (err, result) => {
      if (err) {
        console.log(err);
      } else {
        console.log(res.rows[0])
        res.send('data received');
      }
    })
  }

  postReview();
}