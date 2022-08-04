const cf = require('../../config.js')

const { Pool, Client } = require('pg');
const pool = new Pool({
  user: 'postgres',
  password: 'postgres',
  host: module.exports.aws,
  port: 5432,
  database: 'reviews'
})

module.exports.getReviews = (req, res) => {
  // console.log(req.originalUrl)
  let path = req.originalUrl.split('/')
  // console.log(path)
  let product_id = path[2].split('?')[0];
  console.log(product_id)
  // console.log('queries:', req.query)
  let sort = req.query.sort;
  // sort = sort.split(':')
  // console.log('sort:', sort)
  // let sort1 = sort[0];
  // let sort2 = sort[1];
  let limit = req.query.count.split('').slice(0, req.query.count.length-1).join('')
  console.log(limit)
  // console.log(limit)
  // console.log(path[2])

  getReviewData = (product_id, sort, limit) => {
    // console.log('sorts:', sort1, sort2)
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
      // console.log(result.rows[0].json_build_object);
      res.send(result.rows[0].json_build_object)
    })
    .catch((err) => {
      console.log('error in review fetching:', err);
    })
    // console.log('help')
  }
  getReviewData(product_id, sort, limit)
}

