const { Pool, Client } = require('pg');
const pool = new Pool({
  user: 'postgres',
  host:'localhost',
  port: 5432,
  database: 'reviews'
})

module.exports.getReviews = (req, res) => {
  console.log(req.originalUrl)
  let path = req.originalUrl.split('/')
  console.log(path[2])

  getReviewData = (product_id) => {
    pool.query(
      `select json_build_object(
        'product', ${product_id},
        'page', 0,
        'count', 5,
        'results',
        (
          select json_agg(rp) as results
          from (
            select r.*,
            coalesce((
              select json_agg(pho)
              from (
                select rp.id, rp.url
                from reviewphotos rp
                where rp.review_id = r.id
              ) as pho
            ), '[]') as photos
            from reviews r
            where r.product_id=${product_id}
            limit 5
          ) as rp
        )
      )`
    )
    .then((result) => {
      console.log(result.rows[0].json_build_object);
      res.send(result.rows[0].json_build_object)
    })
  }
  getReviewData(path[2])
}
