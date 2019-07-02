BEGIN;
SET CONSTRAINTS at_least_one_edition_for_book DEFERRED;

WITH b1 AS (
    INSERT INTO books (NAME, current_edition_id)
        VALUES ('Kane & Abel', 0) RETURNING *
),
    e1 AS (
        INSERT INTO editions (book_id)
            (SELECT id FROM b1)
            RETURNING *
    )

UPDATE books
SET current_edition_id = e1.id
FROM e1
WHERE books.id = e1.book_id RETURNING *;



SELECT *
FROM books;

ROLLBACK;
COMMIT;



ALTER TABLE editions
    ADD COLUMN current BOOLEAN DEFAULT FALSE;

ALTER TABLE editions
    ADD COLUMN name CHARACTER VARYING NOT NULL;



ALTER TABLE editions
    ADD CONSTRAINT only_one_current_edition EXCLUDE (book_id WITH =)
        WHERE (current);


DELETE
FROM editions
WHERE id > 2 RETURNING *;

ALTER TABLE editions
    ADD CONSTRAINT edition_name_unique_per_book
        EXCLUDE (book_id WITH =, lower(name) WITH !=);


-- New Rule:
-- Two editions of a book cannot have the same name, case-insensitive
-- Two editions of different books *can* have the same name, case-insensitive


CREATE TABLE shelves
(
    id         SERIAL PRIMARY KEY,
    name       CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);


CREATE TABLE users
(
    id         SERIAL PRIMARY KEY,
    email      CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);

ALTER TABLE users
    ADD CONSTRAINT unique_users_email EXCLUDE (lower(email) WITH =);


CREATE TABLE editions_shelves
(
    id         SERIAL PRIMARY KEY,
    edition_id INTEGER NOT NULL REFERENCES editions (id),
    shelf_id   INTEGER NOT NULL REFERENCES shelves (id)
);

ALTER TABLE editions_shelves
    ADD CONSTRAINT one_edition_per_shelf UNIQUE (edition_id, shelf_id);

CREATE TABLE shelves_users
(
    id       SERIAL PRIMARY KEY,
    shelf_id INTEGER NOT NULL REFERENCES shelves (id),
    user_id  INTEGER NOT NULL REFERENCES users (id)
);

ALTER TABLE shelves_users
    ADD CONSTRAINT
        unique_shelf_per_user EXCLUDE (user_id WITH =, shelf_id WITH =);

TRUNCATE TABLE shelves RESTART IDENTITY CASCADE;

-- ALTER TABLE shelves
--     ADD COLUMN first_user_id INTEGER NOT NULL;
--
-- ALTER TABLE shelves
--     ADD CONSTRAINT user_must_for_shelf
--         FOREIGN KEY (first_user_id) REFERENCES shelves_users (id)
--             DEFERRABLE INITIALLY DEFERRED;
--

BEGIN;

INSERT INTO users(email)
VALUES ('b@example.com') RETURNING *;

INSERT INTO shelves (name, first_user_id)
VALUES ('first', 0) RETURNING *;

INSERT INTO shelves_users (user_id, shelf_id)
VALUES (2, 4) RETURNING *;

UPDATE shelves
SET first_user_id = 2
WHERE id = 4;

COMMIT;
ROLLBACK;


