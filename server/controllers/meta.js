const cf = require('../../config.js')

const { Pool, Client } = require('pg');
const pool = new Pool({
  user: cf.user,
  password: cf.password,
  host: cf.aws,
  port: 5432,
  database: 'reviews'
})

module.exports.getMeta = (req, res) => {
  const path = req.originalUrl.split('/')
  function getMetadata(product_id) {
    pool.query(`with ratings as (
        select r.rating,
        count(r.rating)
        from reviews r where r.product_id=${product_id} group by rating
      ),
      chars as (
        select c.id,
        avg(cr.value) as value
        from characteristics c,
        characteristicsreviews cr
        where c.product_id = ${product_id}
        and c.id=cr.characteristic_id
        group by c.id
      ),
      res as (
        select json_object_agg(c.name, row_to_json(chars)) as characteristics
        from characteristics c, chars
        where c.id=chars.id
      ),
      meta as (
      select
        (
          select distinct r.product_id
          from reviews r
          where r.product_id=${product_id}
      ) as product_id,
        (
          select json_object_agg(ratings.rating, ratings.count)
          from ratings
      ) as ratings,
        (
          select count(r.recommend)
          from reviews r
          where r.recommend = true and product_id=${product_id}
      ) as recommend,
        (
          select json_object_agg(c.name, row_to_json(chars)) as characteristics
          from characteristics c, chars
          where c.id=chars.id
        ) as characteristics)
      select row_to_json(meta) from meta`)
      .then((result) => {
        // console.log('metadata request received & server contacted')
        res.send(result.rows[0].row_to_json)
      })
      .catch((err) => {
        console.log('error in metadata fetching:', err);
      })
      }
  getMetadata(path[2])
}