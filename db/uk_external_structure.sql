--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: mchar; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE mchar;


--
-- Name: mchar_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_in(cstring) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_in';


--
-- Name: mchar_out(mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_out(mchar) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_out';


--
-- Name: mchar_recv(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_recv(internal) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_recv';


--
-- Name: mchar_send(mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_send(mchar) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_send';


--
-- Name: mchartypmod_in(cstring[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchartypmod_in(cstring[]) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchartypmod_in';


--
-- Name: mchartypmod_out(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchartypmod_out(integer) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchartypmod_out';


--
-- Name: mchar; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE mchar (
    INTERNALLENGTH = variable,
    INPUT = mchar_in,
    OUTPUT = mchar_out,
    RECEIVE = mchar_recv,
    SEND = mchar_send,
    TYPMOD_IN = mchartypmod_in,
    TYPMOD_OUT = mchartypmod_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


--
-- Name: mvarchar; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE mvarchar;


--
-- Name: mvarchar_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_in(cstring) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_in';


--
-- Name: mvarchar_out(mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_out(mvarchar) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_out';


--
-- Name: mvarchar_recv(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_recv(internal) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_recv';


--
-- Name: mvarchar_send(mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_send(mvarchar) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_send';


--
-- Name: mvarchar; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE mvarchar (
    INTERNALLENGTH = variable,
    INPUT = mvarchar_in,
    OUTPUT = mvarchar_out,
    RECEIVE = mvarchar_recv,
    SEND = mvarchar_send,
    TYPMOD_IN = mchartypmod_in,
    TYPMOD_OUT = mchartypmod_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


--
-- Name: binrowver(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION binrowver(p1 integer) RETURNS bytea
    LANGUAGE plpgsql
    AS $$
 DECLARE
 bytearea BYTEA;
 BEGIN
 bytearea := SET_BYTE('\\000\\000\\000\\000\\000\\000\\000\\000'::bytea, 4, MOD(P1 / 16777216, 256));
 bytearea := SET_BYTE(bytearea, 5, MOD(P1 / 65536, 256));
 bytearea := SET_BYTE(bytearea, 6, MOD(P1 / 256, 256));
 bytearea := SET_BYTE(bytearea, 7, MOD(P1, 256));
 RETURN bytearea;
 END;$$;


--
-- Name: btrim(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION btrim(bdata bytea, blen integer) RETURNS bytea
    LANGUAGE plpgsql
    AS $$
   DECLARE
       ln int;
       res bytea;
   BEGIN
       ln := length(bdata);
       if ln < blen then
          res := bdata;
          for i in ln .. blen - 1
          loop
               res := res || '\\000';
          end loop;
          return res;
       elsif ln > blen then
          return substring(bdata from 1 for blen);
       else
          return bdata;
       end if;
  END;$$;


--
-- Name: datediff(character varying, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION datediff(character varying, timestamp without time zone, timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
    DECLARE
     arg_mode alias for $1;
     arg_d2 alias for $2;
     arg_d1 alias for $3;
    BEGIN
    if arg_mode = 'SECOND' then
     return date_part('epoch',arg_d1) - date_part('epoch',arg_d2) ;
    elsif arg_mode = 'MINUTE' then
     return floor((date_part('epoch',arg_d1) - date_part('epoch',arg_d2)) / 60);
    elsif arg_mode = 'HOUR' then
     return floor((date_part('epoch',arg_d1) - date_part('epoch',arg_d2)) /3600);
    elsif arg_mode = 'DAY' then
     return cast(arg_d1 as date) - cast(arg_d2 as date);
    elsif arg_mode = 'WEEK' then
            return floor( ( cast(arg_d1 as date) - cast(arg_d2 as date) ) / 7.0);
    elsif arg_mode = 'MONTH' then
     return 12 * (date_part('year',arg_d1) - date_part('year',arg_d2))
          + date_part('month',arg_d1) - date_part('month',arg_d2);
    elsif arg_mode = 'QUARTER' then
     return 4 * (date_part('year',arg_d1) - date_part('year',arg_d2))
          + date_part('quarter',arg_d1) - date_part('quarter',arg_d2);
    elsif arg_mode = 'YEAR' then
     return (date_part('year',arg_d1) - date_part('year',arg_d2));
   end if;
    END
    $_$;


--
-- Name: fasttruncate(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fasttruncate(text) RETURNS void
    LANGUAGE c STRICT
    AS '$libdir/fasttrun', 'fasttruncate';


--
-- Name: fullhash_abstime(abstime); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_abstime(abstime) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_abstime';


--
-- Name: fullhash_bool(boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_bool(boolean) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_bool';


--
-- Name: fullhash_bytea(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_bytea(bytea) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_bytea';


--
-- Name: fullhash_char(character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_char(character) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_char';


--
-- Name: fullhash_cid(cid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_cid(cid) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_cid';


--
-- Name: fullhash_cidr(cidr); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_cidr(cidr) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_cidr';


--
-- Name: fullhash_date(date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_date(date) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_date';


--
-- Name: fullhash_float4(real); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_float4(real) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_float4';


--
-- Name: fullhash_float8(double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_float8(double precision) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_float8';


--
-- Name: fullhash_inet(inet); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_inet(inet) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_inet';


--
-- Name: fullhash_int2(smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_int2(smallint) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_int2';


--
-- Name: fullhash_int2vector(int2vector); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_int2vector(int2vector) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_int2vector';


--
-- Name: fullhash_int4(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_int4(integer) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_int4';


--
-- Name: fullhash_int8(bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_int8(bigint) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_int8';


--
-- Name: fullhash_interval(interval); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_interval(interval) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_interval';


--
-- Name: fullhash_macaddr(macaddr); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_macaddr(macaddr) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_macaddr';


--
-- Name: fullhash_mchar(mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_mchar(mchar) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'fullhash_mchar';


--
-- Name: fullhash_mvarchar(mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_mvarchar(mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'fullhash_mvarchar';


--
-- Name: fullhash_name(name); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_name(name) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_name';


--
-- Name: fullhash_oid(oid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_oid(oid) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_oid';


--
-- Name: fullhash_oidvector(oidvector); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_oidvector(oidvector) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_oidvector';


--
-- Name: fullhash_reltime(reltime); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_reltime(reltime) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_reltime';


--
-- Name: fullhash_text(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_text(text) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_text';


--
-- Name: fullhash_time(time without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_time(time without time zone) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_time';


--
-- Name: fullhash_timestamp(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_timestamp(timestamp without time zone) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_timestamp';


--
-- Name: fullhash_timestamptz(timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_timestamptz(timestamp with time zone) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_timestamptz';


--
-- Name: fullhash_timetz(time with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_timetz(time with time zone) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_timetz';


--
-- Name: fullhash_varchar(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_varchar(character varying) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_varchar';


--
-- Name: fullhash_xid(xid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fullhash_xid(xid) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_xid';


--
-- Name: isfulleq_abstime(abstime, abstime); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_abstime(abstime, abstime) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_abstime';


--
-- Name: isfulleq_bool(boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_bool(boolean, boolean) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_bool';


--
-- Name: isfulleq_bytea(bytea, bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_bytea(bytea, bytea) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_bytea';


--
-- Name: isfulleq_char(character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_char(character, character) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_char';


--
-- Name: isfulleq_cid(cid, cid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_cid(cid, cid) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_cid';


--
-- Name: isfulleq_cidr(cidr, cidr); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_cidr(cidr, cidr) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_cidr';


--
-- Name: isfulleq_date(date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_date(date, date) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_date';


--
-- Name: isfulleq_float4(real, real); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_float4(real, real) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_float4';


--
-- Name: isfulleq_float8(double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_float8(double precision, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_float8';


--
-- Name: isfulleq_inet(inet, inet); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_inet(inet, inet) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_inet';


--
-- Name: isfulleq_int2(smallint, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_int2(smallint, smallint) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_int2';


--
-- Name: isfulleq_int2vector(int2vector, int2vector); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_int2vector(int2vector, int2vector) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_int2vector';


--
-- Name: isfulleq_int4(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_int4(integer, integer) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_int4';


--
-- Name: isfulleq_int8(bigint, bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_int8(bigint, bigint) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_int8';


--
-- Name: isfulleq_interval(interval, interval); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_interval(interval, interval) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_interval';


--
-- Name: isfulleq_macaddr(macaddr, macaddr); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_macaddr(macaddr, macaddr) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_macaddr';


--
-- Name: isfulleq_mchar(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_mchar(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'isfulleq_mchar';


--
-- Name: isfulleq_mvarchar(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_mvarchar(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'isfulleq_mvarchar';


--
-- Name: isfulleq_name(name, name); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_name(name, name) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_name';


--
-- Name: isfulleq_oid(oid, oid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_oid(oid, oid) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_oid';


--
-- Name: isfulleq_oidvector(oidvector, oidvector); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_oidvector(oidvector, oidvector) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_oidvector';


--
-- Name: isfulleq_reltime(reltime, reltime); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_reltime(reltime, reltime) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_reltime';


--
-- Name: isfulleq_text(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_text(text, text) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_text';


--
-- Name: isfulleq_time(time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_time(time without time zone, time without time zone) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_time';


--
-- Name: isfulleq_timestamp(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_timestamp(timestamp without time zone, timestamp without time zone) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_timestamp';


--
-- Name: isfulleq_timestamptz(timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_timestamptz(timestamp with time zone, timestamp with time zone) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_timestamptz';


--
-- Name: isfulleq_timetz(time with time zone, time with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_timetz(time with time zone, time with time zone) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_timetz';


--
-- Name: isfulleq_varchar(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_varchar(character varying, character varying) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_varchar';


--
-- Name: isfulleq_xid(xid, xid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION isfulleq_xid(xid, xid) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_xid';


--
-- Name: length(mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION length(mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_length';


--
-- Name: length(mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION length(mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_length';


--
-- Name: like_escape(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION like_escape(mvarchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_like_escape';


--
-- Name: lower(mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lower(mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_lower';


--
-- Name: lower(mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lower(mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_lower';


--
-- Name: mc_mv_case_cmp(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_case_cmp(mchar, mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_cmp';


--
-- Name: mc_mv_case_eq(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_case_eq(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_eq';


--
-- Name: mc_mv_case_ge(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_case_ge(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_ge';


--
-- Name: mc_mv_case_gt(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_case_gt(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_gt';


--
-- Name: mc_mv_case_le(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_case_le(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_le';


--
-- Name: mc_mv_case_lt(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_case_lt(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_lt';


--
-- Name: mc_mv_case_ne(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_case_ne(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_ne';


--
-- Name: mc_mv_icase_cmp(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_icase_cmp(mchar, mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_cmp';


--
-- Name: mc_mv_icase_eq(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_icase_eq(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_eq';


--
-- Name: mc_mv_icase_ge(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_icase_ge(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_ge';


--
-- Name: mc_mv_icase_gt(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_icase_gt(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_gt';


--
-- Name: mc_mv_icase_le(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_icase_le(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_le';


--
-- Name: mc_mv_icase_lt(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_icase_lt(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_lt';


--
-- Name: mc_mv_icase_ne(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mc_mv_icase_ne(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_ne';


--
-- Name: mchar(mchar, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar(mchar, integer, boolean) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar';


--
-- Name: mchar_case_cmp(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_case_cmp(mchar, mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_cmp';


--
-- Name: mchar_case_eq(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_case_eq(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_eq';


--
-- Name: mchar_case_ge(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_case_ge(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_ge';


--
-- Name: mchar_case_gt(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_case_gt(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_gt';


--
-- Name: mchar_case_le(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_case_le(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_le';


--
-- Name: mchar_case_lt(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_case_lt(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_lt';


--
-- Name: mchar_case_ne(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_case_ne(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_ne';


--
-- Name: mchar_concat(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_concat(mchar, mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_concat';


--
-- Name: mchar_greaterstring(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_greaterstring(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_greaterstring';


--
-- Name: mchar_hash(mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_hash(mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_hash';


--
-- Name: mchar_icase_cmp(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_icase_cmp(mchar, mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_cmp';


--
-- Name: mchar_icase_eq(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_icase_eq(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_eq';


--
-- Name: mchar_icase_ge(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_icase_ge(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_ge';


--
-- Name: mchar_icase_gt(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_icase_gt(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_gt';


--
-- Name: mchar_icase_le(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_icase_le(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_le';


--
-- Name: mchar_icase_lt(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_icase_lt(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_lt';


--
-- Name: mchar_icase_ne(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_icase_ne(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_ne';


--
-- Name: mchar_larger(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_larger(mchar, mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_larger';


--
-- Name: mchar_like(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_like(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_like';


--
-- Name: mchar_mvarchar(mchar, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_mvarchar(mchar, integer, boolean) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_mvarchar';


--
-- Name: mchar_mvarchar_concat(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_mvarchar_concat(mchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_mvarchar_concat';


--
-- Name: mchar_notlike(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_notlike(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_notlike';


--
-- Name: mchar_pattern_fixed_prefix(internal, internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_pattern_fixed_prefix(internal, internal, internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_pattern_fixed_prefix';


--
-- Name: mchar_regexeq(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_regexeq(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_regexeq';


--
-- Name: mchar_regexne(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_regexne(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_regexne';


--
-- Name: mchar_smaller(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mchar_smaller(mchar, mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_smaller';


--
-- Name: mv_mc_case_cmp(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_case_cmp(mvarchar, mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_cmp';


--
-- Name: mv_mc_case_eq(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_case_eq(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_eq';


--
-- Name: mv_mc_case_ge(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_case_ge(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_ge';


--
-- Name: mv_mc_case_gt(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_case_gt(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_gt';


--
-- Name: mv_mc_case_le(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_case_le(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_le';


--
-- Name: mv_mc_case_lt(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_case_lt(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_lt';


--
-- Name: mv_mc_case_ne(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_case_ne(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_ne';


--
-- Name: mv_mc_icase_cmp(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_icase_cmp(mvarchar, mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_cmp';


--
-- Name: mv_mc_icase_eq(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_icase_eq(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_eq';


--
-- Name: mv_mc_icase_ge(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_icase_ge(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_ge';


--
-- Name: mv_mc_icase_gt(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_icase_gt(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_gt';


--
-- Name: mv_mc_icase_le(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_icase_le(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_le';


--
-- Name: mv_mc_icase_lt(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_icase_lt(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_lt';


--
-- Name: mv_mc_icase_ne(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mv_mc_icase_ne(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_ne';


--
-- Name: mvarchar(mvarchar, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar(mvarchar, integer, boolean) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar';


--
-- Name: mvarchar_case_cmp(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_case_cmp(mvarchar, mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_cmp';


--
-- Name: mvarchar_case_eq(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_case_eq(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_eq';


--
-- Name: mvarchar_case_ge(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_case_ge(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_ge';


--
-- Name: mvarchar_case_gt(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_case_gt(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_gt';


--
-- Name: mvarchar_case_le(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_case_le(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_le';


--
-- Name: mvarchar_case_lt(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_case_lt(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_lt';


--
-- Name: mvarchar_case_ne(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_case_ne(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_ne';


--
-- Name: mvarchar_concat(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_concat(mvarchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_concat';


--
-- Name: mvarchar_hash(mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_hash(mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_hash';


--
-- Name: mvarchar_icase_cmp(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_icase_cmp(mvarchar, mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_cmp';


--
-- Name: mvarchar_icase_eq(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_icase_eq(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_eq';


--
-- Name: mvarchar_icase_ge(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_icase_ge(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_ge';


--
-- Name: mvarchar_icase_gt(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_icase_gt(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_gt';


--
-- Name: mvarchar_icase_le(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_icase_le(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_le';


--
-- Name: mvarchar_icase_lt(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_icase_lt(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_lt';


--
-- Name: mvarchar_icase_ne(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_icase_ne(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_ne';


--
-- Name: mvarchar_larger(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_larger(mvarchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_larger';


--
-- Name: mvarchar_like(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_like(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_like';


--
-- Name: mvarchar_mchar(mvarchar, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_mchar(mvarchar, integer, boolean) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_mchar';


--
-- Name: mvarchar_mchar_concat(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_mchar_concat(mvarchar, mchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_mchar_concat';


--
-- Name: mvarchar_notlike(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_notlike(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_notlike';


--
-- Name: mvarchar_regexeq(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_regexeq(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_regexeq';


--
-- Name: mvarchar_regexne(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_regexne(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_regexne';


--
-- Name: mvarchar_smaller(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mvarchar_smaller(mvarchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_smaller';


--
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler
    LANGUAGE c
    AS '$libdir/plpgsql', 'plpgsql_call_handler';


--
-- Name: similar_escape(mchar, mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION similar_escape(mchar, mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'mchar_similar_escape';


--
-- Name: similar_escape(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION similar_escape(mvarchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'mvarchar_similar_escape';


--
-- Name: state_max_bool(boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION state_max_bool(st boolean, inp boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    BEGIN
         if st is null or not st
         then
            return inp;
         else
            return true;
         end if;
    END;$$;


--
-- Name: state_max_bytea(bytea, bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION state_max_bytea(st bytea, inp bytea) RETURNS bytea
    LANGUAGE plpgsql
    AS $$
    BEGIN
         if st is null
         then
            return inp;
         elseif st<inp then
            return inp;
         else
            return st;
         end if;
    END;$$;


--
-- Name: state_min_bool(boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION state_min_bool(st boolean, inp boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    BEGIN
         if st is null or st
             then
            return inp;
         else
            return false;
            end if;
    END;$$;


--
-- Name: state_min_bytea(bytea, bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION state_min_bytea(st bytea, inp bytea) RETURNS bytea
    LANGUAGE plpgsql
    AS $$
    BEGIN
         if st is null
         then
            return inp;
         elseif st>inp then
            return inp;
         else
            return st;
         end if;
    END;$$;


--
-- Name: substr(mchar, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION substr(mchar, integer) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_substring_no_len';


--
-- Name: substr(mvarchar, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION substr(mvarchar, integer) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_substring_no_len';


--
-- Name: substr(mchar, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION substr(mchar, integer, integer) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_substring';


--
-- Name: substr(mvarchar, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION substr(mvarchar, integer, integer) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_substring';


--
-- Name: upper(mchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION upper(mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_upper';


--
-- Name: upper(mvarchar); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION upper(mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_upper';


--
-- Name: vassn(boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION vassn(boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE bexpr alias for $1;
BEGIN
if bexpr
then return 0;
else return 2000000000;
end if;
END
$_$;


--
-- Name: max(boolean); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE max(boolean) (
    SFUNC = state_max_bool,
    STYPE = boolean
);


--
-- Name: max(bytea); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE max(bytea) (
    SFUNC = state_max_bytea,
    STYPE = bytea
);


--
-- Name: >; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR > (
    PROCEDURE = mchar_icase_gt,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: max(mchar); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE max(mchar) (
    SFUNC = mchar_larger,
    STYPE = mchar,
    SORTOP = >
);


--
-- Name: >; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR > (
    PROCEDURE = mvarchar_icase_gt,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: max(mvarchar); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE max(mvarchar) (
    SFUNC = mvarchar_larger,
    STYPE = mvarchar,
    SORTOP = >
);


--
-- Name: min(boolean); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE min(boolean) (
    SFUNC = state_min_bool,
    STYPE = boolean
);


--
-- Name: min(bytea); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE min(bytea) (
    SFUNC = state_min_bytea,
    STYPE = bytea
);


--
-- Name: <; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR < (
    PROCEDURE = mchar_icase_lt,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: min(mchar); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE min(mchar) (
    SFUNC = mchar_smaller,
    STYPE = mchar,
    SORTOP = <
);


--
-- Name: <; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR < (
    PROCEDURE = mvarchar_icase_lt,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: min(mvarchar); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE min(mvarchar) (
    SFUNC = mvarchar_smaller,
    STYPE = mvarchar,
    SORTOP = <
);


--
-- Name: !~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR !~ (
    PROCEDURE = mchar_regexne,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    NEGATOR = ~,
    RESTRICT = regexnesel,
    JOIN = regexnejoinsel
);


--
-- Name: !~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR !~ (
    PROCEDURE = mvarchar_regexne,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    NEGATOR = ~,
    RESTRICT = regexnesel,
    JOIN = regexnejoinsel
);


--
-- Name: !~~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR !~~ (
    PROCEDURE = mchar_notlike,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    NEGATOR = ~~,
    RESTRICT = nlikesel,
    JOIN = nlikejoinsel
);


--
-- Name: !~~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR !~~ (
    PROCEDURE = mvarchar_notlike,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    NEGATOR = ~~,
    RESTRICT = nlikesel,
    JOIN = nlikejoinsel
);


--
-- Name: &<; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &< (
    PROCEDURE = mchar_case_lt,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &>,
    NEGATOR = &>=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: &<; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &< (
    PROCEDURE = mvarchar_case_lt,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &>,
    NEGATOR = &>=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: &<; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &< (
    PROCEDURE = mc_mv_case_lt,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &>,
    NEGATOR = &>=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: &<; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &< (
    PROCEDURE = mv_mc_case_lt,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &>,
    NEGATOR = &>=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: &<=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &<= (
    PROCEDURE = mchar_case_le,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &>=,
    NEGATOR = &>,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: &<=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &<= (
    PROCEDURE = mvarchar_case_le,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &>=,
    NEGATOR = &>,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: &<=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &<= (
    PROCEDURE = mc_mv_case_le,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &>=,
    NEGATOR = &>,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: &<=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &<= (
    PROCEDURE = mv_mc_case_le,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &>=,
    NEGATOR = &>,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: &<>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &<> (
    PROCEDURE = mchar_case_ne,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<>,
    NEGATOR = &=,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


--
-- Name: &<>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &<> (
    PROCEDURE = mvarchar_case_ne,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<>,
    NEGATOR = &=,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


--
-- Name: &<>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &<> (
    PROCEDURE = mv_mc_case_ne,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<>,
    NEGATOR = &=,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


--
-- Name: &<>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &<> (
    PROCEDURE = mc_mv_case_ne,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<>,
    NEGATOR = &=,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


--
-- Name: &=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &= (
    PROCEDURE = mchar_case_eq,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &=,
    NEGATOR = &<>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: &=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &= (
    PROCEDURE = mvarchar_case_eq,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &=,
    NEGATOR = &<>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: &=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &= (
    PROCEDURE = mc_mv_case_eq,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &=,
    NEGATOR = &<>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: &=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &= (
    PROCEDURE = mv_mc_case_eq,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &=,
    NEGATOR = &<>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: &>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &> (
    PROCEDURE = mchar_case_gt,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<,
    NEGATOR = &<=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: &>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &> (
    PROCEDURE = mvarchar_case_gt,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<,
    NEGATOR = &<=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: &>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &> (
    PROCEDURE = mv_mc_case_gt,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<,
    NEGATOR = &<=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: &>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &> (
    PROCEDURE = mc_mv_case_gt,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<,
    NEGATOR = &<=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: &>=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &>= (
    PROCEDURE = mchar_case_ge,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<=,
    NEGATOR = &<,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: &>=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &>= (
    PROCEDURE = mvarchar_case_ge,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<=,
    NEGATOR = &<,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: &>=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &>= (
    PROCEDURE = mc_mv_case_ge,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<=,
    NEGATOR = &<,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: &>=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &>= (
    PROCEDURE = mv_mc_case_ge,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<=,
    NEGATOR = &<,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: <; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR < (
    PROCEDURE = mc_mv_icase_lt,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: <; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR < (
    PROCEDURE = mv_mc_icase_lt,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <= (
    PROCEDURE = mchar_icase_le,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <= (
    PROCEDURE = mvarchar_icase_le,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <= (
    PROCEDURE = mc_mv_icase_le,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <= (
    PROCEDURE = mv_mc_icase_le,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <> (
    PROCEDURE = mchar_icase_ne,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <> (
    PROCEDURE = mvarchar_icase_ne,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <> (
    PROCEDURE = mv_mc_icase_ne,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <> (
    PROCEDURE = mc_mv_icase_ne,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


--
-- Name: =; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR = (
    PROCEDURE = mchar_icase_eq,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: =; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR = (
    PROCEDURE = mvarchar_icase_eq,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: =; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR = (
    PROCEDURE = mc_mv_icase_eq,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: =; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR = (
    PROCEDURE = mv_mc_icase_eq,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_bool,
    LEFTARG = boolean,
    RIGHTARG = boolean,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_bytea,
    LEFTARG = bytea,
    RIGHTARG = bytea,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_char,
    LEFTARG = character,
    RIGHTARG = character,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_name,
    LEFTARG = name,
    RIGHTARG = name,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_int8,
    LEFTARG = bigint,
    RIGHTARG = bigint,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_int2,
    LEFTARG = smallint,
    RIGHTARG = smallint,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_int2vector,
    LEFTARG = int2vector,
    RIGHTARG = int2vector,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_int4,
    LEFTARG = integer,
    RIGHTARG = integer,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_text,
    LEFTARG = text,
    RIGHTARG = text,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_oid,
    LEFTARG = oid,
    RIGHTARG = oid,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_xid,
    LEFTARG = xid,
    RIGHTARG = xid,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_cid,
    LEFTARG = cid,
    RIGHTARG = cid,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_oidvector,
    LEFTARG = oidvector,
    RIGHTARG = oidvector,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_float4,
    LEFTARG = real,
    RIGHTARG = real,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_float8,
    LEFTARG = double precision,
    RIGHTARG = double precision,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_abstime,
    LEFTARG = abstime,
    RIGHTARG = abstime,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_reltime,
    LEFTARG = reltime,
    RIGHTARG = reltime,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_macaddr,
    LEFTARG = macaddr,
    RIGHTARG = macaddr,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_inet,
    LEFTARG = inet,
    RIGHTARG = inet,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_cidr,
    LEFTARG = cidr,
    RIGHTARG = cidr,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_varchar,
    LEFTARG = character varying,
    RIGHTARG = character varying,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_date,
    LEFTARG = date,
    RIGHTARG = date,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_time,
    LEFTARG = time without time zone,
    RIGHTARG = time without time zone,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_timestamp,
    LEFTARG = timestamp without time zone,
    RIGHTARG = timestamp without time zone,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_timestamptz,
    LEFTARG = timestamp with time zone,
    RIGHTARG = timestamp with time zone,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_interval,
    LEFTARG = interval,
    RIGHTARG = interval,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_timetz,
    LEFTARG = time with time zone,
    RIGHTARG = time with time zone,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_mchar,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_mvarchar,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


--
-- Name: >; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR > (
    PROCEDURE = mv_mc_icase_gt,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: >; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR > (
    PROCEDURE = mc_mv_icase_gt,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR >= (
    PROCEDURE = mchar_icase_ge,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR >= (
    PROCEDURE = mvarchar_icase_ge,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR >= (
    PROCEDURE = mc_mv_icase_ge,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR >= (
    PROCEDURE = mv_mc_icase_ge,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = mchar_concat,
    LEFTARG = mchar,
    RIGHTARG = mchar
);


--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = mvarchar_concat,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar
);


--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = mchar_mvarchar_concat,
    LEFTARG = mchar,
    RIGHTARG = mvarchar
);


--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = mvarchar_mchar_concat,
    LEFTARG = mvarchar,
    RIGHTARG = mchar
);


--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = mchar_regexeq,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    NEGATOR = !~,
    RESTRICT = regexeqsel,
    JOIN = regexeqjoinsel
);


--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = mvarchar_regexeq,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    NEGATOR = !~,
    RESTRICT = regexeqsel,
    JOIN = regexeqjoinsel
);


--
-- Name: ~~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~~ (
    PROCEDURE = mchar_like,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    NEGATOR = !~~,
    RESTRICT = likesel,
    JOIN = likejoinsel
);


--
-- Name: ~~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~~ (
    PROCEDURE = mvarchar_like,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    NEGATOR = !~~,
    RESTRICT = likesel,
    JOIN = likejoinsel
);


--
-- Name: abstime_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS abstime_fill_ops
    FOR TYPE abstime USING hash AS
    OPERATOR 1 ==(abstime,abstime) ,
    FUNCTION 1 (abstime, abstime) fullhash_abstime(abstime);


--
-- Name: bool_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS bool_fill_ops
    FOR TYPE boolean USING hash AS
    OPERATOR 1 ==(boolean,boolean) ,
    FUNCTION 1 (boolean, boolean) fullhash_bool(boolean);


--
-- Name: bytea_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS bytea_fill_ops
    FOR TYPE bytea USING hash AS
    OPERATOR 1 ==(bytea,bytea) ,
    FUNCTION 1 (bytea, bytea) fullhash_bytea(bytea);


--
-- Name: case_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY case_ops USING btree;


--
-- Name: char_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS char_fill_ops
    FOR TYPE character USING hash AS
    OPERATOR 1 ==(character,character) ,
    FUNCTION 1 (character, character) fullhash_char(character);


--
-- Name: cid_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS cid_fill_ops
    FOR TYPE cid USING hash AS
    OPERATOR 1 ==(cid,cid) ,
    FUNCTION 1 (cid, cid) fullhash_cid(cid);


--
-- Name: cidr_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS cidr_fill_ops
    FOR TYPE cidr USING hash AS
    OPERATOR 1 ==(cidr,cidr) ,
    FUNCTION 1 (cidr, cidr) fullhash_cidr(cidr);


--
-- Name: date_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS date_fill_ops
    FOR TYPE date USING hash AS
    OPERATOR 1 ==(date,date) ,
    FUNCTION 1 (date, date) fullhash_date(date);


--
-- Name: float4_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS float4_fill_ops
    FOR TYPE real USING hash AS
    OPERATOR 1 ==(real,real) ,
    FUNCTION 1 (real, real) fullhash_float4(real);


--
-- Name: float8_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS float8_fill_ops
    FOR TYPE double precision USING hash AS
    OPERATOR 1 ==(double precision,double precision) ,
    FUNCTION 1 (double precision, double precision) fullhash_float8(double precision);


--
-- Name: icase_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY icase_ops USING btree;


--
-- Name: inet_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS inet_fill_ops
    FOR TYPE inet USING hash AS
    OPERATOR 1 ==(inet,inet) ,
    FUNCTION 1 (inet, inet) fullhash_inet(inet);


--
-- Name: int2_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS int2_fill_ops
    FOR TYPE smallint USING hash AS
    OPERATOR 1 ==(smallint,smallint) ,
    FUNCTION 1 (smallint, smallint) fullhash_int2(smallint);


--
-- Name: int2vector_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS int2vector_fill_ops
    FOR TYPE int2vector USING hash AS
    OPERATOR 1 ==(int2vector,int2vector) ,
    FUNCTION 1 (int2vector, int2vector) fullhash_int2vector(int2vector);


--
-- Name: int4_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS int4_fill_ops
    FOR TYPE integer USING hash AS
    OPERATOR 1 ==(integer,integer) ,
    FUNCTION 1 (integer, integer) fullhash_int4(integer);


--
-- Name: int8_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS int8_fill_ops
    FOR TYPE bigint USING hash AS
    OPERATOR 1 ==(bigint,bigint) ,
    FUNCTION 1 (bigint, bigint) fullhash_int8(bigint);


--
-- Name: interval_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS interval_fill_ops
    FOR TYPE interval USING hash AS
    OPERATOR 1 ==(interval,interval) ,
    FUNCTION 1 (interval, interval) fullhash_interval(interval);


--
-- Name: macaddr_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS macaddr_fill_ops
    FOR TYPE macaddr USING hash AS
    OPERATOR 1 ==(macaddr,macaddr) ,
    FUNCTION 1 (macaddr, macaddr) fullhash_macaddr(macaddr);


--
-- Name: mchar_case_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS mchar_case_ops
    FOR TYPE mchar USING btree FAMILY case_ops AS
    OPERATOR 1 &<(mchar,mvarchar) ,
    OPERATOR 1 &<(mchar,mchar) ,
    OPERATOR 2 &<=(mchar,mchar) ,
    OPERATOR 2 &<=(mchar,mvarchar) ,
    OPERATOR 3 &=(mchar,mvarchar) ,
    OPERATOR 3 &=(mchar,mchar) ,
    OPERATOR 4 &>=(mchar,mvarchar) ,
    OPERATOR 4 &>=(mchar,mchar) ,
    OPERATOR 5 &>(mchar,mchar) ,
    OPERATOR 5 &>(mchar,mvarchar) ,
    FUNCTION 1 (mchar, mvarchar) mc_mv_case_cmp(mchar,mvarchar) ,
    FUNCTION 1 (mchar, mchar) mchar_case_cmp(mchar,mchar);


--
-- Name: mchar_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS mchar_fill_ops
    FOR TYPE mchar USING hash AS
    OPERATOR 1 ==(mchar,mchar) ,
    FUNCTION 1 (mchar, mchar) fullhash_mchar(mchar);


--
-- Name: mchar_icase_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS mchar_icase_ops
    DEFAULT FOR TYPE mchar USING btree FAMILY icase_ops AS
    OPERATOR 1 <(mchar,mvarchar) ,
    OPERATOR 1 <(mchar,mchar) ,
    OPERATOR 2 <=(mchar,mchar) ,
    OPERATOR 2 <=(mchar,mvarchar) ,
    OPERATOR 3 =(mchar,mvarchar) ,
    OPERATOR 3 =(mchar,mchar) ,
    OPERATOR 4 >=(mchar,mvarchar) ,
    OPERATOR 4 >=(mchar,mchar) ,
    OPERATOR 5 >(mchar,mchar) ,
    OPERATOR 5 >(mchar,mvarchar) ,
    FUNCTION 1 (mchar, mchar) mchar_icase_cmp(mchar,mchar) ,
    FUNCTION 1 (mchar, mvarchar) mc_mv_icase_cmp(mchar,mvarchar);


--
-- Name: mchar_icase_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS mchar_icase_ops
    DEFAULT FOR TYPE mchar USING hash AS
    OPERATOR 1 =(mchar,mchar) ,
    FUNCTION 1 (mchar, mchar) mchar_hash(mchar);


--
-- Name: mvarchar_case_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS mvarchar_case_ops
    FOR TYPE mvarchar USING btree FAMILY case_ops AS
    OPERATOR 1 &<(mvarchar,mvarchar) ,
    OPERATOR 1 &<(mvarchar,mchar) ,
    OPERATOR 2 &<=(mvarchar,mchar) ,
    OPERATOR 2 &<=(mvarchar,mvarchar) ,
    OPERATOR 3 &=(mvarchar,mvarchar) ,
    OPERATOR 3 &=(mvarchar,mchar) ,
    OPERATOR 4 &>=(mvarchar,mvarchar) ,
    OPERATOR 4 &>=(mvarchar,mchar) ,
    OPERATOR 5 &>(mvarchar,mchar) ,
    OPERATOR 5 &>(mvarchar,mvarchar) ,
    FUNCTION 1 (mvarchar, mchar) mv_mc_case_cmp(mvarchar,mchar) ,
    FUNCTION 1 (mvarchar, mvarchar) mvarchar_case_cmp(mvarchar,mvarchar);


--
-- Name: mvarchar_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS mvarchar_fill_ops
    FOR TYPE mvarchar USING hash AS
    OPERATOR 1 ==(mvarchar,mvarchar) ,
    FUNCTION 1 (mvarchar, mvarchar) fullhash_mvarchar(mvarchar);


--
-- Name: mvarchar_icase_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS mvarchar_icase_ops
    DEFAULT FOR TYPE mvarchar USING btree FAMILY icase_ops AS
    OPERATOR 1 <(mvarchar,mvarchar) ,
    OPERATOR 1 <(mvarchar,mchar) ,
    OPERATOR 2 <=(mvarchar,mchar) ,
    OPERATOR 2 <=(mvarchar,mvarchar) ,
    OPERATOR 3 =(mvarchar,mvarchar) ,
    OPERATOR 3 =(mvarchar,mchar) ,
    OPERATOR 4 >=(mvarchar,mvarchar) ,
    OPERATOR 4 >=(mvarchar,mchar) ,
    OPERATOR 5 >(mvarchar,mchar) ,
    OPERATOR 5 >(mvarchar,mvarchar) ,
    FUNCTION 1 (mvarchar, mvarchar) mvarchar_icase_cmp(mvarchar,mvarchar) ,
    FUNCTION 1 (mvarchar, mchar) mv_mc_icase_cmp(mvarchar,mchar);


--
-- Name: mvarchar_icase_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS mvarchar_icase_ops
    DEFAULT FOR TYPE mvarchar USING hash AS
    OPERATOR 1 =(mvarchar,mvarchar) ,
    FUNCTION 1 (mvarchar, mvarchar) mvarchar_hash(mvarchar);


--
-- Name: name_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS name_fill_ops
    FOR TYPE name USING hash AS
    OPERATOR 1 ==(name,name) ,
    FUNCTION 1 (name, name) fullhash_name(name);


--
-- Name: oid_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS oid_fill_ops
    FOR TYPE oid USING hash AS
    OPERATOR 1 ==(oid,oid) ,
    FUNCTION 1 (oid, oid) fullhash_oid(oid);


--
-- Name: oidvector_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS oidvector_fill_ops
    FOR TYPE oidvector USING hash AS
    OPERATOR 1 ==(oidvector,oidvector) ,
    FUNCTION 1 (oidvector, oidvector) fullhash_oidvector(oidvector);


--
-- Name: reltime_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS reltime_fill_ops
    FOR TYPE reltime USING hash AS
    OPERATOR 1 ==(reltime,reltime) ,
    FUNCTION 1 (reltime, reltime) fullhash_reltime(reltime);


--
-- Name: text_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS text_fill_ops
    FOR TYPE text USING hash AS
    OPERATOR 1 ==(text,text) ,
    FUNCTION 1 (text, text) fullhash_text(text);


--
-- Name: time_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS time_fill_ops
    FOR TYPE time without time zone USING hash AS
    OPERATOR 1 ==(time without time zone,time without time zone) ,
    FUNCTION 1 (time without time zone, time without time zone) fullhash_time(time without time zone);


--
-- Name: timestamp_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS timestamp_fill_ops
    FOR TYPE timestamp without time zone USING hash AS
    OPERATOR 1 ==(timestamp without time zone,timestamp without time zone) ,
    FUNCTION 1 (timestamp without time zone, timestamp without time zone) fullhash_timestamp(timestamp without time zone);


--
-- Name: timestamptz_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS timestamptz_fill_ops
    FOR TYPE timestamp with time zone USING hash AS
    OPERATOR 1 ==(timestamp with time zone,timestamp with time zone) ,
    FUNCTION 1 (timestamp with time zone, timestamp with time zone) fullhash_timestamptz(timestamp with time zone);


--
-- Name: timetz_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS timetz_fill_ops
    FOR TYPE time with time zone USING hash AS
    OPERATOR 1 ==(time with time zone,time with time zone) ,
    FUNCTION 1 (time with time zone, time with time zone) fullhash_timetz(time with time zone);


--
-- Name: varchar_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS varchar_fill_ops
    FOR TYPE character varying USING hash AS
    OPERATOR 1 ==(character varying,character varying) ,
    FUNCTION 1 (character varying, character varying) fullhash_varchar(character varying);


--
-- Name: xid_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS xid_fill_ops
    FOR TYPE xid USING hash AS
    OPERATOR 1 ==(xid,xid) ,
    FUNCTION 1 (xid, xid) fullhash_xid(xid);


SET search_path = pg_catalog;

--
-- Name: CAST (public.mchar AS public.mchar); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.mchar AS public.mchar) WITH FUNCTION public.mchar(public.mchar, integer, boolean) AS IMPLICIT;


--
-- Name: CAST (public.mchar AS public.mvarchar); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.mchar AS public.mvarchar) WITH FUNCTION public.mchar_mvarchar(public.mchar, integer, boolean) AS IMPLICIT;


--
-- Name: CAST (public.mvarchar AS public.mchar); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.mvarchar AS public.mchar) WITH FUNCTION public.mvarchar_mchar(public.mvarchar, integer, boolean) AS IMPLICIT;


--
-- Name: CAST (public.mvarchar AS public.mvarchar); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.mvarchar AS public.mvarchar) WITH FUNCTION public.mvarchar(public.mvarchar, integer, boolean) AS IMPLICIT;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: _accumrg1513; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1513 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _recordkind numeric(1,0) NOT NULL,
    _fld1514rref bytea NOT NULL,
    _fld1515rref bytea NOT NULL,
    _fld1516_type bytea NOT NULL,
    _fld1516_rtref bytea NOT NULL,
    _fld1516_rrref bytea NOT NULL,
    _fld1517 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _accumrg1513 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1513 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1513 ALTER COLUMN _fld1514rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1513 ALTER COLUMN _fld1515rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1513 ALTER COLUMN _fld1516_type SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1513 ALTER COLUMN _fld1516_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1513 ALTER COLUMN _fld1516_rrref SET STORAGE PLAIN;


--
-- Name: _accumrg1522; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1522 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _recordkind numeric(1,0) NOT NULL,
    _fld1523rref bytea NOT NULL,
    _fld1524rref bytea NOT NULL,
    _fld1525 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _accumrg1522 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1522 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1522 ALTER COLUMN _fld1523rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1522 ALTER COLUMN _fld1524rref SET STORAGE PLAIN;


--
-- Name: _accumrg1528; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1528 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _recordkind numeric(1,0) NOT NULL,
    _fld1529rref bytea NOT NULL,
    _fld1530 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _accumrg1528 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1528 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1528 ALTER COLUMN _fld1529rref SET STORAGE PLAIN;


--
-- Name: _accumrg1533; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1533 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _recordkind numeric(1,0) NOT NULL,
    _fld1534rref bytea NOT NULL,
    _fld1535rref bytea NOT NULL,
    _fld1536rref bytea NOT NULL,
    _fld1537rref bytea NOT NULL,
    _fld1538rref bytea NOT NULL,
    _fld1539 numeric(15,2) NOT NULL,
    _fld1540 numeric(5,2) NOT NULL,
    _fld1541 numeric(5,2) NOT NULL,
    _fld1542rref bytea NOT NULL,
    _fld1543_type bytea NOT NULL,
    _fld1543_n numeric(15,2) NOT NULL,
    _fld1543_rrref bytea NOT NULL,
    _fld1544 boolean NOT NULL,
    _fld1545 mvarchar(150) NOT NULL,
    _fld1546 numeric(10,0) NOT NULL,
    _fld1547 boolean NOT NULL,
    _fld1548 numeric(10,0) NOT NULL,
    _fld1549 numeric(5,0) NOT NULL,
    _fld1550 numeric(15,3) NOT NULL,
    _fld1551 numeric(15,2) NOT NULL,
    _dimhash numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _accumrg1533 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1533 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1533 ALTER COLUMN _fld1534rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1533 ALTER COLUMN _fld1535rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1533 ALTER COLUMN _fld1536rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1533 ALTER COLUMN _fld1537rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1533 ALTER COLUMN _fld1538rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1533 ALTER COLUMN _fld1542rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1533 ALTER COLUMN _fld1543_type SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1533 ALTER COLUMN _fld1543_rrref SET STORAGE PLAIN;


--
-- Name: _accumrg1557; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1557 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _recordkind numeric(1,0) NOT NULL,
    _fld1558rref bytea NOT NULL,
    _fld1559rref bytea NOT NULL,
    _fld1560rref bytea NOT NULL,
    _fld1561rref bytea NOT NULL,
    _fld1562 numeric(15,2) NOT NULL,
    _fld1563 numeric(15,3) NOT NULL,
    _fld1564 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _accumrg1557 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1557 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1557 ALTER COLUMN _fld1558rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1557 ALTER COLUMN _fld1559rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1557 ALTER COLUMN _fld1560rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1557 ALTER COLUMN _fld1561rref SET STORAGE PLAIN;


--
-- Name: _accumrg1568; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1568 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1569rref bytea NOT NULL,
    _fld1570rref bytea NOT NULL,
    _fld1571rref bytea NOT NULL,
    _fld1572rref bytea NOT NULL,
    _fld1663rref bytea NOT NULL,
    _fld1573 numeric(15,3) NOT NULL,
    _fld1574 numeric(15,2) NOT NULL,
    _fld1575 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _accumrg1568 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1568 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1568 ALTER COLUMN _fld1569rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1568 ALTER COLUMN _fld1570rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1568 ALTER COLUMN _fld1571rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1568 ALTER COLUMN _fld1572rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1568 ALTER COLUMN _fld1663rref SET STORAGE PLAIN;


--
-- Name: _accumrg1579; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1579 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _recordkind numeric(1,0) NOT NULL,
    _fld1580rref bytea NOT NULL,
    _fld1581rref bytea NOT NULL,
    _fld1582_type bytea NOT NULL,
    _fld1582_rtref bytea NOT NULL,
    _fld1582_rrref bytea NOT NULL,
    _fld1583 numeric(15,6) NOT NULL,
    _fld1584 numeric(15,3) NOT NULL,
    _fld1585rref bytea NOT NULL
);
ALTER TABLE ONLY _accumrg1579 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1579 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1579 ALTER COLUMN _fld1580rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1579 ALTER COLUMN _fld1581rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1579 ALTER COLUMN _fld1582_type SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1579 ALTER COLUMN _fld1582_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1579 ALTER COLUMN _fld1582_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1579 ALTER COLUMN _fld1585rref SET STORAGE PLAIN;


--
-- Name: _accumrg1588; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1588 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1589rref bytea NOT NULL,
    _fld1590rref bytea NOT NULL,
    _fld1591rref bytea NOT NULL,
    _fld1592rref bytea NOT NULL,
    _fld1593 numeric(15,3) NOT NULL,
    _fld1594 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _accumrg1588 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1588 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1588 ALTER COLUMN _fld1589rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1588 ALTER COLUMN _fld1590rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1588 ALTER COLUMN _fld1591rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1588 ALTER COLUMN _fld1592rref SET STORAGE PLAIN;


--
-- Name: _accumrg1597; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1597 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1598rref bytea NOT NULL,
    _fld1599rref bytea NOT NULL,
    _fld1600rref bytea NOT NULL,
    _fld1601 numeric(15,3) NOT NULL,
    _fld1602 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _accumrg1597 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1597 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1597 ALTER COLUMN _fld1598rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1597 ALTER COLUMN _fld1599rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1597 ALTER COLUMN _fld1600rref SET STORAGE PLAIN;


--
-- Name: _accumrg1605; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1605 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _recordkind numeric(1,0) NOT NULL,
    _fld1606rref bytea NOT NULL,
    _fld1607 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _accumrg1605 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1605 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1605 ALTER COLUMN _fld1606rref SET STORAGE PLAIN;


--
-- Name: _accumrg1610; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1610 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _recordkind numeric(1,0) NOT NULL,
    _fld1611rref bytea NOT NULL,
    _fld1612rref bytea NOT NULL,
    _fld1613rref bytea NOT NULL,
    _fld1614rref bytea NOT NULL,
    _fld1615rref bytea NOT NULL,
    _fld1616 numeric(12,3) NOT NULL,
    _fld1617 numeric(13,2) NOT NULL
);
ALTER TABLE ONLY _accumrg1610 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1610 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1610 ALTER COLUMN _fld1611rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1610 ALTER COLUMN _fld1612rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1610 ALTER COLUMN _fld1613rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1610 ALTER COLUMN _fld1614rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1610 ALTER COLUMN _fld1615rref SET STORAGE PLAIN;


--
-- Name: _accumrg1620; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1620 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1621rref bytea NOT NULL,
    _fld1622 numeric(15,0) NOT NULL
);
ALTER TABLE ONLY _accumrg1620 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1620 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1620 ALTER COLUMN _fld1621rref SET STORAGE PLAIN;


--
-- Name: _accumrg1625; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrg1625 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1626rref bytea NOT NULL,
    _fld1627 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _accumrg1625 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1625 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrg1625 ALTER COLUMN _fld1626rref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1521; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1521 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1521 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1521 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1521 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1521 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1527; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1527 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1527 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1527 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1527 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1527 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1532; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1532 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1532 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1532 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1532 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1532 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1556; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1556 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1556 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1556 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1556 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1556 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1567; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1567 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1567 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1567 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1567 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1567 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1578; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1578 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1578 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1578 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1578 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1578 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1587; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1587 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1587 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1587 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1587 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1587 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1596; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1596 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1596 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1596 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1596 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1596 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1604; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1604 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1604 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1604 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1604 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1604 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1609; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1609 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1609 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1609 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1609 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1609 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1619; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1619 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1619 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1619 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1619 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1619 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1624; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1624 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1624 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1624 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1624 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1624 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgchngr1629; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgchngr1629 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _accumrgchngr1629 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1629 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1629 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgchngr1629 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _accumrgopt1630; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1630 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1630 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1631; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1631 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1631 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1632; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1632 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1632 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1633; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1633 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1633 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1634; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1634 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1634 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1635; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1635 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1635 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1636; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1636 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1636 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1637; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1637 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1637 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1638; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1638 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1638 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1639; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1639 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1639 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1640; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1640 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1640 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1641; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1641 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1641 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgopt1642; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgopt1642 (
    _regid bytea NOT NULL,
    _period timestamp without time zone NOT NULL,
    _actualperiod boolean NOT NULL,
    _periodicity numeric(2,0) NOT NULL,
    _repetitionfactor numeric(2,0) NOT NULL,
    _usetotals numeric(1,0) NOT NULL,
    _minperiod timestamp without time zone NOT NULL,
    _usesplitter boolean NOT NULL
);
ALTER TABLE ONLY _accumrgopt1642 ALTER COLUMN _regid SET STORAGE PLAIN;


--
-- Name: _accumrgt1520; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgt1520 (
    _period timestamp without time zone NOT NULL,
    _fld1514rref bytea NOT NULL,
    _fld1515rref bytea NOT NULL,
    _fld1516_type bytea NOT NULL,
    _fld1516_rtref bytea NOT NULL,
    _fld1516_rrref bytea NOT NULL,
    _fld1517 numeric(21,2) NOT NULL
);
ALTER TABLE ONLY _accumrgt1520 ALTER COLUMN _fld1514rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1520 ALTER COLUMN _fld1515rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1520 ALTER COLUMN _fld1516_type SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1520 ALTER COLUMN _fld1516_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1520 ALTER COLUMN _fld1516_rrref SET STORAGE PLAIN;


--
-- Name: _accumrgt1526; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgt1526 (
    _period timestamp without time zone NOT NULL,
    _fld1523rref bytea NOT NULL,
    _fld1524rref bytea NOT NULL,
    _fld1525 numeric(21,2) NOT NULL
);
ALTER TABLE ONLY _accumrgt1526 ALTER COLUMN _fld1523rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1526 ALTER COLUMN _fld1524rref SET STORAGE PLAIN;


--
-- Name: _accumrgt1531; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgt1531 (
    _period timestamp without time zone NOT NULL,
    _fld1529rref bytea NOT NULL,
    _fld1530 numeric(21,2) NOT NULL
);
ALTER TABLE ONLY _accumrgt1531 ALTER COLUMN _fld1529rref SET STORAGE PLAIN;


--
-- Name: _accumrgt1555; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgt1555 (
    _period timestamp without time zone NOT NULL,
    _fld1534rref bytea NOT NULL,
    _fld1535rref bytea NOT NULL,
    _fld1536rref bytea NOT NULL,
    _fld1537rref bytea NOT NULL,
    _fld1538rref bytea NOT NULL,
    _fld1539 numeric(15,2) NOT NULL,
    _fld1540 numeric(5,2) NOT NULL,
    _fld1541 numeric(5,2) NOT NULL,
    _fld1542rref bytea NOT NULL,
    _fld1543_type bytea NOT NULL,
    _fld1543_n numeric(15,2) NOT NULL,
    _fld1543_rrref bytea NOT NULL,
    _fld1544 boolean NOT NULL,
    _fld1545 mvarchar(150) NOT NULL,
    _fld1546 numeric(10,0) NOT NULL,
    _fld1547 boolean NOT NULL,
    _fld1548 numeric(10,0) NOT NULL,
    _fld1549 numeric(5,0) NOT NULL,
    _fld1550 numeric(21,3) NOT NULL,
    _fld1551 numeric(21,2) NOT NULL,
    _dimhash numeric(10,0) NOT NULL,
    _splitter numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _accumrgt1555 ALTER COLUMN _fld1534rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1555 ALTER COLUMN _fld1535rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1555 ALTER COLUMN _fld1536rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1555 ALTER COLUMN _fld1537rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1555 ALTER COLUMN _fld1538rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1555 ALTER COLUMN _fld1542rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1555 ALTER COLUMN _fld1543_type SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1555 ALTER COLUMN _fld1543_rrref SET STORAGE PLAIN;


--
-- Name: _accumrgt1566; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgt1566 (
    _period timestamp without time zone NOT NULL,
    _fld1558rref bytea NOT NULL,
    _fld1559rref bytea NOT NULL,
    _fld1560rref bytea NOT NULL,
    _fld1561rref bytea NOT NULL,
    _fld1562 numeric(15,2) NOT NULL,
    _fld1563 numeric(21,3) NOT NULL,
    _fld1564 numeric(21,2) NOT NULL
);
ALTER TABLE ONLY _accumrgt1566 ALTER COLUMN _fld1558rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1566 ALTER COLUMN _fld1559rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1566 ALTER COLUMN _fld1560rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1566 ALTER COLUMN _fld1561rref SET STORAGE PLAIN;


--
-- Name: _accumrgt1586; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgt1586 (
    _period timestamp without time zone NOT NULL,
    _fld1580rref bytea NOT NULL,
    _fld1581rref bytea NOT NULL,
    _fld1582_type bytea NOT NULL,
    _fld1582_rtref bytea NOT NULL,
    _fld1582_rrref bytea NOT NULL,
    _fld1583 numeric(21,6) NOT NULL,
    _fld1584 numeric(21,3) NOT NULL
);
ALTER TABLE ONLY _accumrgt1586 ALTER COLUMN _fld1580rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1586 ALTER COLUMN _fld1581rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1586 ALTER COLUMN _fld1582_type SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1586 ALTER COLUMN _fld1582_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1586 ALTER COLUMN _fld1582_rrref SET STORAGE PLAIN;


--
-- Name: _accumrgt1608; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgt1608 (
    _period timestamp without time zone NOT NULL,
    _fld1606rref bytea NOT NULL,
    _fld1607 numeric(21,2) NOT NULL,
    _splitter numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _accumrgt1608 ALTER COLUMN _fld1606rref SET STORAGE PLAIN;


--
-- Name: _accumrgt1618; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgt1618 (
    _period timestamp without time zone NOT NULL,
    _fld1611rref bytea NOT NULL,
    _fld1612rref bytea NOT NULL,
    _fld1613rref bytea NOT NULL,
    _fld1614rref bytea NOT NULL,
    _fld1615rref bytea NOT NULL,
    _fld1616 numeric(18,3) NOT NULL,
    _fld1617 numeric(19,2) NOT NULL,
    _splitter numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _accumrgt1618 ALTER COLUMN _fld1611rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1618 ALTER COLUMN _fld1612rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1618 ALTER COLUMN _fld1613rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1618 ALTER COLUMN _fld1614rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgt1618 ALTER COLUMN _fld1615rref SET STORAGE PLAIN;


--
-- Name: _accumrgtn1577; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgtn1577 (
    _period timestamp without time zone NOT NULL,
    _fld1569rref bytea NOT NULL,
    _fld1570rref bytea NOT NULL,
    _fld1571rref bytea NOT NULL,
    _fld1572rref bytea NOT NULL,
    _fld1663rref bytea NOT NULL,
    _fld1573 numeric(21,3) NOT NULL,
    _fld1574 numeric(21,2) NOT NULL,
    _fld1575 numeric(21,2) NOT NULL
);
ALTER TABLE ONLY _accumrgtn1577 ALTER COLUMN _fld1569rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgtn1577 ALTER COLUMN _fld1570rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgtn1577 ALTER COLUMN _fld1571rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgtn1577 ALTER COLUMN _fld1572rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgtn1577 ALTER COLUMN _fld1663rref SET STORAGE PLAIN;


--
-- Name: _accumrgtn1595; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgtn1595 (
    _period timestamp without time zone NOT NULL,
    _fld1589rref bytea NOT NULL,
    _fld1590rref bytea NOT NULL,
    _fld1591rref bytea NOT NULL,
    _fld1592rref bytea NOT NULL,
    _fld1593 numeric(21,3) NOT NULL,
    _fld1594 numeric(21,2) NOT NULL
);
ALTER TABLE ONLY _accumrgtn1595 ALTER COLUMN _fld1589rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgtn1595 ALTER COLUMN _fld1590rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgtn1595 ALTER COLUMN _fld1591rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgtn1595 ALTER COLUMN _fld1592rref SET STORAGE PLAIN;


--
-- Name: _accumrgtn1603; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgtn1603 (
    _period timestamp without time zone NOT NULL,
    _fld1598rref bytea NOT NULL,
    _fld1599rref bytea NOT NULL,
    _fld1600rref bytea NOT NULL,
    _fld1601 numeric(21,3) NOT NULL,
    _fld1602 numeric(21,2) NOT NULL,
    _splitter numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _accumrgtn1603 ALTER COLUMN _fld1598rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgtn1603 ALTER COLUMN _fld1599rref SET STORAGE PLAIN;
ALTER TABLE ONLY _accumrgtn1603 ALTER COLUMN _fld1600rref SET STORAGE PLAIN;


--
-- Name: _accumrgtn1623; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgtn1623 (
    _period timestamp without time zone NOT NULL,
    _fld1621rref bytea NOT NULL,
    _fld1622 numeric(21,0) NOT NULL,
    _splitter numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _accumrgtn1623 ALTER COLUMN _fld1621rref SET STORAGE PLAIN;


--
-- Name: _accumrgtn1628; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _accumrgtn1628 (
    _period timestamp without time zone NOT NULL,
    _fld1626rref bytea NOT NULL,
    _fld1627 numeric(21,2) NOT NULL,
    _splitter numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _accumrgtn1628 ALTER COLUMN _fld1626rref SET STORAGE PLAIN;


--
-- Name: _chrc127; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _chrc127 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(150) NOT NULL,
    _type bytea
);
ALTER TABLE ONLY _chrc127 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _chrc127 ALTER COLUMN _parentidrref SET STORAGE PLAIN;


--
-- Name: _chrc128; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _chrc128 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(100) NOT NULL,
    _type bytea
);
ALTER TABLE ONLY _chrc128 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _chrc128 ALTER COLUMN _parentidrref SET STORAGE PLAIN;


--
-- Name: _chrc129; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _chrc129 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(25) NOT NULL,
    _type bytea
);
ALTER TABLE ONLY _chrc129 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _chrcchngr1646; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _chrcchngr1646 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _chrcchngr1646 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _chrcchngr1646 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _chrcchngr1646 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _chrcchngr1647; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _chrcchngr1647 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _chrcchngr1647 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _chrcchngr1647 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _chrcchngr1647 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _chrcchngr1648; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _chrcchngr1648 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _chrcchngr1648 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _chrcchngr1648 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _chrcchngr1648 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _commonsettings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _commonsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _commonsettings ALTER COLUMN _version SET STORAGE PLAIN;


--
-- Name: _configchngr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _configchngr (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _mdobjid bytea NOT NULL,
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _configchngr ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _configchngr ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _configchngr ALTER COLUMN _mdobjid SET STORAGE PLAIN;
ALTER TABLE ONLY _configchngr ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _configchngr_extprops; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _configchngr_extprops (
    _configchngr_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _filename mvarchar(128) NOT NULL
);
ALTER TABLE ONLY _configchngr_extprops ALTER COLUMN _configchngr_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _configchngr_extprops ALTER COLUMN _keyfield SET STORAGE PLAIN;


--
-- Name: _const1119; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1119 (
    _fld1120 mvarchar(10) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1119 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1122; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1122 (
    _fld1123 numeric(10,0) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1122 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1125; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1125 (
    _fld1126 mchar(1) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1125 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1128; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1128 (
    _fld1129 mchar(1) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1128 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1131; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1131 (
    _fld1132 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1131 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1134; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1134 (
    _fld1135 mvarchar(10) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1134 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1136; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1136 (
    _fld1137 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1136 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1139; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1139 (
    _fld1140 mvarchar(2) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1139 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1141; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1141 (
    _fld1142 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1141 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1144; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1144 (
    _fld1145 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1144 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1147; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1147 (
    _fld1148 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1147 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1150; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1150 (
    _fld1151rref bytea NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1150 ALTER COLUMN _fld1151rref SET STORAGE PLAIN;
ALTER TABLE ONLY _const1150 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1152; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1152 (
    _fld1153 timestamp without time zone NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1152 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1155; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1155 (
    _fld1156 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1155 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1158; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1158 (
    _fld1159rref bytea NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1158 ALTER COLUMN _fld1159rref SET STORAGE PLAIN;
ALTER TABLE ONLY _const1158 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1160; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1160 (
    _fld1161 bytea NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1160 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1162; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1162 (
    _fld1163rref bytea NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1162 ALTER COLUMN _fld1163rref SET STORAGE PLAIN;
ALTER TABLE ONLY _const1162 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1164; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1164 (
    _fld1165 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1164 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1166; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1166 (
    _fld1167 bytea NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1166 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1168; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1168 (
    _fld1169 mvarchar(2) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1168 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1170; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1170 (
    _fld1171 timestamp without time zone NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1170 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1172; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1172 (
    _fld1173 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1172 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1174; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1174 (
    _fld1175 bytea NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1174 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1176; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1176 (
    _fld1177rref bytea NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1176 ALTER COLUMN _fld1177rref SET STORAGE PLAIN;
ALTER TABLE ONLY _const1176 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1178; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1178 (
    _fld1179 numeric(10,0) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1178 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1180; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1180 (
    _fld1181 bytea NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1180 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1182; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1182 (
    _fld1183 bytea NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1182 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1184; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1184 (
    _fld1185 mvarchar NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1184 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1186; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1186 (
    _fld1187 numeric(10,0) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1186 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1188; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1188 (
    _fld1189 numeric(2,0) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1188 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1190; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1190 (
    _fld1191 numeric(9,0) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1190 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1192; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1192 (
    _fld1193 numeric(4,1) NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1192 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1194; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1194 (
    _fld1195 timestamp without time zone NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1194 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1196; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1196 (
    _fld1197 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1196 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1199; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1199 (
    _fld1200 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1199 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _const1201; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _const1201 (
    _fld1202 boolean NOT NULL,
    _recordkey bytea NOT NULL
);
ALTER TABLE ONLY _const1201 ALTER COLUMN _recordkey SET STORAGE PLAIN;


--
-- Name: _constchngr1121; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1121 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1121 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1121 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1121 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1124; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1124 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1124 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1124 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1124 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1127; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1127 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1127 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1127 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1127 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1130; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1130 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1130 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1130 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1130 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1133; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1133 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1133 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1133 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1133 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1138; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1138 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1138 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1138 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1138 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1143; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1143 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1143 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1143 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1143 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1146; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1146 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1146 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1146 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1146 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1149; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1149 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1149 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1149 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1149 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1154; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1154 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1154 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1154 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1154 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1157; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1157 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1157 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1157 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1157 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _constchngr1198; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _constchngr1198 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _constid bytea NOT NULL
);
ALTER TABLE ONLY _constchngr1198 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1198 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _constchngr1198 ALTER COLUMN _constid SET STORAGE PLAIN;


--
-- Name: _document52; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document52 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld544rref bytea NOT NULL,
    _fld545rref bytea NOT NULL,
    _fld546 numeric(15,3) NOT NULL,
    _fld547 numeric(10,2) NOT NULL,
    _fld548rref bytea NOT NULL,
    _fld549rref bytea NOT NULL,
    _fld550 mvarchar NOT NULL,
    _fld551 boolean NOT NULL,
    _fld552rref bytea NOT NULL
);
ALTER TABLE ONLY _document52 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document52 ALTER COLUMN _fld544rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document52 ALTER COLUMN _fld545rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document52 ALTER COLUMN _fld548rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document52 ALTER COLUMN _fld549rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document52 ALTER COLUMN _fld552rref SET STORAGE PLAIN;


--
-- Name: _document52_vt553; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document52_vt553 (
    _document52_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno554 numeric(5,0) NOT NULL,
    _fld555rref bytea NOT NULL,
    _fld556 numeric(10,2) NOT NULL,
    _fld557 numeric(15,3) NOT NULL,
    _fld558 numeric(15,3) NOT NULL,
    _fld559rref bytea NOT NULL,
    _fld560 numeric(10,3) NOT NULL,
    _fld561 numeric(10,2) NOT NULL,
    _fld562 numeric(10,2) NOT NULL
);
ALTER TABLE ONLY _document52_vt553 ALTER COLUMN _document52_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document52_vt553 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document52_vt553 ALTER COLUMN _fld555rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document52_vt553 ALTER COLUMN _fld559rref SET STORAGE PLAIN;


--
-- Name: _document53; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document53 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld564rref bytea NOT NULL,
    _fld565rref bytea NOT NULL,
    _fld566 timestamp without time zone NOT NULL,
    _fld567 timestamp without time zone NOT NULL,
    _fld568 mvarchar(300) NOT NULL,
    _fld569rref bytea NOT NULL,
    _fld570 mvarchar(150) NOT NULL,
    _fld571 mvarchar(150) NOT NULL,
    _fld572 numeric(15,2) NOT NULL,
    _fld573 numeric(15,2) NOT NULL,
    _fld574 boolean NOT NULL
);
ALTER TABLE ONLY _document53 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document53 ALTER COLUMN _fld564rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document53 ALTER COLUMN _fld565rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document53 ALTER COLUMN _fld569rref SET STORAGE PLAIN;


--
-- Name: _document53_vt575; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document53_vt575 (
    _document53_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno576 numeric(5,0) NOT NULL,
    _fld577 timestamp without time zone NOT NULL,
    _fld578_type bytea NOT NULL,
    _fld578_rtref bytea NOT NULL,
    _fld578_rrref bytea NOT NULL,
    _fld579 mvarchar(150) NOT NULL,
    _fld580 numeric(15,2) NOT NULL,
    _fld581 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _document53_vt575 ALTER COLUMN _document53_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document53_vt575 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document53_vt575 ALTER COLUMN _fld578_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document53_vt575 ALTER COLUMN _fld578_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _document53_vt575 ALTER COLUMN _fld578_rrref SET STORAGE PLAIN;


--
-- Name: _document53_vt582; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document53_vt582 (
    _document53_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno583 numeric(5,0) NOT NULL,
    _fld584 timestamp without time zone NOT NULL,
    _fld585_type bytea NOT NULL,
    _fld585_rtref bytea NOT NULL,
    _fld585_rrref bytea NOT NULL,
    _fld586 mvarchar(150) NOT NULL,
    _fld587 numeric(15,2) NOT NULL,
    _fld588 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _document53_vt582 ALTER COLUMN _document53_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document53_vt582 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document53_vt582 ALTER COLUMN _fld585_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document53_vt582 ALTER COLUMN _fld585_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _document53_vt582 ALTER COLUMN _fld585_rrref SET STORAGE PLAIN;


--
-- Name: _document54; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document54 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld590 mvarchar NOT NULL,
    _fld591rref bytea NOT NULL,
    _fld592rref bytea NOT NULL,
    _fld593rref bytea NOT NULL,
    _fld594rref bytea NOT NULL
);
ALTER TABLE ONLY _document54 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document54 ALTER COLUMN _fld591rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document54 ALTER COLUMN _fld592rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document54 ALTER COLUMN _fld593rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document54 ALTER COLUMN _fld594rref SET STORAGE PLAIN;


--
-- Name: _document54_vt595; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document54_vt595 (
    _document54_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno596 numeric(5,0) NOT NULL,
    _fld597rref bytea NOT NULL,
    _fld598rref bytea NOT NULL,
    _fld599 numeric(10,3) NOT NULL,
    _fld600 numeric(15,3) NOT NULL,
    _fld601rref bytea NOT NULL
);
ALTER TABLE ONLY _document54_vt595 ALTER COLUMN _document54_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document54_vt595 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document54_vt595 ALTER COLUMN _fld597rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document54_vt595 ALTER COLUMN _fld598rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document54_vt595 ALTER COLUMN _fld601rref SET STORAGE PLAIN;


--
-- Name: _document55; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document55 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld604 mvarchar(300) NOT NULL,
    _fld605rref bytea NOT NULL,
    _fld606rref bytea NOT NULL,
    _fld607rref bytea NOT NULL,
    _fld608rref bytea NOT NULL,
    _fld609 boolean NOT NULL,
    _fld610 numeric(15,2) NOT NULL,
    _fld611rref bytea NOT NULL,
    _fld612 boolean NOT NULL,
    _fld613rref bytea NOT NULL,
    _fld614 boolean NOT NULL
);
ALTER TABLE ONLY _document55 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document55 ALTER COLUMN _fld605rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document55 ALTER COLUMN _fld606rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document55 ALTER COLUMN _fld607rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document55 ALTER COLUMN _fld608rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document55 ALTER COLUMN _fld611rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document55 ALTER COLUMN _fld613rref SET STORAGE PLAIN;


--
-- Name: _document55_vt615; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document55_vt615 (
    _document55_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno616 numeric(5,0) NOT NULL,
    _fld617rref bytea NOT NULL,
    _fld618 numeric(15,3) NOT NULL,
    _fld619rref bytea NOT NULL,
    _fld620 numeric(10,3) NOT NULL,
    _fld621 numeric(15,2) NOT NULL,
    _fld622rref bytea NOT NULL,
    _fld623 numeric(15,2) NOT NULL,
    _fld624 numeric(15,2) NOT NULL,
    _fld625 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _document55_vt615 ALTER COLUMN _document55_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document55_vt615 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document55_vt615 ALTER COLUMN _fld617rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document55_vt615 ALTER COLUMN _fld619rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document55_vt615 ALTER COLUMN _fld622rref SET STORAGE PLAIN;


--
-- Name: _document56; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document56 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld627rref bytea NOT NULL,
    _fld628rref bytea NOT NULL,
    _fld629rref bytea NOT NULL,
    _fld630rref bytea NOT NULL,
    _fld631 timestamp without time zone NOT NULL,
    _fld632rref bytea NOT NULL,
    _fld633 numeric(15,2) NOT NULL,
    _fld634 numeric(5,0) NOT NULL,
    _fld635 mvarchar(300) NOT NULL,
    _fld636rref bytea NOT NULL,
    _fld637 boolean NOT NULL,
    _fld638 boolean NOT NULL,
    _fld639rref bytea NOT NULL,
    _fld640rref bytea NOT NULL,
    _fld641 boolean NOT NULL,
    _fld642 boolean NOT NULL,
    _fld643 boolean NOT NULL,
    _fld644 numeric(3,0) NOT NULL,
    _fld645 boolean NOT NULL
);
ALTER TABLE ONLY _document56 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56 ALTER COLUMN _fld627rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56 ALTER COLUMN _fld628rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56 ALTER COLUMN _fld629rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56 ALTER COLUMN _fld630rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56 ALTER COLUMN _fld632rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56 ALTER COLUMN _fld636rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56 ALTER COLUMN _fld639rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56 ALTER COLUMN _fld640rref SET STORAGE PLAIN;


--
-- Name: _document56_vt1655; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document56_vt1655 (
    _document56_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno1656 numeric(5,0) NOT NULL,
    _fld1657rref bytea NOT NULL
);
ALTER TABLE ONLY _document56_vt1655 ALTER COLUMN _document56_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt1655 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt1655 ALTER COLUMN _fld1657rref SET STORAGE PLAIN;


--
-- Name: _document56_vt646; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document56_vt646 (
    _document56_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno647 numeric(5,0) NOT NULL,
    _fld648rref bytea NOT NULL,
    _fld649rref bytea NOT NULL,
    _fld650 numeric(10,3) NOT NULL,
    _fld651 numeric(15,3) NOT NULL,
    _fld652 numeric(15,2) NOT NULL,
    _fld653 numeric(15,2) NOT NULL,
    _fld654 numeric(15,2) NOT NULL,
    _fld655 numeric(15,2) NOT NULL,
    _fld656 numeric(5,2) NOT NULL,
    _fld657 numeric(5,2) NOT NULL,
    _fld658rref bytea NOT NULL,
    _fld659_type bytea NOT NULL,
    _fld659_n numeric(15,2) NOT NULL,
    _fld659_rrref bytea NOT NULL,
    _fld660rref bytea NOT NULL,
    _fld661 numeric(15,2) NOT NULL,
    _fld662 boolean NOT NULL,
    _fld663 boolean NOT NULL,
    _fld664 numeric(10,0) NOT NULL,
    _fld665 mvarchar(150) NOT NULL,
    _fld666 numeric(10,0) NOT NULL,
    _fld667 boolean NOT NULL,
    _fld668 numeric(5,0) NOT NULL
);
ALTER TABLE ONLY _document56_vt646 ALTER COLUMN _document56_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt646 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt646 ALTER COLUMN _fld648rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt646 ALTER COLUMN _fld649rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt646 ALTER COLUMN _fld658rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt646 ALTER COLUMN _fld659_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt646 ALTER COLUMN _fld659_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt646 ALTER COLUMN _fld660rref SET STORAGE PLAIN;


--
-- Name: _document56_vt669; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document56_vt669 (
    _document56_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno670 numeric(5,0) NOT NULL,
    _fld671rref bytea NOT NULL
);
ALTER TABLE ONLY _document56_vt669 ALTER COLUMN _document56_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt669 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt669 ALTER COLUMN _fld671rref SET STORAGE PLAIN;


--
-- Name: _document56_vt672; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document56_vt672 (
    _document56_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno673 numeric(5,0) NOT NULL,
    _fld674rref bytea NOT NULL
);
ALTER TABLE ONLY _document56_vt672 ALTER COLUMN _document56_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt672 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt672 ALTER COLUMN _fld674rref SET STORAGE PLAIN;


--
-- Name: _document56_vt675; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document56_vt675 (
    _document56_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno676 numeric(5,0) NOT NULL,
    _fld677 numeric(15,2) NOT NULL,
    _fld678 timestamp without time zone NOT NULL
);
ALTER TABLE ONLY _document56_vt675 ALTER COLUMN _document56_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document56_vt675 ALTER COLUMN _keyfield SET STORAGE PLAIN;


--
-- Name: _document57; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document57 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld680 mvarchar(300) NOT NULL,
    _fld681rref bytea NOT NULL,
    _fld682rref bytea NOT NULL,
    _fld683rref bytea NOT NULL,
    _fld684rref bytea NOT NULL,
    _fld685 boolean NOT NULL,
    _fld686 numeric(15,2) NOT NULL,
    _fld687rref bytea NOT NULL,
    _fld688 boolean NOT NULL
);
ALTER TABLE ONLY _document57 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document57 ALTER COLUMN _fld681rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document57 ALTER COLUMN _fld682rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document57 ALTER COLUMN _fld683rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document57 ALTER COLUMN _fld684rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document57 ALTER COLUMN _fld687rref SET STORAGE PLAIN;


--
-- Name: _document57_vt689; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document57_vt689 (
    _document57_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno690 numeric(5,0) NOT NULL,
    _fld691rref bytea NOT NULL,
    _fld692rref bytea NOT NULL,
    _fld693 numeric(10,3) NOT NULL,
    _fld694 numeric(15,3) NOT NULL,
    _fld695 numeric(15,2) NOT NULL,
    _fld696 numeric(15,2) NOT NULL,
    _fld697rref bytea NOT NULL,
    _fld698 numeric(15,2) NOT NULL,
    _fld699 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _document57_vt689 ALTER COLUMN _document57_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document57_vt689 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document57_vt689 ALTER COLUMN _fld691rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document57_vt689 ALTER COLUMN _fld692rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document57_vt689 ALTER COLUMN _fld697rref SET STORAGE PLAIN;


--
-- Name: _document58; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document58 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld702 mvarchar NOT NULL,
    _fld703rref bytea NOT NULL,
    _fld704rref bytea NOT NULL,
    _fld705rref bytea NOT NULL
);
ALTER TABLE ONLY _document58 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document58 ALTER COLUMN _fld703rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document58 ALTER COLUMN _fld704rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document58 ALTER COLUMN _fld705rref SET STORAGE PLAIN;


--
-- Name: _document58_vt706; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document58_vt706 (
    _document58_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno707 numeric(5,0) NOT NULL,
    _fld708rref bytea NOT NULL,
    _fld709rref bytea NOT NULL,
    _fld710 numeric(10,3) NOT NULL,
    _fld711 numeric(15,3) NOT NULL,
    _fld712 numeric(15,2) NOT NULL,
    _fld713 numeric(15,2) NOT NULL,
    _fld714 numeric(15,3) NOT NULL,
    _fld715 numeric(15,2) NOT NULL,
    _fld716 numeric(15,2) NOT NULL,
    _fld717 numeric(15,0) NOT NULL,
    _fld718 numeric(15,2) NOT NULL,
    _fld719rref bytea NOT NULL
);
ALTER TABLE ONLY _document58_vt706 ALTER COLUMN _document58_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document58_vt706 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document58_vt706 ALTER COLUMN _fld708rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document58_vt706 ALTER COLUMN _fld709rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document58_vt706 ALTER COLUMN _fld719rref SET STORAGE PLAIN;


--
-- Name: _document59; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document59 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld722rref bytea NOT NULL,
    _fld723 numeric(15,2) NOT NULL,
    _fld724rref bytea NOT NULL,
    _fld725 mvarchar(300) NOT NULL,
    _fld726 boolean NOT NULL
);
ALTER TABLE ONLY _document59 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document59 ALTER COLUMN _fld722rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document59 ALTER COLUMN _fld724rref SET STORAGE PLAIN;


--
-- Name: _document59_vt727; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document59_vt727 (
    _document59_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno728 numeric(5,0) NOT NULL,
    _fld729rref bytea NOT NULL,
    _fld730 numeric(15,2) NOT NULL,
    _fld731rref bytea NOT NULL
);
ALTER TABLE ONLY _document59_vt727 ALTER COLUMN _document59_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document59_vt727 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document59_vt727 ALTER COLUMN _fld729rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document59_vt727 ALTER COLUMN _fld731rref SET STORAGE PLAIN;


--
-- Name: _document60; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document60 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld733 mvarchar NOT NULL,
    _fld734rref bytea NOT NULL,
    _fld735rref bytea NOT NULL,
    _fld736rref bytea NOT NULL,
    _fld737 numeric(15,2) NOT NULL,
    _fld738rref bytea NOT NULL,
    _fld739 boolean NOT NULL
);
ALTER TABLE ONLY _document60 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document60 ALTER COLUMN _fld734rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document60 ALTER COLUMN _fld735rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document60 ALTER COLUMN _fld736rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document60 ALTER COLUMN _fld738rref SET STORAGE PLAIN;


--
-- Name: _document60_vt740; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document60_vt740 (
    _document60_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno741 numeric(5,0) NOT NULL,
    _fld742rref bytea NOT NULL,
    _fld743 numeric(15,3) NOT NULL,
    _fld744rref bytea NOT NULL,
    _fld745 numeric(10,3) NOT NULL,
    _fld746 numeric(15,2) NOT NULL,
    _fld747 numeric(15,2) NOT NULL,
    _fld748 numeric(15,2) NOT NULL,
    _fld749 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _document60_vt740 ALTER COLUMN _document60_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document60_vt740 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document60_vt740 ALTER COLUMN _fld742rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document60_vt740 ALTER COLUMN _fld744rref SET STORAGE PLAIN;


--
-- Name: _document61; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document61 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld752rref bytea NOT NULL,
    _fld753 mvarchar(300) NOT NULL
);
ALTER TABLE ONLY _document61 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document61 ALTER COLUMN _fld752rref SET STORAGE PLAIN;


--
-- Name: _document61_vt754; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document61_vt754 (
    _document61_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno755 numeric(5,0) NOT NULL,
    _fld756rref bytea NOT NULL,
    _fld757rref bytea NOT NULL
);
ALTER TABLE ONLY _document61_vt754 ALTER COLUMN _document61_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document61_vt754 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document61_vt754 ALTER COLUMN _fld756rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document61_vt754 ALTER COLUMN _fld757rref SET STORAGE PLAIN;


--
-- Name: _document62; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document62 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(11) NOT NULL,
    _posted boolean NOT NULL,
    _fld759 mvarchar NOT NULL,
    _fld760rref bytea NOT NULL,
    _fld761rref bytea NOT NULL,
    _fld762rref bytea NOT NULL,
    _fld763rref bytea NOT NULL,
    _fld764 boolean NOT NULL
);
ALTER TABLE ONLY _document62 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document62 ALTER COLUMN _fld760rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document62 ALTER COLUMN _fld761rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document62 ALTER COLUMN _fld762rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document62 ALTER COLUMN _fld763rref SET STORAGE PLAIN;


--
-- Name: _document62_vt765; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document62_vt765 (
    _document62_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno766 numeric(5,0) NOT NULL,
    _fld767rref bytea NOT NULL,
    _fld768 numeric(15,3) NOT NULL,
    _fld769 numeric(10,3) NOT NULL,
    _fld770rref bytea NOT NULL
);
ALTER TABLE ONLY _document62_vt765 ALTER COLUMN _document62_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document62_vt765 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document62_vt765 ALTER COLUMN _fld767rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document62_vt765 ALTER COLUMN _fld770rref SET STORAGE PLAIN;


--
-- Name: _document63; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document63 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld773rref bytea NOT NULL,
    _fld774rref bytea NOT NULL,
    _fld775rref bytea NOT NULL,
    _fld776rref bytea NOT NULL,
    _fld777 boolean NOT NULL,
    _fld778 boolean NOT NULL,
    _fld779 boolean NOT NULL,
    _fld780 boolean NOT NULL,
    _fld781rref bytea NOT NULL,
    _fld782 mvarchar NOT NULL,
    _fld783 boolean NOT NULL
);
ALTER TABLE ONLY _document63 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document63 ALTER COLUMN _fld773rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document63 ALTER COLUMN _fld774rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document63 ALTER COLUMN _fld775rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document63 ALTER COLUMN _fld776rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document63 ALTER COLUMN _fld781rref SET STORAGE PLAIN;


--
-- Name: _document63_vt784; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document63_vt784 (
    _document63_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno785 numeric(5,0) NOT NULL,
    _fld786rref bytea NOT NULL,
    _fld787rref bytea NOT NULL,
    _fld788 numeric(10,3) NOT NULL,
    _fld789rref bytea NOT NULL,
    _fld790 numeric(15,3) NOT NULL,
    _fld791 numeric(15,2) NOT NULL,
    _fld792 numeric(5,0) NOT NULL,
    _fld793 numeric(5,0) NOT NULL
);
ALTER TABLE ONLY _document63_vt784 ALTER COLUMN _document63_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document63_vt784 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document63_vt784 ALTER COLUMN _fld786rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document63_vt784 ALTER COLUMN _fld787rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document63_vt784 ALTER COLUMN _fld789rref SET STORAGE PLAIN;


--
-- Name: _document63_vt794; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document63_vt794 (
    _document63_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno795 numeric(5,0) NOT NULL,
    _fld796rref bytea NOT NULL,
    _fld797 numeric(15,3) NOT NULL,
    _fld798 numeric(15,3) NOT NULL,
    _fld799 numeric(5,0) NOT NULL,
    _fld800 numeric(15,2) NOT NULL,
    _fld801 numeric(5,0) NOT NULL,
    _fld802 boolean NOT NULL,
    _fld803 boolean NOT NULL,
    _fld804rref bytea NOT NULL
);
ALTER TABLE ONLY _document63_vt794 ALTER COLUMN _document63_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document63_vt794 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document63_vt794 ALTER COLUMN _fld796rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document63_vt794 ALTER COLUMN _fld804rref SET STORAGE PLAIN;


--
-- Name: _document64; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document64 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(11) NOT NULL,
    _posted boolean NOT NULL,
    _fld806 mvarchar(300) NOT NULL,
    _fld807_type bytea NOT NULL,
    _fld807_rtref bytea NOT NULL,
    _fld807_rrref bytea NOT NULL,
    _fld808rref bytea NOT NULL,
    _fld809rref bytea NOT NULL,
    _fld810rref bytea NOT NULL,
    _fld811 boolean NOT NULL,
    _fld812 numeric(15,2) NOT NULL,
    _fld813rref bytea NOT NULL,
    _fld814 boolean NOT NULL,
    _fld815 timestamp without time zone NOT NULL,
    _fld816 mvarchar(10) NOT NULL,
    _fld817 boolean NOT NULL,
    _fld818rref bytea NOT NULL,
    _fld819 boolean NOT NULL,
    _fld820 timestamp without time zone NOT NULL,
    _fld821 boolean NOT NULL,
    _fld822rref bytea NOT NULL
);
ALTER TABLE ONLY _document64 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64 ALTER COLUMN _fld807_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document64 ALTER COLUMN _fld807_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64 ALTER COLUMN _fld807_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64 ALTER COLUMN _fld808rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64 ALTER COLUMN _fld809rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64 ALTER COLUMN _fld810rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64 ALTER COLUMN _fld813rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64 ALTER COLUMN _fld818rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64 ALTER COLUMN _fld822rref SET STORAGE PLAIN;


--
-- Name: _document64_vt823; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document64_vt823 (
    _document64_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno824 numeric(5,0) NOT NULL,
    _fld825rref bytea NOT NULL,
    _fld826 numeric(15,3) NOT NULL,
    _fld827rref bytea NOT NULL,
    _fld828 numeric(10,3) NOT NULL,
    _fld829 numeric(15,2) NOT NULL,
    _fld830rref bytea NOT NULL,
    _fld831 numeric(15,2) NOT NULL,
    _fld832 numeric(15,2) NOT NULL,
    _fld833 numeric(15,2) NOT NULL,
    _fld834 mvarchar(20) NOT NULL,
    _fld835 numeric(15,2) NOT NULL,
    _fld836rref bytea NOT NULL
);
ALTER TABLE ONLY _document64_vt823 ALTER COLUMN _document64_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64_vt823 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document64_vt823 ALTER COLUMN _fld825rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64_vt823 ALTER COLUMN _fld827rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64_vt823 ALTER COLUMN _fld830rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document64_vt823 ALTER COLUMN _fld836rref SET STORAGE PLAIN;


--
-- Name: _document65; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document65 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld839rref bytea NOT NULL,
    _fld840rref bytea NOT NULL,
    _fld841rref bytea NOT NULL,
    _fld842 mvarchar NOT NULL,
    _fld843_type bytea NOT NULL,
    _fld843_rtref bytea NOT NULL,
    _fld843_rrref bytea NOT NULL,
    _fld844 numeric(4,0) NOT NULL,
    _fld845rref bytea NOT NULL,
    _fld846 mvarchar NOT NULL,
    _fld847rref bytea NOT NULL,
    _fld848 mvarchar NOT NULL,
    _fld849 mvarchar NOT NULL,
    _fld850rref bytea NOT NULL,
    _fld851rref bytea NOT NULL,
    _fld852 numeric(15,2) NOT NULL,
    _fld853 numeric(15,2) NOT NULL,
    _fld854rref bytea NOT NULL,
    _fld855 boolean NOT NULL,
    _fld856rref bytea NOT NULL,
    _fld857rref bytea NOT NULL,
    _fld858rref bytea NOT NULL
);
ALTER TABLE ONLY _document65 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld839rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld840rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld841rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld843_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld843_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld843_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld845rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld847rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld850rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld851rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld854rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld856rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld857rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document65 ALTER COLUMN _fld858rref SET STORAGE PLAIN;


--
-- Name: _document66; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document66 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld861rref bytea NOT NULL,
    _fld862 mvarchar NOT NULL,
    _fld863rref bytea NOT NULL,
    _fld864rref bytea NOT NULL,
    _fld865 mvarchar NOT NULL,
    _fld866rref bytea NOT NULL,
    _fld867 numeric(4,0) NOT NULL,
    _fld868rref bytea NOT NULL,
    _fld869 mvarchar NOT NULL,
    _fld870rref bytea NOT NULL,
    _fld871 mvarchar NOT NULL,
    _fld872 mvarchar NOT NULL,
    _fld873rref bytea NOT NULL,
    _fld874rref bytea NOT NULL,
    _fld875 numeric(15,2) NOT NULL,
    _fld876 numeric(15,2) NOT NULL,
    _fld877rref bytea NOT NULL,
    _fld878 boolean NOT NULL,
    _fld879rref bytea NOT NULL
);
ALTER TABLE ONLY _document66 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document66 ALTER COLUMN _fld861rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document66 ALTER COLUMN _fld863rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document66 ALTER COLUMN _fld864rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document66 ALTER COLUMN _fld866rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document66 ALTER COLUMN _fld868rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document66 ALTER COLUMN _fld870rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document66 ALTER COLUMN _fld873rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document66 ALTER COLUMN _fld874rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document66 ALTER COLUMN _fld877rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document66 ALTER COLUMN _fld879rref SET STORAGE PLAIN;


--
-- Name: _document67; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document67 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld882 boolean NOT NULL,
    _fld883rref bytea NOT NULL,
    _fld884rref bytea NOT NULL,
    _fld885_type bytea NOT NULL,
    _fld885_rtref bytea NOT NULL,
    _fld885_rrref bytea NOT NULL,
    _fld886 mvarchar(300) NOT NULL,
    _fld887 numeric(4,0) NOT NULL,
    _fld888 numeric(4,0) NOT NULL,
    _fld889rref bytea NOT NULL,
    _fld890rref bytea NOT NULL,
    _fld891rref bytea NOT NULL,
    _fld892 numeric(15,2) NOT NULL,
    _fld893 numeric(15,2) NOT NULL,
    _fld894rref bytea NOT NULL,
    _fld895rref bytea NOT NULL,
    _fld896 boolean NOT NULL,
    _fld897_type bytea NOT NULL,
    _fld897_rtref bytea NOT NULL,
    _fld897_rrref bytea NOT NULL,
    _fld898 numeric(10,0) NOT NULL,
    _fld899 boolean NOT NULL,
    _fld900 boolean NOT NULL,
    _fld901rref bytea NOT NULL,
    _fld902 boolean NOT NULL,
    _fld903 boolean NOT NULL,
    _fld904rref bytea NOT NULL,
    _fld905rref bytea NOT NULL,
    _fld906rref bytea NOT NULL
);
ALTER TABLE ONLY _document67 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld883rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld884rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld885_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld885_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld885_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld889rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld890rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld891rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld894rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld895rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld897_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld897_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld897_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld901rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld904rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld905rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67 ALTER COLUMN _fld906rref SET STORAGE PLAIN;


--
-- Name: _document67_vt1658; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document67_vt1658 (
    _document67_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno1659 numeric(5,0) NOT NULL,
    _fld1660rref bytea NOT NULL
);
ALTER TABLE ONLY _document67_vt1658 ALTER COLUMN _document67_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt1658 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt1658 ALTER COLUMN _fld1660rref SET STORAGE PLAIN;


--
-- Name: _document67_vt907; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document67_vt907 (
    _document67_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno908 numeric(5,0) NOT NULL,
    _fld909rref bytea NOT NULL,
    _fld910 numeric(15,3) NOT NULL,
    _fld911rref bytea NOT NULL,
    _fld912 numeric(15,3) NOT NULL,
    _fld913 numeric(15,2) NOT NULL,
    _fld914 numeric(5,2) NOT NULL,
    _fld915 numeric(5,2) NOT NULL,
    _fld916 numeric(15,2) NOT NULL,
    _fld917 numeric(15,2) NOT NULL,
    _fld918 mvarchar(250) NOT NULL,
    _fld919rref bytea NOT NULL,
    _fld920_type bytea NOT NULL,
    _fld920_n numeric(15,2) NOT NULL,
    _fld920_rrref bytea NOT NULL,
    _fld921rref bytea NOT NULL,
    _fld922rref bytea NOT NULL,
    _fld923 numeric(15,2) NOT NULL,
    _fld924 numeric(15,2) NOT NULL,
    _fld925rref bytea NOT NULL,
    _fld926 boolean NOT NULL,
    _fld927 numeric(10,0) NOT NULL,
    _fld928 mvarchar(150) NOT NULL,
    _fld929 numeric(5,0) NOT NULL,
    _fld930rref bytea NOT NULL,
    _fld931 boolean NOT NULL,
    _fld932 numeric(10,0) NOT NULL,
    _fld933 boolean NOT NULL
);
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _document67_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _fld909rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _fld911rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _fld919rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _fld920_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _fld920_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _fld921rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _fld922rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _fld925rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document67_vt907 ALTER COLUMN _fld930rref SET STORAGE PLAIN;


--
-- Name: _document68; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document68 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld936 mvarchar NOT NULL,
    _fld937rref bytea NOT NULL,
    _fld938rref bytea NOT NULL,
    _fld939rref bytea NOT NULL,
    _fld940 boolean NOT NULL
);
ALTER TABLE ONLY _document68 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document68 ALTER COLUMN _fld937rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document68 ALTER COLUMN _fld938rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document68 ALTER COLUMN _fld939rref SET STORAGE PLAIN;


--
-- Name: _document68_vt941; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document68_vt941 (
    _document68_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno942 numeric(5,0) NOT NULL,
    _fld943rref bytea NOT NULL,
    _fld944 numeric(15,3) NOT NULL,
    _fld945 numeric(10,3) NOT NULL,
    _fld946rref bytea NOT NULL,
    _fld947 numeric(15,4) NOT NULL,
    _fld948 numeric(15,2) NOT NULL,
    _fld949rref bytea NOT NULL
);
ALTER TABLE ONLY _document68_vt941 ALTER COLUMN _document68_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document68_vt941 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document68_vt941 ALTER COLUMN _fld943rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document68_vt941 ALTER COLUMN _fld946rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document68_vt941 ALTER COLUMN _fld949rref SET STORAGE PLAIN;


--
-- Name: _document69; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document69 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld952 timestamp without time zone NOT NULL,
    _fld953 timestamp without time zone NOT NULL,
    _fld954 boolean NOT NULL,
    _fld955 boolean NOT NULL,
    _fld956 boolean NOT NULL,
    _fld957rref bytea NOT NULL,
    _fld958 numeric(15,2) NOT NULL,
    _fld959 mvarchar NOT NULL,
    _fld960 boolean NOT NULL,
    _fld961 timestamp without time zone NOT NULL,
    _fld962 timestamp without time zone NOT NULL,
    _fld963 numeric(15,2) NOT NULL,
    _fld964rref bytea NOT NULL,
    _fld965 numeric(5,2) NOT NULL,
    _fld966rref bytea NOT NULL
);
ALTER TABLE ONLY _document69 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document69 ALTER COLUMN _fld957rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document69 ALTER COLUMN _fld964rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document69 ALTER COLUMN _fld966rref SET STORAGE PLAIN;


--
-- Name: _document69_vt967; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document69_vt967 (
    _document69_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno968 numeric(5,0) NOT NULL,
    _fld969rref bytea NOT NULL,
    _fld970 numeric(5,2) NOT NULL,
    _fld971 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _document69_vt967 ALTER COLUMN _document69_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document69_vt967 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document69_vt967 ALTER COLUMN _fld969rref SET STORAGE PLAIN;


--
-- Name: _document69_vt972; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document69_vt972 (
    _document69_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno973 numeric(5,0) NOT NULL,
    _fld974 boolean NOT NULL,
    _fld975rref bytea NOT NULL,
    _fld976 timestamp without time zone NOT NULL,
    _fld977 timestamp without time zone NOT NULL
);
ALTER TABLE ONLY _document69_vt972 ALTER COLUMN _document69_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document69_vt972 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document69_vt972 ALTER COLUMN _fld975rref SET STORAGE PLAIN;


--
-- Name: _document69_vt978; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document69_vt978 (
    _document69_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno979 numeric(5,0) NOT NULL,
    _fld980rref bytea NOT NULL
);
ALTER TABLE ONLY _document69_vt978 ALTER COLUMN _document69_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document69_vt978 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document69_vt978 ALTER COLUMN _fld980rref SET STORAGE PLAIN;


--
-- Name: _document69_vt981; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document69_vt981 (
    _document69_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno982 numeric(5,0) NOT NULL,
    _fld983rref bytea NOT NULL
);
ALTER TABLE ONLY _document69_vt981 ALTER COLUMN _document69_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document69_vt981 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document69_vt981 ALTER COLUMN _fld983rref SET STORAGE PLAIN;


--
-- Name: _document69_vt984; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document69_vt984 (
    _document69_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno985 numeric(5,0) NOT NULL,
    _fld986rref bytea NOT NULL,
    _fld987 numeric(5,2) NOT NULL,
    _fld988 numeric(5,2) NOT NULL
);
ALTER TABLE ONLY _document69_vt984 ALTER COLUMN _document69_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document69_vt984 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document69_vt984 ALTER COLUMN _fld986rref SET STORAGE PLAIN;


--
-- Name: _document70; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document70 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld990rref bytea NOT NULL,
    _fld991rref bytea NOT NULL,
    _fld992 mvarchar NOT NULL,
    _fld993_type bytea NOT NULL,
    _fld993_rtref bytea NOT NULL,
    _fld993_rrref bytea NOT NULL
);
ALTER TABLE ONLY _document70 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document70 ALTER COLUMN _fld990rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document70 ALTER COLUMN _fld991rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document70 ALTER COLUMN _fld993_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document70 ALTER COLUMN _fld993_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _document70 ALTER COLUMN _fld993_rrref SET STORAGE PLAIN;


--
-- Name: _document70_vt994; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document70_vt994 (
    _document70_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno995 numeric(5,0) NOT NULL,
    _fld996rref bytea NOT NULL,
    _fld997 numeric(15,2) NOT NULL,
    _fld998rref bytea NOT NULL,
    _fld999 numeric(8,1) NOT NULL,
    _fld1000 numeric(8,2) NOT NULL
);
ALTER TABLE ONLY _document70_vt994 ALTER COLUMN _document70_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document70_vt994 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document70_vt994 ALTER COLUMN _fld996rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document70_vt994 ALTER COLUMN _fld998rref SET STORAGE PLAIN;


--
-- Name: _document71; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document71 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _numberprefix timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld1002rref bytea NOT NULL,
    _fld1003rref bytea NOT NULL,
    _fld1004 mvarchar(300) NOT NULL,
    _fld1005 boolean NOT NULL,
    _fld1006 boolean NOT NULL
);
ALTER TABLE ONLY _document71 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document71 ALTER COLUMN _fld1002rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document71 ALTER COLUMN _fld1003rref SET STORAGE PLAIN;


--
-- Name: _document71_vt1007; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document71_vt1007 (
    _document71_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno1008 numeric(5,0) NOT NULL,
    _fld1009rref bytea NOT NULL,
    _fld1010rref bytea NOT NULL,
    _fld1011 numeric(10,3) NOT NULL,
    _fld1012 numeric(15,3) NOT NULL,
    _fld1013 numeric(15,2) NOT NULL,
    _fld1014 numeric(15,2) NOT NULL,
    _fld1015 numeric(15,2) NOT NULL,
    _fld1016 numeric(15,2) NOT NULL,
    _fld1017 numeric(5,2) NOT NULL,
    _fld1018 numeric(5,2) NOT NULL,
    _fld1019rref bytea NOT NULL,
    _fld1020_type bytea NOT NULL,
    _fld1020_n numeric(15,2) NOT NULL,
    _fld1020_rrref bytea NOT NULL,
    _fld1021rref bytea NOT NULL,
    _fld1022 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _document71_vt1007 ALTER COLUMN _document71_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document71_vt1007 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document71_vt1007 ALTER COLUMN _fld1009rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document71_vt1007 ALTER COLUMN _fld1010rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document71_vt1007 ALTER COLUMN _fld1019rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document71_vt1007 ALTER COLUMN _fld1020_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document71_vt1007 ALTER COLUMN _fld1020_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document71_vt1007 ALTER COLUMN _fld1021rref SET STORAGE PLAIN;


--
-- Name: _document72; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document72 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld1024 timestamp without time zone NOT NULL,
    _fld1025 timestamp without time zone NOT NULL,
    _fld1026 numeric(15,2) NOT NULL,
    _fld1027 boolean NOT NULL,
    _fld1028rref bytea NOT NULL,
    _fld1029 numeric(15,2) NOT NULL,
    _fld1030rref bytea NOT NULL,
    _fld1031 boolean NOT NULL
);
ALTER TABLE ONLY _document72 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document72 ALTER COLUMN _fld1028rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document72 ALTER COLUMN _fld1030rref SET STORAGE PLAIN;


--
-- Name: _document72_vt1032; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document72_vt1032 (
    _document72_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno1033 numeric(5,0) NOT NULL,
    _fld1034rref bytea NOT NULL
);
ALTER TABLE ONLY _document72_vt1032 ALTER COLUMN _document72_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document72_vt1032 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document72_vt1032 ALTER COLUMN _fld1034rref SET STORAGE PLAIN;


--
-- Name: _document72_vt1035; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document72_vt1035 (
    _document72_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno1036 numeric(5,0) NOT NULL,
    _fld1037_type bytea NOT NULL,
    _fld1037_rtref bytea NOT NULL,
    _fld1037_rrref bytea NOT NULL
);
ALTER TABLE ONLY _document72_vt1035 ALTER COLUMN _document72_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document72_vt1035 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document72_vt1035 ALTER COLUMN _fld1037_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document72_vt1035 ALTER COLUMN _fld1037_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _document72_vt1035 ALTER COLUMN _fld1037_rrref SET STORAGE PLAIN;


--
-- Name: _document73; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document73 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _number mchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld1039rref bytea NOT NULL,
    _fld1040 mvarchar(300) NOT NULL
);
ALTER TABLE ONLY _document73 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document73 ALTER COLUMN _fld1039rref SET STORAGE PLAIN;


--
-- Name: _document73_vt1041; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document73_vt1041 (
    _document73_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno1042 numeric(5,0) NOT NULL,
    _fld1043 mvarchar(150) NOT NULL,
    _fld1044 bytea NOT NULL
);
ALTER TABLE ONLY _document73_vt1041 ALTER COLUMN _document73_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document73_vt1041 ALTER COLUMN _keyfield SET STORAGE PLAIN;


--
-- Name: _document74; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document74 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _number mvarchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld1046 mvarchar(100) NOT NULL,
    _fld1047 timestamp without time zone NOT NULL,
    _fld1048rref bytea NOT NULL,
    _fld1049rref bytea NOT NULL,
    _fld1050 numeric(4,1) NOT NULL,
    _fld1661rref bytea NOT NULL
);
ALTER TABLE ONLY _document74 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document74 ALTER COLUMN _fld1048rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document74 ALTER COLUMN _fld1049rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document74 ALTER COLUMN _fld1661rref SET STORAGE PLAIN;


--
-- Name: _document75; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document75 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _number mvarchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld1051 numeric(11,0) NOT NULL,
    _fld1052rref bytea NOT NULL,
    _fld1053 mvarchar NOT NULL,
    _fld1054rref bytea NOT NULL,
    _fld1055rref bytea NOT NULL,
    _fld1056 boolean NOT NULL,
    _fld1057 boolean NOT NULL,
    _fld1058rref bytea NOT NULL,
    _fld1059rref bytea NOT NULL,
    _fld1060 numeric(15,2) NOT NULL,
    _fld1061rref bytea NOT NULL,
    _fld1062rref bytea NOT NULL,
    _fld1063rref bytea NOT NULL,
    _fld1064rref bytea NOT NULL,
    _fld1065rref bytea NOT NULL,
    _fld1066 mvarchar NOT NULL,
    _fld1067 numeric(4,1) NOT NULL,
    _fld1068 timestamp without time zone NOT NULL,
    _fld1069 numeric(3,0) NOT NULL,
    _fld1070 mvarchar(20) NOT NULL,
    _fld1071 numeric(10,2) NOT NULL,
    _fld1072rref bytea NOT NULL,
    _fld1073 boolean NOT NULL
);
ALTER TABLE ONLY _document75 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1052rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1054rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1055rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1058rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1059rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1061rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1062rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1063rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1064rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1065rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75 ALTER COLUMN _fld1072rref SET STORAGE PLAIN;


--
-- Name: _document75_vt1074; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document75_vt1074 (
    _document75_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno1075 numeric(5,0) NOT NULL,
    _fld1076rref bytea NOT NULL,
    _fld1077 numeric(15,3) NOT NULL,
    _fld1078rref bytea NOT NULL,
    _fld1079 numeric(15,3) NOT NULL,
    _fld1080 numeric(15,2) NOT NULL,
    _fld1081 numeric(5,2) NOT NULL,
    _fld1082 numeric(5,2) NOT NULL,
    _fld1083 numeric(15,2) NOT NULL,
    _fld1084 numeric(15,2) NOT NULL,
    _fld1085 mvarchar(250) NOT NULL,
    _fld1086rref bytea NOT NULL,
    _fld1087rref bytea NOT NULL,
    _fld1088 numeric(15,2) NOT NULL,
    _fld1089 numeric(15,2) NOT NULL,
    _fld1090rref bytea NOT NULL,
    _fld1091 boolean NOT NULL,
    _fld1092 numeric(10,0) NOT NULL,
    _fld1093 mvarchar(150) NOT NULL,
    _fld1094 numeric(5,0) NOT NULL,
    _fld1095rref bytea NOT NULL,
    _fld1096 boolean NOT NULL,
    _fld1097 numeric(10,0) NOT NULL,
    _fld1098_type bytea NOT NULL,
    _fld1098_n numeric(10,0) NOT NULL,
    _fld1098_rrref bytea NOT NULL
);
ALTER TABLE ONLY _document75_vt1074 ALTER COLUMN _document75_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75_vt1074 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document75_vt1074 ALTER COLUMN _fld1076rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75_vt1074 ALTER COLUMN _fld1078rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75_vt1074 ALTER COLUMN _fld1086rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75_vt1074 ALTER COLUMN _fld1087rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75_vt1074 ALTER COLUMN _fld1090rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75_vt1074 ALTER COLUMN _fld1095rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document75_vt1074 ALTER COLUMN _fld1098_type SET STORAGE PLAIN;
ALTER TABLE ONLY _document75_vt1074 ALTER COLUMN _fld1098_rrref SET STORAGE PLAIN;


--
-- Name: _document76; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document76 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _number mvarchar(9) NOT NULL,
    _posted boolean NOT NULL,
    _fld1099rref bytea NOT NULL,
    _fld1100rref bytea NOT NULL,
    _fld1101rref bytea NOT NULL,
    _fld1102 numeric(10,2) NOT NULL
);
ALTER TABLE ONLY _document76 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document76 ALTER COLUMN _fld1099rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document76 ALTER COLUMN _fld1100rref SET STORAGE PLAIN;
ALTER TABLE ONLY _document76 ALTER COLUMN _fld1101rref SET STORAGE PLAIN;


--
-- Name: _document76_vt1103; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _document76_vt1103 (
    _document76_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno1104 numeric(5,0) NOT NULL,
    _fld1105rref bytea NOT NULL
);
ALTER TABLE ONLY _document76_vt1103 ALTER COLUMN _document76_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _document76_vt1103 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _document76_vt1103 ALTER COLUMN _fld1105rref SET STORAGE PLAIN;


--
-- Name: _documentchngr1001; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr1001 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr1001 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr1001 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr1001 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr1023; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr1023 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr1023 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr1023 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr1023 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr1038; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr1038 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr1038 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr1038 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr1038 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr1045; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr1045 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr1045 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr1045 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr1045 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr563; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr563 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr563 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr563 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr563 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr589; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr589 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr589 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr589 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr589 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr603; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr603 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr603 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr603 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr603 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr626; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr626 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr626 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr626 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr626 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr679; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr679 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr679 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr679 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr679 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr701; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr701 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr701 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr701 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr701 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr721; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr721 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr721 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr721 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr721 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr732; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr732 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr732 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr732 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr732 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr751; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr751 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr751 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr751 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr751 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr758; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr758 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr758 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr758 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr758 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr772; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr772 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr772 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr772 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr772 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr805; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr805 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr805 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr805 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr805 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr838; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr838 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr838 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr838 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr838 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr860; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr860 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr860 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr860 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr860 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr881; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr881 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr881 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr881 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr881 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr935; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr935 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr935 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr935 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr935 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr951; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr951 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr951 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr951 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr951 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentchngr989; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentchngr989 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _documentchngr989 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr989 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentchngr989 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _documentjournal1106; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentjournal1106 (
    _documenttref bytea NOT NULL,
    _documentrref bytea NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _marked boolean NOT NULL,
    _posted boolean NOT NULL,
    _number mchar(11) NOT NULL
);
ALTER TABLE ONLY _documentjournal1106 ALTER COLUMN _documenttref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1106 ALTER COLUMN _documentrref SET STORAGE PLAIN;


--
-- Name: _documentjournal1107; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentjournal1107 (
    _documenttref bytea NOT NULL,
    _documentrref bytea NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _marked boolean NOT NULL,
    _posted boolean NOT NULL,
    _number mchar(9) NOT NULL,
    _fld1108 numeric(15,2),
    _fld1109rref bytea,
    _fld1110rref bytea,
    _fld1111 mvarchar(300),
    _fld1112rref bytea
);
ALTER TABLE ONLY _documentjournal1107 ALTER COLUMN _documenttref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1107 ALTER COLUMN _documentrref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1107 ALTER COLUMN _fld1109rref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1107 ALTER COLUMN _fld1110rref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1107 ALTER COLUMN _fld1112rref SET STORAGE PLAIN;


--
-- Name: _documentjournal1113; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _documentjournal1113 (
    _documenttref bytea NOT NULL,
    _documentrref bytea NOT NULL,
    _date_time timestamp without time zone NOT NULL,
    _marked boolean NOT NULL,
    _posted boolean NOT NULL,
    _number mchar(11) NOT NULL,
    _fld1114rref bytea NOT NULL,
    _fld1115rref bytea,
    _fld1116_type bytea,
    _fld1116_rtref bytea,
    _fld1116_rrref bytea,
    _fld1117 numeric(15,2),
    _fld1118 mvarchar(300) NOT NULL
);
ALTER TABLE ONLY _documentjournal1113 ALTER COLUMN _documenttref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1113 ALTER COLUMN _documentrref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1113 ALTER COLUMN _fld1114rref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1113 ALTER COLUMN _fld1115rref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1113 ALTER COLUMN _fld1116_type SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1113 ALTER COLUMN _fld1116_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _documentjournal1113 ALTER COLUMN _fld1116_rrref SET STORAGE PLAIN;


--
-- Name: _dynlistsettings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _dynlistsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _dynlistsettings ALTER COLUMN _version SET STORAGE PLAIN;


--
-- Name: _enum100; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum100 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum100 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum101; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum101 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum101 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum102; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum102 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum102 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum103; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum103 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum103 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum104; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum104 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum104 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum105; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum105 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum105 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum106; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum106 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum106 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum107; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum107 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum107 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum108; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum108 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum108 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum109; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum109 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum109 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum110; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum110 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum110 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum111; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum111 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum111 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum112; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum112 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum112 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum113; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum113 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum113 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum114; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum114 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum114 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum115; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum115 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum115 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum116; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum116 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum116 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum117; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum117 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum117 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum118; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum118 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum118 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum119; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum119 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum119 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum120; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum120 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum120 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum121; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum121 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum121 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum122; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum122 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum122 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum123; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum123 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum123 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum124; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum124 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum124 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum125; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum125 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum125 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum126; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum126 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum126 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum77; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum77 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum77 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum78; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum78 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum78 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum79; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum79 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum79 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum80; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum80 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum80 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum81; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum81 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum81 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum82; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum82 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum82 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum83; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum83 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum83 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum84; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum84 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum84 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum85; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum85 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum85 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum86; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum86 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum86 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum87; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum87 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum87 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum88; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum88 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum88 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum89; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum89 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum89 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum90; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum90 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum90 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum91; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum91 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum91 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum92; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum92 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum92 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum93; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum93 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum93 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum94; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum94 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum94 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum95; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum95 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum95 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum96; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum96 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum96 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum97; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum97 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum97 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum98; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum98 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum98 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _enum99; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _enum99 (
    _idrref bytea NOT NULL,
    _enumorder numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _enum99 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _frmdtsettings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _frmdtsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _frmdtsettings ALTER COLUMN _version SET STORAGE PLAIN;


--
-- Name: _inforg1203; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1203 (
    _fld1204 numeric(1,0) NOT NULL,
    _fld1205 numeric(2,0) NOT NULL,
    _fld1206 numeric(25,0) NOT NULL,
    _fld1207 numeric(3,0) NOT NULL,
    _fld1208 numeric(3,0) NOT NULL,
    _fld1209 numeric(3,0) NOT NULL,
    _fld1210 numeric(4,0) NOT NULL,
    _fld1211 mvarchar(52) NOT NULL,
    _fld1212 mchar(12) NOT NULL,
    _fld1213 mchar(6) NOT NULL,
    _fld1214 mvarchar(50) NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1203 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1225; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1225 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1226rref bytea NOT NULL,
    _fld1662rref bytea NOT NULL,
    _fld1227 mvarchar(100) NOT NULL,
    _fld1228 timestamp without time zone NOT NULL,
    _fld1229rref bytea NOT NULL,
    _fld1230 numeric(4,1) NOT NULL,
    _fld1231 timestamp without time zone NOT NULL
);
ALTER TABLE ONLY _inforg1225 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1225 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1225 ALTER COLUMN _fld1226rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1225 ALTER COLUMN _fld1662rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1225 ALTER COLUMN _fld1229rref SET STORAGE PLAIN;


--
-- Name: _inforg1232; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1232 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1233rref bytea NOT NULL,
    _fld1234 timestamp without time zone NOT NULL,
    _fld1235 timestamp without time zone NOT NULL,
    _fld1236 timestamp without time zone NOT NULL,
    _fld1237 timestamp without time zone NOT NULL
);
ALTER TABLE ONLY _inforg1232 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1232 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1232 ALTER COLUMN _fld1233rref SET STORAGE PLAIN;


--
-- Name: _inforg1239; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1239 (
    _period timestamp without time zone NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1240rref bytea NOT NULL,
    _fld1241rref bytea NOT NULL,
    _fld1242rref bytea NOT NULL,
    _fld1243rref bytea NOT NULL
);
ALTER TABLE ONLY _inforg1239 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1239 ALTER COLUMN _fld1240rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1239 ALTER COLUMN _fld1241rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1239 ALTER COLUMN _fld1242rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1239 ALTER COLUMN _fld1243rref SET STORAGE PLAIN;


--
-- Name: _inforg1244; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1244 (
    _period timestamp without time zone NOT NULL,
    _fld1245_type bytea NOT NULL,
    _fld1245_rtref bytea NOT NULL,
    _fld1245_rrref bytea NOT NULL,
    _fld1246 boolean NOT NULL,
    _fld1247_type bytea NOT NULL,
    _fld1247_l boolean NOT NULL,
    _fld1247_n numeric(10,0) NOT NULL,
    _fld1248 numeric(5,0) NOT NULL,
    _fld1249 timestamp without time zone NOT NULL,
    _fld1250 timestamp without time zone NOT NULL,
    _fld1251_type bytea NOT NULL,
    _fld1251_l boolean NOT NULL,
    _fld1251_n numeric(10,0) NOT NULL,
    _fld1252_type bytea NOT NULL,
    _fld1252_l boolean NOT NULL,
    _fld1252_n numeric(10,0) NOT NULL,
    _fld1253_type bytea NOT NULL,
    _fld1253_l boolean NOT NULL,
    _fld1253_n numeric(10,0) NOT NULL,
    _fld1254 mvarchar NOT NULL,
    _fld1255 mvarchar NOT NULL,
    _fld1256 mvarchar NOT NULL,
    _fld1257 timestamp without time zone NOT NULL,
    _fld1258 timestamp without time zone NOT NULL
);
ALTER TABLE ONLY _inforg1244 ALTER COLUMN _fld1245_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1244 ALTER COLUMN _fld1245_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1244 ALTER COLUMN _fld1245_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1244 ALTER COLUMN _fld1247_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1244 ALTER COLUMN _fld1251_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1244 ALTER COLUMN _fld1252_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1244 ALTER COLUMN _fld1253_type SET STORAGE PLAIN;


--
-- Name: _inforg1263; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1263 (
    _fld1264rref bytea NOT NULL,
    _fld1265 mvarchar NOT NULL,
    _fld1266 mvarchar(10) NOT NULL
);
ALTER TABLE ONLY _inforg1263 ALTER COLUMN _fld1264rref SET STORAGE PLAIN;


--
-- Name: _inforg1268; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1268 (
    _fld1269 numeric(10,0) NOT NULL,
    _fld1270rref bytea NOT NULL
);
ALTER TABLE ONLY _inforg1268 ALTER COLUMN _fld1270rref SET STORAGE PLAIN;


--
-- Name: _inforg1273; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1273 (
    _fld1274_type bytea NOT NULL,
    _fld1274_s mvarchar(200) NOT NULL,
    _fld1274_rtref bytea NOT NULL,
    _fld1274_rrref bytea NOT NULL,
    _fld1275_type bytea NOT NULL,
    _fld1275_rtref bytea NOT NULL,
    _fld1275_rrref bytea NOT NULL,
    _fld1276 timestamp without time zone NOT NULL,
    _fld1277 mvarchar NOT NULL,
    _fld1278 mvarchar NOT NULL,
    _fld1279rref bytea NOT NULL,
    _fld1280rref bytea NOT NULL,
    _fld1281 boolean NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1273 ALTER COLUMN _fld1274_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1273 ALTER COLUMN _fld1274_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1273 ALTER COLUMN _fld1274_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1273 ALTER COLUMN _fld1275_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1273 ALTER COLUMN _fld1275_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1273 ALTER COLUMN _fld1275_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1273 ALTER COLUMN _fld1279rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1273 ALTER COLUMN _fld1280rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1273 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1286; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1286 (
    _fld1287rref bytea NOT NULL,
    _fld1288 numeric(2,0) NOT NULL,
    _fld1289 mvarchar NOT NULL,
    _fld1290 mvarchar(100) NOT NULL,
    _fld1291 mvarchar(100) NOT NULL,
    _fld1292 mvarchar(100) NOT NULL,
    _fld1293 mvarchar(100) NOT NULL,
    _fld1294 mvarchar(100) NOT NULL,
    _fld1295 mvarchar(100) NOT NULL,
    _fld1296 mvarchar(100) NOT NULL,
    _fld1297 mvarchar(100) NOT NULL,
    _fld1298 mvarchar(100) NOT NULL,
    _fld1299 mvarchar(100) NOT NULL,
    _fld1300 mvarchar NOT NULL,
    _fld1301 boolean NOT NULL,
    _fld1302 mvarchar(10) NOT NULL,
    _fld1303 mvarchar(10) NOT NULL,
    _fld1304 mvarchar(10) NOT NULL,
    _fld1305rref bytea NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1286 ALTER COLUMN _fld1287rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1286 ALTER COLUMN _fld1305rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1286 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1308; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1308 (
    _fld1309rref bytea NOT NULL,
    _fld1310rref bytea NOT NULL,
    _fld1311_type bytea NOT NULL,
    _fld1311_l boolean NOT NULL,
    _fld1311_n numeric(10,0) NOT NULL,
    _fld1311_t timestamp without time zone NOT NULL,
    _fld1311_s mvarchar(200) NOT NULL,
    _fld1311_rtref bytea NOT NULL,
    _fld1311_rrref bytea NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1308 ALTER COLUMN _fld1309rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1308 ALTER COLUMN _fld1310rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1308 ALTER COLUMN _fld1311_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1308 ALTER COLUMN _fld1311_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1308 ALTER COLUMN _fld1311_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1308 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1314; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1314 (
    _fld1315_type bytea NOT NULL,
    _fld1315_rtref bytea NOT NULL,
    _fld1315_rrref bytea NOT NULL,
    _fld1316 boolean NOT NULL,
    _fld1317 numeric(1,0) NOT NULL,
    _fld1318 mvarchar NOT NULL,
    _fld1319 mvarchar(50) NOT NULL,
    _fld1320 mvarchar NOT NULL,
    _fld1321 mvarchar NOT NULL,
    _fld1322 mvarchar(50) NOT NULL,
    _fld1323 numeric(10,0) NOT NULL,
    _fld1324 boolean NOT NULL,
    _fld1325 mvarchar(10) NOT NULL,
    _fld1326 mvarchar NOT NULL,
    _fld1327 boolean NOT NULL,
    _fld1328 boolean NOT NULL,
    _fld1329 numeric(10,0) NOT NULL,
    _fld1330 mvarchar(50) NOT NULL,
    _fld1331 boolean NOT NULL,
    _fld1332 mvarchar(50) NOT NULL,
    _fld1333 numeric(5,0) NOT NULL,
    _fld1334 mvarchar NOT NULL,
    _fld1335rref bytea NOT NULL,
    _fld1336 boolean NOT NULL,
    _fld1337 mvarchar(255) NOT NULL,
    _fld1338 numeric(10,0) NOT NULL,
    _fld1339 numeric(10,0) NOT NULL,
    _fld1340 mvarchar(50) NOT NULL,
    _fld1341rref bytea NOT NULL,
    _fld1342 mvarchar NOT NULL,
    _fld1343 mvarchar NOT NULL,
    _fld1344 mvarchar(50) NOT NULL,
    _fld1345 mvarchar(150) NOT NULL,
    _fld1346 mvarchar(50) NOT NULL
);
ALTER TABLE ONLY _inforg1314 ALTER COLUMN _fld1315_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1314 ALTER COLUMN _fld1315_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1314 ALTER COLUMN _fld1315_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1314 ALTER COLUMN _fld1335rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1314 ALTER COLUMN _fld1341rref SET STORAGE PLAIN;


--
-- Name: _inforg1347; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1347 (
    _fld1348_type bytea NOT NULL,
    _fld1348_rtref bytea NOT NULL,
    _fld1348_rrref bytea NOT NULL,
    _fld1349 boolean NOT NULL,
    _fld1350 boolean NOT NULL,
    _fld1351 numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _inforg1347 ALTER COLUMN _fld1348_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1347 ALTER COLUMN _fld1348_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1347 ALTER COLUMN _fld1348_rrref SET STORAGE PLAIN;


--
-- Name: _inforg1352; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1352 (
    _fld1353_type bytea NOT NULL,
    _fld1353_rtref bytea NOT NULL,
    _fld1353_rrref bytea NOT NULL,
    _fld1354_type bytea NOT NULL,
    _fld1354_rtref bytea NOT NULL,
    _fld1354_rrref bytea NOT NULL
);
ALTER TABLE ONLY _inforg1352 ALTER COLUMN _fld1353_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1352 ALTER COLUMN _fld1353_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1352 ALTER COLUMN _fld1353_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1352 ALTER COLUMN _fld1354_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1352 ALTER COLUMN _fld1354_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1352 ALTER COLUMN _fld1354_rrref SET STORAGE PLAIN;


--
-- Name: _inforg1356; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1356 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1357rref bytea NOT NULL,
    _fld1358 numeric(5,0) NOT NULL,
    _fld1359 numeric(5,0) NOT NULL,
    _fld1360 mvarchar(10) NOT NULL
);
ALTER TABLE ONLY _inforg1356 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1356 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1356 ALTER COLUMN _fld1357rref SET STORAGE PLAIN;


--
-- Name: _inforg1362; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1362 (
    _fld1363_type bytea NOT NULL,
    _fld1363_rtref bytea NOT NULL,
    _fld1363_rrref bytea NOT NULL,
    _fld1364_type bytea NOT NULL,
    _fld1364_rtref bytea NOT NULL,
    _fld1364_rrref bytea NOT NULL,
    _fld1365 timestamp without time zone NOT NULL,
    _fld1366 numeric(10,0) NOT NULL,
    _fld1367 mvarchar NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1362 ALTER COLUMN _fld1363_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1362 ALTER COLUMN _fld1363_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1362 ALTER COLUMN _fld1363_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1362 ALTER COLUMN _fld1364_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1362 ALTER COLUMN _fld1364_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1362 ALTER COLUMN _fld1364_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1362 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1372; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1372 (
    _fld1373_type bytea NOT NULL,
    _fld1373_rtref bytea NOT NULL,
    _fld1373_rrref bytea NOT NULL,
    _fld1374 timestamp without time zone NOT NULL,
    _fld1375 timestamp without time zone NOT NULL,
    _fld1376 boolean NOT NULL,
    _fld1377 boolean NOT NULL
);
ALTER TABLE ONLY _inforg1372 ALTER COLUMN _fld1373_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1372 ALTER COLUMN _fld1373_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1372 ALTER COLUMN _fld1373_rrref SET STORAGE PLAIN;


--
-- Name: _inforg1378; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1378 (
    _fld1379 mvarchar(150) NOT NULL,
    _fld1380rref bytea NOT NULL,
    _fld1381 bytea NOT NULL,
    _fld1382 bytea NOT NULL,
    _fld1383 mvarchar(255) NOT NULL,
    _fld1384 mvarchar(150) NOT NULL,
    _fld1385rref bytea NOT NULL,
    _fld1386 mvarchar NOT NULL,
    _fld1387 mvarchar(150) NOT NULL,
    _fld1388 boolean NOT NULL,
    _fld1389 boolean NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1378 ALTER COLUMN _fld1380rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1378 ALTER COLUMN _fld1385rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1378 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1390; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1390 (
    _fld1391 mvarchar(3) NOT NULL
);


--
-- Name: _inforg1392; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1392 (
    _period timestamp without time zone NOT NULL,
    _fld1393rref bytea NOT NULL,
    _fld1394rref bytea NOT NULL,
    _fld1395 numeric(15,2) NOT NULL
);
ALTER TABLE ONLY _inforg1392 ALTER COLUMN _fld1393rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1392 ALTER COLUMN _fld1394rref SET STORAGE PLAIN;


--
-- Name: _inforg1398; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1398 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1399rref bytea NOT NULL,
    _fld1400rref bytea NOT NULL,
    _fld1401 numeric(15,2) NOT NULL,
    _fld1402rref bytea NOT NULL,
    _fld1403 numeric(5,2) NOT NULL,
    _fld1404 numeric(5,2) NOT NULL,
    _fld1405 timestamp without time zone NOT NULL,
    _fld1406rref bytea NOT NULL
);
ALTER TABLE ONLY _inforg1398 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1398 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1398 ALTER COLUMN _fld1399rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1398 ALTER COLUMN _fld1400rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1398 ALTER COLUMN _fld1402rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1398 ALTER COLUMN _fld1406rref SET STORAGE PLAIN;


--
-- Name: _inforg1409; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1409 (
    _fld1410_type bytea NOT NULL,
    _fld1410_rtref bytea NOT NULL,
    _fld1410_rrref bytea NOT NULL,
    _fld1411_type bytea NOT NULL,
    _fld1411_rtref bytea NOT NULL,
    _fld1411_rrref bytea NOT NULL,
    _fld1412 mvarchar(100) NOT NULL,
    _fld1413 mvarchar(150) NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1409 ALTER COLUMN _fld1410_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1409 ALTER COLUMN _fld1410_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1409 ALTER COLUMN _fld1410_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1409 ALTER COLUMN _fld1411_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1409 ALTER COLUMN _fld1411_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1409 ALTER COLUMN _fld1411_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1409 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1417; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1417 (
    _fld1418_type bytea NOT NULL,
    _fld1418_rtref bytea NOT NULL,
    _fld1418_rrref bytea NOT NULL,
    _fld1419_type bytea NOT NULL,
    _fld1419_rtref bytea NOT NULL,
    _fld1419_rrref bytea NOT NULL,
    _fld1420 mvarchar(36) NOT NULL,
    _fld1421 mvarchar(100) NOT NULL,
    _fld1422 mvarchar(100) NOT NULL,
    _fld1423 mvarchar(36) NOT NULL,
    _fld1424 boolean NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1417 ALTER COLUMN _fld1418_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1417 ALTER COLUMN _fld1418_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1417 ALTER COLUMN _fld1418_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1417 ALTER COLUMN _fld1419_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1417 ALTER COLUMN _fld1419_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1417 ALTER COLUMN _fld1419_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1417 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1426; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1426 (
    _fld1427_type bytea NOT NULL,
    _fld1427_rtref bytea NOT NULL,
    _fld1427_rrref bytea NOT NULL,
    _fld1428rref bytea NOT NULL,
    _fld1429rref bytea NOT NULL,
    _fld1430 timestamp without time zone NOT NULL,
    _fld1431 timestamp without time zone NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1426 ALTER COLUMN _fld1427_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1426 ALTER COLUMN _fld1427_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1426 ALTER COLUMN _fld1427_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1426 ALTER COLUMN _fld1428rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1426 ALTER COLUMN _fld1429rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1426 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1432; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1432 (
    _fld1433_type bytea NOT NULL,
    _fld1433_rtref bytea NOT NULL,
    _fld1433_rrref bytea NOT NULL,
    _fld1434rref bytea NOT NULL,
    _fld1435 timestamp without time zone NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1432 ALTER COLUMN _fld1433_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1432 ALTER COLUMN _fld1433_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1432 ALTER COLUMN _fld1433_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1432 ALTER COLUMN _fld1434rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1432 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1436; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1436 (
    _fld1437rref bytea NOT NULL,
    _fld1438 numeric(15,0) NOT NULL,
    _fld1439 numeric(5,1) NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1436 ALTER COLUMN _fld1437rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1436 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1441; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1441 (
    _fld1442 numeric(11,0) NOT NULL,
    _fld1443rref bytea NOT NULL
);
ALTER TABLE ONLY _inforg1441 ALTER COLUMN _fld1443rref SET STORAGE PLAIN;


--
-- Name: _inforg1445; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1445 (
    _fld1446 mchar(36) NOT NULL,
    _fld1447 mvarchar NOT NULL,
    _fld1448rref bytea NOT NULL,
    _fld1449rref bytea NOT NULL,
    _fld1450 mvarchar(100) NOT NULL,
    _fld1451rref bytea NOT NULL,
    _fld1452 boolean NOT NULL
);
ALTER TABLE ONLY _inforg1445 ALTER COLUMN _fld1448rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1445 ALTER COLUMN _fld1449rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1445 ALTER COLUMN _fld1451rref SET STORAGE PLAIN;


--
-- Name: _inforg1456; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1456 (
    _fld1457 mvarchar(50) NOT NULL,
    _fld1458rref bytea NOT NULL,
    _fld1459rref bytea NOT NULL,
    _fld1460 numeric(10,0) NOT NULL,
    _fld1461 boolean NOT NULL,
    _fld1462 mvarchar NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1456 ALTER COLUMN _fld1458rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1456 ALTER COLUMN _fld1459rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1456 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforg1466; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1466 (
    _period timestamp without time zone NOT NULL,
    _fld1467rref bytea NOT NULL,
    _fld1468 boolean NOT NULL,
    _fld1469rref bytea NOT NULL,
    _fld1470 boolean NOT NULL,
    _fld1471 boolean NOT NULL
);
ALTER TABLE ONLY _inforg1466 ALTER COLUMN _fld1467rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1466 ALTER COLUMN _fld1469rref SET STORAGE PLAIN;


--
-- Name: _inforg1475; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1475 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL,
    _lineno numeric(9,0) NOT NULL,
    _active boolean NOT NULL,
    _fld1476rref bytea NOT NULL,
    _fld1477rref bytea NOT NULL,
    _fld1478rref bytea NOT NULL,
    _fld1479 numeric(15,2) NOT NULL,
    _fld1480rref bytea NOT NULL,
    _fld1481 numeric(10,2) NOT NULL
);
ALTER TABLE ONLY _inforg1475 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1475 ALTER COLUMN _recorderrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1475 ALTER COLUMN _fld1476rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1475 ALTER COLUMN _fld1477rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1475 ALTER COLUMN _fld1478rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1475 ALTER COLUMN _fld1480rref SET STORAGE PLAIN;


--
-- Name: _inforg1485; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1485 (
    _fld1486 numeric(10,0) NOT NULL,
    _fld1487rref bytea NOT NULL,
    _fld1488 mvarchar(200) NOT NULL,
    _fld1489_type bytea NOT NULL,
    _fld1489_rtref bytea NOT NULL,
    _fld1489_rrref bytea NOT NULL,
    _fld1490rref bytea NOT NULL
);
ALTER TABLE ONLY _inforg1485 ALTER COLUMN _fld1487rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1485 ALTER COLUMN _fld1489_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1485 ALTER COLUMN _fld1489_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1485 ALTER COLUMN _fld1489_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1485 ALTER COLUMN _fld1490rref SET STORAGE PLAIN;


--
-- Name: _inforg1494; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1494 (
    _fld1495rref bytea NOT NULL,
    _fld1496 mvarchar(10) NOT NULL
);
ALTER TABLE ONLY _inforg1494 ALTER COLUMN _fld1495rref SET STORAGE PLAIN;


--
-- Name: _inforg1497; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforg1497 (
    _fld1498rref bytea NOT NULL,
    _fld1499rref bytea NOT NULL,
    _fld1500rref bytea NOT NULL,
    _fld1501rref bytea NOT NULL,
    _fld1502rref bytea NOT NULL,
    _fld1503 mvarchar(255) NOT NULL,
    _fld1504 mvarchar(255) NOT NULL,
    _fld1505 mvarchar(255) NOT NULL,
    _fld1506 mvarchar(255) NOT NULL,
    _fld1507 mvarchar(255) NOT NULL,
    _fld1508rref bytea NOT NULL,
    _fld1509 mvarchar(255) NOT NULL,
    _fld1510rref bytea NOT NULL,
    _fld1511rref bytea NOT NULL,
    _fld1512rref bytea NOT NULL,
    _simplekey bytea NOT NULL
);
ALTER TABLE ONLY _inforg1497 ALTER COLUMN _fld1498rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1497 ALTER COLUMN _fld1499rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1497 ALTER COLUMN _fld1500rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1497 ALTER COLUMN _fld1501rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1497 ALTER COLUMN _fld1502rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1497 ALTER COLUMN _fld1508rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1497 ALTER COLUMN _fld1510rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1497 ALTER COLUMN _fld1511rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1497 ALTER COLUMN _fld1512rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforg1497 ALTER COLUMN _simplekey SET STORAGE PLAIN;


--
-- Name: _inforgchngr1224; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1224 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _fld1204 numeric(1,0),
    _fld1205 numeric(2,0),
    _fld1206 numeric(25,0),
    _fld1207 numeric(3,0),
    _fld1208 numeric(3,0),
    _fld1209 numeric(3,0),
    _fld1210 numeric(4,0)
);
ALTER TABLE ONLY _inforgchngr1224 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1224 ALTER COLUMN _noderref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1238; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1238 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _inforgchngr1238 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1238 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1238 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1238 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1262; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1262 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _period timestamp without time zone,
    _fld1245_type bytea,
    _fld1245_rtref bytea,
    _fld1245_rrref bytea,
    _fld1246 boolean
);
ALTER TABLE ONLY _inforgchngr1262 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1262 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1262 ALTER COLUMN _fld1245_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1262 ALTER COLUMN _fld1245_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1262 ALTER COLUMN _fld1245_rrref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1267; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1267 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _fld1264rref bytea
);
ALTER TABLE ONLY _inforgchngr1267 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1267 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1267 ALTER COLUMN _fld1264rref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1272; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1272 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _fld1269 numeric(10,0)
);
ALTER TABLE ONLY _inforgchngr1272 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1272 ALTER COLUMN _noderref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1307; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1307 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _fld1287rref bytea,
    _fld1288 numeric(2,0)
);
ALTER TABLE ONLY _inforgchngr1307 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1307 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1307 ALTER COLUMN _fld1287rref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1313; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1313 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _fld1309rref bytea,
    _fld1310rref bytea
);
ALTER TABLE ONLY _inforgchngr1313 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1313 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1313 ALTER COLUMN _fld1309rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1313 ALTER COLUMN _fld1310rref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1361; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1361 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _inforgchngr1361 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1361 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1361 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1361 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1371; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1371 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _fld1363_type bytea,
    _fld1363_rtref bytea,
    _fld1363_rrref bytea,
    _fld1364_type bytea,
    _fld1364_rtref bytea,
    _fld1364_rrref bytea
);
ALTER TABLE ONLY _inforgchngr1371 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1371 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1371 ALTER COLUMN _fld1363_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1371 ALTER COLUMN _fld1363_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1371 ALTER COLUMN _fld1363_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1371 ALTER COLUMN _fld1364_type SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1371 ALTER COLUMN _fld1364_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1371 ALTER COLUMN _fld1364_rrref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1397; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1397 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _period timestamp without time zone,
    _fld1393rref bytea,
    _fld1394rref bytea
);
ALTER TABLE ONLY _inforgchngr1397 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1397 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1397 ALTER COLUMN _fld1393rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1397 ALTER COLUMN _fld1394rref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1408; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1408 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _inforgchngr1408 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1408 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1408 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1408 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1440; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1440 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _fld1437rref bytea,
    _fld1438 numeric(15,0)
);
ALTER TABLE ONLY _inforgchngr1440 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1440 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1440 ALTER COLUMN _fld1437rref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1444; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1444 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _fld1442 numeric(11,0)
);
ALTER TABLE ONLY _inforgchngr1444 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1444 ALTER COLUMN _noderref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1465; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1465 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _fld1457 mvarchar(50),
    _fld1458rref bytea,
    _fld1459rref bytea,
    _fld1460 numeric(10,0)
);
ALTER TABLE ONLY _inforgchngr1465 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1465 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1465 ALTER COLUMN _fld1458rref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1465 ALTER COLUMN _fld1459rref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1474; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1474 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _period timestamp without time zone,
    _fld1467rref bytea
);
ALTER TABLE ONLY _inforgchngr1474 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1474 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1474 ALTER COLUMN _fld1467rref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1484; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1484 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _inforgchngr1484 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1484 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1484 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1484 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _inforgchngr1493; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _inforgchngr1493 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _fld1486 numeric(10,0)
);
ALTER TABLE ONLY _inforgchngr1493 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _inforgchngr1493 ALTER COLUMN _noderref SET STORAGE PLAIN;


--
-- Name: _node10; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _node10 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL,
    _sentno numeric(10,0) NOT NULL,
    _receivedno numeric(10,0) NOT NULL,
    _predefinedid bytea NOT NULL
);
ALTER TABLE ONLY _node10 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _node10 ALTER COLUMN _predefinedid SET STORAGE PLAIN;


--
-- Name: _node11; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _node11 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL,
    _sentno numeric(10,0) NOT NULL,
    _receivedno numeric(10,0) NOT NULL,
    _predefinedid bytea NOT NULL
);
ALTER TABLE ONLY _node11 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _node11 ALTER COLUMN _predefinedid SET STORAGE PLAIN;


--
-- Name: _node9; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _node9 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _code mchar(20) NOT NULL,
    _description mvarchar(50) NOT NULL,
    _sentno numeric(10,0) NOT NULL,
    _receivedno numeric(10,0) NOT NULL,
    _predefinedid bytea NOT NULL
);
ALTER TABLE ONLY _node9 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _node9 ALTER COLUMN _predefinedid SET STORAGE PLAIN;


--
-- Name: _reference12; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference12 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _owneridrref bytea NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL,
    _fld133rref bytea NOT NULL,
    _fld134 numeric(10,3) NOT NULL,
    _fld135 numeric(15,3) NOT NULL,
    _fld136 numeric(15,3) NOT NULL
);
ALTER TABLE ONLY _reference12 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference12 ALTER COLUMN _owneridrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference12 ALTER COLUMN _fld133rref SET STORAGE PLAIN;


--
-- Name: _reference13; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference13 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(50) NOT NULL,
    _fld138 mvarchar(150),
    _fld139_type bytea,
    _fld139_rtref bytea,
    _fld139_rrref bytea,
    _fld140 boolean,
    _fld141 numeric(6,2),
    _fld142rref bytea,
    _fld143rref bytea,
    _fld144rref bytea,
    _fld145rref bytea,
    _fld146 boolean
);
ALTER TABLE ONLY _reference13 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference13 ALTER COLUMN _parentidrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference13 ALTER COLUMN _fld139_type SET STORAGE PLAIN;
ALTER TABLE ONLY _reference13 ALTER COLUMN _fld139_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference13 ALTER COLUMN _fld139_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference13 ALTER COLUMN _fld142rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference13 ALTER COLUMN _fld143rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference13 ALTER COLUMN _fld144rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference13 ALTER COLUMN _fld145rref SET STORAGE PLAIN;


--
-- Name: _reference14; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference14 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(150) NOT NULL,
    _fld148rref bytea
);
ALTER TABLE ONLY _reference14 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference14 ALTER COLUMN _parentidrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference14 ALTER COLUMN _fld148rref SET STORAGE PLAIN;


--
-- Name: _reference15; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference15 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _owneridrref bytea NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(50) NOT NULL,
    _fld150 boolean NOT NULL
);
ALTER TABLE ONLY _reference15 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference15 ALTER COLUMN _owneridrref SET STORAGE PLAIN;


--
-- Name: _reference16; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference16 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL,
    _fld152 mvarchar NOT NULL
);
ALTER TABLE ONLY _reference16 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference17; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference17 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(150) NOT NULL,
    _fld154 mvarchar,
    _fld155 mvarchar(12),
    _fld156 mvarchar(150),
    _fld157 mvarchar(150),
    _fld158 mvarchar(150),
    _fld159 mvarchar,
    _fld160 mvarchar(20),
    _fld161 mvarchar(20),
    _fld162 mvarchar(20),
    _fld163 numeric(10,0),
    _fld164 timestamp without time zone,
    _fld165 boolean,
    _fld166 bytea,
    _fld167 boolean
);
ALTER TABLE ONLY _reference17 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference17 ALTER COLUMN _parentidrref SET STORAGE PLAIN;


--
-- Name: _reference18; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference18 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(6) NOT NULL,
    _description mvarchar(150) NOT NULL,
    _fld169 boolean NOT NULL,
    _fld170 boolean NOT NULL,
    _fld171 boolean NOT NULL,
    _fld172rref bytea NOT NULL,
    _fld173 boolean NOT NULL,
    _fld174 boolean NOT NULL,
    _fld175 mvarchar(255) NOT NULL,
    _fld176 mvarchar(255) NOT NULL,
    _fld177 numeric(10,0) NOT NULL,
    _fld178 numeric(10,0) NOT NULL,
    _fld179 mvarchar(10) NOT NULL,
    _fld180 mvarchar(100) NOT NULL,
    _fld181 mvarchar NOT NULL,
    _fld182 mvarchar(40) NOT NULL
);
ALTER TABLE ONLY _reference18 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference18 ALTER COLUMN _fld172rref SET STORAGE PLAIN;


--
-- Name: _reference18_vt183; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference18_vt183 (
    _reference18_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno184 numeric(5,0) NOT NULL,
    _fld185rref bytea NOT NULL,
    _fld186rref bytea NOT NULL
);
ALTER TABLE ONLY _reference18_vt183 ALTER COLUMN _reference18_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference18_vt183 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference18_vt183 ALTER COLUMN _fld185rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference18_vt183 ALTER COLUMN _fld186rref SET STORAGE PLAIN;


--
-- Name: _reference18_vt188; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference18_vt188 (
    _reference18_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno189 numeric(5,0) NOT NULL,
    _fld190 mvarchar(512) NOT NULL
);
ALTER TABLE ONLY _reference18_vt188 ALTER COLUMN _reference18_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference18_vt188 ALTER COLUMN _keyfield SET STORAGE PLAIN;


--
-- Name: _reference19; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference19 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(3) NOT NULL,
    _description mvarchar(150) NOT NULL,
    _fld192_type bytea NOT NULL,
    _fld192_rtref bytea NOT NULL,
    _fld192_rrref bytea NOT NULL,
    _fld193rref bytea NOT NULL,
    _fld194 boolean NOT NULL,
    _fld195 boolean NOT NULL,
    _fld196 boolean NOT NULL,
    _fld197 boolean NOT NULL,
    _fld198 boolean NOT NULL,
    _fld199 boolean NOT NULL,
    _fld200 boolean NOT NULL,
    _fld201 mvarchar NOT NULL,
    _fld202 mvarchar NOT NULL,
    _fld203 mvarchar NOT NULL,
    _fld204 bytea NOT NULL,
    _fld205 boolean NOT NULL,
    _fld206 timestamp without time zone NOT NULL,
    _fld207 timestamp without time zone NOT NULL,
    _fld208 timestamp without time zone NOT NULL,
    _fld209 timestamp without time zone NOT NULL,
    _fld210 boolean NOT NULL,
    _fld211 boolean NOT NULL,
    _fld212 numeric(15,0) NOT NULL,
    _fld213 boolean NOT NULL,
    _fld214 numeric(10,0) NOT NULL,
    _fld215 mvarchar(36) NOT NULL,
    _fld216_type bytea NOT NULL,
    _fld216_rtref bytea NOT NULL,
    _fld216_rrref bytea NOT NULL,
    _fld217 boolean NOT NULL,
    _fld218 boolean NOT NULL,
    _fld219 numeric(10,0) NOT NULL,
    _fld220 numeric(10,0) NOT NULL,
    _fld221 mvarchar NOT NULL,
    _fld222 mvarchar NOT NULL,
    _fld223 mvarchar NOT NULL,
    _fld224 mvarchar NOT NULL,
    _fld225 numeric(10,0) NOT NULL,
    _fld226 mvarchar(50) NOT NULL,
    _fld227 mvarchar(50) NOT NULL,
    _fld228 numeric(10,0) NOT NULL,
    _fld229 boolean NOT NULL,
    _fld230_type bytea NOT NULL,
    _fld230_rtref bytea NOT NULL,
    _fld230_rrref bytea NOT NULL,
    _fld231 bytea NOT NULL,
    _fld232 numeric(10,0) NOT NULL,
    _fld233 numeric(10,0) NOT NULL,
    _fld234 boolean NOT NULL,
    _fld235 boolean NOT NULL,
    _fld236 mvarchar NOT NULL,
    _fld237 mvarchar NOT NULL,
    _fld238 mvarchar NOT NULL,
    _fld239 boolean NOT NULL,
    _fld240 mvarchar NOT NULL,
    _fld241 mvarchar NOT NULL,
    _fld242 mvarchar(5) NOT NULL,
    _fld243 boolean NOT NULL,
    _fld244 mvarchar(255) NOT NULL,
    _fld245_type bytea NOT NULL,
    _fld245_rtref bytea NOT NULL,
    _fld245_rrref bytea NOT NULL,
    _fld246 boolean NOT NULL,
    _fld247 numeric(10,0) NOT NULL,
    _fld248 boolean NOT NULL,
    _fld249 boolean NOT NULL,
    _fld250 mvarchar(40) NOT NULL,
    _fld251 mvarchar(40) NOT NULL,
    _fld252 mvarchar(255) NOT NULL,
    _fld253 boolean NOT NULL,
    _fld254 boolean NOT NULL,
    _fld255 mvarchar(255) NOT NULL,
    _fld256 boolean NOT NULL,
    _fld257 boolean NOT NULL,
    _fld258 mvarchar(40) NOT NULL,
    _fld259 mvarchar NOT NULL,
    _fld260 mvarchar(10) NOT NULL,
    _fld261 boolean NOT NULL,
    _fld262 numeric(10,0) NOT NULL,
    _fld263 mvarchar(10) NOT NULL,
    _fld264 mvarchar(100) NOT NULL,
    _fld265 boolean NOT NULL,
    _fld266 boolean NOT NULL,
    _fld267 mvarchar(50) NOT NULL,
    _fld268 mvarchar(50) NOT NULL,
    _fld269 mvarchar(50) NOT NULL,
    _fld270 numeric(10,0) NOT NULL,
    _fld271 mvarchar(50) NOT NULL
);
ALTER TABLE ONLY _reference19 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld192_type SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld192_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld192_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld193rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld216_type SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld216_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld216_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld230_type SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld230_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld230_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld245_type SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld245_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19 ALTER COLUMN _fld245_rrref SET STORAGE PLAIN;


--
-- Name: _reference19_vt272; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference19_vt272 (
    _reference19_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno273 numeric(5,0) NOT NULL,
    _fld274 mvarchar(512) NOT NULL
);
ALTER TABLE ONLY _reference19_vt272 ALTER COLUMN _reference19_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19_vt272 ALTER COLUMN _keyfield SET STORAGE PLAIN;


--
-- Name: _reference19_vt275; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference19_vt275 (
    _reference19_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno276 numeric(5,0) NOT NULL,
    _fld277 mvarchar(150) NOT NULL,
    _fld278 mvarchar(150) NOT NULL,
    _fld279 mvarchar(150) NOT NULL,
    _fld280 mvarchar NOT NULL,
    _fld281 mvarchar NOT NULL,
    _fld282 boolean NOT NULL,
    _fld283 boolean NOT NULL,
    _fld284 boolean NOT NULL
);
ALTER TABLE ONLY _reference19_vt275 ALTER COLUMN _reference19_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19_vt275 ALTER COLUMN _keyfield SET STORAGE PLAIN;


--
-- Name: _reference19_vt289; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference19_vt289 (
    _reference19_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno290 numeric(5,0) NOT NULL,
    _fld291 mvarchar(150) NOT NULL,
    _fld292 mvarchar(150) NOT NULL,
    _fld293 mvarchar(150) NOT NULL,
    _fld294 boolean NOT NULL,
    _fld295 boolean NOT NULL,
    _fld296 boolean NOT NULL,
    _fld297 boolean NOT NULL
);
ALTER TABLE ONLY _reference19_vt289 ALTER COLUMN _reference19_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference19_vt289 ALTER COLUMN _keyfield SET STORAGE PLAIN;


--
-- Name: _reference20; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference20 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(11) NOT NULL,
    _description mvarchar(100) NOT NULL,
    _fld304rref bytea,
    _fld305 boolean,
    _fld306rref bytea,
    _fld307rref bytea,
    _fld308rref bytea,
    _fld309 mvarchar(5),
    _fld310 mvarchar,
    _fld311 mvarchar,
    _fld312rref bytea,
    _fld313rref bytea,
    _fld314 boolean,
    _fld315 bytea,
    _fld316 numeric(5,2),
    _fld317 numeric(5,2),
    _fld318 boolean,
    _fld319 boolean,
    _fld320rref bytea,
    _fld321 boolean,
    _fld322rref bytea,
    _fld323 boolean,
    _fld324 boolean
);
ALTER TABLE ONLY _reference20 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20 ALTER COLUMN _parentidrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20 ALTER COLUMN _fld304rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20 ALTER COLUMN _fld306rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20 ALTER COLUMN _fld307rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20 ALTER COLUMN _fld308rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20 ALTER COLUMN _fld312rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20 ALTER COLUMN _fld313rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20 ALTER COLUMN _fld320rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20 ALTER COLUMN _fld322rref SET STORAGE PLAIN;


--
-- Name: _reference20_vt325; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference20_vt325 (
    _reference20_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno326 numeric(5,0) NOT NULL,
    _fld327rref bytea NOT NULL,
    _fld328 numeric(5,2) NOT NULL
);
ALTER TABLE ONLY _reference20_vt325 ALTER COLUMN _reference20_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20_vt325 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20_vt325 ALTER COLUMN _fld327rref SET STORAGE PLAIN;


--
-- Name: _reference20_vt329; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference20_vt329 (
    _reference20_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno330 numeric(5,0) NOT NULL,
    _fld331rref bytea NOT NULL,
    _fld332rref bytea NOT NULL,
    _fld333 numeric(10,2) NOT NULL,
    _fld334 boolean NOT NULL
);
ALTER TABLE ONLY _reference20_vt329 ALTER COLUMN _reference20_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20_vt329 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20_vt329 ALTER COLUMN _fld331rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20_vt329 ALTER COLUMN _fld332rref SET STORAGE PLAIN;


--
-- Name: _reference20_vt335; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference20_vt335 (
    _reference20_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno336 numeric(5,0) NOT NULL,
    _fld337rref bytea NOT NULL,
    _fld338rref bytea NOT NULL,
    _fld339 numeric(10,0) NOT NULL,
    _fld340rref bytea NOT NULL,
    _fld341 boolean NOT NULL
);
ALTER TABLE ONLY _reference20_vt335 ALTER COLUMN _reference20_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20_vt335 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20_vt335 ALTER COLUMN _fld337rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20_vt335 ALTER COLUMN _fld338rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference20_vt335 ALTER COLUMN _fld340rref SET STORAGE PLAIN;


--
-- Name: _reference21; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference21 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(50) NOT NULL,
    _fld343 mvarchar NOT NULL,
    _fld344rref bytea NOT NULL,
    _fld345 mvarchar(256) NOT NULL,
    _fld346 bytea NOT NULL,
    _fld347 numeric(10,2) NOT NULL,
    _fld348 mchar(36) NOT NULL,
    _fld349 numeric(10,2) NOT NULL
);
ALTER TABLE ONLY _reference21 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference21 ALTER COLUMN _fld344rref SET STORAGE PLAIN;


--
-- Name: _reference21_vt350; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference21_vt350 (
    _reference21_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno351 numeric(5,0) NOT NULL,
    _fld352 mvarchar(256) NOT NULL
);
ALTER TABLE ONLY _reference21_vt350 ALTER COLUMN _reference21_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference21_vt350 ALTER COLUMN _keyfield SET STORAGE PLAIN;


--
-- Name: _reference22; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference22 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(150) NOT NULL
);
ALTER TABLE ONLY _reference22 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference23; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference23 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(150) NOT NULL
);
ALTER TABLE ONLY _reference23 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference24; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference24 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _owneridrref bytea NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(150) NOT NULL,
    _fld357 mvarchar(5) NOT NULL,
    _fld358 numeric(15,3) NOT NULL,
    _fld359 mvarchar NOT NULL,
    _fld360 timestamp without time zone NOT NULL,
    _fld361 mvarchar NOT NULL,
    _fld362rref bytea NOT NULL,
    _fld363rref bytea NOT NULL,
    _fld364 numeric(5,0) NOT NULL
);
ALTER TABLE ONLY _reference24 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24 ALTER COLUMN _owneridrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24 ALTER COLUMN _fld362rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24 ALTER COLUMN _fld363rref SET STORAGE PLAIN;


--
-- Name: _reference24_vt365; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference24_vt365 (
    _reference24_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno366 numeric(5,0) NOT NULL,
    _fld367rref bytea NOT NULL,
    _fld368rref bytea NOT NULL,
    _fld369rref bytea NOT NULL,
    _fld370 numeric(10,3) NOT NULL,
    _fld371 numeric(15,3) NOT NULL,
    _fld372 numeric(15,3) NOT NULL,
    _fld373 numeric(5,2) NOT NULL,
    _fld374 numeric(5,2) NOT NULL,
    _fld375 numeric(18,6) NOT NULL,
    _fld376 boolean NOT NULL
);
ALTER TABLE ONLY _reference24_vt365 ALTER COLUMN _reference24_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24_vt365 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24_vt365 ALTER COLUMN _fld367rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24_vt365 ALTER COLUMN _fld368rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24_vt365 ALTER COLUMN _fld369rref SET STORAGE PLAIN;


--
-- Name: _reference24_vt377; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference24_vt377 (
    _reference24_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno378 numeric(5,0) NOT NULL,
    _fld379rref bytea NOT NULL,
    _fld380rref bytea NOT NULL,
    _fld381 numeric(15,3) NOT NULL,
    _fld382 numeric(15,3) NOT NULL,
    _fld383rref bytea NOT NULL,
    _fld384 numeric(3,0) NOT NULL,
    _fld385 boolean NOT NULL
);
ALTER TABLE ONLY _reference24_vt377 ALTER COLUMN _reference24_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24_vt377 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24_vt377 ALTER COLUMN _fld379rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24_vt377 ALTER COLUMN _fld380rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference24_vt377 ALTER COLUMN _fld383rref SET STORAGE PLAIN;


--
-- Name: _reference25; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference25 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(50) NOT NULL,
    _fld389 mvarchar(3) NOT NULL,
    _fld390 mvarchar NOT NULL,
    _fld391 mvarchar NOT NULL,
    _fld392 mvarchar(12) NOT NULL,
    _fld393 mvarchar(10) NOT NULL,
    _fld394 mvarchar(9) NOT NULL,
    _fld395rref bytea NOT NULL
);
ALTER TABLE ONLY _reference25 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference25 ALTER COLUMN _fld395rref SET STORAGE PLAIN;


--
-- Name: _reference26; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference26 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(50) NOT NULL,
    _description mvarchar(100) NOT NULL,
    _fld397rref bytea,
    _fld398 boolean,
    _fld399 boolean,
    _fld400 mvarchar(30)
);
ALTER TABLE ONLY _reference26 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference26 ALTER COLUMN _parentidrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference26 ALTER COLUMN _fld397rref SET STORAGE PLAIN;


--
-- Name: _reference27; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference27 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _owneridrref bytea NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(150) NOT NULL,
    _fld402 numeric(5,0) NOT NULL,
    _fld403 numeric(5,0) NOT NULL,
    _fld404 mvarchar(4) NOT NULL,
    _fld405 numeric(4,0) NOT NULL,
    _fld406 numeric(4,0) NOT NULL
);
ALTER TABLE ONLY _reference27 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference27 ALTER COLUMN _owneridrref SET STORAGE PLAIN;


--
-- Name: _reference28; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference28 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(50) NOT NULL,
    _fld411 boolean NOT NULL,
    _fld412 boolean NOT NULL,
    _fld413 numeric(15,2) NOT NULL,
    _fld414 timestamp without time zone NOT NULL,
    _fld415 timestamp without time zone NOT NULL,
    _fld416 numeric(15,2) NOT NULL,
    _fld417 numeric(15,2) NOT NULL,
    _fld418rref bytea NOT NULL
);
ALTER TABLE ONLY _reference28 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference28 ALTER COLUMN _fld418rref SET STORAGE PLAIN;


--
-- Name: _reference28_vt419; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference28_vt419 (
    _reference28_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno420 numeric(5,0) NOT NULL,
    _fld421 boolean NOT NULL,
    _fld422rref bytea NOT NULL,
    _fld423 timestamp without time zone NOT NULL,
    _fld424 timestamp without time zone NOT NULL
);
ALTER TABLE ONLY _reference28_vt419 ALTER COLUMN _reference28_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference28_vt419 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference28_vt419 ALTER COLUMN _fld422rref SET STORAGE PLAIN;


--
-- Name: _reference29; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference29 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(50) NOT NULL,
    _fld426rref bytea,
    _fld427 numeric(1,0),
    _fld428 mvarchar,
    _fld429rref bytea,
    _fld430 boolean,
    _fld431rref bytea,
    _fld432 mvarchar
);
ALTER TABLE ONLY _reference29 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference29 ALTER COLUMN _parentidrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference29 ALTER COLUMN _fld426rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference29 ALTER COLUMN _fld429rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference29 ALTER COLUMN _fld431rref SET STORAGE PLAIN;


--
-- Name: _reference30; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference30 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(100) NOT NULL,
    _fld434rref bytea NOT NULL,
    _fld435 mvarchar NOT NULL,
    _fld436rref bytea NOT NULL,
    _fld437 mvarchar(20) NOT NULL,
    _fld438 numeric(3,0) NOT NULL,
    _fld439 boolean NOT NULL
);
ALTER TABLE ONLY _reference30 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference30 ALTER COLUMN _fld434rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference30 ALTER COLUMN _fld436rref SET STORAGE PLAIN;


--
-- Name: _reference30_vt440; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference30_vt440 (
    _reference30_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno441 numeric(5,0) NOT NULL,
    _fld442rref bytea NOT NULL
);
ALTER TABLE ONLY _reference30_vt440 ALTER COLUMN _reference30_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference30_vt440 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference30_vt440 ALTER COLUMN _fld442rref SET STORAGE PLAIN;


--
-- Name: _reference31; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference31 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(150) NOT NULL
);
ALTER TABLE ONLY _reference31 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference32; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference32 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(150) NOT NULL,
    _fld444 mvarchar(150) NOT NULL,
    _fld445 boolean NOT NULL,
    _fld446 boolean NOT NULL,
    _fld447 bytea NOT NULL
);
ALTER TABLE ONLY _reference32 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference33; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference33 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(50) NOT NULL
);
ALTER TABLE ONLY _reference33 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference34; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference34 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mvarchar(5) NOT NULL,
    _description mvarchar(150) NOT NULL,
    _fld450 boolean NOT NULL,
    _fld451 mvarchar NOT NULL,
    _fld452 mvarchar(40) NOT NULL
);
ALTER TABLE ONLY _reference34 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference34_vt453; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference34_vt453 (
    _reference34_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno454 numeric(5,0) NOT NULL,
    _fld455_type bytea NOT NULL,
    _fld455_rtref bytea NOT NULL,
    _fld455_rrref bytea NOT NULL,
    _fld456rref bytea NOT NULL,
    _fld457rref bytea NOT NULL,
    _fld458 numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _reference34_vt453 ALTER COLUMN _reference34_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference34_vt453 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference34_vt453 ALTER COLUMN _fld455_type SET STORAGE PLAIN;
ALTER TABLE ONLY _reference34_vt453 ALTER COLUMN _fld455_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference34_vt453 ALTER COLUMN _fld455_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference34_vt453 ALTER COLUMN _fld456rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference34_vt453 ALTER COLUMN _fld457rref SET STORAGE PLAIN;


--
-- Name: _reference35; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference35 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(25) NOT NULL,
    _fld459rref bytea NOT NULL,
    _fld460 boolean NOT NULL,
    _fld461 numeric(10,2) NOT NULL,
    _fld462 boolean NOT NULL,
    _fld463 mvarchar NOT NULL,
    _fld464rref bytea NOT NULL,
    _fld465 boolean NOT NULL
);
ALTER TABLE ONLY _reference35 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference35 ALTER COLUMN _fld459rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference35 ALTER COLUMN _fld464rref SET STORAGE PLAIN;


--
-- Name: _reference36; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference36 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(100) NOT NULL,
    _fld467rref bytea NOT NULL,
    _fld468 mvarchar(256) NOT NULL
);
ALTER TABLE ONLY _reference36 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference36 ALTER COLUMN _fld467rref SET STORAGE PLAIN;


--
-- Name: _reference37; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference37 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(5) NOT NULL,
    _description mvarchar(50) NOT NULL,
    _fld471 mvarchar
);
ALTER TABLE ONLY _reference37 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference37 ALTER COLUMN _parentidrref SET STORAGE PLAIN;


--
-- Name: _reference38; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference38 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(100) NOT NULL,
    _fld473 mchar(20),
    _fld474 mvarchar(50),
    _fld475 mvarchar,
    _fld476 mvarchar
);
ALTER TABLE ONLY _reference38 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference38 ALTER COLUMN _parentidrref SET STORAGE PLAIN;


--
-- Name: _reference39; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference39 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _owneridrref bytea NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL,
    _fld480rref bytea NOT NULL,
    _fld481 mvarchar(20) NOT NULL,
    _fld482 mvarchar(20) NOT NULL,
    _fld483 mvarchar(9) NOT NULL
);
ALTER TABLE ONLY _reference39 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference39 ALTER COLUMN _owneridrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference39 ALTER COLUMN _fld480rref SET STORAGE PLAIN;


--
-- Name: _reference40; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference40 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(50) NOT NULL
);
ALTER TABLE ONLY _reference40 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference40 ALTER COLUMN _parentidrref SET STORAGE PLAIN;


--
-- Name: _reference41; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference41 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mchar(9) NOT NULL,
    _description mvarchar(50) NOT NULL,
    _fld486rref bytea NOT NULL,
    _fld487rref bytea NOT NULL,
    _fld488 boolean NOT NULL
);
ALTER TABLE ONLY _reference41 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference41 ALTER COLUMN _fld486rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference41 ALTER COLUMN _fld487rref SET STORAGE PLAIN;


--
-- Name: _reference41_vt489; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference41_vt489 (
    _reference41_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno490 numeric(5,0) NOT NULL,
    _fld491rref bytea NOT NULL,
    _fld492 numeric(5,2) NOT NULL
);
ALTER TABLE ONLY _reference41_vt489 ALTER COLUMN _reference41_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference41_vt489 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference41_vt489 ALTER COLUMN _fld491rref SET STORAGE PLAIN;


--
-- Name: _reference42; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference42 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _parentidrref bytea NOT NULL,
    _folder boolean NOT NULL,
    _code mchar(10) NOT NULL,
    _description mvarchar(50) NOT NULL,
    _fld494 mvarchar,
    _fld495 boolean,
    _fld496 mvarchar(15),
    _fld1664 timestamp without time zone
);
ALTER TABLE ONLY _reference42 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference42 ALTER COLUMN _parentidrref SET STORAGE PLAIN;


--
-- Name: _reference43; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference43 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code numeric(3,0) NOT NULL,
    _description mvarchar(30) NOT NULL,
    _fld498 numeric(1,0) NOT NULL,
    _fld499 mchar(10) NOT NULL
);
ALTER TABLE ONLY _reference43 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference44; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference44 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL
);
ALTER TABLE ONLY _reference44 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference45; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference45 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL
);
ALTER TABLE ONLY _reference45 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference46; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference46 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL
);
ALTER TABLE ONLY _reference46 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference47; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference47 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL
);
ALTER TABLE ONLY _reference47 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference48; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference48 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL
);
ALTER TABLE ONLY _reference48 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference48_vt506; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference48_vt506 (
    _reference48_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno507 numeric(5,0) NOT NULL,
    _fld508 numeric(15,0) NOT NULL,
    _fld509 numeric(15,0) NOT NULL,
    _fld510 numeric(5,1) NOT NULL
);
ALTER TABLE ONLY _reference48_vt506 ALTER COLUMN _reference48_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference48_vt506 ALTER COLUMN _keyfield SET STORAGE PLAIN;


--
-- Name: _reference49; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference49 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL,
    _fld512rref bytea NOT NULL,
    _fld513 timestamp without time zone NOT NULL,
    _fld514 timestamp without time zone NOT NULL,
    _fld515rref bytea NOT NULL,
    _fld516 boolean NOT NULL,
    _fld517 mvarchar(35) NOT NULL
);
ALTER TABLE ONLY _reference49 ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49 ALTER COLUMN _fld512rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49 ALTER COLUMN _fld515rref SET STORAGE PLAIN;


--
-- Name: _reference49_vt518; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference49_vt518 (
    _reference49_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno519 numeric(5,0) NOT NULL,
    _fld520_type bytea NOT NULL,
    _fld520_s mvarchar(50) NOT NULL,
    _fld520_rrref bytea NOT NULL,
    _fld521_type bytea NOT NULL,
    _fld521_s mvarchar(50) NOT NULL,
    _fld521_rrref bytea NOT NULL,
    _fld522 numeric(2,0) NOT NULL,
    _fld523 numeric(4,0) NOT NULL
);
ALTER TABLE ONLY _reference49_vt518 ALTER COLUMN _reference49_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt518 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt518 ALTER COLUMN _fld520_type SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt518 ALTER COLUMN _fld520_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt518 ALTER COLUMN _fld521_type SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt518 ALTER COLUMN _fld521_rrref SET STORAGE PLAIN;


--
-- Name: _reference49_vt524; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference49_vt524 (
    _reference49_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno525 numeric(5,0) NOT NULL,
    _fld526_type bytea NOT NULL,
    _fld526_s mvarchar(50) NOT NULL,
    _fld526_rrref bytea NOT NULL,
    _fld527rref bytea NOT NULL,
    _fld528 numeric(14,2) NOT NULL,
    _fld529 numeric(4,0) NOT NULL,
    _fld530rref bytea NOT NULL
);
ALTER TABLE ONLY _reference49_vt524 ALTER COLUMN _reference49_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt524 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt524 ALTER COLUMN _fld526_type SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt524 ALTER COLUMN _fld526_rrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt524 ALTER COLUMN _fld527rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt524 ALTER COLUMN _fld530rref SET STORAGE PLAIN;


--
-- Name: _reference49_vt531; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference49_vt531 (
    _reference49_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno532 numeric(5,0) NOT NULL,
    _fld533 boolean NOT NULL,
    _fld534rref bytea NOT NULL,
    _fld535 timestamp without time zone NOT NULL,
    _fld536 timestamp without time zone NOT NULL
);
ALTER TABLE ONLY _reference49_vt531 ALTER COLUMN _reference49_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt531 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt531 ALTER COLUMN _fld534rref SET STORAGE PLAIN;


--
-- Name: _reference49_vt537; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference49_vt537 (
    _reference49_idrref bytea NOT NULL,
    _keyfield bytea NOT NULL,
    _lineno538 numeric(5,0) NOT NULL,
    _fld539rref bytea NOT NULL,
    _fld540rref bytea NOT NULL,
    _fld541 boolean NOT NULL,
    _fld542 boolean NOT NULL,
    _fld543 boolean NOT NULL
);
ALTER TABLE ONLY _reference49_vt537 ALTER COLUMN _reference49_idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt537 ALTER COLUMN _keyfield SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt537 ALTER COLUMN _fld539rref SET STORAGE PLAIN;
ALTER TABLE ONLY _reference49_vt537 ALTER COLUMN _fld540rref SET STORAGE PLAIN;


--
-- Name: _reference50; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference50 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(25) NOT NULL
);
ALTER TABLE ONLY _reference50 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _reference51; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _reference51 (
    _idrref bytea NOT NULL,
    _version integer DEFAULT 0 NOT NULL,
    _marked boolean NOT NULL,
    _ismetadata boolean NOT NULL,
    _code mvarchar(9) NOT NULL,
    _description mvarchar(150) NOT NULL
);
ALTER TABLE ONLY _reference51 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr137; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr137 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr137 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr137 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr137 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr147; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr147 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr147 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr147 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr147 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr149; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr149 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr149 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr149 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr149 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr151; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr151 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr151 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr151 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr151 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr153; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr153 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr153 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr153 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr153 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr168; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr168 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr168 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr168 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr168 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr342; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr342 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr342 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr342 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr342 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr356; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr356 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr356 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr356 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr356 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr388; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr388 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr388 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr388 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr388 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr396; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr396 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr396 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr396 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr396 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr401; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr401 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr401 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr401 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr401 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr425; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr425 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr425 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr425 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr425 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr433; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr433 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr433 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr433 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr433 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr443; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr443 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr443 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr443 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr443 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr449; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr449 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr449 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr449 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr449 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr466; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr466 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr466 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr466 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr466 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr472; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr472 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr472 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr472 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr472 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr479; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr479 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr479 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr479 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr479 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr484; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr484 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr484 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr484 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr484 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr485; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr485 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr485 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr485 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr485 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr493; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr493 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr493 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr493 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr493 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr497; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr497 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr497 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr497 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr497 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr501; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr501 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr501 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr501 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr501 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr502; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr502 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr502 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr502 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr502 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr503; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr503 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr503 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr503 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr503 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr504; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr504 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr504 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr504 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr504 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr505; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr505 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr505 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr505 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr505 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _referencechngr511; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _referencechngr511 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _idrref bytea NOT NULL
);
ALTER TABLE ONLY _referencechngr511 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr511 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _referencechngr511 ALTER COLUMN _idrref SET STORAGE PLAIN;


--
-- Name: _repsettings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _repsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _repsettings ALTER COLUMN _version SET STORAGE PLAIN;


--
-- Name: _repvarsettings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _repvarsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _repvarsettings ALTER COLUMN _version SET STORAGE PLAIN;


--
-- Name: _scheduledjobs1650; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _scheduledjobs1650 (
    _id bytea NOT NULL,
    _description mvarchar(128) NOT NULL,
    _jobkey mvarchar(128) NOT NULL,
    _metadataid bytea NOT NULL,
    _predefined boolean NOT NULL,
    _parameters bytea NOT NULL,
    _username mvarchar(255) NOT NULL,
    _activationcondition bytea NOT NULL,
    _use boolean NOT NULL,
    _restartcount numeric(9,0) NOT NULL,
    _restartperiod numeric(9,0) NOT NULL,
    _restartattemptnumber numeric(9,0) NOT NULL,
    _state numeric(9,0) NOT NULL,
    _starttime timestamp without time zone NOT NULL,
    _finishtime timestamp without time zone NOT NULL,
    _version numeric(9,0) NOT NULL
);
ALTER TABLE ONLY _scheduledjobs1650 ALTER COLUMN _id SET STORAGE PLAIN;
ALTER TABLE ONLY _scheduledjobs1650 ALTER COLUMN _metadataid SET STORAGE PLAIN;


--
-- Name: _scheduledjobs1651; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _scheduledjobs1651 (
    _id bytea NOT NULL,
    _description mvarchar(128) NOT NULL,
    _jobkey mvarchar(128) NOT NULL,
    _metadataid bytea NOT NULL,
    _predefined boolean NOT NULL,
    _parameters bytea NOT NULL,
    _username mvarchar(255) NOT NULL,
    _activationcondition bytea NOT NULL,
    _use boolean NOT NULL,
    _restartcount numeric(9,0) NOT NULL,
    _restartperiod numeric(9,0) NOT NULL,
    _restartattemptnumber numeric(9,0) NOT NULL,
    _state numeric(9,0) NOT NULL,
    _starttime timestamp without time zone NOT NULL,
    _finishtime timestamp without time zone NOT NULL,
    _version numeric(9,0) NOT NULL
);
ALTER TABLE ONLY _scheduledjobs1651 ALTER COLUMN _id SET STORAGE PLAIN;
ALTER TABLE ONLY _scheduledjobs1651 ALTER COLUMN _metadataid SET STORAGE PLAIN;


--
-- Name: _scheduledjobs1652; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _scheduledjobs1652 (
    _id bytea NOT NULL,
    _description mvarchar(128) NOT NULL,
    _jobkey mvarchar(128) NOT NULL,
    _metadataid bytea NOT NULL,
    _predefined boolean NOT NULL,
    _parameters bytea NOT NULL,
    _username mvarchar(255) NOT NULL,
    _activationcondition bytea NOT NULL,
    _use boolean NOT NULL,
    _restartcount numeric(9,0) NOT NULL,
    _restartperiod numeric(9,0) NOT NULL,
    _restartattemptnumber numeric(9,0) NOT NULL,
    _state numeric(9,0) NOT NULL,
    _starttime timestamp without time zone NOT NULL,
    _finishtime timestamp without time zone NOT NULL,
    _version numeric(9,0) NOT NULL
);
ALTER TABLE ONLY _scheduledjobs1652 ALTER COLUMN _id SET STORAGE PLAIN;
ALTER TABLE ONLY _scheduledjobs1652 ALTER COLUMN _metadataid SET STORAGE PLAIN;


--
-- Name: _seq1643; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _seq1643 (
    _period timestamp without time zone NOT NULL,
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _seq1643 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _seq1643 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _seqb1644; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _seqb1644 (
    _period timestamp without time zone NOT NULL,
    _recorder_type bytea NOT NULL,
    _recorder_rtref bytea NOT NULL,
    _recorder_rrref bytea NOT NULL
);
ALTER TABLE ONLY _seqb1644 ALTER COLUMN _recorder_type SET STORAGE PLAIN;
ALTER TABLE ONLY _seqb1644 ALTER COLUMN _recorder_rtref SET STORAGE PLAIN;
ALTER TABLE ONLY _seqb1644 ALTER COLUMN _recorder_rrref SET STORAGE PLAIN;


--
-- Name: _seqchngr1645; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _seqchngr1645 (
    _nodetref bytea NOT NULL,
    _noderref bytea NOT NULL,
    _messageno numeric(10,0),
    _recordertref bytea NOT NULL,
    _recorderrref bytea NOT NULL
);
ALTER TABLE ONLY _seqchngr1645 ALTER COLUMN _nodetref SET STORAGE PLAIN;
ALTER TABLE ONLY _seqchngr1645 ALTER COLUMN _noderref SET STORAGE PLAIN;
ALTER TABLE ONLY _seqchngr1645 ALTER COLUMN _recordertref SET STORAGE PLAIN;
ALTER TABLE ONLY _seqchngr1645 ALTER COLUMN _recorderrref SET STORAGE PLAIN;


--
-- Name: _systemsettings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _systemsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _systemsettings ALTER COLUMN _version SET STORAGE PLAIN;


--
-- Name: _usersworkhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _usersworkhistory (
    _id bytea NOT NULL,
    _userid bytea NOT NULL,
    _url mvarchar NOT NULL,
    _date timestamp without time zone NOT NULL,
    _urlhash numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _usersworkhistory ALTER COLUMN _id SET STORAGE PLAIN;
ALTER TABLE ONLY _usersworkhistory ALTER COLUMN _userid SET STORAGE PLAIN;


SET default_with_oids = true;

--
-- Name: _yearoffset; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE _yearoffset (
    ofset integer NOT NULL
);


--
-- Name: config; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE config (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize integer NOT NULL,
    binarydata bytea NOT NULL
);


--
-- Name: configsave; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE configsave (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize integer NOT NULL,
    binarydata bytea NOT NULL
);


--
-- Name: dbschema; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dbschema (
    serializeddata bytea NOT NULL
);


--
-- Name: files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE files (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize integer NOT NULL,
    binarydata bytea NOT NULL
);


--
-- Name: ibversion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ibversion (
    ibversion integer NOT NULL,
    platformversionreq integer NOT NULL
);


--
-- Name: params; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE params (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize integer NOT NULL,
    binarydata bytea NOT NULL
);


SET default_with_oids = false;

--
-- Name: v8users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v8users (
    id bytea NOT NULL,
    name mvarchar(64) NOT NULL,
    descr mvarchar(128) NOT NULL,
    osname mvarchar(128),
    changed timestamp without time zone NOT NULL,
    rolesid numeric(10,0) NOT NULL,
    show boolean NOT NULL,
    data bytea NOT NULL,
    eauth boolean,
    admrole boolean,
    ussprh numeric(10,0)
);
ALTER TABLE ONLY v8users ALTER COLUMN id SET STORAGE PLAIN;


--
-- Name: _chrc127_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _chrc127
    ADD CONSTRAINT _chrc127_pkey PRIMARY KEY (_idrref);


--
-- Name: _chrc128_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _chrc128
    ADD CONSTRAINT _chrc128_pkey PRIMARY KEY (_idrref);


--
-- Name: _chrc129_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _chrc129
    ADD CONSTRAINT _chrc129_pkey PRIMARY KEY (_idrref);


--
-- Name: _configchngr_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _configchngr
    ADD CONSTRAINT _configchngr_pkey PRIMARY KEY (_idrref);


--
-- Name: _document52_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document52
    ADD CONSTRAINT _document52_pkey PRIMARY KEY (_idrref);


--
-- Name: _document53_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document53
    ADD CONSTRAINT _document53_pkey PRIMARY KEY (_idrref);


--
-- Name: _document54_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document54
    ADD CONSTRAINT _document54_pkey PRIMARY KEY (_idrref);


--
-- Name: _document55_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document55
    ADD CONSTRAINT _document55_pkey PRIMARY KEY (_idrref);


--
-- Name: _document56ng_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document56
    ADD CONSTRAINT _document56ng_pkey PRIMARY KEY (_idrref);


--
-- Name: _document57_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document57
    ADD CONSTRAINT _document57_pkey PRIMARY KEY (_idrref);


--
-- Name: _document58_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document58
    ADD CONSTRAINT _document58_pkey PRIMARY KEY (_idrref);


--
-- Name: _document59_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document59
    ADD CONSTRAINT _document59_pkey PRIMARY KEY (_idrref);


--
-- Name: _document60_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document60
    ADD CONSTRAINT _document60_pkey PRIMARY KEY (_idrref);


--
-- Name: _document61_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document61
    ADD CONSTRAINT _document61_pkey PRIMARY KEY (_idrref);


--
-- Name: _document62_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document62
    ADD CONSTRAINT _document62_pkey PRIMARY KEY (_idrref);


--
-- Name: _document63_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document63
    ADD CONSTRAINT _document63_pkey PRIMARY KEY (_idrref);


--
-- Name: _document64_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document64
    ADD CONSTRAINT _document64_pkey PRIMARY KEY (_idrref);


--
-- Name: _document65_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document65
    ADD CONSTRAINT _document65_pkey PRIMARY KEY (_idrref);


--
-- Name: _document66_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document66
    ADD CONSTRAINT _document66_pkey PRIMARY KEY (_idrref);


--
-- Name: _document67ng_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document67
    ADD CONSTRAINT _document67ng_pkey PRIMARY KEY (_idrref);


--
-- Name: _document68_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document68
    ADD CONSTRAINT _document68_pkey PRIMARY KEY (_idrref);


--
-- Name: _document69_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document69
    ADD CONSTRAINT _document69_pkey PRIMARY KEY (_idrref);


--
-- Name: _document70_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document70
    ADD CONSTRAINT _document70_pkey PRIMARY KEY (_idrref);


--
-- Name: _document71_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document71
    ADD CONSTRAINT _document71_pkey PRIMARY KEY (_idrref);


--
-- Name: _document72_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document72
    ADD CONSTRAINT _document72_pkey PRIMARY KEY (_idrref);


--
-- Name: _document73_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document73
    ADD CONSTRAINT _document73_pkey PRIMARY KEY (_idrref);


--
-- Name: _document74ng_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document74
    ADD CONSTRAINT _document74ng_pkey PRIMARY KEY (_idrref);


--
-- Name: _document75_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document75
    ADD CONSTRAINT _document75_pkey PRIMARY KEY (_idrref);


--
-- Name: _document76_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _document76
    ADD CONSTRAINT _document76_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum100_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum100
    ADD CONSTRAINT _enum100_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum101_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum101
    ADD CONSTRAINT _enum101_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum102_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum102
    ADD CONSTRAINT _enum102_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum103_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum103
    ADD CONSTRAINT _enum103_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum104_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum104
    ADD CONSTRAINT _enum104_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum105_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum105
    ADD CONSTRAINT _enum105_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum106_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum106
    ADD CONSTRAINT _enum106_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum107_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum107
    ADD CONSTRAINT _enum107_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum108_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum108
    ADD CONSTRAINT _enum108_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum109_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum109
    ADD CONSTRAINT _enum109_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum110_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum110
    ADD CONSTRAINT _enum110_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum111_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum111
    ADD CONSTRAINT _enum111_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum112_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum112
    ADD CONSTRAINT _enum112_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum113_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum113
    ADD CONSTRAINT _enum113_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum114_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum114
    ADD CONSTRAINT _enum114_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum115_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum115
    ADD CONSTRAINT _enum115_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum116_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum116
    ADD CONSTRAINT _enum116_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum117_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum117
    ADD CONSTRAINT _enum117_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum118_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum118
    ADD CONSTRAINT _enum118_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum119_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum119
    ADD CONSTRAINT _enum119_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum120_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum120
    ADD CONSTRAINT _enum120_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum121_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum121
    ADD CONSTRAINT _enum121_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum122_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum122
    ADD CONSTRAINT _enum122_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum123_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum123
    ADD CONSTRAINT _enum123_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum124_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum124
    ADD CONSTRAINT _enum124_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum125_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum125
    ADD CONSTRAINT _enum125_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum126_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum126
    ADD CONSTRAINT _enum126_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum77_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum77
    ADD CONSTRAINT _enum77_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum78_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum78
    ADD CONSTRAINT _enum78_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum79_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum79
    ADD CONSTRAINT _enum79_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum80_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum80
    ADD CONSTRAINT _enum80_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum81_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum81
    ADD CONSTRAINT _enum81_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum82_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum82
    ADD CONSTRAINT _enum82_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum83_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum83
    ADD CONSTRAINT _enum83_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum84_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum84
    ADD CONSTRAINT _enum84_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum85_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum85
    ADD CONSTRAINT _enum85_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum86_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum86
    ADD CONSTRAINT _enum86_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum87_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum87
    ADD CONSTRAINT _enum87_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum88_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum88
    ADD CONSTRAINT _enum88_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum89_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum89
    ADD CONSTRAINT _enum89_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum90_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum90
    ADD CONSTRAINT _enum90_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum91_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum91
    ADD CONSTRAINT _enum91_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum92_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum92
    ADD CONSTRAINT _enum92_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum93_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum93
    ADD CONSTRAINT _enum93_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum94_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum94
    ADD CONSTRAINT _enum94_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum95_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum95
    ADD CONSTRAINT _enum95_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum96_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum96
    ADD CONSTRAINT _enum96_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum97_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum97
    ADD CONSTRAINT _enum97_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum98_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum98
    ADD CONSTRAINT _enum98_pkey PRIMARY KEY (_idrref);


--
-- Name: _enum99_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _enum99
    ADD CONSTRAINT _enum99_pkey PRIMARY KEY (_idrref);


--
-- Name: _node10_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _node10
    ADD CONSTRAINT _node10_pkey PRIMARY KEY (_idrref);


--
-- Name: _node11_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _node11
    ADD CONSTRAINT _node11_pkey PRIMARY KEY (_idrref);


--
-- Name: _node9_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _node9
    ADD CONSTRAINT _node9_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference12_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference12
    ADD CONSTRAINT _reference12_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference13_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference13
    ADD CONSTRAINT _reference13_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference14_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference14
    ADD CONSTRAINT _reference14_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference15_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference15
    ADD CONSTRAINT _reference15_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference16_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference16
    ADD CONSTRAINT _reference16_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference17_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference17
    ADD CONSTRAINT _reference17_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference18_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference18
    ADD CONSTRAINT _reference18_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference19_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference19
    ADD CONSTRAINT _reference19_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference20_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference20
    ADD CONSTRAINT _reference20_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference21_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference21
    ADD CONSTRAINT _reference21_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference22_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference22
    ADD CONSTRAINT _reference22_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference23_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference23
    ADD CONSTRAINT _reference23_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference24_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference24
    ADD CONSTRAINT _reference24_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference25_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference25
    ADD CONSTRAINT _reference25_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference26_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference26
    ADD CONSTRAINT _reference26_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference27_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference27
    ADD CONSTRAINT _reference27_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference28_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference28
    ADD CONSTRAINT _reference28_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference29_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference29
    ADD CONSTRAINT _reference29_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference30_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference30
    ADD CONSTRAINT _reference30_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference31_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference31
    ADD CONSTRAINT _reference31_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference32_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference32
    ADD CONSTRAINT _reference32_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference33_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference33
    ADD CONSTRAINT _reference33_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference34_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference34
    ADD CONSTRAINT _reference34_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference35_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference35
    ADD CONSTRAINT _reference35_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference36_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference36
    ADD CONSTRAINT _reference36_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference37_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference37
    ADD CONSTRAINT _reference37_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference38_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference38
    ADD CONSTRAINT _reference38_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference39_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference39
    ADD CONSTRAINT _reference39_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference40_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference40
    ADD CONSTRAINT _reference40_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference41_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference41
    ADD CONSTRAINT _reference41_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference42ng_pkey1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference42
    ADD CONSTRAINT _reference42ng_pkey1 PRIMARY KEY (_idrref);


--
-- Name: _reference43_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference43
    ADD CONSTRAINT _reference43_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference44_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference44
    ADD CONSTRAINT _reference44_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference45_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference45
    ADD CONSTRAINT _reference45_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference46_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference46
    ADD CONSTRAINT _reference46_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference47_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference47
    ADD CONSTRAINT _reference47_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference48_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference48
    ADD CONSTRAINT _reference48_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference49_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference49
    ADD CONSTRAINT _reference49_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference50_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference50
    ADD CONSTRAINT _reference50_pkey PRIMARY KEY (_idrref);


--
-- Name: _reference51_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY _reference51
    ADD CONSTRAINT _reference51_pkey PRIMARY KEY (_idrref);


--
-- Name: config_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY config
    ADD CONSTRAINT config_pkey PRIMARY KEY (filename);


--
-- Name: configsave_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY configsave
    ADD CONSTRAINT configsave_pkey PRIMARY KEY (filename);


--
-- Name: files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_pkey PRIMARY KEY (filename);


--
-- Name: params_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY params
    ADD CONSTRAINT params_pkey PRIMARY KEY (filename);


--
-- Name: v8users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v8users
    ADD CONSTRAINT v8users_pkey PRIMARY KEY (id);


--
-- Name: _accumr1513_bydims1518_rtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1513_bydims1518_rtrn ON _accumrg1513 USING btree (_fld1514rref, _period, _recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1513_bydims1519_rtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1513_bydims1519_rtrn ON _accumrg1513 USING btree (_fld1515rref, _period, _recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1513_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1513_byperiod_trn ON _accumrg1513 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1513 CLUSTER ON _accumr1513_byperiod_trn;


--
-- Name: _accumr1513_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1513_byrecorder_rn ON _accumrg1513 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1520_bydims1519_tr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _accumr1520_bydims1519_tr ON _accumrgt1520 USING btree (_period, _fld1515rref);


--
-- Name: _accumr1520_bydims_trrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1520_bydims_trrr ON _accumrgt1520 USING btree (_period, _fld1514rref, _fld1515rref, _fld1516_type, _fld1516_rtref, _fld1516_rrref);

ALTER TABLE _accumrgt1520 CLUSTER ON _accumr1520_bydims_trrr;


--
-- Name: _accumr1521_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1521_bydatakey_rr ON _accumrgchngr1521 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1521 CLUSTER ON _accumr1521_bydatakey_rr;


--
-- Name: _accumr1521_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1521_bynodemsg_rnr ON _accumrgchngr1521 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1522_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1522_byperiod_trn ON _accumrg1522 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1522 CLUSTER ON _accumr1522_byperiod_trn;


--
-- Name: _accumr1522_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1522_byrecorder_rn ON _accumrg1522 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1526_bydims_trr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1526_bydims_trr ON _accumrgt1526 USING btree (_period, _fld1523rref, _fld1524rref);

ALTER TABLE _accumrgt1526 CLUSTER ON _accumr1526_bydims_trr;


--
-- Name: _accumr1527_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1527_bydatakey_rr ON _accumrgchngr1527 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1527 CLUSTER ON _accumr1527_bydatakey_rr;


--
-- Name: _accumr1527_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1527_bynodemsg_rnr ON _accumrgchngr1527 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1528_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1528_byperiod_trn ON _accumrg1528 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1528 CLUSTER ON _accumr1528_byperiod_trn;


--
-- Name: _accumr1528_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1528_byrecorder_rn ON _accumrg1528 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1531_bydims_tr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1531_bydims_tr ON _accumrgt1531 USING btree (_period, _fld1529rref);

ALTER TABLE _accumrgt1531 CLUSTER ON _accumr1531_bydims_tr;


--
-- Name: _accumr1532_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1532_bydatakey_rr ON _accumrgchngr1532 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1532 CLUSTER ON _accumr1532_bydatakey_rr;


--
-- Name: _accumr1532_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1532_bynodemsg_rnr ON _accumrgchngr1532 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1533_bydims1552_rtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1533_bydims1552_rtrn ON _accumrg1533 USING btree (_fld1534rref, _period, _recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1533_bydims1553_rtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1533_bydims1553_rtrn ON _accumrg1533 USING btree (_fld1535rref, _period, _recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1533_bydims1554_rtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1533_bydims1554_rtrn ON _accumrg1533 USING btree (_fld1536rref, _period, _recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1533_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1533_byperiod_trn ON _accumrg1533 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1533 CLUSTER ON _accumr1533_byperiod_trn;


--
-- Name: _accumr1533_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1533_byrecorder_rn ON _accumrg1533 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1555_bydims1553_tr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _accumr1555_bydims1553_tr ON _accumrgt1555 USING btree (_period, _fld1535rref);


--
-- Name: _accumr1555_bydims1554_tr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _accumr1555_bydims1554_tr ON _accumrgt1555 USING btree (_period, _fld1536rref);


--
-- Name: _accumr1555_bydims_trrrrrnnnrnlnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _accumr1555_bydims_trrrrrnnnrnlnn ON _accumrgt1555 USING btree (_period, _fld1534rref, _fld1535rref, _fld1536rref, _fld1537rref, _fld1538rref, _fld1539, _fld1540, _fld1541, _fld1542rref, _fld1543_type, _fld1543_n, _fld1544, _dimhash, _splitter);


--
-- Name: _accumr1555_bydims_trrrrrnnnrrlnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _accumr1555_bydims_trrrrrnnnrrlnn ON _accumrgt1555 USING btree (_period, _fld1534rref, _fld1535rref, _fld1536rref, _fld1537rref, _fld1538rref, _fld1539, _fld1540, _fld1541, _fld1542rref, _fld1543_type, _fld1543_rrref, _fld1544, _dimhash, _splitter);

ALTER TABLE _accumrgt1555 CLUSTER ON _accumr1555_bydims_trrrrrnnnrrlnn;


--
-- Name: _accumr1556_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1556_bydatakey_rr ON _accumrgchngr1556 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1556 CLUSTER ON _accumr1556_bydatakey_rr;


--
-- Name: _accumr1556_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1556_bynodemsg_rnr ON _accumrgchngr1556 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1557_bydims1565_rtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1557_bydims1565_rtrn ON _accumrg1557 USING btree (_fld1559rref, _period, _recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1557_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1557_byperiod_trn ON _accumrg1557 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1557 CLUSTER ON _accumr1557_byperiod_trn;


--
-- Name: _accumr1557_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1557_byrecorder_rn ON _accumrg1557 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1566_bydims1565_tr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _accumr1566_bydims1565_tr ON _accumrgt1566 USING btree (_period, _fld1559rref);


--
-- Name: _accumr1566_bydims_trrrrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1566_bydims_trrrrn ON _accumrgt1566 USING btree (_period, _fld1558rref, _fld1559rref, _fld1560rref, _fld1561rref, _fld1562);

ALTER TABLE _accumrgt1566 CLUSTER ON _accumr1566_bydims_trrrrn;


--
-- Name: _accumr1567_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1567_bydatakey_rr ON _accumrgchngr1567 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1567 CLUSTER ON _accumr1567_bydatakey_rr;


--
-- Name: _accumr1567_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1567_bynodemsg_rnr ON _accumrgchngr1567 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1568_bydims1576_rtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1568_bydims1576_rtrn ON _accumrg1568 USING btree (_fld1572rref, _period, _recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1568_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1568_byperiod_trn ON _accumrg1568 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1568 CLUSTER ON _accumr1568_byperiod_trn;


--
-- Name: _accumr1568_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1568_byrecorder_rn ON _accumrg1568 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1577_bydims1576_rt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _accumr1577_bydims1576_rt ON _accumrgtn1577 USING btree (_fld1572rref, _period);


--
-- Name: _accumr1577_bydims_trrrrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1577_bydims_trrrrr ON _accumrgtn1577 USING btree (_period, _fld1569rref, _fld1570rref, _fld1571rref, _fld1572rref, _fld1663rref);

ALTER TABLE _accumrgtn1577 CLUSTER ON _accumr1577_bydims_trrrrr;


--
-- Name: _accumr1578_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1578_bydatakey_rr ON _accumrgchngr1578 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1578 CLUSTER ON _accumr1578_bydatakey_rr;


--
-- Name: _accumr1578_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1578_bynodemsg_rnr ON _accumrgchngr1578 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1579_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1579_byperiod_trn ON _accumrg1579 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1579 CLUSTER ON _accumr1579_byperiod_trn;


--
-- Name: _accumr1579_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1579_byrecorder_rn ON _accumrg1579 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1586_bydims_trrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1586_bydims_trrr ON _accumrgt1586 USING btree (_period, _fld1580rref, _fld1581rref, _fld1582_type, _fld1582_rtref, _fld1582_rrref);

ALTER TABLE _accumrgt1586 CLUSTER ON _accumr1586_bydims_trrr;


--
-- Name: _accumr1587_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1587_bydatakey_rr ON _accumrgchngr1587 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1587 CLUSTER ON _accumr1587_bydatakey_rr;


--
-- Name: _accumr1587_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1587_bynodemsg_rnr ON _accumrgchngr1587 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1588_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1588_byperiod_trn ON _accumrg1588 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1588 CLUSTER ON _accumr1588_byperiod_trn;


--
-- Name: _accumr1588_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1588_byrecorder_rn ON _accumrg1588 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1595_bydims_trrrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1595_bydims_trrrr ON _accumrgtn1595 USING btree (_period, _fld1589rref, _fld1590rref, _fld1591rref, _fld1592rref);

ALTER TABLE _accumrgtn1595 CLUSTER ON _accumr1595_bydims_trrrr;


--
-- Name: _accumr1596_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1596_bydatakey_rr ON _accumrgchngr1596 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1596 CLUSTER ON _accumr1596_bydatakey_rr;


--
-- Name: _accumr1596_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1596_bynodemsg_rnr ON _accumrgchngr1596 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1597_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1597_byperiod_trn ON _accumrg1597 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1597 CLUSTER ON _accumr1597_byperiod_trn;


--
-- Name: _accumr1597_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1597_byrecorder_rn ON _accumrg1597 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1603_bydims_trrrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1603_bydims_trrrn ON _accumrgtn1603 USING btree (_period, _fld1598rref, _fld1599rref, _fld1600rref, _splitter);

ALTER TABLE _accumrgtn1603 CLUSTER ON _accumr1603_bydims_trrrn;


--
-- Name: _accumr1604_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1604_bydatakey_rr ON _accumrgchngr1604 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1604 CLUSTER ON _accumr1604_bydatakey_rr;


--
-- Name: _accumr1604_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1604_bynodemsg_rnr ON _accumrgchngr1604 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1605_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1605_byperiod_trn ON _accumrg1605 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1605 CLUSTER ON _accumr1605_byperiod_trn;


--
-- Name: _accumr1605_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1605_byrecorder_rn ON _accumrg1605 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1608_bydims_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1608_bydims_trn ON _accumrgt1608 USING btree (_period, _fld1606rref, _splitter);

ALTER TABLE _accumrgt1608 CLUSTER ON _accumr1608_bydims_trn;


--
-- Name: _accumr1609_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1609_bydatakey_rr ON _accumrgchngr1609 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1609 CLUSTER ON _accumr1609_bydatakey_rr;


--
-- Name: _accumr1609_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1609_bynodemsg_rnr ON _accumrgchngr1609 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1610_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1610_byperiod_trn ON _accumrg1610 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1610 CLUSTER ON _accumr1610_byperiod_trn;


--
-- Name: _accumr1610_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1610_byrecorder_rn ON _accumrg1610 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1618_bydims_trrrrrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1618_bydims_trrrrrn ON _accumrgt1618 USING btree (_period, _fld1611rref, _fld1612rref, _fld1613rref, _fld1614rref, _fld1615rref, _splitter);

ALTER TABLE _accumrgt1618 CLUSTER ON _accumr1618_bydims_trrrrrn;


--
-- Name: _accumr1619_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1619_bydatakey_rr ON _accumrgchngr1619 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1619 CLUSTER ON _accumr1619_bydatakey_rr;


--
-- Name: _accumr1619_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1619_bynodemsg_rnr ON _accumrgchngr1619 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1620_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1620_byperiod_trn ON _accumrg1620 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1620 CLUSTER ON _accumr1620_byperiod_trn;


--
-- Name: _accumr1620_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1620_byrecorder_rn ON _accumrg1620 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1623_bydims_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1623_bydims_trn ON _accumrgtn1623 USING btree (_period, _fld1621rref, _splitter);

ALTER TABLE _accumrgtn1623 CLUSTER ON _accumr1623_bydims_trn;


--
-- Name: _accumr1624_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1624_bydatakey_rr ON _accumrgchngr1624 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1624 CLUSTER ON _accumr1624_bydatakey_rr;


--
-- Name: _accumr1624_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1624_bynodemsg_rnr ON _accumrgchngr1624 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1625_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1625_byperiod_trn ON _accumrg1625 USING btree (_period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _accumrg1625 CLUSTER ON _accumr1625_byperiod_trn;


--
-- Name: _accumr1625_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1625_byrecorder_rn ON _accumrg1625 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _accumr1628_bydims_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1628_bydims_trn ON _accumrgtn1628 USING btree (_period, _fld1626rref, _splitter);

ALTER TABLE _accumrgtn1628 CLUSTER ON _accumr1628_bydims_trn;


--
-- Name: _accumr1629_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1629_bydatakey_rr ON _accumrgchngr1629 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _accumrgchngr1629 CLUSTER ON _accumr1629_bydatakey_rr;


--
-- Name: _accumr1629_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1629_bynodemsg_rnr ON _accumrgchngr1629 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _accumr1630_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1630_byregid_b ON _accumrgopt1630 USING btree (_regid);

ALTER TABLE _accumrgopt1630 CLUSTER ON _accumr1630_byregid_b;


--
-- Name: _accumr1631_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1631_byregid_b ON _accumrgopt1631 USING btree (_regid);

ALTER TABLE _accumrgopt1631 CLUSTER ON _accumr1631_byregid_b;


--
-- Name: _accumr1632_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1632_byregid_b ON _accumrgopt1632 USING btree (_regid);

ALTER TABLE _accumrgopt1632 CLUSTER ON _accumr1632_byregid_b;


--
-- Name: _accumr1633_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1633_byregid_b ON _accumrgopt1633 USING btree (_regid);

ALTER TABLE _accumrgopt1633 CLUSTER ON _accumr1633_byregid_b;


--
-- Name: _accumr1634_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1634_byregid_b ON _accumrgopt1634 USING btree (_regid);

ALTER TABLE _accumrgopt1634 CLUSTER ON _accumr1634_byregid_b;


--
-- Name: _accumr1635_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1635_byregid_b ON _accumrgopt1635 USING btree (_regid);

ALTER TABLE _accumrgopt1635 CLUSTER ON _accumr1635_byregid_b;


--
-- Name: _accumr1636_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1636_byregid_b ON _accumrgopt1636 USING btree (_regid);

ALTER TABLE _accumrgopt1636 CLUSTER ON _accumr1636_byregid_b;


--
-- Name: _accumr1637_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1637_byregid_b ON _accumrgopt1637 USING btree (_regid);

ALTER TABLE _accumrgopt1637 CLUSTER ON _accumr1637_byregid_b;


--
-- Name: _accumr1638_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1638_byregid_b ON _accumrgopt1638 USING btree (_regid);

ALTER TABLE _accumrgopt1638 CLUSTER ON _accumr1638_byregid_b;


--
-- Name: _accumr1639_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1639_byregid_b ON _accumrgopt1639 USING btree (_regid);

ALTER TABLE _accumrgopt1639 CLUSTER ON _accumr1639_byregid_b;


--
-- Name: _accumr1640_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1640_byregid_b ON _accumrgopt1640 USING btree (_regid);

ALTER TABLE _accumrgopt1640 CLUSTER ON _accumr1640_byregid_b;


--
-- Name: _accumr1641_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1641_byregid_b ON _accumrgopt1641 USING btree (_regid);

ALTER TABLE _accumrgopt1641 CLUSTER ON _accumr1641_byregid_b;


--
-- Name: _accumr1642_byregid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _accumr1642_byregid_b ON _accumrgopt1642 USING btree (_regid);

ALTER TABLE _accumrgopt1642 CLUSTER ON _accumr1642_byregid_b;


--
-- Name: _chrc127_bycode_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrc127_bycode_sr ON _chrc127 USING btree (_code, _idrref);


--
-- Name: _chrc127_bydescr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrc127_bydescr_sr ON _chrc127 USING btree (_description, _idrref);


--
-- Name: _chrc127_byparentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrc127_byparentcode_rlsr ON _chrc127 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _chrc127_byparentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrc127_byparentdescr_rlsr ON _chrc127 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _chrc128_bycode_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrc128_bycode_sr ON _chrc128 USING btree (_code, _idrref);


--
-- Name: _chrc128_bydescr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrc128_bydescr_sr ON _chrc128 USING btree (_description, _idrref);


--
-- Name: _chrc128_byparentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrc128_byparentcode_rlsr ON _chrc128 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _chrc128_byparentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrc128_byparentdescr_rlsr ON _chrc128 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _chrc129_bycode_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrc129_bycode_sr ON _chrc129 USING btree (_code, _idrref);


--
-- Name: _chrc129_bydescr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrc129_bydescr_sr ON _chrc129 USING btree (_description, _idrref);


--
-- Name: _chrcch1646_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrcch1646_bydatakey_rr ON _chrcchngr1646 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _chrcchngr1646 CLUSTER ON _chrcch1646_bydatakey_rr;


--
-- Name: _chrcch1646_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrcch1646_bynodemsg_rnr ON _chrcchngr1646 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _chrcch1647_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrcch1647_bydatakey_rr ON _chrcchngr1647 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _chrcchngr1647 CLUSTER ON _chrcch1647_bydatakey_rr;


--
-- Name: _chrcch1647_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrcch1647_bynodemsg_rnr ON _chrcchngr1647 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _chrcch1648_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrcch1648_bydatakey_rr ON _chrcchngr1648 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _chrcchngr1648 CLUSTER ON _chrcch1648_bydatakey_rr;


--
-- Name: _chrcch1648_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _chrcch1648_bynodemsg_rnr ON _chrcchngr1648 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _commonsett_bykey_sss; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _commonsett_bykey_sss ON _commonsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _commonsettings CLUSTER ON _commonsett_bykey_sss;


--
-- Name: _configchng_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _configchng_bydatakey_br ON _configchngr USING btree (_mdobjid, _nodetref, _noderref);


--
-- Name: _configchng_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _configchng_bynodemsg_rnb ON _configchngr USING btree (_nodetref, _noderref, _messageno, _mdobjid);


--
-- Name: _configchng_extprops_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _configchng_extprops_intkeyind ON _configchngr_extprops USING btree (_configchngr_idrref, _keyfield);

ALTER TABLE _configchngr_extprops CLUSTER ON _configchng_extprops_intkeyind;


--
-- Name: _const1119_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1119_bykey_b ON _const1119 USING btree (_recordkey);

ALTER TABLE _const1119 CLUSTER ON _const1119_bykey_b;


--
-- Name: _const1122_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1122_bykey_b ON _const1122 USING btree (_recordkey);

ALTER TABLE _const1122 CLUSTER ON _const1122_bykey_b;


--
-- Name: _const1125_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1125_bykey_b ON _const1125 USING btree (_recordkey);

ALTER TABLE _const1125 CLUSTER ON _const1125_bykey_b;


--
-- Name: _const1128_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1128_bykey_b ON _const1128 USING btree (_recordkey);

ALTER TABLE _const1128 CLUSTER ON _const1128_bykey_b;


--
-- Name: _const1131_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1131_bykey_b ON _const1131 USING btree (_recordkey);

ALTER TABLE _const1131 CLUSTER ON _const1131_bykey_b;


--
-- Name: _const1134_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1134_bykey_b ON _const1134 USING btree (_recordkey);

ALTER TABLE _const1134 CLUSTER ON _const1134_bykey_b;


--
-- Name: _const1136_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1136_bykey_b ON _const1136 USING btree (_recordkey);

ALTER TABLE _const1136 CLUSTER ON _const1136_bykey_b;


--
-- Name: _const1139_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1139_bykey_b ON _const1139 USING btree (_recordkey);

ALTER TABLE _const1139 CLUSTER ON _const1139_bykey_b;


--
-- Name: _const1141_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1141_bykey_b ON _const1141 USING btree (_recordkey);

ALTER TABLE _const1141 CLUSTER ON _const1141_bykey_b;


--
-- Name: _const1144_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1144_bykey_b ON _const1144 USING btree (_recordkey);

ALTER TABLE _const1144 CLUSTER ON _const1144_bykey_b;


--
-- Name: _const1147_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1147_bykey_b ON _const1147 USING btree (_recordkey);

ALTER TABLE _const1147 CLUSTER ON _const1147_bykey_b;


--
-- Name: _const1150_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1150_bykey_b ON _const1150 USING btree (_recordkey);

ALTER TABLE _const1150 CLUSTER ON _const1150_bykey_b;


--
-- Name: _const1152_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1152_bykey_b ON _const1152 USING btree (_recordkey);

ALTER TABLE _const1152 CLUSTER ON _const1152_bykey_b;


--
-- Name: _const1155_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1155_bykey_b ON _const1155 USING btree (_recordkey);

ALTER TABLE _const1155 CLUSTER ON _const1155_bykey_b;


--
-- Name: _const1158_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1158_bykey_b ON _const1158 USING btree (_recordkey);

ALTER TABLE _const1158 CLUSTER ON _const1158_bykey_b;


--
-- Name: _const1160_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1160_bykey_b ON _const1160 USING btree (_recordkey);

ALTER TABLE _const1160 CLUSTER ON _const1160_bykey_b;


--
-- Name: _const1162_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1162_bykey_b ON _const1162 USING btree (_recordkey);

ALTER TABLE _const1162 CLUSTER ON _const1162_bykey_b;


--
-- Name: _const1164_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1164_bykey_b ON _const1164 USING btree (_recordkey);

ALTER TABLE _const1164 CLUSTER ON _const1164_bykey_b;


--
-- Name: _const1166_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1166_bykey_b ON _const1166 USING btree (_recordkey);

ALTER TABLE _const1166 CLUSTER ON _const1166_bykey_b;


--
-- Name: _const1168_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1168_bykey_b ON _const1168 USING btree (_recordkey);

ALTER TABLE _const1168 CLUSTER ON _const1168_bykey_b;


--
-- Name: _const1170_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1170_bykey_b ON _const1170 USING btree (_recordkey);

ALTER TABLE _const1170 CLUSTER ON _const1170_bykey_b;


--
-- Name: _const1172_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1172_bykey_b ON _const1172 USING btree (_recordkey);

ALTER TABLE _const1172 CLUSTER ON _const1172_bykey_b;


--
-- Name: _const1174_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1174_bykey_b ON _const1174 USING btree (_recordkey);

ALTER TABLE _const1174 CLUSTER ON _const1174_bykey_b;


--
-- Name: _const1176_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1176_bykey_b ON _const1176 USING btree (_recordkey);

ALTER TABLE _const1176 CLUSTER ON _const1176_bykey_b;


--
-- Name: _const1178_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1178_bykey_b ON _const1178 USING btree (_recordkey);

ALTER TABLE _const1178 CLUSTER ON _const1178_bykey_b;


--
-- Name: _const1180_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1180_bykey_b ON _const1180 USING btree (_recordkey);

ALTER TABLE _const1180 CLUSTER ON _const1180_bykey_b;


--
-- Name: _const1182_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1182_bykey_b ON _const1182 USING btree (_recordkey);

ALTER TABLE _const1182 CLUSTER ON _const1182_bykey_b;


--
-- Name: _const1184_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1184_bykey_b ON _const1184 USING btree (_recordkey);

ALTER TABLE _const1184 CLUSTER ON _const1184_bykey_b;


--
-- Name: _const1186_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1186_bykey_b ON _const1186 USING btree (_recordkey);

ALTER TABLE _const1186 CLUSTER ON _const1186_bykey_b;


--
-- Name: _const1188_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1188_bykey_b ON _const1188 USING btree (_recordkey);

ALTER TABLE _const1188 CLUSTER ON _const1188_bykey_b;


--
-- Name: _const1190_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1190_bykey_b ON _const1190 USING btree (_recordkey);

ALTER TABLE _const1190 CLUSTER ON _const1190_bykey_b;


--
-- Name: _const1192_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1192_bykey_b ON _const1192 USING btree (_recordkey);

ALTER TABLE _const1192 CLUSTER ON _const1192_bykey_b;


--
-- Name: _const1194_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1194_bykey_b ON _const1194 USING btree (_recordkey);

ALTER TABLE _const1194 CLUSTER ON _const1194_bykey_b;


--
-- Name: _const1196_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1196_bykey_b ON _const1196 USING btree (_recordkey);

ALTER TABLE _const1196 CLUSTER ON _const1196_bykey_b;


--
-- Name: _const1199_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1199_bykey_b ON _const1199 USING btree (_recordkey);

ALTER TABLE _const1199 CLUSTER ON _const1199_bykey_b;


--
-- Name: _const1201_bykey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _const1201_bykey_b ON _const1201 USING btree (_recordkey);

ALTER TABLE _const1201 CLUSTER ON _const1201_bykey_b;


--
-- Name: _constc1121_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1121_bydatakey_br ON _constchngr1121 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1121 CLUSTER ON _constc1121_bydatakey_br;


--
-- Name: _constc1121_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1121_bynodemsg_rnb ON _constchngr1121 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1124_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1124_bydatakey_br ON _constchngr1124 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1124 CLUSTER ON _constc1124_bydatakey_br;


--
-- Name: _constc1124_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1124_bynodemsg_rnb ON _constchngr1124 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1127_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1127_bydatakey_br ON _constchngr1127 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1127 CLUSTER ON _constc1127_bydatakey_br;


--
-- Name: _constc1127_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1127_bynodemsg_rnb ON _constchngr1127 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1130_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1130_bydatakey_br ON _constchngr1130 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1130 CLUSTER ON _constc1130_bydatakey_br;


--
-- Name: _constc1130_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1130_bynodemsg_rnb ON _constchngr1130 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1133_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1133_bydatakey_br ON _constchngr1133 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1133 CLUSTER ON _constc1133_bydatakey_br;


--
-- Name: _constc1133_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1133_bynodemsg_rnb ON _constchngr1133 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1138_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1138_bydatakey_br ON _constchngr1138 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1138 CLUSTER ON _constc1138_bydatakey_br;


--
-- Name: _constc1138_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1138_bynodemsg_rnb ON _constchngr1138 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1143_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1143_bydatakey_br ON _constchngr1143 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1143 CLUSTER ON _constc1143_bydatakey_br;


--
-- Name: _constc1143_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1143_bynodemsg_rnb ON _constchngr1143 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1146_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1146_bydatakey_br ON _constchngr1146 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1146 CLUSTER ON _constc1146_bydatakey_br;


--
-- Name: _constc1146_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1146_bynodemsg_rnb ON _constchngr1146 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1149_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1149_bydatakey_br ON _constchngr1149 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1149 CLUSTER ON _constc1149_bydatakey_br;


--
-- Name: _constc1149_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1149_bynodemsg_rnb ON _constchngr1149 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1154_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1154_bydatakey_br ON _constchngr1154 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1154 CLUSTER ON _constc1154_bydatakey_br;


--
-- Name: _constc1154_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1154_bynodemsg_rnb ON _constchngr1154 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1157_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1157_bydatakey_br ON _constchngr1157 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1157 CLUSTER ON _constc1157_bydatakey_br;


--
-- Name: _constc1157_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1157_bynodemsg_rnb ON _constchngr1157 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _constc1198_bydatakey_br; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1198_bydatakey_br ON _constchngr1198 USING btree (_constid, _nodetref, _noderref);

ALTER TABLE _constchngr1198 CLUSTER ON _constc1198_bydatakey_br;


--
-- Name: _constc1198_bynodemsg_rnb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _constc1198_bynodemsg_rnb ON _constchngr1198 USING btree (_nodetref, _noderref, _messageno, _constid);


--
-- Name: _docume1001_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1001_bydatakey_rr ON _documentchngr1001 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr1001 CLUSTER ON _docume1001_bydatakey_rr;


--
-- Name: _docume1001_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1001_bynodemsg_rnr ON _documentchngr1001 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _docume1023_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1023_bydatakey_rr ON _documentchngr1023 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr1023 CLUSTER ON _docume1023_bydatakey_rr;


--
-- Name: _docume1023_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1023_bynodemsg_rnr ON _documentchngr1023 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _docume1038_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1038_bydatakey_rr ON _documentchngr1038 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr1038 CLUSTER ON _docume1038_bydatakey_rr;


--
-- Name: _docume1038_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1038_bynodemsg_rnr ON _documentchngr1038 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _docume1045_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1045_bydatakey_rr ON _documentchngr1045 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr1045 CLUSTER ON _docume1045_bydatakey_rr;


--
-- Name: _docume1045_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1045_bynodemsg_rnr ON _documentchngr1045 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _docume1106_bydoc_r; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1106_bydoc_r ON _documentjournal1106 USING btree (_documenttref, _documentrref);

ALTER TABLE _documentjournal1106 CLUSTER ON _docume1106_bydoc_r;


--
-- Name: _docume1106_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1106_bydocdate_trl ON _documentjournal1106 USING btree (_date_time, _documenttref, _documentrref, _marked);


--
-- Name: _docume1107_bydoc_r; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1107_bydoc_r ON _documentjournal1107 USING btree (_documenttref, _documentrref);

ALTER TABLE _documentjournal1107 CLUSTER ON _docume1107_bydoc_r;


--
-- Name: _docume1107_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1107_bydocdate_trl ON _documentjournal1107 USING btree (_date_time, _documenttref, _documentrref, _marked);


--
-- Name: _docume1113_bydoc_r; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1113_bydoc_r ON _documentjournal1113 USING btree (_documenttref, _documentrref);

ALTER TABLE _documentjournal1113 CLUSTER ON _docume1113_bydoc_r;


--
-- Name: _docume1113_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _docume1113_bydocdate_trl ON _documentjournal1113 USING btree (_date_time, _documenttref, _documentrref, _marked);


--
-- Name: _documen563_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen563_bydatakey_rr ON _documentchngr563 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr563 CLUSTER ON _documen563_bydatakey_rr;


--
-- Name: _documen563_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen563_bynodemsg_rnr ON _documentchngr563 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen589_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen589_bydatakey_rr ON _documentchngr589 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr589 CLUSTER ON _documen589_bydatakey_rr;


--
-- Name: _documen589_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen589_bynodemsg_rnr ON _documentchngr589 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen603_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen603_bydatakey_rr ON _documentchngr603 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr603 CLUSTER ON _documen603_bydatakey_rr;


--
-- Name: _documen603_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen603_bynodemsg_rnr ON _documentchngr603 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen626_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen626_bydatakey_rr ON _documentchngr626 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr626 CLUSTER ON _documen626_bydatakey_rr;


--
-- Name: _documen626_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen626_bynodemsg_rnr ON _documentchngr626 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen679_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen679_bydatakey_rr ON _documentchngr679 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr679 CLUSTER ON _documen679_bydatakey_rr;


--
-- Name: _documen679_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen679_bynodemsg_rnr ON _documentchngr679 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen701_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen701_bydatakey_rr ON _documentchngr701 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr701 CLUSTER ON _documen701_bydatakey_rr;


--
-- Name: _documen701_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen701_bynodemsg_rnr ON _documentchngr701 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen721_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen721_bydatakey_rr ON _documentchngr721 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr721 CLUSTER ON _documen721_bydatakey_rr;


--
-- Name: _documen721_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen721_bynodemsg_rnr ON _documentchngr721 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen732_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen732_bydatakey_rr ON _documentchngr732 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr732 CLUSTER ON _documen732_bydatakey_rr;


--
-- Name: _documen732_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen732_bynodemsg_rnr ON _documentchngr732 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen751_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen751_bydatakey_rr ON _documentchngr751 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr751 CLUSTER ON _documen751_bydatakey_rr;


--
-- Name: _documen751_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen751_bynodemsg_rnr ON _documentchngr751 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen758_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen758_bydatakey_rr ON _documentchngr758 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr758 CLUSTER ON _documen758_bydatakey_rr;


--
-- Name: _documen758_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen758_bynodemsg_rnr ON _documentchngr758 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen772_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen772_bydatakey_rr ON _documentchngr772 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr772 CLUSTER ON _documen772_bydatakey_rr;


--
-- Name: _documen772_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen772_bynodemsg_rnr ON _documentchngr772 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen805_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen805_bydatakey_rr ON _documentchngr805 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr805 CLUSTER ON _documen805_bydatakey_rr;


--
-- Name: _documen805_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen805_bynodemsg_rnr ON _documentchngr805 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen838_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen838_bydatakey_rr ON _documentchngr838 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr838 CLUSTER ON _documen838_bydatakey_rr;


--
-- Name: _documen838_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen838_bynodemsg_rnr ON _documentchngr838 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen860_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen860_bydatakey_rr ON _documentchngr860 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr860 CLUSTER ON _documen860_bydatakey_rr;


--
-- Name: _documen860_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen860_bynodemsg_rnr ON _documentchngr860 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen881_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen881_bydatakey_rr ON _documentchngr881 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr881 CLUSTER ON _documen881_bydatakey_rr;


--
-- Name: _documen881_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen881_bynodemsg_rnr ON _documentchngr881 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen935_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen935_bydatakey_rr ON _documentchngr935 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr935 CLUSTER ON _documen935_bydatakey_rr;


--
-- Name: _documen935_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen935_bynodemsg_rnr ON _documentchngr935 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen951_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen951_bydatakey_rr ON _documentchngr951 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr951 CLUSTER ON _documen951_bydatakey_rr;


--
-- Name: _documen951_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen951_bynodemsg_rnr ON _documentchngr951 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _documen989_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen989_bydatakey_rr ON _documentchngr989 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _documentchngr989 CLUSTER ON _documen989_bydatakey_rr;


--
-- Name: _documen989_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _documen989_bynodemsg_rnr ON _documentchngr989 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _document52_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document52_bydocdate_trl ON _document52 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document52_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document52_bydocnum_sr ON _document52 USING btree (_number, _idrref);


--
-- Name: _document52_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document52_bydocnumprefix_tsr ON _document52 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document52_vt553_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document52_vt553_intkeyind ON _document52_vt553 USING btree (_document52_idrref, _keyfield);

ALTER TABLE _document52_vt553 CLUSTER ON _document52_vt553_intkeyind;


--
-- Name: _document53_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document53_bydocdate_trl ON _document53 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document53_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document53_bydocnum_sr ON _document53 USING btree (_number, _idrref);


--
-- Name: _document53_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document53_bydocnumprefix_tsr ON _document53 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document53_vt575_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document53_vt575_intkeyind ON _document53_vt575 USING btree (_document53_idrref, _keyfield);

ALTER TABLE _document53_vt575 CLUSTER ON _document53_vt575_intkeyind;


--
-- Name: _document53_vt582_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document53_vt582_intkeyind ON _document53_vt582 USING btree (_document53_idrref, _keyfield);

ALTER TABLE _document53_vt582 CLUSTER ON _document53_vt582_intkeyind;


--
-- Name: _document54_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document54_bydocdate_trl ON _document54 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document54_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document54_bydocnum_sr ON _document54 USING btree (_number, _idrref);


--
-- Name: _document54_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document54_bydocnumprefix_tsr ON _document54 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document54_byfield602_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document54_byfield602_rr ON _document54 USING btree (_fld591rref, _idrref);


--
-- Name: _document54_vt595_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document54_vt595_intkeyind ON _document54_vt595 USING btree (_document54_idrref, _keyfield);

ALTER TABLE _document54_vt595 CLUSTER ON _document54_vt595_intkeyind;


--
-- Name: _document55_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document55_bydocdate_trl ON _document55 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document55_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document55_bydocnum_sr ON _document55 USING btree (_number, _idrref);


--
-- Name: _document55_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document55_bydocnumprefix_tsr ON _document55 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document55_vt615_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document55_vt615_intkeyind ON _document55_vt615 USING btree (_document55_idrref, _keyfield);

ALTER TABLE _document55_vt615 CLUSTER ON _document55_vt615_intkeyind;


--
-- Name: _document56_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document56_bydocdate_trl ON _document56 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document56_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document56_bydocnum_sr ON _document56 USING btree (_number, _idrref);


--
-- Name: _document56_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document56_bydocnumprefix_tsr ON _document56 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document56_vt1655_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document56_vt1655_intkeyind ON _document56_vt1655 USING btree (_document56_idrref, _keyfield);

ALTER TABLE _document56_vt1655 CLUSTER ON _document56_vt1655_intkeyind;


--
-- Name: _document56_vt646_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document56_vt646_intkeyind ON _document56_vt646 USING btree (_document56_idrref, _keyfield);

ALTER TABLE _document56_vt646 CLUSTER ON _document56_vt646_intkeyind;


--
-- Name: _document56_vt669_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document56_vt669_intkeyind ON _document56_vt669 USING btree (_document56_idrref, _keyfield);

ALTER TABLE _document56_vt669 CLUSTER ON _document56_vt669_intkeyind;


--
-- Name: _document56_vt672_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document56_vt672_intkeyind ON _document56_vt672 USING btree (_document56_idrref, _keyfield);

ALTER TABLE _document56_vt672 CLUSTER ON _document56_vt672_intkeyind;


--
-- Name: _document56_vt675_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document56_vt675_intkeyind ON _document56_vt675 USING btree (_document56_idrref, _keyfield);

ALTER TABLE _document56_vt675 CLUSTER ON _document56_vt675_intkeyind;


--
-- Name: _document57_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document57_bydocdate_trl ON _document57 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document57_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document57_bydocnum_sr ON _document57 USING btree (_number, _idrref);


--
-- Name: _document57_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document57_bydocnumprefix_tsr ON _document57 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document57_byfield700_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document57_byfield700_rr ON _document57 USING btree (_fld681rref, _idrref);


--
-- Name: _document57_vt689_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document57_vt689_intkeyind ON _document57_vt689 USING btree (_document57_idrref, _keyfield);

ALTER TABLE _document57_vt689 CLUSTER ON _document57_vt689_intkeyind;


--
-- Name: _document58_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document58_bydocdate_trl ON _document58 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document58_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document58_bydocnum_sr ON _document58 USING btree (_number, _idrref);


--
-- Name: _document58_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document58_bydocnumprefix_tsr ON _document58 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document58_byfield720_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document58_byfield720_rr ON _document58 USING btree (_fld703rref, _idrref);


--
-- Name: _document58_vt706_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document58_vt706_intkeyind ON _document58_vt706 USING btree (_document58_idrref, _keyfield);

ALTER TABLE _document58_vt706 CLUSTER ON _document58_vt706_intkeyind;


--
-- Name: _document59_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document59_bydocdate_trl ON _document59 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document59_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document59_bydocnum_sr ON _document59 USING btree (_number, _idrref);


--
-- Name: _document59_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document59_bydocnumprefix_tsr ON _document59 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document59_vt727_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document59_vt727_intkeyind ON _document59_vt727 USING btree (_document59_idrref, _keyfield);

ALTER TABLE _document59_vt727 CLUSTER ON _document59_vt727_intkeyind;


--
-- Name: _document60_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document60_bydocdate_trl ON _document60 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document60_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document60_bydocnum_sr ON _document60 USING btree (_number, _idrref);


--
-- Name: _document60_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document60_bydocnumprefix_tsr ON _document60 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document60_byfield750_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document60_byfield750_rr ON _document60 USING btree (_fld734rref, _idrref);


--
-- Name: _document60_vt740_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document60_vt740_intkeyind ON _document60_vt740 USING btree (_document60_idrref, _keyfield);

ALTER TABLE _document60_vt740 CLUSTER ON _document60_vt740_intkeyind;


--
-- Name: _document61_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document61_bydocdate_trl ON _document61 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document61_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document61_bydocnum_sr ON _document61 USING btree (_number, _idrref);


--
-- Name: _document61_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document61_bydocnumprefix_tsr ON _document61 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document61_vt754_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document61_vt754_intkeyind ON _document61_vt754 USING btree (_document61_idrref, _keyfield);

ALTER TABLE _document61_vt754 CLUSTER ON _document61_vt754_intkeyind;


--
-- Name: _document62_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document62_bydocdate_trl ON _document62 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document62_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document62_bydocnum_sr ON _document62 USING btree (_number, _idrref);


--
-- Name: _document62_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document62_bydocnumprefix_tsr ON _document62 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document62_byfield771_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document62_byfield771_rr ON _document62 USING btree (_fld760rref, _idrref);


--
-- Name: _document62_vt765_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document62_vt765_intkeyind ON _document62_vt765 USING btree (_document62_idrref, _keyfield);

ALTER TABLE _document62_vt765 CLUSTER ON _document62_vt765_intkeyind;


--
-- Name: _document63_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document63_bydocdate_trl ON _document63 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document63_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document63_bydocnum_sr ON _document63 USING btree (_number, _idrref);


--
-- Name: _document63_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document63_bydocnumprefix_tsr ON _document63 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document63_vt784_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document63_vt784_intkeyind ON _document63_vt784 USING btree (_document63_idrref, _keyfield);

ALTER TABLE _document63_vt784 CLUSTER ON _document63_vt784_intkeyind;


--
-- Name: _document63_vt794_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document63_vt794_intkeyind ON _document63_vt794 USING btree (_document63_idrref, _keyfield);

ALTER TABLE _document63_vt794 CLUSTER ON _document63_vt794_intkeyind;


--
-- Name: _document64_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document64_bydocdate_trl ON _document64 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document64_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document64_bydocnum_sr ON _document64 USING btree (_number, _idrref);


--
-- Name: _document64_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document64_bydocnumprefix_tsr ON _document64 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document64_byfield837_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document64_byfield837_rr ON _document64 USING btree (_fld808rref, _idrref);


--
-- Name: _document64_vt823_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document64_vt823_intkeyind ON _document64_vt823 USING btree (_document64_idrref, _keyfield);

ALTER TABLE _document64_vt823 CLUSTER ON _document64_vt823_intkeyind;


--
-- Name: _document65_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document65_bydocdate_trl ON _document65 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document65_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document65_bydocnum_sr ON _document65 USING btree (_number, _idrref);


--
-- Name: _document65_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document65_bydocnumprefix_tsr ON _document65 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document65_byfield859_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document65_byfield859_rr ON _document65 USING btree (_fld845rref, _idrref);


--
-- Name: _document66_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document66_bydocdate_trl ON _document66 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document66_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document66_bydocnum_sr ON _document66 USING btree (_number, _idrref);


--
-- Name: _document66_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document66_bydocnumprefix_tsr ON _document66 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document66_byfield880_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document66_byfield880_rr ON _document66 USING btree (_fld868rref, _idrref);


--
-- Name: _document67_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document67_bydocdate_trl ON _document67 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document67_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document67_bydocnum_sr ON _document67 USING btree (_number, _idrref);


--
-- Name: _document67_byfield934_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document67_byfield934_rr ON _document67 USING btree (_fld889rref, _idrref);


--
-- Name: _document67_vt1658_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document67_vt1658_intkeyind ON _document67_vt1658 USING btree (_document67_idrref, _keyfield);

ALTER TABLE _document67_vt1658 CLUSTER ON _document67_vt1658_intkeyind;


--
-- Name: _document67_vt907_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document67_vt907_intkeyind ON _document67_vt907 USING btree (_document67_idrref, _keyfield);

ALTER TABLE _document67_vt907 CLUSTER ON _document67_vt907_intkeyind;


--
-- Name: _document68_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document68_bydocdate_trl ON _document68 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document68_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document68_bydocnum_sr ON _document68 USING btree (_number, _idrref);


--
-- Name: _document68_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document68_bydocnumprefix_tsr ON _document68 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document68_byfield950_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document68_byfield950_rr ON _document68 USING btree (_fld937rref, _idrref);


--
-- Name: _document68_vt941_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document68_vt941_intkeyind ON _document68_vt941 USING btree (_document68_idrref, _keyfield);

ALTER TABLE _document68_vt941 CLUSTER ON _document68_vt941_intkeyind;


--
-- Name: _document69_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document69_bydocdate_trl ON _document69 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document69_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document69_bydocnum_sr ON _document69 USING btree (_number, _idrref);


--
-- Name: _document69_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document69_bydocnumprefix_tsr ON _document69 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document69_vt967_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document69_vt967_intkeyind ON _document69_vt967 USING btree (_document69_idrref, _keyfield);

ALTER TABLE _document69_vt967 CLUSTER ON _document69_vt967_intkeyind;


--
-- Name: _document69_vt972_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document69_vt972_intkeyind ON _document69_vt972 USING btree (_document69_idrref, _keyfield);

ALTER TABLE _document69_vt972 CLUSTER ON _document69_vt972_intkeyind;


--
-- Name: _document69_vt978_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document69_vt978_intkeyind ON _document69_vt978 USING btree (_document69_idrref, _keyfield);

ALTER TABLE _document69_vt978 CLUSTER ON _document69_vt978_intkeyind;


--
-- Name: _document69_vt981_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document69_vt981_intkeyind ON _document69_vt981 USING btree (_document69_idrref, _keyfield);

ALTER TABLE _document69_vt981 CLUSTER ON _document69_vt981_intkeyind;


--
-- Name: _document69_vt984_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document69_vt984_intkeyind ON _document69_vt984 USING btree (_document69_idrref, _keyfield);

ALTER TABLE _document69_vt984 CLUSTER ON _document69_vt984_intkeyind;


--
-- Name: _document70_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document70_bydocdate_trl ON _document70 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document70_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document70_bydocnum_sr ON _document70 USING btree (_number, _idrref);


--
-- Name: _document70_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document70_bydocnumprefix_tsr ON _document70 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document70_vt994_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document70_vt994_intkeyind ON _document70_vt994 USING btree (_document70_idrref, _keyfield);

ALTER TABLE _document70_vt994 CLUSTER ON _document70_vt994_intkeyind;


--
-- Name: _document71_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document71_bydocdate_trl ON _document71 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document71_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document71_bydocnum_sr ON _document71 USING btree (_number, _idrref);


--
-- Name: _document71_bydocnumprefix_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document71_bydocnumprefix_tsr ON _document71 USING btree (_numberprefix, _number, _idrref);


--
-- Name: _document71_vt1007_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document71_vt1007_intkeyind ON _document71_vt1007 USING btree (_document71_idrref, _keyfield);

ALTER TABLE _document71_vt1007 CLUSTER ON _document71_vt1007_intkeyind;


--
-- Name: _document72_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document72_bydocdate_trl ON _document72 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document72_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document72_bydocnum_sr ON _document72 USING btree (_number, _idrref);


--
-- Name: _document72_vt1032_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document72_vt1032_intkeyind ON _document72_vt1032 USING btree (_document72_idrref, _keyfield);

ALTER TABLE _document72_vt1032 CLUSTER ON _document72_vt1032_intkeyind;


--
-- Name: _document72_vt1035_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document72_vt1035_intkeyind ON _document72_vt1035 USING btree (_document72_idrref, _keyfield);

ALTER TABLE _document72_vt1035 CLUSTER ON _document72_vt1035_intkeyind;


--
-- Name: _document73_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document73_bydocdate_trl ON _document73 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document73_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document73_bydocnum_sr ON _document73 USING btree (_number, _idrref);


--
-- Name: _document73_vt1041_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document73_vt1041_intkeyind ON _document73_vt1041 USING btree (_document73_idrref, _keyfield);

ALTER TABLE _document73_vt1041 CLUSTER ON _document73_vt1041_intkeyind;


--
-- Name: _document74_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document74_bydocdate_trl ON _document74 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document74_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document74_bydocnum_sr ON _document74 USING btree (_number, _idrref);


--
-- Name: _document75_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document75_bydocdate_trl ON _document75 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document75_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document75_bydocnum_sr ON _document75 USING btree (_number, _idrref);


--
-- Name: _document75_vt1074_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document75_vt1074_intkeyind ON _document75_vt1074 USING btree (_document75_idrref, _keyfield);

ALTER TABLE _document75_vt1074 CLUSTER ON _document75_vt1074_intkeyind;


--
-- Name: _document76_bydocdate_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document76_bydocdate_trl ON _document76 USING btree (_date_time, _idrref, _marked);


--
-- Name: _document76_bydocnum_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document76_bydocnum_sr ON _document76 USING btree (_number, _idrref);


--
-- Name: _document76_vt1103_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _document76_vt1103_intkeyind ON _document76_vt1103 USING btree (_document76_idrref, _keyfield);

ALTER TABLE _document76_vt1103 CLUSTER ON _document76_vt1103_intkeyind;


--
-- Name: _dynlistset_bykey_sss; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _dynlistset_bykey_sss ON _dynlistsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _dynlistsettings CLUSTER ON _dynlistset_bykey_sss;


--
-- Name: _enum100_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum100_byorder_nr ON _enum100 USING btree (_enumorder, _idrref);


--
-- Name: _enum101_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum101_byorder_nr ON _enum101 USING btree (_enumorder, _idrref);


--
-- Name: _enum102_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum102_byorder_nr ON _enum102 USING btree (_enumorder, _idrref);


--
-- Name: _enum103_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum103_byorder_nr ON _enum103 USING btree (_enumorder, _idrref);


--
-- Name: _enum104_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum104_byorder_nr ON _enum104 USING btree (_enumorder, _idrref);


--
-- Name: _enum105_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum105_byorder_nr ON _enum105 USING btree (_enumorder, _idrref);


--
-- Name: _enum106_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum106_byorder_nr ON _enum106 USING btree (_enumorder, _idrref);


--
-- Name: _enum107_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum107_byorder_nr ON _enum107 USING btree (_enumorder, _idrref);


--
-- Name: _enum108_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum108_byorder_nr ON _enum108 USING btree (_enumorder, _idrref);


--
-- Name: _enum109_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum109_byorder_nr ON _enum109 USING btree (_enumorder, _idrref);


--
-- Name: _enum110_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum110_byorder_nr ON _enum110 USING btree (_enumorder, _idrref);


--
-- Name: _enum111_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum111_byorder_nr ON _enum111 USING btree (_enumorder, _idrref);


--
-- Name: _enum112_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum112_byorder_nr ON _enum112 USING btree (_enumorder, _idrref);


--
-- Name: _enum113_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum113_byorder_nr ON _enum113 USING btree (_enumorder, _idrref);


--
-- Name: _enum114_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum114_byorder_nr ON _enum114 USING btree (_enumorder, _idrref);


--
-- Name: _enum115_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum115_byorder_nr ON _enum115 USING btree (_enumorder, _idrref);


--
-- Name: _enum116_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum116_byorder_nr ON _enum116 USING btree (_enumorder, _idrref);


--
-- Name: _enum117_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum117_byorder_nr ON _enum117 USING btree (_enumorder, _idrref);


--
-- Name: _enum118_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum118_byorder_nr ON _enum118 USING btree (_enumorder, _idrref);


--
-- Name: _enum119_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum119_byorder_nr ON _enum119 USING btree (_enumorder, _idrref);


--
-- Name: _enum120_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum120_byorder_nr ON _enum120 USING btree (_enumorder, _idrref);


--
-- Name: _enum121_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum121_byorder_nr ON _enum121 USING btree (_enumorder, _idrref);


--
-- Name: _enum122_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum122_byorder_nr ON _enum122 USING btree (_enumorder, _idrref);


--
-- Name: _enum123_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum123_byorder_nr ON _enum123 USING btree (_enumorder, _idrref);


--
-- Name: _enum124_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum124_byorder_nr ON _enum124 USING btree (_enumorder, _idrref);


--
-- Name: _enum125_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum125_byorder_nr ON _enum125 USING btree (_enumorder, _idrref);


--
-- Name: _enum126_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum126_byorder_nr ON _enum126 USING btree (_enumorder, _idrref);


--
-- Name: _enum77_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum77_byorder_nr ON _enum77 USING btree (_enumorder, _idrref);


--
-- Name: _enum78_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum78_byorder_nr ON _enum78 USING btree (_enumorder, _idrref);


--
-- Name: _enum79_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum79_byorder_nr ON _enum79 USING btree (_enumorder, _idrref);


--
-- Name: _enum80_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum80_byorder_nr ON _enum80 USING btree (_enumorder, _idrref);


--
-- Name: _enum81_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum81_byorder_nr ON _enum81 USING btree (_enumorder, _idrref);


--
-- Name: _enum82_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum82_byorder_nr ON _enum82 USING btree (_enumorder, _idrref);


--
-- Name: _enum83_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum83_byorder_nr ON _enum83 USING btree (_enumorder, _idrref);


--
-- Name: _enum84_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum84_byorder_nr ON _enum84 USING btree (_enumorder, _idrref);


--
-- Name: _enum85_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum85_byorder_nr ON _enum85 USING btree (_enumorder, _idrref);


--
-- Name: _enum86_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum86_byorder_nr ON _enum86 USING btree (_enumorder, _idrref);


--
-- Name: _enum87_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum87_byorder_nr ON _enum87 USING btree (_enumorder, _idrref);


--
-- Name: _enum88_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum88_byorder_nr ON _enum88 USING btree (_enumorder, _idrref);


--
-- Name: _enum89_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum89_byorder_nr ON _enum89 USING btree (_enumorder, _idrref);


--
-- Name: _enum90_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum90_byorder_nr ON _enum90 USING btree (_enumorder, _idrref);


--
-- Name: _enum91_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum91_byorder_nr ON _enum91 USING btree (_enumorder, _idrref);


--
-- Name: _enum92_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum92_byorder_nr ON _enum92 USING btree (_enumorder, _idrref);


--
-- Name: _enum93_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum93_byorder_nr ON _enum93 USING btree (_enumorder, _idrref);


--
-- Name: _enum94_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum94_byorder_nr ON _enum94 USING btree (_enumorder, _idrref);


--
-- Name: _enum95_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum95_byorder_nr ON _enum95 USING btree (_enumorder, _idrref);


--
-- Name: _enum96_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum96_byorder_nr ON _enum96 USING btree (_enumorder, _idrref);


--
-- Name: _enum97_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum97_byorder_nr ON _enum97 USING btree (_enumorder, _idrref);


--
-- Name: _enum98_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum98_byorder_nr ON _enum98 USING btree (_enumorder, _idrref);


--
-- Name: _enum99_byorder_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _enum99_byorder_nr ON _enum99 USING btree (_enumorder, _idrref);


--
-- Name: _frmdtsetti_bykey_sss; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _frmdtsetti_bykey_sss ON _frmdtsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _frmdtsettings CLUSTER ON _frmdtsetti_bykey_sss;


--
-- Name: _inforg1203_bydims1215_nnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_bydims1215_nnnnnnn ON _inforg1203 USING btree (_fld1205, _fld1204, _fld1206, _fld1207, _fld1208, _fld1209, _fld1210);


--
-- Name: _inforg1203_bydims1216_nnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_bydims1216_nnnnnnn ON _inforg1203 USING btree (_fld1206, _fld1204, _fld1205, _fld1207, _fld1208, _fld1209, _fld1210);


--
-- Name: _inforg1203_bydims1217_nnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_bydims1217_nnnnnnn ON _inforg1203 USING btree (_fld1207, _fld1204, _fld1205, _fld1206, _fld1208, _fld1209, _fld1210);


--
-- Name: _inforg1203_bydims1218_nnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_bydims1218_nnnnnnn ON _inforg1203 USING btree (_fld1208, _fld1204, _fld1205, _fld1206, _fld1207, _fld1209, _fld1210);


--
-- Name: _inforg1203_bydims1219_nnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_bydims1219_nnnnnnn ON _inforg1203 USING btree (_fld1209, _fld1204, _fld1205, _fld1206, _fld1207, _fld1208, _fld1210);


--
-- Name: _inforg1203_bydims1220_nnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_bydims1220_nnnnnnn ON _inforg1203 USING btree (_fld1210, _fld1204, _fld1205, _fld1206, _fld1207, _fld1208, _fld1209);


--
-- Name: _inforg1203_bydims_nnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_bydims_nnnnnnn ON _inforg1203 USING btree (_fld1204, _fld1205, _fld1206, _fld1207, _fld1208, _fld1209, _fld1210);

ALTER TABLE _inforg1203 CLUSTER ON _inforg1203_bydims_nnnnnnn;


--
-- Name: _inforg1203_byresource1221_snnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_byresource1221_snnnnnnn ON _inforg1203 USING btree (_fld1211, _fld1204, _fld1205, _fld1206, _fld1207, _fld1208, _fld1209, _fld1210);


--
-- Name: _inforg1203_byresource1222_snnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_byresource1222_snnnnnnn ON _inforg1203 USING btree (_fld1213, _fld1204, _fld1205, _fld1206, _fld1207, _fld1208, _fld1209, _fld1210);


--
-- Name: _inforg1203_byresource1223_snnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_byresource1223_snnnnnnn ON _inforg1203 USING btree (_fld1214, _fld1204, _fld1205, _fld1206, _fld1207, _fld1208, _fld1209, _fld1210);


--
-- Name: _inforg1203_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1203_bysimplekey_b ON _inforg1203 USING btree (_simplekey);


--
-- Name: _inforg1224_bydatakey_nnnnnnnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1224_bydatakey_nnnnnnnr ON _inforgchngr1224 USING btree (_fld1204, _fld1205, _fld1206, _fld1207, _fld1208, _fld1209, _fld1210, _nodetref, _noderref);

ALTER TABLE _inforgchngr1224 CLUSTER ON _inforg1224_bydatakey_nnnnnnnr;


--
-- Name: _inforg1224_bynodemsg_rnnnnnnnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1224_bynodemsg_rnnnnnnnn ON _inforgchngr1224 USING btree (_nodetref, _noderref, _messageno, _fld1204, _fld1205, _fld1206, _fld1207, _fld1208, _fld1209, _fld1210);


--
-- Name: _inforg1225_bydims_rrt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1225_bydims_rrt ON _inforg1225 USING btree (_fld1226rref, _fld1662rref, _period);

ALTER TABLE _inforg1225 CLUSTER ON _inforg1225_bydims_rrt;


--
-- Name: _inforg1225_byperiod_trr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1225_byperiod_trr ON _inforg1225 USING btree (_period, _fld1226rref, _fld1662rref);


--
-- Name: _inforg1225_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1225_byrecorder_rn ON _inforg1225 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _inforg1232_bydims_rtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1232_bydims_rtrn ON _inforg1232 USING btree (_fld1233rref, _period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _inforg1232 CLUSTER ON _inforg1232_bydims_rtrn;


--
-- Name: _inforg1232_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1232_byperiod_trn ON _inforg1232 USING btree (_period, _recordertref, _recorderrref, _lineno);


--
-- Name: _inforg1232_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1232_byrecorder_rn ON _inforg1232 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _inforg1238_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1238_bydatakey_rr ON _inforgchngr1238 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _inforgchngr1238 CLUSTER ON _inforg1238_bydatakey_rr;


--
-- Name: _inforg1238_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1238_bynodemsg_rnr ON _inforgchngr1238 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _inforg1239_bydims_rt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1239_bydims_rt ON _inforg1239 USING btree (_fld1240rref, _period);

ALTER TABLE _inforg1239 CLUSTER ON _inforg1239_bydims_rt;


--
-- Name: _inforg1239_byperiod_tr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1239_byperiod_tr ON _inforg1239 USING btree (_period, _fld1240rref);


--
-- Name: _inforg1239_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1239_byrecorder_rn ON _inforg1239 USING btree (_recorderrref, _lineno);


--
-- Name: _inforg1244_bydims1259_rtl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1244_bydims1259_rtl ON _inforg1244 USING btree (_fld1245_type, _fld1245_rtref, _fld1245_rrref, _period, _fld1246);


--
-- Name: _inforg1244_bydims1260_ltr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1244_bydims1260_ltr ON _inforg1244 USING btree (_fld1246, _period, _fld1245_type, _fld1245_rtref, _fld1245_rrref);


--
-- Name: _inforg1244_bydims_rlt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1244_bydims_rlt ON _inforg1244 USING btree (_fld1245_type, _fld1245_rtref, _fld1245_rrref, _fld1246, _period);

ALTER TABLE _inforg1244 CLUSTER ON _inforg1244_bydims_rlt;


--
-- Name: _inforg1244_byperiod_trl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1244_byperiod_trl ON _inforg1244 USING btree (_period, _fld1245_type, _fld1245_rtref, _fld1245_rrref, _fld1246);


--
-- Name: _inforg1244_byresource1261_ntrl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1244_byresource1261_ntrl ON _inforg1244 USING btree (_fld1248, _period, _fld1245_type, _fld1245_rtref, _fld1245_rrref, _fld1246);


--
-- Name: _inforg1262_bydatakey_trlr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1262_bydatakey_trlr ON _inforgchngr1262 USING btree (_period, _fld1245_type, _fld1245_rtref, _fld1245_rrref, _fld1246, _nodetref, _noderref);

ALTER TABLE _inforgchngr1262 CLUSTER ON _inforg1262_bydatakey_trlr;


--
-- Name: _inforg1262_bynodemsg_rntrl; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1262_bynodemsg_rntrl ON _inforgchngr1262 USING btree (_nodetref, _noderref, _messageno, _period, _fld1245_type, _fld1245_rtref, _fld1245_rrref, _fld1246);


--
-- Name: _inforg1263_bydims_r; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1263_bydims_r ON _inforg1263 USING btree (_fld1264rref);

ALTER TABLE _inforg1263 CLUSTER ON _inforg1263_bydims_r;


--
-- Name: _inforg1267_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1267_bydatakey_rr ON _inforgchngr1267 USING btree (_fld1264rref, _nodetref, _noderref);

ALTER TABLE _inforgchngr1267 CLUSTER ON _inforg1267_bydatakey_rr;


--
-- Name: _inforg1267_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1267_bynodemsg_rnr ON _inforgchngr1267 USING btree (_nodetref, _noderref, _messageno, _fld1264rref);


--
-- Name: _inforg1268_bydims_n; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1268_bydims_n ON _inforg1268 USING btree (_fld1269);

ALTER TABLE _inforg1268 CLUSTER ON _inforg1268_bydims_n;


--
-- Name: _inforg1268_byresource1271_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1268_byresource1271_rn ON _inforg1268 USING btree (_fld1270rref, _fld1269);


--
-- Name: _inforg1272_bydatakey_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1272_bydatakey_nr ON _inforgchngr1272 USING btree (_fld1269, _nodetref, _noderref);

ALTER TABLE _inforgchngr1272 CLUSTER ON _inforg1272_bydatakey_nr;


--
-- Name: _inforg1272_bynodemsg_rnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1272_bynodemsg_rnn ON _inforgchngr1272 USING btree (_nodetref, _noderref, _messageno, _fld1269);


--
-- Name: _inforg1273_bydims1282_rrt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1273_bydims1282_rrt ON _inforg1273 USING btree (_fld1275_type, _fld1275_rtref, _fld1275_rrref, _fld1274_type, _fld1274_rtref, _fld1274_rrref, _fld1276);


--
-- Name: _inforg1273_bydims1282_rst; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1273_bydims1282_rst ON _inforg1273 USING btree (_fld1275_type, _fld1275_rtref, _fld1275_rrref, _fld1274_type, _fld1274_s, _fld1276);


--
-- Name: _inforg1273_bydims1283_trr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1273_bydims1283_trr ON _inforg1273 USING btree (_fld1276, _fld1274_type, _fld1274_rtref, _fld1274_rrref, _fld1275_type, _fld1275_rtref, _fld1275_rrref);


--
-- Name: _inforg1273_bydims1283_tsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1273_bydims1283_tsr ON _inforg1273 USING btree (_fld1276, _fld1274_type, _fld1274_s, _fld1275_type, _fld1275_rtref, _fld1275_rrref);


--
-- Name: _inforg1273_bydims_rrt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1273_bydims_rrt ON _inforg1273 USING btree (_fld1274_type, _fld1274_rtref, _fld1274_rrref, _fld1275_type, _fld1275_rtref, _fld1275_rrref, _fld1276);

ALTER TABLE _inforg1273 CLUSTER ON _inforg1273_bydims_rrt;


--
-- Name: _inforg1273_bydims_srt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1273_bydims_srt ON _inforg1273 USING btree (_fld1274_type, _fld1274_s, _fld1275_type, _fld1275_rtref, _fld1275_rrref, _fld1276);


--
-- Name: _inforg1273_byresource1284_rrrt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1273_byresource1284_rrrt ON _inforg1273 USING btree (_fld1279rref, _fld1274_type, _fld1274_rtref, _fld1274_rrref, _fld1275_type, _fld1275_rtref, _fld1275_rrref, _fld1276);


--
-- Name: _inforg1273_byresource1284_rsrt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1273_byresource1284_rsrt ON _inforg1273 USING btree (_fld1279rref, _fld1274_type, _fld1274_s, _fld1275_type, _fld1275_rtref, _fld1275_rrref, _fld1276);


--
-- Name: _inforg1273_byresource1285_rrrt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1273_byresource1285_rrrt ON _inforg1273 USING btree (_fld1280rref, _fld1274_type, _fld1274_rtref, _fld1274_rrref, _fld1275_type, _fld1275_rtref, _fld1275_rrref, _fld1276);


--
-- Name: _inforg1273_byresource1285_rsrt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1273_byresource1285_rsrt ON _inforg1273 USING btree (_fld1280rref, _fld1274_type, _fld1274_s, _fld1275_type, _fld1275_rtref, _fld1275_rrref, _fld1276);


--
-- Name: _inforg1273_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1273_bysimplekey_b ON _inforg1273 USING btree (_simplekey);


--
-- Name: _inforg1286_bydims_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1286_bydims_rn ON _inforg1286 USING btree (_fld1287rref, _fld1288);

ALTER TABLE _inforg1286 CLUSTER ON _inforg1286_bydims_rn;


--
-- Name: _inforg1286_byproperty1306_rrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1286_byproperty1306_rrn ON _inforg1286 USING btree (_fld1305rref, _fld1287rref, _fld1288);


--
-- Name: _inforg1286_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1286_bysimplekey_b ON _inforg1286 USING btree (_simplekey);


--
-- Name: _inforg1307_bydatakey_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1307_bydatakey_rnr ON _inforgchngr1307 USING btree (_fld1287rref, _fld1288, _nodetref, _noderref);

ALTER TABLE _inforgchngr1307 CLUSTER ON _inforg1307_bydatakey_rnr;


--
-- Name: _inforg1307_bynodemsg_rnrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1307_bynodemsg_rnrn ON _inforgchngr1307 USING btree (_nodetref, _noderref, _messageno, _fld1287rref, _fld1288);


--
-- Name: _inforg1308_bydims1312_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1308_bydims1312_rr ON _inforg1308 USING btree (_fld1310rref, _fld1309rref);


--
-- Name: _inforg1308_bydims_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1308_bydims_rr ON _inforg1308 USING btree (_fld1309rref, _fld1310rref);

ALTER TABLE _inforg1308 CLUSTER ON _inforg1308_bydims_rr;


--
-- Name: _inforg1308_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1308_bysimplekey_b ON _inforg1308 USING btree (_simplekey);


--
-- Name: _inforg1313_bydatakey_rrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1313_bydatakey_rrr ON _inforgchngr1313 USING btree (_fld1309rref, _fld1310rref, _nodetref, _noderref);

ALTER TABLE _inforgchngr1313 CLUSTER ON _inforg1313_bydatakey_rrr;


--
-- Name: _inforg1313_bynodemsg_rnrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1313_bynodemsg_rnrr ON _inforgchngr1313 USING btree (_nodetref, _noderref, _messageno, _fld1309rref, _fld1310rref);


--
-- Name: _inforg1314_bydims_r; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1314_bydims_r ON _inforg1314 USING btree (_fld1315_type, _fld1315_rtref, _fld1315_rrref);

ALTER TABLE _inforg1314 CLUSTER ON _inforg1314_bydims_r;


--
-- Name: _inforg1347_bydims_r; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1347_bydims_r ON _inforg1347 USING btree (_fld1348_type, _fld1348_rtref, _fld1348_rrref);

ALTER TABLE _inforg1347 CLUSTER ON _inforg1347_bydims_r;


--
-- Name: _inforg1352_bydims_r; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1352_bydims_r ON _inforg1352 USING btree (_fld1353_type, _fld1353_rtref, _fld1353_rrref);

ALTER TABLE _inforg1352 CLUSTER ON _inforg1352_bydims_r;


--
-- Name: _inforg1352_byresource1355_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1352_byresource1355_rr ON _inforg1352 USING btree (_fld1354_type, _fld1354_rtref, _fld1354_rrref, _fld1353_type, _fld1353_rtref, _fld1353_rrref);


--
-- Name: _inforg1356_bydims_rt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1356_bydims_rt ON _inforg1356 USING btree (_fld1357rref, _period);

ALTER TABLE _inforg1356 CLUSTER ON _inforg1356_bydims_rt;


--
-- Name: _inforg1356_byperiod_tr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1356_byperiod_tr ON _inforg1356 USING btree (_period, _fld1357rref);


--
-- Name: _inforg1356_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1356_byrecorder_rn ON _inforg1356 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _inforg1361_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1361_bydatakey_rr ON _inforgchngr1361 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _inforgchngr1361 CLUSTER ON _inforg1361_bydatakey_rr;


--
-- Name: _inforg1361_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1361_bynodemsg_rnr ON _inforgchngr1361 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _inforg1362_bydims1368_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1362_bydims1368_rr ON _inforg1362 USING btree (_fld1364_type, _fld1364_rtref, _fld1364_rrref, _fld1363_type, _fld1363_rtref, _fld1363_rrref);


--
-- Name: _inforg1362_bydims_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1362_bydims_rr ON _inforg1362 USING btree (_fld1363_type, _fld1363_rtref, _fld1363_rrref, _fld1364_type, _fld1364_rtref, _fld1364_rrref);

ALTER TABLE _inforg1362 CLUSTER ON _inforg1362_bydims_rr;


--
-- Name: _inforg1362_byresource1369_trr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1362_byresource1369_trr ON _inforg1362 USING btree (_fld1365, _fld1363_type, _fld1363_rtref, _fld1363_rrref, _fld1364_type, _fld1364_rtref, _fld1364_rrref);


--
-- Name: _inforg1362_byresource1370_nrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1362_byresource1370_nrr ON _inforg1362 USING btree (_fld1366, _fld1363_type, _fld1363_rtref, _fld1363_rrref, _fld1364_type, _fld1364_rtref, _fld1364_rrref);


--
-- Name: _inforg1362_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1362_bysimplekey_b ON _inforg1362 USING btree (_simplekey);


--
-- Name: _inforg1371_bydatakey_rrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1371_bydatakey_rrr ON _inforgchngr1371 USING btree (_fld1363_type, _fld1363_rtref, _fld1363_rrref, _fld1364_type, _fld1364_rtref, _fld1364_rrref, _nodetref, _noderref);

ALTER TABLE _inforgchngr1371 CLUSTER ON _inforg1371_bydatakey_rrr;


--
-- Name: _inforg1371_bynodemsg_rnrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1371_bynodemsg_rnrr ON _inforgchngr1371 USING btree (_nodetref, _noderref, _messageno, _fld1363_type, _fld1363_rtref, _fld1363_rrref, _fld1364_type, _fld1364_rtref, _fld1364_rrref);


--
-- Name: _inforg1372_bydims_r; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1372_bydims_r ON _inforg1372 USING btree (_fld1373_type, _fld1373_rtref, _fld1373_rrref);

ALTER TABLE _inforg1372 CLUSTER ON _inforg1372_bydims_r;


--
-- Name: _inforg1378_bydims_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1378_bydims_sr ON _inforg1378 USING btree (_fld1379, _fld1380rref);

ALTER TABLE _inforg1378 CLUSTER ON _inforg1378_bydims_sr;


--
-- Name: _inforg1378_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1378_bysimplekey_b ON _inforg1378 USING btree (_simplekey);


--
-- Name: _inforg1390_bydims_s; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1390_bydims_s ON _inforg1390 USING btree (_fld1391);

ALTER TABLE _inforg1390 CLUSTER ON _inforg1390_bydims_s;


--
-- Name: _inforg1392_bydims1396_rtr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1392_bydims1396_rtr ON _inforg1392 USING btree (_fld1393rref, _period, _fld1394rref);


--
-- Name: _inforg1392_bydims_rrt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1392_bydims_rrt ON _inforg1392 USING btree (_fld1393rref, _fld1394rref, _period);

ALTER TABLE _inforg1392 CLUSTER ON _inforg1392_bydims_rrt;


--
-- Name: _inforg1392_byperiod_trr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1392_byperiod_trr ON _inforg1392 USING btree (_period, _fld1393rref, _fld1394rref);


--
-- Name: _inforg1397_bydatakey_trrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1397_bydatakey_trrr ON _inforgchngr1397 USING btree (_period, _fld1393rref, _fld1394rref, _nodetref, _noderref);

ALTER TABLE _inforgchngr1397 CLUSTER ON _inforg1397_bydatakey_trrr;


--
-- Name: _inforg1397_bynodemsg_rntrr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1397_bynodemsg_rntrr ON _inforgchngr1397 USING btree (_nodetref, _noderref, _messageno, _period, _fld1393rref, _fld1394rref);


--
-- Name: _inforg1398_bydims1407_rtrrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1398_bydims1407_rtrrn ON _inforg1398 USING btree (_fld1402rref, _period, _fld1399rref, _fld1400rref, _fld1401);


--
-- Name: _inforg1398_bydims_rrnrt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1398_bydims_rrnrt ON _inforg1398 USING btree (_fld1399rref, _fld1400rref, _fld1401, _fld1402rref, _period);

ALTER TABLE _inforg1398 CLUSTER ON _inforg1398_bydims_rrnrt;


--
-- Name: _inforg1398_byperiod_trrnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _inforg1398_byperiod_trrnr ON _inforg1398 USING btree (_period, _fld1399rref, _fld1400rref, _fld1401, _fld1402rref);


--
-- Name: _inforg1398_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1398_byrecorder_rn ON _inforg1398 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _inforg1408_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1408_bydatakey_rr ON _inforgchngr1408 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _inforgchngr1408 CLUSTER ON _inforg1408_bydatakey_rr;


--
-- Name: _inforg1408_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1408_bynodemsg_rnr ON _inforgchngr1408 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _inforg1409_bydims1414_rrs; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1409_bydims1414_rrs ON _inforg1409 USING btree (_fld1411_type, _fld1411_rtref, _fld1411_rrref, _fld1410_type, _fld1410_rtref, _fld1410_rrref, _fld1412);


--
-- Name: _inforg1409_bydims1415_srr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1409_bydims1415_srr ON _inforg1409 USING btree (_fld1412, _fld1410_type, _fld1410_rtref, _fld1410_rrref, _fld1411_type, _fld1411_rtref, _fld1411_rrref);


--
-- Name: _inforg1409_bydims_rrs; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1409_bydims_rrs ON _inforg1409 USING btree (_fld1410_type, _fld1410_rtref, _fld1410_rrref, _fld1411_type, _fld1411_rtref, _fld1411_rrref, _fld1412);

ALTER TABLE _inforg1409 CLUSTER ON _inforg1409_bydims_rrs;


--
-- Name: _inforg1409_byresource1416_srrs; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1409_byresource1416_srrs ON _inforg1409 USING btree (_fld1413, _fld1410_type, _fld1410_rtref, _fld1410_rrref, _fld1411_type, _fld1411_rtref, _fld1411_rrref, _fld1412);


--
-- Name: _inforg1409_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1409_bysimplekey_b ON _inforg1409 USING btree (_simplekey);


--
-- Name: _inforg1417_bydims1425_rrsss; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1417_bydims1425_rrsss ON _inforg1417 USING btree (_fld1419_type, _fld1419_rtref, _fld1419_rrref, _fld1418_type, _fld1418_rtref, _fld1418_rrref, _fld1420, _fld1421, _fld1422);


--
-- Name: _inforg1417_bydims_rrsss; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1417_bydims_rrsss ON _inforg1417 USING btree (_fld1418_type, _fld1418_rtref, _fld1418_rrref, _fld1419_type, _fld1419_rtref, _fld1419_rrref, _fld1420, _fld1421, _fld1422);

ALTER TABLE _inforg1417 CLUSTER ON _inforg1417_bydims_rrsss;


--
-- Name: _inforg1417_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1417_bysimplekey_b ON _inforg1417 USING btree (_simplekey);


--
-- Name: _inforg1426_bydims_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1426_bydims_rr ON _inforg1426 USING btree (_fld1427_type, _fld1427_rtref, _fld1427_rrref, _fld1428rref);

ALTER TABLE _inforg1426 CLUSTER ON _inforg1426_bydims_rr;


--
-- Name: _inforg1426_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1426_bysimplekey_b ON _inforg1426 USING btree (_simplekey);


--
-- Name: _inforg1432_bydims_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1432_bydims_rr ON _inforg1432 USING btree (_fld1433_type, _fld1433_rtref, _fld1433_rrref, _fld1434rref);

ALTER TABLE _inforg1432 CLUSTER ON _inforg1432_bydims_rr;


--
-- Name: _inforg1432_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1432_bysimplekey_b ON _inforg1432 USING btree (_simplekey);


--
-- Name: _inforg1436_bydims_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1436_bydims_rn ON _inforg1436 USING btree (_fld1437rref, _fld1438);

ALTER TABLE _inforg1436 CLUSTER ON _inforg1436_bydims_rn;


--
-- Name: _inforg1436_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1436_bysimplekey_b ON _inforg1436 USING btree (_simplekey);


--
-- Name: _inforg1440_bydatakey_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1440_bydatakey_rnr ON _inforgchngr1440 USING btree (_fld1437rref, _fld1438, _nodetref, _noderref);

ALTER TABLE _inforgchngr1440 CLUSTER ON _inforg1440_bydatakey_rnr;


--
-- Name: _inforg1440_bynodemsg_rnrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1440_bynodemsg_rnrn ON _inforgchngr1440 USING btree (_nodetref, _noderref, _messageno, _fld1437rref, _fld1438);


--
-- Name: _inforg1441_bydims_n; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1441_bydims_n ON _inforg1441 USING btree (_fld1442);

ALTER TABLE _inforg1441 CLUSTER ON _inforg1441_bydims_n;


--
-- Name: _inforg1444_bydatakey_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1444_bydatakey_nr ON _inforgchngr1444 USING btree (_fld1442, _nodetref, _noderref);

ALTER TABLE _inforgchngr1444 CLUSTER ON _inforg1444_bydatakey_nr;


--
-- Name: _inforg1444_bynodemsg_rnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1444_bynodemsg_rnn ON _inforgchngr1444 USING btree (_nodetref, _noderref, _messageno, _fld1442);


--
-- Name: _inforg1445_bydims_s; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1445_bydims_s ON _inforg1445 USING btree (_fld1446);

ALTER TABLE _inforg1445 CLUSTER ON _inforg1445_bydims_s;


--
-- Name: _inforg1445_byresource1453_rs; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1445_byresource1453_rs ON _inforg1445 USING btree (_fld1448rref, _fld1446);


--
-- Name: _inforg1445_byresource1454_rs; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1445_byresource1454_rs ON _inforg1445 USING btree (_fld1449rref, _fld1446);


--
-- Name: _inforg1445_byresource1455_ss; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1445_byresource1455_ss ON _inforg1445 USING btree (_fld1450, _fld1446);


--
-- Name: _inforg1456_bydims1463_rsrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1456_bydims1463_rsrn ON _inforg1456 USING btree (_fld1458rref, _fld1457, _fld1459rref, _fld1460);


--
-- Name: _inforg1456_bydims1464_rsrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1456_bydims1464_rsrn ON _inforg1456 USING btree (_fld1459rref, _fld1457, _fld1458rref, _fld1460);


--
-- Name: _inforg1456_bydims_srrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1456_bydims_srrn ON _inforg1456 USING btree (_fld1457, _fld1458rref, _fld1459rref, _fld1460);

ALTER TABLE _inforg1456 CLUSTER ON _inforg1456_bydims_srrn;


--
-- Name: _inforg1456_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1456_bysimplekey_b ON _inforg1456 USING btree (_simplekey);


--
-- Name: _inforg1465_bydatakey_srrnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1465_bydatakey_srrnr ON _inforgchngr1465 USING btree (_fld1457, _fld1458rref, _fld1459rref, _fld1460, _nodetref, _noderref);

ALTER TABLE _inforgchngr1465 CLUSTER ON _inforg1465_bydatakey_srrnr;


--
-- Name: _inforg1465_bynodemsg_rnsrrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1465_bynodemsg_rnsrrn ON _inforgchngr1465 USING btree (_nodetref, _noderref, _messageno, _fld1457, _fld1458rref, _fld1459rref, _fld1460);


--
-- Name: _inforg1466_bydims_rt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1466_bydims_rt ON _inforg1466 USING btree (_fld1467rref, _period);

ALTER TABLE _inforg1466 CLUSTER ON _inforg1466_bydims_rt;


--
-- Name: _inforg1466_byperiod_tr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1466_byperiod_tr ON _inforg1466 USING btree (_period, _fld1467rref);


--
-- Name: _inforg1466_byresource1472_rtr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1466_byresource1472_rtr ON _inforg1466 USING btree (_fld1469rref, _period, _fld1467rref);


--
-- Name: _inforg1466_byresource1473_ltr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1466_byresource1473_ltr ON _inforg1466 USING btree (_fld1470, _period, _fld1467rref);


--
-- Name: _inforg1474_bydatakey_trr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1474_bydatakey_trr ON _inforgchngr1474 USING btree (_period, _fld1467rref, _nodetref, _noderref);

ALTER TABLE _inforgchngr1474 CLUSTER ON _inforg1474_bydatakey_trr;


--
-- Name: _inforg1474_bynodemsg_rntr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1474_bynodemsg_rntr ON _inforgchngr1474 USING btree (_nodetref, _noderref, _messageno, _period, _fld1467rref);


--
-- Name: _inforg1475_bydims1482_rtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1475_bydims1482_rtrn ON _inforg1475 USING btree (_fld1476rref, _period, _recordertref, _recorderrref, _lineno);


--
-- Name: _inforg1475_bydims1483_rtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1475_bydims1483_rtrn ON _inforg1475 USING btree (_fld1477rref, _period, _recordertref, _recorderrref, _lineno);


--
-- Name: _inforg1475_bydims_rrrtrn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1475_bydims_rrrtrn ON _inforg1475 USING btree (_fld1476rref, _fld1477rref, _fld1478rref, _period, _recordertref, _recorderrref, _lineno);

ALTER TABLE _inforg1475 CLUSTER ON _inforg1475_bydims_rrrtrn;


--
-- Name: _inforg1475_byperiod_trn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1475_byperiod_trn ON _inforg1475 USING btree (_period, _recordertref, _recorderrref, _lineno);


--
-- Name: _inforg1475_byrecorder_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1475_byrecorder_rn ON _inforg1475 USING btree (_recordertref, _recorderrref, _lineno);


--
-- Name: _inforg1484_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1484_bydatakey_rr ON _inforgchngr1484 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _inforgchngr1484 CLUSTER ON _inforg1484_bydatakey_rr;


--
-- Name: _inforg1484_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1484_bynodemsg_rnr ON _inforgchngr1484 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _inforg1485_bydims_n; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1485_bydims_n ON _inforg1485 USING btree (_fld1486);

ALTER TABLE _inforg1485 CLUSTER ON _inforg1485_bydims_n;


--
-- Name: _inforg1485_byresource1491_sn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1485_byresource1491_sn ON _inforg1485 USING btree (_fld1488, _fld1486);


--
-- Name: _inforg1485_byresource1492_rn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1485_byresource1492_rn ON _inforg1485 USING btree (_fld1489_type, _fld1489_rtref, _fld1489_rrref, _fld1486);


--
-- Name: _inforg1493_bydatakey_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1493_bydatakey_nr ON _inforgchngr1493 USING btree (_fld1486, _nodetref, _noderref);

ALTER TABLE _inforgchngr1493 CLUSTER ON _inforg1493_bydatakey_nr;


--
-- Name: _inforg1493_bynodemsg_rnn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1493_bynodemsg_rnn ON _inforgchngr1493 USING btree (_nodetref, _noderref, _messageno, _fld1486);


--
-- Name: _inforg1494_bydims_r; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1494_bydims_r ON _inforg1494 USING btree (_fld1495rref);

ALTER TABLE _inforg1494 CLUSTER ON _inforg1494_bydims_r;


--
-- Name: _inforg1497_bydims_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1497_bydims_rr ON _inforg1497 USING btree (_fld1498rref, _fld1499rref);

ALTER TABLE _inforg1497 CLUSTER ON _inforg1497_bydims_rr;


--
-- Name: _inforg1497_bysimplekey_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _inforg1497_bysimplekey_b ON _inforg1497 USING btree (_simplekey);


--
-- Name: _node10_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _node10_code_sr ON _node10 USING btree (_code, _idrref);


--
-- Name: _node10_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _node10_descr_sr ON _node10 USING btree (_description, _idrref);


--
-- Name: _node10_predefinedid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _node10_predefinedid_b ON _node10 USING btree (_predefinedid);


--
-- Name: _node11_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _node11_code_sr ON _node11 USING btree (_code, _idrref);


--
-- Name: _node11_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _node11_descr_sr ON _node11 USING btree (_description, _idrref);


--
-- Name: _node11_predefinedid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _node11_predefinedid_b ON _node11 USING btree (_predefinedid);


--
-- Name: _node9_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _node9_code_sr ON _node9 USING btree (_code, _idrref);


--
-- Name: _node9_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _node9_descr_sr ON _node9 USING btree (_description, _idrref);


--
-- Name: _node9_predefinedid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _node9_predefinedid_b ON _node9 USING btree (_predefinedid);


--
-- Name: _referen137_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen137_bydatakey_rr ON _referencechngr137 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr137 CLUSTER ON _referen137_bydatakey_rr;


--
-- Name: _referen137_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen137_bynodemsg_rnr ON _referencechngr137 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen147_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen147_bydatakey_rr ON _referencechngr147 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr147 CLUSTER ON _referen147_bydatakey_rr;


--
-- Name: _referen147_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen147_bynodemsg_rnr ON _referencechngr147 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen149_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen149_bydatakey_rr ON _referencechngr149 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr149 CLUSTER ON _referen149_bydatakey_rr;


--
-- Name: _referen149_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen149_bynodemsg_rnr ON _referencechngr149 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen151_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen151_bydatakey_rr ON _referencechngr151 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr151 CLUSTER ON _referen151_bydatakey_rr;


--
-- Name: _referen151_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen151_bynodemsg_rnr ON _referencechngr151 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen153_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen153_bydatakey_rr ON _referencechngr153 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr153 CLUSTER ON _referen153_bydatakey_rr;


--
-- Name: _referen153_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen153_bynodemsg_rnr ON _referencechngr153 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen168_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen168_bydatakey_rr ON _referencechngr168 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr168 CLUSTER ON _referen168_bydatakey_rr;


--
-- Name: _referen168_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen168_bynodemsg_rnr ON _referencechngr168 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen342_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen342_bydatakey_rr ON _referencechngr342 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr342 CLUSTER ON _referen342_bydatakey_rr;


--
-- Name: _referen342_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen342_bynodemsg_rnr ON _referencechngr342 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen356_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen356_bydatakey_rr ON _referencechngr356 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr356 CLUSTER ON _referen356_bydatakey_rr;


--
-- Name: _referen356_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen356_bynodemsg_rnr ON _referencechngr356 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen388_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen388_bydatakey_rr ON _referencechngr388 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr388 CLUSTER ON _referen388_bydatakey_rr;


--
-- Name: _referen388_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen388_bynodemsg_rnr ON _referencechngr388 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen396_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen396_bydatakey_rr ON _referencechngr396 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr396 CLUSTER ON _referen396_bydatakey_rr;


--
-- Name: _referen396_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen396_bynodemsg_rnr ON _referencechngr396 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen401_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen401_bydatakey_rr ON _referencechngr401 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr401 CLUSTER ON _referen401_bydatakey_rr;


--
-- Name: _referen401_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen401_bynodemsg_rnr ON _referencechngr401 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen425_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen425_bydatakey_rr ON _referencechngr425 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr425 CLUSTER ON _referen425_bydatakey_rr;


--
-- Name: _referen425_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen425_bynodemsg_rnr ON _referencechngr425 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen433_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen433_bydatakey_rr ON _referencechngr433 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr433 CLUSTER ON _referen433_bydatakey_rr;


--
-- Name: _referen433_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen433_bynodemsg_rnr ON _referencechngr433 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen443_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen443_bydatakey_rr ON _referencechngr443 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr443 CLUSTER ON _referen443_bydatakey_rr;


--
-- Name: _referen443_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen443_bynodemsg_rnr ON _referencechngr443 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen449_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen449_bydatakey_rr ON _referencechngr449 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr449 CLUSTER ON _referen449_bydatakey_rr;


--
-- Name: _referen449_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen449_bynodemsg_rnr ON _referencechngr449 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen466_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen466_bydatakey_rr ON _referencechngr466 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr466 CLUSTER ON _referen466_bydatakey_rr;


--
-- Name: _referen466_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen466_bynodemsg_rnr ON _referencechngr466 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen472_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen472_bydatakey_rr ON _referencechngr472 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr472 CLUSTER ON _referen472_bydatakey_rr;


--
-- Name: _referen472_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen472_bynodemsg_rnr ON _referencechngr472 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen479_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen479_bydatakey_rr ON _referencechngr479 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr479 CLUSTER ON _referen479_bydatakey_rr;


--
-- Name: _referen479_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen479_bynodemsg_rnr ON _referencechngr479 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen484_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen484_bydatakey_rr ON _referencechngr484 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr484 CLUSTER ON _referen484_bydatakey_rr;


--
-- Name: _referen484_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen484_bynodemsg_rnr ON _referencechngr484 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen485_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen485_bydatakey_rr ON _referencechngr485 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr485 CLUSTER ON _referen485_bydatakey_rr;


--
-- Name: _referen485_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen485_bynodemsg_rnr ON _referencechngr485 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen493_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen493_bydatakey_rr ON _referencechngr493 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr493 CLUSTER ON _referen493_bydatakey_rr;


--
-- Name: _referen493_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen493_bynodemsg_rnr ON _referencechngr493 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen497_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen497_bydatakey_rr ON _referencechngr497 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr497 CLUSTER ON _referen497_bydatakey_rr;


--
-- Name: _referen497_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen497_bynodemsg_rnr ON _referencechngr497 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen501_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen501_bydatakey_rr ON _referencechngr501 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr501 CLUSTER ON _referen501_bydatakey_rr;


--
-- Name: _referen501_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen501_bynodemsg_rnr ON _referencechngr501 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen502_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen502_bydatakey_rr ON _referencechngr502 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr502 CLUSTER ON _referen502_bydatakey_rr;


--
-- Name: _referen502_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen502_bynodemsg_rnr ON _referencechngr502 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen503_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen503_bydatakey_rr ON _referencechngr503 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr503 CLUSTER ON _referen503_bydatakey_rr;


--
-- Name: _referen503_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen503_bynodemsg_rnr ON _referencechngr503 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen504_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen504_bydatakey_rr ON _referencechngr504 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr504 CLUSTER ON _referen504_bydatakey_rr;


--
-- Name: _referen504_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen504_bynodemsg_rnr ON _referencechngr504 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen505_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen505_bydatakey_rr ON _referencechngr505 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr505 CLUSTER ON _referen505_bydatakey_rr;


--
-- Name: _referen505_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen505_bynodemsg_rnr ON _referencechngr505 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referen511_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen511_bydatakey_rr ON _referencechngr511 USING btree (_idrref, _nodetref, _noderref);

ALTER TABLE _referencechngr511 CLUSTER ON _referen511_bydatakey_rr;


--
-- Name: _referen511_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referen511_bynodemsg_rnr ON _referencechngr511 USING btree (_nodetref, _noderref, _messageno, _idrref);


--
-- Name: _referenc12_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc12_code_sr ON _reference12 USING btree (_code, _idrref);


--
-- Name: _referenc12_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc12_descr_sr ON _reference12 USING btree (_description, _idrref);


--
-- Name: _referenc12_ownercode_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc12_ownercode_rsr ON _reference12 USING btree (_owneridrref, _code, _idrref);


--
-- Name: _referenc12_ownerdescr_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc12_ownerdescr_rsr ON _reference12 USING btree (_owneridrref, _description, _idrref);


--
-- Name: _referenc13_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc13_code_sr ON _reference13 USING btree (_code, _idrref);


--
-- Name: _referenc13_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc13_descr_sr ON _reference13 USING btree (_description, _idrref);


--
-- Name: _referenc13_parentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc13_parentcode_rlsr ON _reference13 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _referenc13_parentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc13_parentdescr_rlsr ON _reference13 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _referenc14_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc14_code_sr ON _reference14 USING btree (_code, _idrref);


--
-- Name: _referenc14_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc14_descr_sr ON _reference14 USING btree (_description, _idrref);


--
-- Name: _referenc14_parentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc14_parentcode_rlsr ON _reference14 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _referenc14_parentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc14_parentdescr_rlsr ON _reference14 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _referenc15_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc15_code_sr ON _reference15 USING btree (_code, _idrref);


--
-- Name: _referenc15_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc15_descr_sr ON _reference15 USING btree (_description, _idrref);


--
-- Name: _referenc15_ownercode_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc15_ownercode_rsr ON _reference15 USING btree (_owneridrref, _code, _idrref);


--
-- Name: _referenc15_ownerdescr_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc15_ownerdescr_rsr ON _reference15 USING btree (_owneridrref, _description, _idrref);


--
-- Name: _referenc16_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc16_code_sr ON _reference16 USING btree (_code, _idrref);


--
-- Name: _referenc16_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc16_descr_sr ON _reference16 USING btree (_description, _idrref);


--
-- Name: _referenc17_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc17_code_sr ON _reference17 USING btree (_code, _idrref);


--
-- Name: _referenc17_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc17_descr_sr ON _reference17 USING btree (_description, _idrref);


--
-- Name: _referenc17_parentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc17_parentcode_rlsr ON _reference17 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _referenc17_parentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc17_parentdescr_rlsr ON _reference17 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _referenc18_byfield191_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc18_byfield191_rr ON _reference18 USING btree (_fld172rref, _idrref);


--
-- Name: _referenc18_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc18_code_sr ON _reference18 USING btree (_code, _idrref);


--
-- Name: _referenc18_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc18_descr_sr ON _reference18 USING btree (_description, _idrref);


--
-- Name: _referenc18_vt183_byfield187_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _referenc18_vt183_byfield187_rr ON _reference18_vt183 USING btree (_fld185rref, _reference18_idrref);


--
-- Name: _referenc18_vt183_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc18_vt183_intkeyind ON _reference18_vt183 USING btree (_reference18_idrref, _keyfield);

ALTER TABLE _reference18_vt183 CLUSTER ON _referenc18_vt183_intkeyind;


--
-- Name: _referenc18_vt188_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc18_vt188_intkeyind ON _reference18_vt188 USING btree (_reference18_idrref, _keyfield);

ALTER TABLE _reference18_vt188 CLUSTER ON _referenc18_vt188_intkeyind;


--
-- Name: _referenc19_byfield302_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc19_byfield302_rr ON _reference19 USING btree (_fld245_type, _fld245_rtref, _fld245_rrref, _idrref);


--
-- Name: _referenc19_byfield303_lr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc19_byfield303_lr ON _reference19 USING btree (_fld254, _idrref);


--
-- Name: _referenc19_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc19_code_sr ON _reference19 USING btree (_code, _idrref);


--
-- Name: _referenc19_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc19_descr_sr ON _reference19 USING btree (_description, _idrref);


--
-- Name: _referenc19_vt272_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc19_vt272_intkeyind ON _reference19_vt272 USING btree (_reference19_idrref, _keyfield);

ALTER TABLE _reference19_vt272 CLUSTER ON _referenc19_vt272_intkeyind;


--
-- Name: _referenc19_vt275_byfield285_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _referenc19_vt275_byfield285_sr ON _reference19_vt275 USING btree (_fld277, _reference19_idrref);


--
-- Name: _referenc19_vt275_byfield286_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _referenc19_vt275_byfield286_sr ON _reference19_vt275 USING btree (_fld278, _reference19_idrref);


--
-- Name: _referenc19_vt275_byfield287_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _referenc19_vt275_byfield287_sr ON _reference19_vt275 USING btree (_fld279, _reference19_idrref);


--
-- Name: _referenc19_vt275_byfield288_lr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _referenc19_vt275_byfield288_lr ON _reference19_vt275 USING btree (_fld282, _reference19_idrref);


--
-- Name: _referenc19_vt275_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc19_vt275_intkeyind ON _reference19_vt275 USING btree (_reference19_idrref, _keyfield);

ALTER TABLE _reference19_vt275 CLUSTER ON _referenc19_vt275_intkeyind;


--
-- Name: _referenc19_vt289_byfield298_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _referenc19_vt289_byfield298_sr ON _reference19_vt289 USING btree (_fld291, _reference19_idrref);


--
-- Name: _referenc19_vt289_byfield299_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _referenc19_vt289_byfield299_sr ON _reference19_vt289 USING btree (_fld292, _reference19_idrref);


--
-- Name: _referenc19_vt289_byfield300_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _referenc19_vt289_byfield300_sr ON _reference19_vt289 USING btree (_fld293, _reference19_idrref);


--
-- Name: _referenc19_vt289_byfield301_lr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _referenc19_vt289_byfield301_lr ON _reference19_vt289 USING btree (_fld294, _reference19_idrref);


--
-- Name: _referenc19_vt289_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc19_vt289_intkeyind ON _reference19_vt289 USING btree (_reference19_idrref, _keyfield);

ALTER TABLE _reference19_vt289 CLUSTER ON _referenc19_vt289_intkeyind;


--
-- Name: _referenc20_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc20_code_sr ON _reference20 USING btree (_code, _idrref);


--
-- Name: _referenc20_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc20_descr_sr ON _reference20 USING btree (_description, _idrref);


--
-- Name: _referenc20_parentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc20_parentcode_rlsr ON _reference20 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _referenc20_parentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc20_parentdescr_rlsr ON _reference20 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _referenc20_vt325_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc20_vt325_intkeyind ON _reference20_vt325 USING btree (_reference20_idrref, _keyfield);

ALTER TABLE _reference20_vt325 CLUSTER ON _referenc20_vt325_intkeyind;


--
-- Name: _referenc20_vt329_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc20_vt329_intkeyind ON _reference20_vt329 USING btree (_reference20_idrref, _keyfield);

ALTER TABLE _reference20_vt329 CLUSTER ON _referenc20_vt329_intkeyind;


--
-- Name: _referenc20_vt335_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc20_vt335_intkeyind ON _reference20_vt335 USING btree (_reference20_idrref, _keyfield);

ALTER TABLE _reference20_vt335 CLUSTER ON _referenc20_vt335_intkeyind;


--
-- Name: _referenc21_byfield353_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc21_byfield353_nr ON _reference21 USING btree (_fld347, _idrref);


--
-- Name: _referenc21_byfield354_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc21_byfield354_sr ON _reference21 USING btree (_fld348, _idrref);


--
-- Name: _referenc21_byfield355_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc21_byfield355_nr ON _reference21 USING btree (_fld349, _idrref);


--
-- Name: _referenc21_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc21_code_sr ON _reference21 USING btree (_code, _idrref);


--
-- Name: _referenc21_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc21_descr_sr ON _reference21 USING btree (_description, _idrref);


--
-- Name: _referenc21_vt350_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc21_vt350_intkeyind ON _reference21_vt350 USING btree (_reference21_idrref, _keyfield);

ALTER TABLE _reference21_vt350 CLUSTER ON _referenc21_vt350_intkeyind;


--
-- Name: _referenc22_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc22_code_sr ON _reference22 USING btree (_code, _idrref);


--
-- Name: _referenc22_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc22_descr_sr ON _reference22 USING btree (_description, _idrref);


--
-- Name: _referenc23_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc23_code_sr ON _reference23 USING btree (_code, _idrref);


--
-- Name: _referenc23_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc23_descr_sr ON _reference23 USING btree (_description, _idrref);


--
-- Name: _referenc24_byfield387_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc24_byfield387_sr ON _reference24 USING btree (_fld357, _idrref);


--
-- Name: _referenc24_byownerfield386_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc24_byownerfield386_rsr ON _reference24 USING btree (_owneridrref, _fld357, _idrref);


--
-- Name: _referenc24_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc24_code_sr ON _reference24 USING btree (_code, _idrref);


--
-- Name: _referenc24_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc24_descr_sr ON _reference24 USING btree (_description, _idrref);


--
-- Name: _referenc24_ownercode_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc24_ownercode_rsr ON _reference24 USING btree (_owneridrref, _code, _idrref);


--
-- Name: _referenc24_ownerdescr_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc24_ownerdescr_rsr ON _reference24 USING btree (_owneridrref, _description, _idrref);


--
-- Name: _referenc24_vt365_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc24_vt365_intkeyind ON _reference24_vt365 USING btree (_reference24_idrref, _keyfield);

ALTER TABLE _reference24_vt365 CLUSTER ON _referenc24_vt365_intkeyind;


--
-- Name: _referenc24_vt377_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc24_vt377_intkeyind ON _reference24_vt377 USING btree (_reference24_idrref, _keyfield);

ALTER TABLE _reference24_vt377 CLUSTER ON _referenc24_vt377_intkeyind;


--
-- Name: _referenc25_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc25_code_sr ON _reference25 USING btree (_code, _idrref);


--
-- Name: _referenc25_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc25_descr_sr ON _reference25 USING btree (_description, _idrref);


--
-- Name: _referenc26_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc26_code_sr ON _reference26 USING btree (_code, _idrref);


--
-- Name: _referenc26_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc26_descr_sr ON _reference26 USING btree (_description, _idrref);


--
-- Name: _referenc26_parentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc26_parentcode_rlsr ON _reference26 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _referenc26_parentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc26_parentdescr_rlsr ON _reference26 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _referenc27_byfield408_nsrln; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc27_byfield408_nsrln ON _reference27 USING btree (_fld402, _description, _idrref, _marked, _fld403);


--
-- Name: _referenc27_byfield410_nsrln; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc27_byfield410_nsrln ON _reference27 USING btree (_fld403, _description, _idrref, _marked, _fld402);


--
-- Name: _referenc27_byownerfield407_rnsrln; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc27_byownerfield407_rnsrln ON _reference27 USING btree (_owneridrref, _fld402, _description, _idrref, _marked, _fld403);


--
-- Name: _referenc27_byownerfield409_rnsrln; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc27_byownerfield409_rnsrln ON _reference27 USING btree (_owneridrref, _fld403, _description, _idrref, _marked, _fld402);


--
-- Name: _referenc27_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc27_code_sr ON _reference27 USING btree (_code, _idrref);


--
-- Name: _referenc27_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc27_descr_sr ON _reference27 USING btree (_description, _idrref);


--
-- Name: _referenc27_ownercode_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc27_ownercode_rsr ON _reference27 USING btree (_owneridrref, _code, _idrref);


--
-- Name: _referenc27_ownerdescr_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc27_ownerdescr_rsr ON _reference27 USING btree (_owneridrref, _description, _idrref);


--
-- Name: _referenc28_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc28_code_sr ON _reference28 USING btree (_code, _idrref);


--
-- Name: _referenc28_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc28_descr_sr ON _reference28 USING btree (_description, _idrref);


--
-- Name: _referenc28_vt419_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc28_vt419_intkeyind ON _reference28_vt419 USING btree (_reference28_idrref, _keyfield);

ALTER TABLE _reference28_vt419 CLUSTER ON _referenc28_vt419_intkeyind;


--
-- Name: _referenc29_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc29_code_sr ON _reference29 USING btree (_code, _idrref);


--
-- Name: _referenc29_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc29_descr_sr ON _reference29 USING btree (_description, _idrref);


--
-- Name: _referenc29_parentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc29_parentcode_rlsr ON _reference29 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _referenc29_parentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc29_parentdescr_rlsr ON _reference29 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _referenc30_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc30_code_sr ON _reference30 USING btree (_code, _idrref);


--
-- Name: _referenc30_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc30_descr_sr ON _reference30 USING btree (_description, _idrref);


--
-- Name: _referenc30_vt440_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc30_vt440_intkeyind ON _reference30_vt440 USING btree (_reference30_idrref, _keyfield);

ALTER TABLE _reference30_vt440 CLUSTER ON _referenc30_vt440_intkeyind;


--
-- Name: _referenc31_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc31_code_sr ON _reference31 USING btree (_code, _idrref);


--
-- Name: _referenc31_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc31_descr_sr ON _reference31 USING btree (_description, _idrref);


--
-- Name: _referenc32_byfield448_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc32_byfield448_sr ON _reference32 USING btree (_fld444, _idrref);


--
-- Name: _referenc32_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc32_code_sr ON _reference32 USING btree (_code, _idrref);


--
-- Name: _referenc32_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc32_descr_sr ON _reference32 USING btree (_description, _idrref);


--
-- Name: _referenc33_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc33_code_sr ON _reference33 USING btree (_code, _idrref);


--
-- Name: _referenc33_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc33_descr_sr ON _reference33 USING btree (_description, _idrref);


--
-- Name: _referenc34_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc34_code_sr ON _reference34 USING btree (_code, _idrref);


--
-- Name: _referenc34_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc34_descr_sr ON _reference34 USING btree (_description, _idrref);


--
-- Name: _referenc34_vt453_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc34_vt453_intkeyind ON _reference34_vt453 USING btree (_reference34_idrref, _keyfield);

ALTER TABLE _reference34_vt453 CLUSTER ON _referenc34_vt453_intkeyind;


--
-- Name: _referenc35_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc35_code_sr ON _reference35 USING btree (_code, _idrref);


--
-- Name: _referenc35_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc35_descr_sr ON _reference35 USING btree (_description, _idrref);


--
-- Name: _referenc36_byfield469_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc36_byfield469_rr ON _reference36 USING btree (_fld467rref, _idrref);


--
-- Name: _referenc36_byfield470_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc36_byfield470_sr ON _reference36 USING btree (_fld468, _idrref);


--
-- Name: _referenc36_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc36_code_sr ON _reference36 USING btree (_code, _idrref);


--
-- Name: _referenc36_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc36_descr_sr ON _reference36 USING btree (_description, _idrref);


--
-- Name: _referenc37_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc37_code_sr ON _reference37 USING btree (_code, _idrref);


--
-- Name: _referenc37_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc37_descr_sr ON _reference37 USING btree (_description, _idrref);


--
-- Name: _referenc37_parentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc37_parentcode_rlsr ON _reference37 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _referenc37_parentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc37_parentdescr_rlsr ON _reference37 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _referenc38_byfield478_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc38_byfield478_sr ON _reference38 USING btree (_fld473, _idrref);


--
-- Name: _referenc38_byparentfield477_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc38_byparentfield477_rlsr ON _reference38 USING btree (_parentidrref, _folder, _fld473, _idrref);


--
-- Name: _referenc38_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc38_code_sr ON _reference38 USING btree (_code, _idrref);


--
-- Name: _referenc38_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc38_descr_sr ON _reference38 USING btree (_description, _idrref);


--
-- Name: _referenc38_parentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc38_parentcode_rlsr ON _reference38 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _referenc38_parentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc38_parentdescr_rlsr ON _reference38 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _referenc39_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc39_code_sr ON _reference39 USING btree (_code, _idrref);


--
-- Name: _referenc39_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc39_descr_sr ON _reference39 USING btree (_description, _idrref);


--
-- Name: _referenc39_ownercode_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc39_ownercode_rsr ON _reference39 USING btree (_owneridrref, _code, _idrref);


--
-- Name: _referenc39_ownerdescr_rsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc39_ownerdescr_rsr ON _reference39 USING btree (_owneridrref, _description, _idrref);


--
-- Name: _referenc40_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc40_code_sr ON _reference40 USING btree (_code, _idrref);


--
-- Name: _referenc40_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc40_descr_sr ON _reference40 USING btree (_description, _idrref);


--
-- Name: _referenc40_parentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc40_parentcode_rlsr ON _reference40 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _referenc40_parentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc40_parentdescr_rlsr ON _reference40 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _referenc41_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc41_code_sr ON _reference41 USING btree (_code, _idrref);


--
-- Name: _referenc41_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc41_descr_sr ON _reference41 USING btree (_description, _idrref);


--
-- Name: _referenc41_vt489_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc41_vt489_intkeyind ON _reference41_vt489 USING btree (_reference41_idrref, _keyfield);

ALTER TABLE _reference41_vt489 CLUSTER ON _referenc41_vt489_intkeyind;


--
-- Name: _referenc42_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc42_code_sr ON _reference42 USING btree (_code, _idrref);


--
-- Name: _referenc42_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc42_descr_sr ON _reference42 USING btree (_description, _idrref);


--
-- Name: _referenc42_parentcode_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc42_parentcode_rlsr ON _reference42 USING btree (_parentidrref, _folder, _code, _idrref);


--
-- Name: _referenc42_parentdescr_rlsr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc42_parentdescr_rlsr ON _reference42 USING btree (_parentidrref, _folder, _description, _idrref);


--
-- Name: _referenc43_byfield500_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc43_byfield500_nr ON _reference43 USING btree (_fld498, _idrref);


--
-- Name: _referenc43_code_nr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc43_code_nr ON _reference43 USING btree (_code, _idrref);


--
-- Name: _referenc43_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc43_descr_sr ON _reference43 USING btree (_description, _idrref);


--
-- Name: _referenc44_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc44_code_sr ON _reference44 USING btree (_code, _idrref);


--
-- Name: _referenc44_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc44_descr_sr ON _reference44 USING btree (_description, _idrref);


--
-- Name: _referenc45_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc45_code_sr ON _reference45 USING btree (_code, _idrref);


--
-- Name: _referenc45_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc45_descr_sr ON _reference45 USING btree (_description, _idrref);


--
-- Name: _referenc46_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc46_code_sr ON _reference46 USING btree (_code, _idrref);


--
-- Name: _referenc46_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc46_descr_sr ON _reference46 USING btree (_description, _idrref);


--
-- Name: _referenc47_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc47_code_sr ON _reference47 USING btree (_code, _idrref);


--
-- Name: _referenc47_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc47_descr_sr ON _reference47 USING btree (_description, _idrref);


--
-- Name: _referenc48_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc48_code_sr ON _reference48 USING btree (_code, _idrref);


--
-- Name: _referenc48_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc48_descr_sr ON _reference48 USING btree (_description, _idrref);


--
-- Name: _referenc48_vt506_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc48_vt506_intkeyind ON _reference48_vt506 USING btree (_reference48_idrref, _keyfield);

ALTER TABLE _reference48_vt506 CLUSTER ON _referenc48_vt506_intkeyind;


--
-- Name: _referenc49_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc49_code_sr ON _reference49 USING btree (_code, _idrref);


--
-- Name: _referenc49_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc49_descr_sr ON _reference49 USING btree (_description, _idrref);


--
-- Name: _referenc49_vt518_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc49_vt518_intkeyind ON _reference49_vt518 USING btree (_reference49_idrref, _keyfield);

ALTER TABLE _reference49_vt518 CLUSTER ON _referenc49_vt518_intkeyind;


--
-- Name: _referenc49_vt524_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc49_vt524_intkeyind ON _reference49_vt524 USING btree (_reference49_idrref, _keyfield);

ALTER TABLE _reference49_vt524 CLUSTER ON _referenc49_vt524_intkeyind;


--
-- Name: _referenc49_vt531_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc49_vt531_intkeyind ON _reference49_vt531 USING btree (_reference49_idrref, _keyfield);

ALTER TABLE _reference49_vt531 CLUSTER ON _referenc49_vt531_intkeyind;


--
-- Name: _referenc49_vt537_intkeyind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc49_vt537_intkeyind ON _reference49_vt537 USING btree (_reference49_idrref, _keyfield);

ALTER TABLE _reference49_vt537 CLUSTER ON _referenc49_vt537_intkeyind;


--
-- Name: _referenc50_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc50_code_sr ON _reference50 USING btree (_code, _idrref);


--
-- Name: _referenc50_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc50_descr_sr ON _reference50 USING btree (_description, _idrref);


--
-- Name: _referenc51_code_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc51_code_sr ON _reference51 USING btree (_code, _idrref);


--
-- Name: _referenc51_descr_sr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _referenc51_descr_sr ON _reference51 USING btree (_description, _idrref);


--
-- Name: _repsetting_bykey_sss; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _repsetting_bykey_sss ON _repsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _repsettings CLUSTER ON _repsetting_bykey_sss;


--
-- Name: _repvarsett_bykey_sss; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _repvarsett_bykey_sss ON _repvarsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _repvarsettings CLUSTER ON _repvarsett_bykey_sss;


--
-- Name: _schedu1650_byid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _schedu1650_byid_b ON _scheduledjobs1650 USING btree (_id);

ALTER TABLE _scheduledjobs1650 CLUSTER ON _schedu1650_byid_b;


--
-- Name: _schedu1651_byid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _schedu1651_byid_b ON _scheduledjobs1651 USING btree (_id);

ALTER TABLE _scheduledjobs1651 CLUSTER ON _schedu1651_byid_b;


--
-- Name: _schedu1652_byid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _schedu1652_byid_b ON _scheduledjobs1652 USING btree (_id);

ALTER TABLE _scheduledjobs1652 CLUSTER ON _schedu1652_byid_b;


--
-- Name: _seq1643_bydims_tr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _seq1643_bydims_tr ON _seq1643 USING btree (_period, _recordertref, _recorderrref);


--
-- Name: _seq1643_byrecorder_r; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _seq1643_byrecorder_r ON _seq1643 USING btree (_recordertref, _recorderrref);

ALTER TABLE _seq1643 CLUSTER ON _seq1643_byrecorder_r;


--
-- Name: _seqchn1645_bydatakey_rr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _seqchn1645_bydatakey_rr ON _seqchngr1645 USING btree (_recordertref, _recorderrref, _nodetref, _noderref);

ALTER TABLE _seqchngr1645 CLUSTER ON _seqchn1645_bydatakey_rr;


--
-- Name: _seqchn1645_bynodemsg_rnr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _seqchn1645_bynodemsg_rnr ON _seqchngr1645 USING btree (_nodetref, _noderref, _messageno, _recordertref, _recorderrref);


--
-- Name: _systemsett_bykey_sss; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _systemsett_bykey_sss ON _systemsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _systemsettings CLUSTER ON _systemsett_bykey_sss;


--
-- Name: _usersworkh_byid_b; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX _usersworkh_byid_b ON _usersworkhistory USING btree (_id);


--
-- Name: _usersworkh_byuserdate_bt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _usersworkh_byuserdate_bt ON _usersworkhistory USING btree (_userid, _date);


--
-- Name: _usersworkh_byuserurlhash_bn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX _usersworkh_byuserurlhash_bn ON _usersworkhistory USING btree (_userid, _urlhash);

ALTER TABLE _usersworkhistory CLUSTER ON _usersworkh_byuserurlhash_bn;


--
-- Name: bydescr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX bydescr ON v8users USING btree (descr);


--
-- Name: byeauth; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX byeauth ON v8users USING btree (admrole, eauth);


--
-- Name: byname; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX byname ON v8users USING btree (name);


--
-- Name: byosname; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX byosname ON v8users USING btree (osname);


--
-- Name: byrolesid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX byrolesid ON v8users USING btree (rolesid);


--
-- Name: byshow; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX byshow ON v8users USING btree (show);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

