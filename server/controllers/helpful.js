const { Pool, Client } = require('pg');
const pool = new Pool({
  user: 'postgres',
  host:'localhost',
  port: 5432,
  database: 'reviews'
})

module.exports.helpful = (req, res) => {
  console.log('request received:', req.body)
}