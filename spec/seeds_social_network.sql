-- -------------------------------------------------------------
-- TablePlus 4.5.0(396)
--
-- https://tableplus.com/
--
-- Database: design
-- Generation Time: 2022-04-27 17:13:27.2140
-- -------------------------------------------------------------


DROP TABLE IF EXISTS "public"."user_accounts" CASCADE;
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS user_accounts_id_seq;

-- Table Definition
CREATE TABLE "public"."user_accounts" (
    id SERIAL PRIMARY KEY,
    email text,
    username text
);

DROP TABLE IF EXISTS "public"."posts";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS posts_id_seq;

-- Table Definition
CREATE TABLE "public"."posts" (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  views int,
-- The foreign key name is always {other_table_singular}_id
  user_account_id int,
  constraint fk_user_account foreign key(user_account_id) references user_accounts(id)
  ON DELETE CASCADE
);

INSERT INTO "public"."user_accounts" ("email", "username") VALUES
('anna@gmail.com', 'anna'),
('shaun@gmail.com', 'shaun'),
('mark@gmail.com', 'mark'),
('alice@gmail.com', 'alice'),
('creator@gmail.com', 'creator'),
('fanthom@gmail.com', 'fanthom');

INSERT INTO "public"."posts" ("title", "content", "views", "user_account_id") VALUES
('I think', 'I think about lots of things', '5', '1'),
('I see', 'I see lots of things', '10', '1'),
('I am smart', 'I studied a lot', '5516', '2'),
('People are smart', 'I think about people a lot', '2', '3'),
('Dogs are great', 'They do everything I tell them to do. In theory', '0', '3'),
('I am not smart', 'My dog does not listen to me', '450', '3'),
('I still think', 'Sometimes', '13', '4'),
('Nice weather', 'It is sunny and lovely outside', '1235', '5'),
('The green', 'Trees and clean water are essential for our survival', '5', '5'),
('Something is going on', 'People are horrible human beings. They damage the environment', '90', '5'),
('Cats', 'They are still so much better than dogs', '1000000', '6');
