const reviews = require('./reviews.js')
const meta = require('./meta.js')

// all reviews
module.exports.reviews = reviews.getReviews;

// review metadata
module.exports.meta = meta.getMeta;