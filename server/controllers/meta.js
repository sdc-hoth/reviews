const { Pool, Client } = require('pg');
const pool = new Pool({
  user: 'postgres',
  host:'localhost',
  port: 5432,
  database: 'reviews'
})

module.exports.getMeta = (req, res) => {
  console.log(req.originalUrl);
  const path = req.originalUrl.split('/')
  console.log(path[2]);

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
        console.log(result.rows[0].row_to_json);
        res.send(result.rows[0].row_to_json)
      })
      }
  getMetadata(path[2])
}