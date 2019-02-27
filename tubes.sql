--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
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
-- Name: is_query_valid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_query_valid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	begin
		if exists (select * from employees 
		where daterange(new.start_date, new.end_date) && daterange(employees.start_date, employees.end_date)) then
			raise 'Overlapping valid dates';
		else
			return new;
		end if;
	end;
$$;


ALTER FUNCTION public.is_query_valid() OWNER TO postgres;

--
-- Name: is_query_valid_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_query_valid_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	begin
		with tmp as (select * from employees where 
		daterange(new.start_date, new.end_date) && daterange(employees.start_date, employees.end_date)),
		exc as (select * from (select * from employees except select * from tmp) as zxc)
		insert into exc values (new.name, new.salary, new.start_date, new.end_date);
		return exc;
	end;
$$;


ALTER FUNCTION public.is_query_valid_update() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    name text NOT NULL,
    salary numeric(20,2),
    start_date date,
    end_date date
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (name, salary, start_date, end_date) FROM stdin;
Fadhriga Bestari	1000000.00	2019-02-26	2019-12-12
\.


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (name);


--
-- Name: employees is_query_valid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER is_query_valid BEFORE INSERT ON public.employees FOR EACH ROW EXECUTE PROCEDURE public.is_query_valid();


--
-- Name: employees is_query_valid_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER is_query_valid_update BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE PROCEDURE public.is_query_valid_update();


--
-- PostgreSQL database dump complete
--

