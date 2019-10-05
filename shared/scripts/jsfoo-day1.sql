CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    name CHARACTER VARYING NOT NULL
);

SELECT 1 IS NULL AS is_one_null;


DROP TABLE books;

CREATE TABLE editions (
    id SERIAL PRIMARY KEY,
    book_id INTEGER REFERENCES books(id),
    name CHARACTER VARYING
);
--
ALTER TABLE editions
    ALTER COLUMN book_id SET NOT NULL;

INSERT INTO editions(name)
VALUES ('first edition');

DROP TABLE editions;


CREATE TABLE genres (
    id SERIAL PRIMARY KEY,
    name CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO genres (name)
VALUES ('fantasy') RETURNING *;


CREATE TABLE books_genres (
    id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL REFERENCES books(id),
    genre_id INTEGER NOT NULL REFERENCES genres(id)
);


ALTER TABLE books_genres
    ADD CONSTRAINT books_genres_uniqueness
        UNIQUE (book_id, genre_id);



CREATE TABLE shelves (
    id SERIAL PRIMARY KEY,
    name CHARACTER VARYING NOT NULL
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email CHARACTER VARYING NOT NULL UNIQUE
);


ALTER TABLE users
    ADD COLUMN name CHARACTER VARYING;

CREATE TABLE editions_shelves (
    id SERIAL PRIMARY KEY,
    edition_id INTEGER NOT NULL REFERENCES editions(id),
    shelf_id INTEGER NOT NULL REFERENCES shelves(id)
);

ALTER TABLE editions_shelves
    ADD CONSTRAINT
        editions_shelves_uniqueness UNIQUE (edition_id, shelf_id);


CREATE TABLE shelves_users (
    id SERIAL PRIMARY KEY,
    shelf_id INTEGER NOT NULL REFERENCES shelves(id),
    user_id INTEGER NOT NULL REFERENCES users(id)
);

ALTER TABLE shelves_users
    ADD CONSTRAINT
        shelves_users_uniqueness UNIQUE (shelf_id, user_id);

ALTER TABLE editions
    ADD COLUMN current BOOLEAN NOT NULL DEFAULT FALSE;



ALTER TABLE editions
    ADD CONSTRAINT
        only_one_current_edition EXCLUDE USING btree (book_id WITH =)
        WHERE (current);

ALTER TABLE editions
    DROP CONSTRAINT only_one_current_edition;

INSERT INTO books(name)
VALUES ('harry potter') RETURNING *;

INSERT INTO editions (name, book_id, current)
VALUES ('first', 1, FALSE) RETURNING *;


INSERT INTO editions (name, book_id, current)
VALUES ('second', 1, TRUE) RETURNING *;


INSERT INTO editions (name, book_id, current)
VALUES ('third', 1, FALSE) RETURNING *;

INSERT INTO editions (name, book_id, current)
VALUES ('fourth', 1, TRUE) RETURNING *;


INSERT INTO users (email, name)
VALUES ('A@B.com', 'A');

INSERT INTO users (email, name)
VALUES ('a@b.com', 'A');

DELETE
FROM users
WHERE id = 3 RETURNING *;

ALTER TABLE users
    DROP CONSTRAINT users_email_key;


ALTER TABLE users
    ADD CONSTRAINT
        user_email_case_insensitive_uniqueness EXCLUDE USING btree
        (lower(email) WITH =);

ALTER TABLE users
    ADD CONSTRAINT
        everybody_has_different_length_name EXCLUDE USING btree
        (length(name) WITH =);

ALTER TABLE users
    DROP CONSTRAINT everybody_has_different_length_name;


INSERT INTO users (email, name)
VALUES ('b@c.com', '25');

INSERT INTO users (email, name)
VALUES ('b@c1.com', '25df');

INSERT INTO users (email, name)
VALUES ('b@d.com', '25df');

ALTER TABLE users
    ADD CONSTRAINT username_must_be_above_20
        CHECK (5 <= length(name) AND length(name) <= 20 );


DELETE
FROM users
WHERE TRUE;

-- HOMEWORK: FIGURE OUT HOW DROP WORKS WITH CASCADE

TRUNCATE TABLE users RESTART IDENTITY CASCADE;


CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name CHARACTER VARYING NOT NULL
);

CREATE TABLE authors_books (
    id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL REFERENCES books(id),
    author_id INTEGER NOT NULL REFERENCES authors(id),
    position INTEGER NOT NULL CHECK ( position > 0 ) -- figure out other ways of doing this
);

ALTER TABLE authors_books
    ADD CONSTRAINT author_a_book_only_once
        UNIQUE (book_id, author_id);

ALTER TABLE authors_books
    ADD CONSTRAINT authors_are_ordered
        UNIQUE (book_id, position);



TRUNCATE TABLE books RESTART IDENTITY CASCADE;


ALTER TABLE books
    ADD COLUMN current_edition_id
        INTEGER NOT NULL REFERENCES editions(id)
            DEFERRABLE INITIALLY DEFERRED;


BEGIN;

INSERT INTO books (name, current_edition_id)
VALUES ('test', 0) RETURNING *;

SELECT *
FROM books;

INSERT INTO editions (book_id, name)
VALUES (4, 'first') RETURNING *;

UPDATE books
SET current_edition_id = 1
WHERE id = 4;

COMMIT;
ROLLBACK;


ALTER TABLE editions
    ADD CONSTRAINT restrict_names
        CHECK ( name IN ('first', 'second') );

ALTER TABLE editions
    DROP CONSTRAINT restrict_names;

SELECT '{
  "a": "b"
}'::JSONB || '{
  "c": "d"
}'::JSONB AS merged;


CREATE TYPE public.APPOINTMENT_TYPE AS ENUM (
    'email',
    'phone',
    'text',
    'other',
    'in_person'
--     'note'
    );

BEGIN;

ALTER TYPE APPOINTMENT_TYPE ADD VALUE 'note';

COMMIT;

INSERT INTO editions(book_id, name)
VALUES (1, 'sfdsdfsd');
