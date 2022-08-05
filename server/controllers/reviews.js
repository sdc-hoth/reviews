const cf = require('../../config.js')

const { Pool, Client } = require('pg');
const pool = new Pool({
  user: cf.user,
  password: cf.password,
  host: cf.aws,
  port: 5432,
  database: 'reviews'
})

module.exports.getReviews = (req, res) => {
  let path = req.originalUrl.split('/')
  let product_id = path[2].split('?')[0];
  let sort = req.query.sort;
  let limit = req.query.count.split('').slice(0, req.query.count.length-1).join('')

  getReviewData = (product_id, sort, limit) => {
    pool.query(
      `select json_build_object(
        'product', ${product_id},
        'page', 0,
        'count', ${limit},
        'results',
        (
          select json_agg(rp) as results
          from (
            select r.id as review_id,
            r.rating as rating,
            r.summary as summary,
            r.recommend as recommend,
            coalesce(nullif(r.response,''), '') as response,
            r.body as body,
            to_timestamp(r.date ::double precision / 1000) at time zone 'UTC' as date,
            r.reviewer_name as reviewer_name,
            r.helpfulness as helpfulness,
            coalesce((
              select json_agg(pho)
              from (
                select rp.id, rp.url
                from reviewphotos rp
                where rp.review_id = r.id
              ) as pho
            ), '[]') as photos
            from reviews r
            where r.product_id=${product_id} and reported = false
            order by helpfulness desc
            limit ${limit}
          ) as rp
        )
      )`
    )
    .then((result) => {
      // console.log('reviews request received & server contacted')
      res.send(result.rows[0].json_build_object)
    })
    .catch((err) => {
      console.log('error in review fetching:', err);
    })
  }

  getReviewData(product_id, sort, limit)
}

