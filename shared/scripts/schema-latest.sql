--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.17
-- Dumped by pg_dump version 10.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: appointment_type; Type: TYPE; Schema: public; Owner: pgw
--

CREATE TYPE public.appointment_type AS ENUM (
    'email',
    'phone',
    'text',
    'other',
    'in_person',
    'note'
);


ALTER TYPE public.appointment_type OWNER TO pgw;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: pgw
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO pgw;

--
-- Name: books; Type: TABLE; Schema: public; Owner: pgw
--

CREATE TABLE public.books (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT name_must_be_at_least_3 CHECK ((length((name)::text) >= 3))
);


ALTER TABLE public.books OWNER TO pgw;

--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: pgw
--

CREATE SEQUENCE public.books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.books_id_seq OWNER TO pgw;

--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgw
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: editions; Type: TABLE; Schema: public; Owner: pgw
--

CREATE TABLE public.editions (
    id integer NOT NULL,
    book_id bigint,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.editions OWNER TO pgw;

--
-- Name: editions_id_seq; Type: SEQUENCE; Schema: public; Owner: pgw
--

CREATE SEQUENCE public.editions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.editions_id_seq OWNER TO pgw;

--
-- Name: editions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgw
--

ALTER SEQUENCE public.editions_id_seq OWNED BY public.editions.id;


--
-- Name: editions_shelves; Type: TABLE; Schema: public; Owner: pgw
--

CREATE TABLE public.editions_shelves (
    id integer NOT NULL,
    edition_id integer NOT NULL,
    shelf_id integer NOT NULL,
    "position" integer NOT NULL,
    CONSTRAINT editions_shelves_position_check CHECK (("position" > 0))
);


ALTER TABLE public.editions_shelves OWNER TO pgw;

--
-- Name: editions_shelves_id_seq; Type: SEQUENCE; Schema: public; Owner: pgw
--

CREATE SEQUENCE public.editions_shelves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.editions_shelves_id_seq OWNER TO pgw;

--
-- Name: editions_shelves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgw
--

ALTER SEQUENCE public.editions_shelves_id_seq OWNED BY public.editions_shelves.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: pgw
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    name character varying,
    manager_id integer,
    ceo boolean DEFAULT false,
    CONSTRAINT manager_required CHECK ((ceo OR (manager_id IS NOT NULL)))
);


ALTER TABLE public.employees OWNER TO pgw;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: pgw
--

CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_id_seq OWNER TO pgw;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgw
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: pgw
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO pgw;

--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: editions id; Type: DEFAULT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.editions ALTER COLUMN id SET DEFAULT nextval('public.editions_id_seq'::regclass);


--
-- Name: editions_shelves id; Type: DEFAULT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.editions_shelves ALTER COLUMN id SET DEFAULT nextval('public.editions_shelves_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: editions_shelves books_are_ordered_in_a_shelf; Type: CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.editions_shelves
    ADD CONSTRAINT books_are_ordered_in_a_shelf UNIQUE (shelf_id, "position");


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: editions editions_pkey; Type: CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.editions
    ADD CONSTRAINT editions_pkey PRIMARY KEY (id);


--
-- Name: editions_shelves editions_shelves_pkey; Type: CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.editions_shelves
    ADD CONSTRAINT editions_shelves_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: books name_must_be_unique; Type: CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT name_must_be_unique UNIQUE (name);


--
-- Name: editions_shelves one_book_once_in_a_shelf; Type: CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.editions_shelves
    ADD CONSTRAINT one_book_once_in_a_shelf UNIQUE (shelf_id, edition_id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: editions editions_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.editions
    ADD CONSTRAINT editions_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: employees employees_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pgw
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

