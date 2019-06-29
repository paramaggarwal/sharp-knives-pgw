-- Book can have many editions
-- Edition belongs to a book
-- Each book has only one current edition
-- Each book has a at least one edition


CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    name CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);

ALTER TABLE books
    ADD CONSTRAINT name_must_be_at_least_3 CHECK ( length(name) >= 3 );

TRUNCATE TABLE books RESTART IDENTITY CASCADE;
TRUNCATE TABLE editions RESTART IDENTITY;

ALTER TABLE books
    ADD CONSTRAINT name_must_be_unique UNIQUE (name);

ALTER TABLE books
    ADD CONSTRAINT name_author_must_be_unique UNIQUE (name, author);

ALTER TABLE books
    DROP COLUMN author;

INSERT INTO books(name)
VALUES ('Fourth Estate') RETURNING *;

INSERT INTO editions(name, book_id, current)
VALUES ('first', 1, FALSE) RETURNING *;


SELECT *
FROM books;

DELETE
FROM books
WHERE id = 2 AND id = 3 RETURNING *;



ALTER TABLE books
    ADD COLUMN author CHARACTER VARYING;



CREATE TABLE editions (
    id SERIAL PRIMARY KEY,
    book_id BIGINT REFERENCES books(id),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);


ALTER TABLE books
    ADD COLUMN current_edition_id INTEGER NOT NULL;

ALTER TABLE books
    ADD CONSTRAINT at_least_one_edition_for_book
        FOREIGN KEY (current_edition_id) REFERENCES editions(id)
            DEFERRABLE INITIALLY IMMEDIATE;


ALTER TABLE books
    DROP COLUMN current_edition_id;



BEGIN;
SET CONSTRAINTS at_least_one_edition_for_book DEFERRED;

INSERT INTO books (name, current_edition_id)
VALUES ('Fellowship of the ring', 0) RETURNING *;


INSERT INTO editions (book_id)
VALUES (5) RETURNING *;

UPDATE books
SET current_edition_id = 2
WHERE id = 5;

COMMIT;
ROLLBACK;

BEGIN;
SET CONSTRAINTS at_least_one_edition_for_book DEFERRED;

WITH b1 AS (
    INSERT INTO books(NAME, current_edition_id)
        VALUES ('Kane & Abel', 0) RETURNING *
),
    e1 AS (
        INSERT INTO editions(book_id)
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


CREATE TABLE shelves (
    id SERIAL PRIMARY KEY,
    name CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);


CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);

ALTER TABLE users
    ADD CONSTRAINT unique_users_email EXCLUDE (lower(email) WITH =);


CREATE TABLE editions_shelves (
    id SERIAL PRIMARY KEY,
    edition_id INTEGER NOT NULL REFERENCES editions(id),
    shelf_id INTEGER NOT NULL REFERENCES shelves(id)
);

ALTER TABLE editions_shelves
    ADD CONSTRAINT one_edition_per_shelf UNIQUE (edition_id, shelf_id);

CREATE TABLE shelves_users (
    id SERIAL PRIMARY KEY,
    shelf_id INTEGER NOT NULL REFERENCES shelves(id),
    user_id INTEGER NOT NULL REFERENCES users(id)
);

ALTER TABLE shelves_users
    ADD CONSTRAINT
        unique_shelf_per_user EXCLUDE (user_id WITH =, shelf_id WITH =);

TRUNCATE TABLE shelves RESTART IDENTITY CASCADE;

ALTER TABLE shelves
    ADD COLUMN first_user_id INTEGER NOT NULL;

ALTER TABLE shelves
    ADD CONSTRAINT user_must_for_shelf
        FOREIGN KEY (first_user_id) REFERENCES shelves_users(id)
            DEFERRABLE INITIALLY DEFERRED;


BEGIN;

-- INSERT INTO users(email)
-- VALUES ('b@example.com') RETURNING *;

INSERT INTO shelves (name, first_user_id)
VALUES ('first', 0) RETURNING *;

INSERT INTO shelves_users (user_id, shelf_id)
VALUES (2, 4) RETURNING *;

UPDATE shelves
SET first_user_id = 2
WHERE id = 4;

COMMIT;
ROLLBACK;
