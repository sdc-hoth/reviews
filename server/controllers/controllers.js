const reviews = require('./reviews.js')
const post = require('./post.js')
const meta = require('./meta.js')
const helpful = require('./helpful.js')
const report = require('./report.js')

// all reviews
module.exports.reviews = reviews.getReviews;

// review metadata
module.exports.meta = meta.getMeta;

// post review to db
module.exports.post = post.post;

module.exports.helpful = helpful.helpful;

module.exports.report = report.report;