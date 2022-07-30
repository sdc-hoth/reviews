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

-- -- return characteristic name with characteristic id and average rating
-- select json_object_agg(e.name, e.avg) from (select c.name, avg(cr.value)
-- from characteristics c, characteristicsreviews cr
-- where c.product_id = 1 and c.id = cr.characteristic_id
-- group by c.name) e;

-- -- -- exact matches for reviews

-- -- reviews
--

-- -- photos
-- with photos as (select rp.id, rp.url from reviewphotos rp where rp.review_id=5) select json_agg(photos) from photos;

-- with photos as (
-- 	select r.product_id, rp.review_id, rp.id, rp.url
-- 	from reviews r, reviewphotos rp
-- 	where r.product_id=4 and r.id=rp.review_id
-- ),
-- -- selectPhotos as (
-- -- 	select photos.id, photos.url
-- -- 	from photos, reviews r
-- -- 	where photos.product_id=2 and photos.review_id=r.id
-- -- ),
-- review as (
-- 	select r.id, r.product_id, r.body, json_agg(photos) as photos
-- 	from reviews r left join photos on r.id=photos.review_id
-- 	where r.product_id=4
-- 	group by r.id
-- )
-- select review.id, review.product_id, review.body, review.photos
-- from review;



-- -- -- exact matches for meta

-- -- part 1
-- select json_build_object('product_id', (select distinct r.product_id from reviews r where r.product_id=5));

-- with ratings as (select r.rating, count(r.rating) from reviews r where r.product_id=5 group by rating) select json_object_agg(ratings.rating, ratings.count) from ratings;
-- -- part 2
-- with ratings as (select r.rating, count(r.rating) from reviews r where r.product_id=5 group by rating) select json_build_object('ratings', (select json_object_agg(ratings.rating, ratings.count) from ratings));

-- -- part 3
-- select json_build_object('recommend', (select count(r.recommend) from reviews r where r.recommend = true and product_id=5));

-- -- part 4
-- with chars as (select c.id, avg(cr.value) as value from characteristics c, characteristicsreviews cr where c.product_id = 5 and c.id=cr.characteristic_id group by c.id), res as (select json_object_agg(c.name, row_to_json(chars)) as characteristics from characteristics c, chars where c.id=chars.id) select row_to_json(res) from res;

-- -- all together - 1.935s
with ratings as (
	select r.rating,
	count(r.rating)
	from reviews r where r.product_id=5 group by rating
),
chars as (
	select c.id,
	avg(cr.value) as value
	from characteristics c,
	characteristicsreviews cr
	where c.product_id = 5
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
		where r.product_id=5
) as product_id,
	(
		select json_object_agg(ratings.rating, ratings.count)
		from ratings
) as ratings,
	(
		select count(r.recommend)
		from reviews r
		where r.recommend = true and product_id=5
) as recommend,
	(
		select json_object_agg(c.name, row_to_json(chars)) as characteristics
		from characteristics c, chars
		where c.id=chars.id
	) as characteristics)
select row_to_json(meta) from meta;