CREATE TABLE genres
(
    id         SERIAL PRIMARY KEY,
    name       CHARACTER VARYING NOT NULL,/* Name must be present */
    created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE books_genres
(
    id       SERIAL PRIMARY KEY,
    book_id  INTEGER NOT NULL REFERENCES books (id),
    genre_id INTEGER NOT NULL REFERENCES genres (id)
);

-- Authors
CREATE TABLE authors
(
    id         SERIAL PRIMARY KEY,
    name       CHARACTER VARYING NOT NULL,
    bio        TEXT,
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Books can have many authors
-- Authors can have many books
CREATE TABLE authors_books
(
    id         SERIAL PRIMARY KEY,
    book_id    INTEGER NOT NULL REFERENCES books (id),
    author_id  INTEGER NOT NULL REFERENCES authors (id),
    position   INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Since position is a list, add some constraints
ALTER TABLE authors_books
    ADD CONSTRAINT authors_books_position_unique
        UNIQUE (book_id, position);

ALTER TABLE authors_books
    ADD CONSTRAINT author_position_must_be_positive
        CHECK ( position > 0 );

-- Editions can have many authors
-- Authors can have many editions
CREATE TABLE authors_editions
(
    id         SERIAL PRIMARY KEY,
    edition_id INTEGER NOT NULL REFERENCES editions (id),
    author_id  INTEGER NOT NULL REFERENCES authors (id),
    position   INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Since position is a list, add some constraints
ALTER TABLE authors_editions
    ADD CONSTRAINT authors_editions_position_unique
        UNIQUE (edition_id, position);

ALTER TABLE authors_editions
    ADD CONSTRAINT author_edition_position_must_be_positive
        CHECK ( position > 0 );


CREATE TABLE reviews
(
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER NOT NULL REFERENCES users (id),
    edition_id INTEGER NOT NULL REFERENCES editions (id),
    rating     INTEGER NOT NULL CHECK ( 0 <= rating AND rating <= 5 )
);

ALTER TABLE reviews
    ADD CONSTRAINT one_review_per_edition UNIQUE (edition_id, user_id);

-- CREATE UNIQUE INDEX fast_user_editions_lookup ON reviews (user_id, edition_id);


ALTER TABLE editions
    ADD CONSTRAINT max_ten_editions
        CHECK ( count(DISTINCT) );


SELECT EXTRACT(YEAR FROM now());


SELECT *
FROM editions
LIMIT 1;

CREATE TYPE EDITION_ROW AS (
    id INTEGER,
    bid INTEGER,
    cat TIMESTAMP,
    crr BOOLEAN,
    nm VARCHAR
    );

SELECT (x.foo).book_id
FROM (
    SELECT books.id,
        (SELECT ROW (e2.id, e2.book_id, e2.created_at, e2.current, e2.name)
         FROM editions e2
         LIMIT 1)                                AS foo,
        round(extract(SECOND FROM e.created_at)) AS day_created_at,
        array_agg(DISTINCT e.id)                 AS edition_ids,
        count(DISTINCT e.id)                     AS num_editions
    FROM books
             INNER JOIN editions e ON books.id = e.book_id
    GROUP BY books.id, round(extract(SECOND FROM e.created_at))
    HAVING count(e.id) >= 2
    ORDER BY day_created_at) x;
--


CREATE TYPE EDITIONS_ROW AS (
    id INTEGER,
    current BOOLEAN,
    name VARCHAR
    );

SELECT books.id,
    (SELECT ROW (e2.id, e2.current, e2.name)::EDITIONS_ROW
     FROM editions e2
     WHERE e2.book_id = books.id AND e2.current = TRUE
     LIMIT 1)                  AS first_edition,
    round(extract(SECOND FROM e.created_at)) AS second_created,
    array_agg(DISTINCT e.id)                 AS edition_ids,
    count(DISTINCT e.id)                     AS num_editions
FROM books
         INNER JOIN editions e ON books.id = e.book_id
GROUP BY books.id,
    round(extract(SECOND FROM e.created_at))
HAVING count(e.id) >= 2
ORDER BY books.id;



-- 1. Count of

SELECT COUNT(books.id)
FROM books
         LEFT JOIN books_genres bg ON books.id = bg.book_id
WHERE bg.id IS NULL;


SELECT DISTINCT a.id, a.name
FROM authors a
         INNER JOIN authors_editions ae ON a.id = ae.author_id
         LEFT OUTER JOIN authors_books ab ON a.id = ab.author_id
WHERE ab.id IS NULL;



SELECT book_name,
    book_id,
    array_agg(author_id)   AS author_ids,
    array_agg(author_name) AS author_names
FROM (
    SELECT b.id AS book_id, b.name AS book_name, a.id AS author_id, a.name AS author_name
    FROM books b
             INNER JOIN authors_books ab ON b.id = ab.book_id
             INNER JOIN authors a ON ab.author_id = a.id
    UNION
    SELECT b.id, b.name, a2.id, a2.name
    FROM books b
             INNER JOIN editions e ON b.id = e.book_id
             INNER JOIN authors_editions ae ON e.id = ae.edition_id
             INNER JOIN authors a2 ON ae.author_id = a2.id
) authors_of_a_book
WHERE book_id = 1
GROUP BY book_name, book_id
ORDER BY book_name, book_id;


SELECT DISTINCT b.id                                                              AS book_id,
    (CASE WHEN ae.id IS NULL THEN ab.author_id ELSE ae.author_id END) AS author_id
FROM books b
         LEFT OUTER JOIN editions e ON b.id = e.book_id
         LEFT OUTER JOIN authors_editions ae ON e.id = ae.edition_id
         LEFT OUTER JOIN authors_books ab ON b.id = ab.book_id
WHERE ab.book_id = 1;

SELECT *
FROM books b
         LEFT OUTER JOIN editions e ON b.id = e.book_id
WHERE b.id = 1;



SELECT shelf_id, array_agg(user_id)
FROM shelves_users
GROUP BY shelf_id
HAVING count(user_id) = 1
        AND 30 = (array_agg(user_id))[1];

SELECT shelf_id, array_agg(user_id)
FROM shelves_users
GROUP BY shelf_id
HAVING 30 = (array_agg(DISTINCT user_id))[1];


SELECT shelf_id
FROM shelves_users
WHERE user_id = 30;

SELECT user_id
FROM shelves_users
WHERE shelf_id = 66;

SELECT user_id
FROM shelves_users
WHERE shelf_id = 39;


SELECT 1 AS numeral, 'one' AS literal
UNION
VALUES (2, 'two'),
(3, 'three');










