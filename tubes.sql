--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.2

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
-- Name: is_date_valid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_date_valid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 begin
  if(new.start_date > new.end_date) then
   raise 'Require: start_date > end_date';
  else
   return new;
  end if;
 end;
$$;


ALTER FUNCTION public.is_date_valid() OWNER TO postgres;

--
-- Name: is_query_valid_employees(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_query_valid_employees() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	begin
		if exists (select * from employees 
		where new.id_employee = employees.id_employee and
		daterange(new.start_date, new.end_date) && daterange(employees.start_date, employees.end_date)) then
			raise 'Overlapping valid dates';
		else
			return new;
		end if;
	end;
$$;


ALTER FUNCTION public.is_query_valid_employees() OWNER TO postgres;

--
-- Name: is_query_valid_employees_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_query_valid_employees_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	begin
		if exists (select * from employees 
		where new.id_employee = employees.id_employee and 
		daterange(new.start_date, new.end_date) && daterange(employees.start_date, employees.end_date) and
		employees <> old) then
			raise 'Overlapping valid dates';
		else
			return new;
		end if;
	end;
$$;


ALTER FUNCTION public.is_query_valid_employees_update() OWNER TO postgres;

--
-- Name: is_work_valid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_work_valid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 begin
  if(new.work_start > new.work_end) then
   raise 'Require: work_start > work_end';
  else
   return new;
  end if;
 end;
$$;


ALTER FUNCTION public.is_work_valid() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id_department integer NOT NULL,
    name text,
    salary text,
    work_start time without time zone,
    work_end time without time zone
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    id_employee integer NOT NULL,
    id_department integer NOT NULL,
    start_date date NOT NULL,
    end_date date
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees_data (
    id_employee integer NOT NULL,
    name text,
    birth_date date
);


ALTER TABLE public.employees_data OWNER TO postgres;

--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id_department, name, salary, work_start, work_end) FROM stdin;
1	a	1000000	07:00:00	19:00:00
2	s	2000000	08:00:00	17:00:00
3	d	3000000	09:00:00	15:00:00
4	f	4000000	10:00:00	14:00:00
5	Medical	2500000	07:30:00	16:30:30
6	Education	1500000	06:30:00	17:00:00
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (id_employee, id_department, start_date, end_date) FROM stdin;
1	1	2000-01-01	2002-03-04
1	2	2004-04-01	2005-02-23
1	3	2007-07-15	2009-11-25
1	4	2010-03-01	\N
2	4	2011-04-05	2014-12-12
3	3	2017-09-21	2019-02-02
4	2	1999-01-01	\N
5	5	2000-12-01	\N
6	4	1998-12-12	2007-08-01
6	6	2007-08-02	\N
7	1	2008-08-08	2009-03-03
8	3	2001-04-07	2019-01-01
8	5	2019-01-02	\N
9	6	2001-07-03	2008-05-06
9	3	2008-05-07	2010-09-06
9	3	2018-11-15	\N
9	5	2010-09-07	2015-02-14
9	2	2015-02-15	2018-11-14
10	6	2019-01-01	\N
\.


--
-- Data for Name: employees_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees_data (id_employee, name, birth_date) FROM stdin;
1	Fadhriga Bestari	1997-11-24
2	Naufal Putra	2000-04-08
3	Shinta Ayu	1999-01-01
4	Yuly Haruka	1998-12-31
5	Azka Nabilah Mumtaz	1998-10-14
6	Dandy Arif Rahman	1998-08-01
7	Ribka Febriana Permata Gunawan	2000-02-02
8	Khresna Aditya	2003-09-13
9	Ihsan Azuharu	1998-02-27
10	Dewi Haroen	1960-03-30
\.


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id_department);


--
-- Name: employees_data employees_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_data
    ADD CONSTRAINT employees_data_pkey PRIMARY KEY (id_employee);


--
-- Name: employees is_date_valid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER is_date_valid BEFORE INSERT OR UPDATE ON public.employees FOR EACH ROW EXECUTE PROCEDURE public.is_date_valid();


--
-- Name: employees is_query_valid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER is_query_valid BEFORE INSERT ON public.employees FOR EACH ROW EXECUTE PROCEDURE public.is_query_valid_employees();


--
-- Name: employees is_query_valid_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER is_query_valid_update BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE PROCEDURE public.is_query_valid_employees_update();


--
-- Name: departments is_work_valid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER is_work_valid BEFORE INSERT OR UPDATE ON public.departments FOR EACH ROW EXECUTE PROCEDURE public.is_work_valid();


--
-- Name: employees employees_id_department_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_id_department_fkey FOREIGN KEY (id_department) REFERENCES public.departments(id_department);


--
-- Name: employees employees_id_employee_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_id_employee_fkey FOREIGN KEY (id_employee) REFERENCES public.employees_data(id_employee);


--
-- PostgreSQL database dump complete
--

