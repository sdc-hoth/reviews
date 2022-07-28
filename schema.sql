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

-- get average rating for product
-- SELECT AVG(r.rating) FROM reviews r WHERE r.product_id = 13;