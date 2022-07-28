DROP TABLE IF EXISTS reviewsMeta;

-- CREATE TABLE reviewsMeta (
--   "id" SERIAL PRIMARY KEY
-- );

DROP TABLE IF EXISTS reviews CASCADE;

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    product_id integer,
    rating smallint,
    date varchar(255),
    summary varchar(255),
    body varchar,
    recommend boolean,
    reported boolean,
    reviewer_name varchar(255),
    reviewer_email varchar(255),
    repsponse varchar(255),
    helpfulness smallint
);

-- COPY reviews(id,product_id,rating, date, summary, body, recommend, reported,
-- reviewer_name, reviewer_email, repsponse, helpfulness)
-- FROM '/home/david/hackreactor/sdc/reviews/csv/reviews.csv'
-- delimiter ','
-- CSV HEADER;

DROP TABLE IF EXISTS reviewPhotos CASCADE;

CREATE TABLE IF NOT EXISTS reviewPhotos (
    id SERIAL PRIMARY KEY,
    review_id INTEGER,
    url VARCHAR(255)
);

-- COPY reviewphotos(id,review_id,url)
-- FROM '/home/david/hackreactor/sdc/reviews/csv/reviews_photos.csv'
-- delimiter ','
-- CSV HEADER;

DROP TABLE IF EXISTS characteristics CASCADE;

CREATE TABLE characteristics (
    id SERIAL PRIMARY KEY,
    product_id integer,
    name varchar(10)
);

-- COPY characteristics(id,product_id,name)
-- FROM '/home/david/hackreactor/sdc/reviews/csv/characteristics.csv'
-- delimiter ','
-- CSV HEADER;

DROP TABLE IF EXISTS characteristicsReviews CASCADE;

CREATE TABLE characteristicsReviews (
    id SERIAL PRIMARY KEY,
    characteristic_id integer,
    review_id integer,
    value integer
);

-- COPY characteristicsreviews(id,Characteristic_id, review_id,value)
-- FROM '/home/david/hackreactor/sdc/reviews/csv/characteristic_reviews.csv'
-- delimiter ','
-- CSV HEADER;

-- -- ---
-- -- Foreign Keys
-- -- ---

ALTER TABLE reviewPhotos ADD FOREIGN KEY (review_id) REFERENCES reviews (id);
-- ALTER TABLE characteristicsReviews ADD FOREIGN KEY (characteristic_id) REFERENCES characteristics (id);
-- ALTER TABLE characteristicsReviews ADD FOREIGN KEY (review_id) REFERENCES reviews (id);

-- -- ---
-- -- SQL Queries
-- -- ---

-- -- return a row as a json rather than a table
-- SELECT row_to_json(r) FROM reviews r WHERE r.product_id = 13;

-- -- return a series of jsons from a table
-- SELECT json_agg(r) FROM (
--  SELECT r.product_id, r.summary, r.recommend, r.rating FROM reviews r WHERE r.product_id < 5
-- ) r;

-- -- return a nested json

-- -- get average rating for product
-- SELECT AVG(r.rating) FROM reviews r WHERE r.product_id = 13;

-- -- get all ratings for product
-- SELECT r.rating, COUNT(r.rating) FROM reviews r WHERE r.product_id = 13 GROUP BY r.rating;

-- -- get number of times a product has been recommended
-- SELECT COUNT(r.recommend) FROM reviews r WHERE r.recommend = true AND r.product_id = 13;

-- -- return average characteristic ratings for a certain product
-- SELECT c.name, AVG(cr.value) FROM characteristics c, characteristicsreviews cr WHERE c.product_id = 13
-- AND c.id = cr.characteristic_id GROUP BY c.name;

-- -- return average characteristics as json key-value pairs
-- select json_object_agg(e.name, e.avg) from (select c.name, avg(cr.value)
-- from characteristics c, characteristicsreviews cr
-- where c.product_id = 1 and c.id = cr.characteristic_id
-- group by c.name) e;


-- -- all together