DROP TABLE IF EXISTS reviewsMeta;

-- CREATE TABLE reviewsMeta (
--   "id" SERIAL PRIMARY KEY
-- );

DROP TABLE IF EXISTS reviews;

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

DROP TABLE IF EXISTS reviewPhotos;

CREATE TABLE IF NOT EXISTS reviewPhotos (
    id SERIAL PRIMARY KEY,
    review_id INTEGER,
    url VARCHAR(255)
);

-- COPY reviewphotos(id,review_id,url)
-- FROM '/home/david/hackreactor/sdc/reviews/csv/reviews_photos.csv'
-- delimiter ','
-- CSV HEADER;

-- DROP TABLE IF EXISTS characteristics;

-- CREATE TABLE characteristics (
--     "id" SERIAL PRIMARY KEY,
-- )

-- -- ---
-- -- Foreign Keys
-- -- ---

ALTER TABLE reviewPhotos ADD FOREIGN KEY (review_id) REFERENCES reviews (id);
-- ALTER TABLE `messages` ADD FOREIGN KEY (id_rooms) REFERENCES `rooms` (`id`);

-- CREATE DATABASE chat;

-- USE chat;

-- -- CREATE TABLE messages (
-- --   /* Describe your table here.*/
-- --   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
-- --   id_usernames INT NOT NULL,
-- --   id_rooms INT NOT NULL,
-- --   messageText VARCHAR(255)
-- -- );

-- -- /* Create other tables and define schemas for them here! */

-- -- CREATE TABLE usernames (
-- --   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
-- --   username VARCHAR(255) NOT NULL
-- -- );

-- -- CREATE TABLE rooms (
-- --   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
-- --   room VARCHAR(255) NOT NULL
-- -- );

-- -- -- ---
-- -- -- Foreign Keys
-- -- -- ---

-- -- ALTER TABLE `messages` ADD FOREIGN KEY (id_usernames) REFERENCES usernames (id);
-- -- ALTER TABLE `messages` ADD FOREIGN KEY (id_rooms) REFERENCES rooms (id);

-- -- INSERT INTO `messages` (`id`,`id_usernames`,`id_rooms`,`messageText`) VALUES
-- -- (0,0,0,'sup guys');
-- -- INSERT INTO `usernames` (`id`,`username`) VALUES
-- -- (0,'david');
-- -- INSERT INTO `rooms` (`id`,`room`) VALUES
-- -- (0,'lobby');

-- /*  Execute this file from the command line by typing:
--  *    mysql -u root < server/schema.sql
--  *  to create the database and the tables.*/

-- DROP TABLE IF EXISTS `messages`;

-- CREATE TABLE `messages` (
--   `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'the message id',
--   `id_usernames` INTEGER NOT NULL COMMENT 'the user id',
--   `id_rooms` INTEGER NOT NULL COMMENT 'the room id',
--   `messageText` VARCHAR(255) NOT NULL COMMENT 'the contents of the message submitted',
--   PRIMARY KEY (`id`)
-- ) COMMENT 'contains all messages sent to the server';

-- -- ---
-- -- Table 'usernames'
-- -- holds each username submitted to the application
-- -- ---

-- DROP TABLE IF EXISTS `usernames`;

-- CREATE TABLE `usernames` (
--   `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'the user id',
--   `username` VARCHAR(255) NOT NULL COMMENT 'the chosen username',
--   PRIMARY KEY (`id`)
-- ) COMMENT 'holds each username submitted to the application';

-- -- ---
-- -- Table 'rooms'
-- -- holds every room created
-- -- ---

-- DROP TABLE IF EXISTS `rooms`;

-- CREATE TABLE `rooms` (
--   `id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'the room id',
--   `room` VARCHAR(255) NOT NULL COMMENT 'the chosen room',
--   PRIMARY KEY (`id`)
-- ) COMMENT 'holds every room created';

-- -- ---
-- -- Foreign Keys
-- -- ---

-- ALTER TABLE `messages` ADD FOREIGN KEY (id_usernames) REFERENCES `usernames` (`id`);
-- ALTER TABLE `messages` ADD FOREIGN KEY (id_rooms) REFERENCES `rooms` (`id`);

-- -- ---
-- -- Table Properties
-- -- ---

-- -- ALTER TABLE `messages` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- -- ALTER TABLE `usernames` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- -- ALTER TABLE `rooms` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- -- ---
-- -- Test Data
-- -- ---

-- -- INSERT INTO `usernames` (`id`,`username`) VALUES
-- -- (0,'David');
-- -- INSERT INTO `rooms` (`id`,`room`) VALUES
-- -- (0,'lobby');
-- -- INSERT INTO `messages` (`id`,`id_usernames`,`id_rooms`,`messageText`) VALUES
-- -- (0,1,1,'howdy yall');
-- -- INSERT INTO `usernames` (`id`,`username`) VALUES
-- -- (1,'Kai');
-- -- INSERT INTO `rooms` (`id`,`room`) VALUES
-- -- (1,'lobby');
-- -- INSERT INTO `messages` (`id`,`id_usernames`,`id_rooms`,`messageText`) VALUES
-- -- (1,1,1,'sup man');

-- -- query for finding usernames rooms, and messages:
-- -- select u.username, r.room, m.messageText from messages m inner join usernames u on u.id = m.id_usernames inner join rooms r on r.id = m.id_rooms;