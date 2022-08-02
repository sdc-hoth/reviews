const reviews = require('./reviews.js')
const post = require('./post.js')
const meta = require('./meta.js')

// all reviews
module.exports.reviews = reviews.getReviews;

// review metadata
module.exports.meta = meta.getMeta;

// post review to db
module.exports.post = post.post;