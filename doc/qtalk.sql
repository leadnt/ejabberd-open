--
-- PostgreSQL database cluster dump
--

-- Started on 2018-12-13 17:11:42 CST

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE ejabberd;
ALTER ROLE ejabberd WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION NOBYPASSRLS;






--
-- Database creation
--

CREATE DATABASE ejabberd WITH TEMPLATE = template0 OWNER = postgres;
REVOKE ALL ON DATABASE ejabberd FROM postgres;
ALTER DATABASE ejabberd SET standard_conforming_strings TO 'off';
REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect ejabberd

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

-- Started on 2018-12-13 17:11:42 CST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 13086)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 4652 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 1 (class 3079 OID 16509)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 4653 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 6 (class 3079 OID 16518)
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- TOC entry 4654 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- TOC entry 5 (class 3079 OID 17141)
-- Name: pg_buffercache; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;


--
-- TOC entry 4655 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION pg_buffercache; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';


--
-- TOC entry 4 (class 3079 OID 17147)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 4656 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 3 (class 3079 OID 17212)
-- Name: pgstattuple; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;


--
-- TOC entry 4657 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgstattuple; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';


--
-- TOC entry 508 (class 1255 OID 17223)
-- Name: qto_char(timestamp with time zone, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.qto_char(timestamp with time zone, text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$select to_char($1, $2);$_$;


ALTER FUNCTION public.qto_char(timestamp with time zone, text) OWNER TO postgres;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 202 (class 1259 OID 17226)
-- Name: a; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.a (
    id bigint
);


ALTER TABLE public.a OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 17229)
-- Name: admin_user; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.admin_user (
    username character varying(255) NOT NULL,
    priority text NOT NULL
);


ALTER TABLE public.admin_user OWNER TO ejabberd;

--
-- TOC entry 204 (class 1259 OID 17235)
-- Name: android_send_stat; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.android_send_stat (
    id bigint NOT NULL,
    uuid text NOT NULL,
    imei text NOT NULL,
    payload text NOT NULL,
    done integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    update_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.android_send_stat OWNER TO ejabberd;

--
-- TOC entry 205 (class 1259 OID 17244)
-- Name: android_send_stat_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.android_send_stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.android_send_stat_id_seq OWNER TO ejabberd;

--
-- TOC entry 4874 (class 0 OID 0)
-- Dependencies: 205
-- Name: android_send_stat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.android_send_stat_id_seq OWNED BY public.android_send_stat.id;


--
-- TOC entry 206 (class 1259 OID 17246)
-- Name: b; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.b (
    id bigint
);


ALTER TABLE public.b OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 17249)
-- Name: client_config_sync; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_config_sync (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    host character varying(255) NOT NULL,
    configkey character varying(255) NOT NULL,
    subkey character varying(255) NOT NULL,
    configinfo text NOT NULL,
    version bigint DEFAULT 1,
    operate_plat character varying(50) NOT NULL,
    create_time timestamp with time zone DEFAULT now(),
    update_time timestamp with time zone DEFAULT now(),
    isdel smallint DEFAULT 0
);


ALTER TABLE public.client_config_sync OWNER TO postgres;

--
-- TOC entry 4876 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE client_config_sync; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.client_config_sync IS '客户端漫游用户配置表';


--
-- TOC entry 4877 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN client_config_sync.username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_config_sync.username IS '用户用户名';


--
-- TOC entry 4878 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN client_config_sync.host; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_config_sync.host IS '用户域名';


--
-- TOC entry 4879 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN client_config_sync.configkey; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_config_sync.configkey IS '漫游数据key';


--
-- TOC entry 4880 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN client_config_sync.subkey; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_config_sync.subkey IS '漫游数据子key';


--
-- TOC entry 4881 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN client_config_sync.configinfo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_config_sync.configinfo IS '漫游数据';


--
-- TOC entry 4882 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN client_config_sync.version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_config_sync.version IS '版本号';


--
-- TOC entry 4883 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN client_config_sync.operate_plat; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_config_sync.operate_plat IS '操作平台';


--
-- TOC entry 4884 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN client_config_sync.create_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_config_sync.create_time IS '创建时间';


--
-- TOC entry 4885 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN client_config_sync.update_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_config_sync.update_time IS '更新时间';


--
-- TOC entry 4886 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN client_config_sync.isdel; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_config_sync.isdel IS '是否删除或取消';


--
-- TOC entry 208 (class 1259 OID 17259)
-- Name: client_config_sync_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.client_config_sync_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_config_sync_id_seq OWNER TO postgres;

--
-- TOC entry 4887 (class 0 OID 0)
-- Dependencies: 208
-- Name: client_config_sync_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.client_config_sync_id_seq OWNED BY public.client_config_sync.id;


--
-- TOC entry 209 (class 1259 OID 17261)
-- Name: day_online_time; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.day_online_time (
    username character varying(50) NOT NULL,
    date_time character varying(20) NOT NULL,
    online_time integer
);


ALTER TABLE public.day_online_time OWNER TO ejabberd;

--
-- TOC entry 210 (class 1259 OID 17264)
-- Name: destroy_muc_info; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.destroy_muc_info (
    muc_name text NOT NULL,
    nick_name text,
    reason text,
    id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.destroy_muc_info OWNER TO ejabberd;

--
-- TOC entry 211 (class 1259 OID 17271)
-- Name: destroy_muc_info_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.destroy_muc_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.destroy_muc_info_id_seq OWNER TO ejabberd;

--
-- TOC entry 4888 (class 0 OID 0)
-- Dependencies: 211
-- Name: destroy_muc_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.destroy_muc_info_id_seq OWNED BY public.destroy_muc_info.id;


--
-- TOC entry 212 (class 1259 OID 17273)
-- Name: domain_mapped_url; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.domain_mapped_url (
    domain text NOT NULL,
    url text NOT NULL
);


ALTER TABLE public.domain_mapped_url OWNER TO ejabberd;

--
-- TOC entry 213 (class 1259 OID 17279)
-- Name: flogin_user; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.flogin_user (
    username text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.flogin_user OWNER TO ejabberd;


--
-- TOC entry 219 (class 1259 OID 17316)
-- Name: fresh_empl_entering; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fresh_empl_entering (
    id bigint NOT NULL,
    user_id character varying(20) NOT NULL,
    user_name character varying(20) NOT NULL,
    hire_flag smallint DEFAULT 1 NOT NULL,
    join_date date NOT NULL,
    send_state smallint DEFAULT 0 NOT NULL,
    sn character varying(15) NOT NULL,
    manager character varying(20) NOT NULL,
    manager_mail character varying(50) NOT NULL,
    dep1 character varying(20) NOT NULL,
    dep2 character varying(20),
    dep3 character varying(20),
    dep4 character varying(20),
    dep5 character varying(20),
    job character varying(20),
    job_code character varying(20) NOT NULL,
    probation_date date NOT NULL,
    version smallint DEFAULT 0 NOT NULL,
    create_time timestamp with time zone DEFAULT now(),
    update_time timestamp with time zone DEFAULT now()
);


ALTER TABLE public.fresh_empl_entering OWNER TO postgres;

--
-- TOC entry 4890 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE fresh_empl_entering; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.fresh_empl_entering IS '表名';


--
-- TOC entry 4891 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.id IS '唯一主键';


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.user_id IS 'qtalkid';


--
-- TOC entry 4893 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.user_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.user_name IS '姓名';


--
-- TOC entry 4894 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.hire_flag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.hire_flag IS '入职状态，0：已入职，1：未入职，2：推迟入职，3：待定入职';


--
-- TOC entry 4895 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.join_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.join_date IS '入职日期';


--
-- TOC entry 4896 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.send_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.send_state IS '消息发送状态，0：未发送，1：已发送';


--
-- TOC entry 4897 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.sn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.sn IS '员工号';


--
-- TOC entry 4898 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.manager; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.manager IS '主管号';


--
-- TOC entry 4899 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.manager_mail; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.manager_mail IS '主管邮箱';


--
-- TOC entry 4900 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.dep1; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.dep1 IS '一级部门';


--
-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.job; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.job IS '岗位名称';


--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.job_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.job_code IS '岗位编码';


--
-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.probation_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.probation_date IS '转正日期';


--
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN fresh_empl_entering.version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fresh_empl_entering.version IS '入职日期修改次数';


--
-- TOC entry 220 (class 1259 OID 17324)
-- Name: fresh_empl_entering_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fresh_empl_entering_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fresh_empl_entering_id_seq OWNER TO postgres;

--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 220
-- Name: fresh_empl_entering_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fresh_empl_entering_id_seq OWNED BY public.fresh_empl_entering.id;


--
-- TOC entry 221 (class 1259 OID 17326)
-- Name: group_extent; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.group_extent (
    id bigint NOT NULL,
    group_id text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    create_at timestamp without time zone DEFAULT now() NOT NULL,
    update_at timestamp without time zone DEFAULT now() NOT NULL,
    version integer DEFAULT 1
);


ALTER TABLE public.group_extent OWNER TO ejabberd;

--
-- TOC entry 222 (class 1259 OID 17335)
-- Name: group_extent_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.group_extent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_extent_id_seq OWNER TO ejabberd;

--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 222
-- Name: group_extent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.group_extent_id_seq OWNED BY public.group_extent.id;


--
-- TOC entry 223 (class 1259 OID 17337)
-- Name: host_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.host_info (
    id bigint NOT NULL,
    host text NOT NULL,
    description text,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    host_admin text NOT NULL
);


ALTER TABLE public.host_info OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17344)
-- Name: host_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.host_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.host_info_id_seq OWNER TO postgres;

--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 224
-- Name: host_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.host_info_id_seq OWNED BY public.host_info.id;


--
-- TOC entry 225 (class 1259 OID 17346)
-- Name: host_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.host_users (
    id bigint NOT NULL,
    host_id bigint NOT NULL,
    user_id text NOT NULL,
    user_name text NOT NULL,
    department text NOT NULL,
    tel text,
    email text,
    dep1 text NOT NULL,
    dep2 text DEFAULT ''::text,
    dep3 text DEFAULT ''::text,
    dep4 text DEFAULT ''::text,
    dep5 text DEFAULT ''::text,
    pinyin text,
    frozen_flag smallint DEFAULT 0 NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    user_type character(1) DEFAULT 'U'::bpchar,
    hire_flag smallint DEFAULT 1 NOT NULL,
    gender smallint DEFAULT 0 NOT NULL,
    password text,
    initialpwd smallint DEFAULT 1 NOT NULL,
    ps_deptid text DEFAULT 'QUNAR'::text
);


ALTER TABLE public.host_users OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17363)
-- Name: host_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.host_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.host_users_id_seq OWNER TO postgres;

--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 226
-- Name: host_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.host_users_id_seq OWNED BY public.host_users.id;


--
-- TOC entry 229 (class 1259 OID 17385)
-- Name: invite_spool; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.invite_spool (
    username text NOT NULL,
    inviter text NOT NULL,
    body text NOT NULL,
    "timestamp" integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    host text DEFAULT 'ejabhost1'::text NOT NULL,
    ihost text DEFAULT 'ejabhost1'::text NOT NULL
);


ALTER TABLE public.invite_spool OWNER TO ejabberd;

--
-- TOC entry 230 (class 1259 OID 17394)
-- Name: iplimit; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.iplimit (
    ip text NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    descriptions text DEFAULT now() NOT NULL,
    name text DEFAULT 'ALL'::text NOT NULL,
    priority text DEFAULT '1'::text NOT NULL,
    manager text
);


ALTER TABLE public.iplimit OWNER TO ejabberd;

--
-- TOC entry 231 (class 1259 OID 17404)
-- Name: irc_custom; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.irc_custom (
    jid text NOT NULL,
    host text NOT NULL,
    data text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.irc_custom OWNER TO ejabberd;

--
-- TOC entry 232 (class 1259 OID 17411)
-- Name: last; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.last (
    username text NOT NULL,
    seconds text NOT NULL,
    state text NOT NULL
);


ALTER TABLE public.last OWNER TO ejabberd;

--
-- TOC entry 233 (class 1259 OID 17417)
-- Name: mac_push_notice; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.mac_push_notice (
    user_name character varying(200) NOT NULL,
    shield_user character varying(200) NOT NULL
);


ALTER TABLE public.mac_push_notice OWNER TO ejabberd;

--
-- TOC entry 234 (class 1259 OID 17420)
-- Name: mask_history; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.mask_history (
    m_from character varying(255),
    m_to character varying(255),
    m_body text,
    create_time timestamp with time zone DEFAULT now(),
    id bigint NOT NULL,
    read_flag smallint DEFAULT 0,
    msg_id text,
    from_host text,
    to_host text
);


ALTER TABLE public.mask_history OWNER TO ejabberd;

--
-- TOC entry 235 (class 1259 OID 17428)
-- Name: mask_history_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.mask_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mask_history_id_seq OWNER TO ejabberd;

--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 235
-- Name: mask_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.mask_history_id_seq OWNED BY public.mask_history.id;


--
-- TOC entry 236 (class 1259 OID 17430)
-- Name: mask_users; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.mask_users (
    user_name text NOT NULL,
    masked_user text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.mask_users OWNER TO ejabberd;

--
-- TOC entry 237 (class 1259 OID 17437)
-- Name: meeting_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meeting_info (
    id integer NOT NULL,
    meeting_id character varying(255) NOT NULL,
    meeting_name character varying(255) NOT NULL,
    meeting_remarks text DEFAULT ''::text,
    meeting_intr text DEFAULT ''::text,
    meeting_locale character varying(255) NOT NULL,
    meeting_room character varying(255) NOT NULL,
    schedule_time timestamp with time zone DEFAULT now(),
    meeting_date date NOT NULL,
    begin_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    inviter character varying(255) NOT NULL,
    member character varying(255) NOT NULL,
    mem_action integer DEFAULT 0,
    remind_flag integer DEFAULT 0,
    refuse_reason text,
    canceled boolean DEFAULT false
);


ALTER TABLE public.meeting_info OWNER TO postgres;

--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE meeting_info; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.meeting_info IS '存储会议提醒信息表';


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.meeting_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.meeting_id IS '会议ID';


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.meeting_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.meeting_name IS '会议名称';


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.meeting_remarks; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.meeting_remarks IS '会议备注';


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.meeting_intr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.meeting_intr IS '会议内容';


--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.meeting_locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.meeting_locale IS '会议地点';


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.meeting_room; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.meeting_room IS '会议室名字';


--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.schedule_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.schedule_time IS '会议预约时间';


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.meeting_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.meeting_date IS '会议日期';


--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.begin_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.begin_time IS '会议开始时间';


--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.end_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.end_time IS '会议结束时间';


--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.inviter; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.inviter IS '会议邀请者';


--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.member; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.member IS '会议被邀请者';


--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.mem_action; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.mem_action IS '参会人员反馈';


--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.remind_flag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.remind_flag IS '提醒状态';


--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.refuse_reason; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.refuse_reason IS '参会者拒绝参会的原因';


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN meeting_info.canceled; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.meeting_info.canceled IS '会议是否取消';


--
-- TOC entry 238 (class 1259 OID 17449)
-- Name: meeting_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.meeting_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.meeting_info_id_seq OWNER TO postgres;

--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 238
-- Name: meeting_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meeting_info_id_seq OWNED BY public.meeting_info.id;


--
-- TOC entry 239 (class 1259 OID 17451)
-- Name: mission_list_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.mission_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mission_list_id_seq OWNER TO ejabberd;

--
-- TOC entry 240 (class 1259 OID 17453)
-- Name: mission_list; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.mission_list (
    id bigint DEFAULT nextval('public.mission_list_id_seq'::regclass) NOT NULL,
    publisher character varying(255) NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    end_time timestamp with time zone DEFAULT now() NOT NULL,
    body text DEFAULT ''::text NOT NULL,
    state integer DEFAULT 0
);


ALTER TABLE public.mission_list OWNER TO ejabberd;

--
-- TOC entry 241 (class 1259 OID 17464)
-- Name: mission_member_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.mission_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mission_member_id_seq OWNER TO ejabberd;

--
-- TOC entry 242 (class 1259 OID 17466)
-- Name: mission_member; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.mission_member (
    id bigint,
    publisher character varying(255) NOT NULL,
    last_effect_time timestamp with time zone DEFAULT now() NOT NULL,
    effect_count integer DEFAULT 0 NOT NULL,
    member_id bigint DEFAULT nextval('public.mission_member_id_seq'::regclass) NOT NULL,
    userstate integer DEFAULT 0 NOT NULL,
    nexttime timestamp with time zone DEFAULT now()
);


ALTER TABLE public.mission_member OWNER TO ejabberd;

--
-- TOC entry 243 (class 1259 OID 17474)
-- Name: mission_milestone_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.mission_milestone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mission_milestone_id_seq OWNER TO ejabberd;

--
-- TOC entry 244 (class 1259 OID 17476)
-- Name: mission_milestone; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.mission_milestone (
    id bigint DEFAULT nextval('public.mission_milestone_id_seq'::regclass) NOT NULL,
    mission_id bigint DEFAULT 0,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    title text DEFAULT ''::text NOT NULL,
    content text DEFAULT ''::text NOT NULL,
    body text DEFAULT ''::text NOT NULL,
    end_time timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.mission_milestone OWNER TO ejabberd;

--
-- TOC entry 245 (class 1259 OID 17489)
-- Name: motd; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.motd (
    username text NOT NULL,
    xml text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.motd OWNER TO ejabberd;

--
-- TOC entry 246 (class 1259 OID 17496)
-- Name: msg_history; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.msg_history (
    m_from character varying(255),
    m_to character varying(255),
    m_body text,
    create_time timestamp with time zone DEFAULT now(),
    id bigint NOT NULL,
    read_flag smallint DEFAULT 0,
    msg_id text,
    from_host text,
    to_host text,
    realfrom character varying(255),
    realto character varying(255),
    msg_type character varying(255),
    update_time timestamp with time zone DEFAULT now()
);


ALTER TABLE public.msg_history OWNER TO ejabberd;

--
-- TOC entry 247 (class 1259 OID 17505)
-- Name: msg_history_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.msg_history_backup (
    m_from character varying(255),
    m_to character varying(255),
    m_body text,
    create_time timestamp with time zone DEFAULT now(),
    id bigint NOT NULL,
    read_flag smallint DEFAULT 0,
    msg_id text,
    from_host text,
    to_host text,
    realfrom character varying(255),
    realto character varying(255),
    msg_type character varying(255),
    update_time timestamp with time zone DEFAULT now()
);


ALTER TABLE public.msg_history_backup OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 17514)
-- Name: msg_history_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.msg_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.msg_history_id_seq OWNER TO ejabberd;

--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 248
-- Name: msg_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.msg_history_id_seq OWNED BY public.msg_history.id;


--
-- TOC entry 249 (class 1259 OID 17516)
-- Name: msg_history_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.msg_history_view AS
 SELECT msg_history.m_from,
    msg_history.m_to,
    msg_history.create_time,
    msg_history.id,
    msg_history.read_flag,
    msg_history.msg_id,
    msg_history.from_host,
    msg_history.to_host
   FROM public.msg_history;


ALTER TABLE public.msg_history_view OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17520)
-- Name: msg_stat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.msg_stat (
    id integer NOT NULL,
    reportdate date,
    m_from text,
    count integer,
    flag text DEFAULT 'muc'::text,
    nickname text
);


ALTER TABLE public.msg_stat OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17527)
-- Name: msg_stat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.msg_stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.msg_stat_id_seq OWNER TO postgres;

--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 251
-- Name: msg_stat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.msg_stat_id_seq OWNED BY public.msg_stat.id;


--
-- TOC entry 252 (class 1259 OID 17529)
-- Name: msgcount; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.msgcount AS
 SELECT count(1) AS cnt,
    msg_history.m_from,
    (msg_history.create_time)::date AS s_date
   FROM public.msg_history
  WHERE (msg_history.create_time >= (('now'::text)::date - '3 days'::interval))
  GROUP BY msg_history.m_from, ((msg_history.create_time)::date);


ALTER TABLE public.msgcount OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 17533)
-- Name: msgview_old; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.msgview_old AS
 SELECT msg_history.m_from,
    msg_history.create_time AS s_date
   FROM public.msg_history;


ALTER TABLE public.msgview_old OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 17537)
-- Name: muc_last; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_last (
    muc_name text NOT NULL,
    create_time text,
    last_msg_time text DEFAULT '0'::text
);


ALTER TABLE public.muc_last OWNER TO ejabberd;

--
-- TOC entry 255 (class 1259 OID 17544)
-- Name: muc_registered; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_registered (
    jid text NOT NULL,
    host text NOT NULL,
    nick text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.muc_registered OWNER TO ejabberd;

--
-- TOC entry 256 (class 1259 OID 17551)
-- Name: muc_room; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_room (
    name text NOT NULL,
    host text NOT NULL,
    opts text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.muc_room OWNER TO ejabberd;

--
-- TOC entry 257 (class 1259 OID 17558)
-- Name: muc_room_backup; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_room_backup (
    name text NOT NULL,
    host text NOT NULL,
    opts text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.muc_room_backup OWNER TO ejabberd;

--
-- TOC entry 258 (class 1259 OID 17565)
-- Name: muc_room_history; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_room_history (
    muc_room_name character varying(255),
    nick character varying(255),
    packet text,
    have_subject boolean,
    size character varying(255),
    create_time timestamp with time zone DEFAULT now(),
    id bigint NOT NULL,
    host text DEFAULT 'ejabhost1'::text,
    msg_id text
);


ALTER TABLE public.muc_room_history OWNER TO ejabberd;

--
-- TOC entry 259 (class 1259 OID 17573)
-- Name: muc_room_history_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.muc_room_history_backup (
    muc_room_name character varying(255),
    nick character varying(255),
    packet text,
    have_subject boolean,
    size character varying(255),
    create_time timestamp with time zone DEFAULT now(),
    id bigint NOT NULL,
    host text,
    msg_id text
);


ALTER TABLE public.muc_room_history_backup OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 17580)
-- Name: muc_room_history_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.muc_room_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.muc_room_history_id_seq OWNER TO ejabberd;

--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 260
-- Name: muc_room_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.muc_room_history_id_seq OWNED BY public.muc_room_history.id;


--
-- TOC entry 261 (class 1259 OID 17582)
-- Name: muc_room_users_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.muc_room_users_id_seq
    START WITH 1542632
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.muc_room_users_id_seq OWNER TO ejabberd;

--
-- TOC entry 262 (class 1259 OID 17584)
-- Name: muc_room_users; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_room_users (
    muc_name character varying(200) NOT NULL,
    username character varying(200) NOT NULL,
    host character varying(200) NOT NULL,
    subscribe_flag text DEFAULT '0'::text NOT NULL,
    id bigint DEFAULT nextval('public.muc_room_users_id_seq'::regclass) NOT NULL,
    date bigint DEFAULT 0,
    login_date integer,
    domain text DEFAULT 'conference.ejabhost1'::text NOT NULL,
    update_time timestamp with time zone DEFAULT now()
);


ALTER TABLE public.muc_room_users OWNER TO ejabberd;

--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN muc_room_users.update_time; Type: COMMENT; Schema: public; Owner: ejabberd
--

COMMENT ON COLUMN public.muc_room_users.update_time IS '更新时间';


--
-- TOC entry 263 (class 1259 OID 17595)
-- Name: muc_room_users_backup; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_room_users_backup (
    muc_name character varying(200) NOT NULL,
    username character varying(200) NOT NULL,
    host character varying(200) NOT NULL,
    subscribe_flag text DEFAULT '0'::text NOT NULL,
    id bigint NOT NULL,
    date bigint DEFAULT 0,
    login_date integer
);


ALTER TABLE public.muc_room_users_backup OWNER TO ejabberd;

--
-- TOC entry 264 (class 1259 OID 17603)
-- Name: muc_spool; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_spool (
    username text NOT NULL,
    xml text NOT NULL,
    seq integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    send_flag text DEFAULT '1'::text,
    from_username text DEFAULT '未知'::text NOT NULL,
    nick text
);


ALTER TABLE public.muc_spool OWNER TO ejabberd;

--
-- TOC entry 265 (class 1259 OID 17612)
-- Name: muc_spool_seq_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.muc_spool_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.muc_spool_seq_seq OWNER TO ejabberd;

--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 265
-- Name: muc_spool_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.muc_spool_seq_seq OWNED BY public.muc_spool.seq;


--
-- TOC entry 266 (class 1259 OID 17614)
-- Name: muc_user_mark; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_user_mark (
    muc_name text NOT NULL,
    user_name text NOT NULL,
    login_date integer NOT NULL,
    logout_date integer,
    id bigint NOT NULL
);


ALTER TABLE public.muc_user_mark OWNER TO ejabberd;

--
-- TOC entry 267 (class 1259 OID 17620)
-- Name: muc_user_mark_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.muc_user_mark_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.muc_user_mark_id_seq OWNER TO ejabberd;

--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 267
-- Name: muc_user_mark_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.muc_user_mark_id_seq OWNED BY public.muc_user_mark.id;


--
-- TOC entry 268 (class 1259 OID 17622)
-- Name: muc_vcard_info; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_vcard_info (
    muc_name text NOT NULL,
    show_name text NOT NULL,
    muc_desc text,
    muc_title text,
    muc_pic text,
    version integer DEFAULT 1
);


ALTER TABLE public.muc_vcard_info OWNER TO ejabberd;

--
-- TOC entry 269 (class 1259 OID 17629)
-- Name: muc_vcard_info_backup; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_vcard_info_backup (
    muc_name text NOT NULL,
    show_name text NOT NULL,
    muc_desc text,
    muc_title text,
    muc_pic text,
    version integer DEFAULT 1
);


ALTER TABLE public.muc_vcard_info_backup OWNER TO ejabberd;

--
-- TOC entry 270 (class 1259 OID 17636)
-- Name: muc_white_list; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.muc_white_list (
    muc_name text NOT NULL,
    date_time timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.muc_white_list OWNER TO ejabberd;

--
-- TOC entry 271 (class 1259 OID 17643)
-- Name: non_human; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.non_human (
    id integer NOT NULL,
    nickname text NOT NULL
);


ALTER TABLE public.non_human OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 17649)
-- Name: non_human_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.non_human_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.non_human_id_seq OWNER TO postgres;

--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 272
-- Name: non_human_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.non_human_id_seq OWNED BY public.non_human.id;


--
-- TOC entry 273 (class 1259 OID 17651)
-- Name: notice_history; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.notice_history (
    id bigint NOT NULL,
    msg_id text NOT NULL,
    m_from text NOT NULL,
    m_body text NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    host text DEFAULT 'ejabhost1'::text NOT NULL
);


ALTER TABLE public.notice_history OWNER TO ejabberd;

--
-- TOC entry 274 (class 1259 OID 17659)
-- Name: notice_history_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.notice_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notice_history_id_seq OWNER TO ejabberd;

--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 274
-- Name: notice_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.notice_history_id_seq OWNED BY public.notice_history.id;


--
-- TOC entry 275 (class 1259 OID 17661)
-- Name: person_extent; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.person_extent (
    id bigint NOT NULL,
    owner text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    create_at timestamp without time zone DEFAULT now() NOT NULL,
    update_at timestamp without time zone DEFAULT now() NOT NULL,
    version integer DEFAULT 1,
    host text DEFAULT 'ejabhost1'::text
);


ALTER TABLE public.person_extent OWNER TO ejabberd;

--
-- TOC entry 276 (class 1259 OID 17671)
-- Name: person_extent_2017_09_22; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_extent_2017_09_22 (
    id bigint NOT NULL,
    owner text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    create_at timestamp without time zone NOT NULL,
    update_at timestamp without time zone NOT NULL,
    version integer
);


ALTER TABLE public.person_extent_2017_09_22 OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 17677)
-- Name: person_extent_2018_05_02; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.person_extent_2018_05_02 (
    id bigint NOT NULL,
    owner text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    create_at timestamp without time zone DEFAULT now() NOT NULL,
    update_at timestamp without time zone DEFAULT now() NOT NULL,
    version integer DEFAULT 1,
    host text DEFAULT 'ejabhost1'::text
);


ALTER TABLE public.person_extent_2018_05_02 OWNER TO ejabberd;

--
-- TOC entry 278 (class 1259 OID 17687)
-- Name: person_extent_2018_07_12; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_extent_2018_07_12 (
    id bigint NOT NULL,
    owner text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    create_at timestamp without time zone NOT NULL,
    update_at timestamp without time zone NOT NULL,
    version integer,
    host text
);


ALTER TABLE public.person_extent_2018_07_12 OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 17693)
-- Name: person_extent_backup_2018_01_28; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.person_extent_backup_2018_01_28 (
    id bigint NOT NULL,
    owner text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    create_at timestamp without time zone DEFAULT now() NOT NULL,
    update_at timestamp without time zone DEFAULT now() NOT NULL,
    version integer DEFAULT 1,
    host text DEFAULT 'ejabhost1'::text
);


ALTER TABLE public.person_extent_backup_2018_01_28 OWNER TO ejabberd;

--
-- TOC entry 280 (class 1259 OID 17703)
-- Name: person_extent_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.person_extent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_extent_id_seq OWNER TO ejabberd;

--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 280
-- Name: person_extent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.person_extent_id_seq OWNED BY public.person_extent.id;


--
-- TOC entry 281 (class 1259 OID 17705)
-- Name: person_user_mac_key; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.person_user_mac_key (
    user_name character varying(255) NOT NULL,
    host character varying(255) NOT NULL,
    mac_key character varying(255),
    os text DEFAULT 'ios'::text NOT NULL,
    version text,
    push_flag integer DEFAULT 0 NOT NULL,
    create_time timestamp with time zone DEFAULT now(),
    update_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.person_user_mac_key OWNER TO ejabberd;

--
-- TOC entry 282 (class 1259 OID 17715)
-- Name: privacy_default_list; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.privacy_default_list (
    username text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.privacy_default_list OWNER TO ejabberd;

--
-- TOC entry 283 (class 1259 OID 17721)
-- Name: privacy_list; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.privacy_list (
    username text NOT NULL,
    name text NOT NULL,
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.privacy_list OWNER TO ejabberd;

--
-- TOC entry 284 (class 1259 OID 17728)
-- Name: privacy_list_data; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.privacy_list_data (
    id bigint,
    t character(1) NOT NULL,
    value text NOT NULL,
    action character(1) NOT NULL,
    ord numeric NOT NULL,
    match_all boolean NOT NULL,
    match_iq boolean NOT NULL,
    match_message boolean NOT NULL,
    match_presence_in boolean NOT NULL,
    match_presence_out boolean NOT NULL
);


ALTER TABLE public.privacy_list_data OWNER TO ejabberd;

--
-- TOC entry 285 (class 1259 OID 17734)
-- Name: privacy_list_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.privacy_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.privacy_list_id_seq OWNER TO ejabberd;

--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 285
-- Name: privacy_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.privacy_list_id_seq OWNED BY public.privacy_list.id;


--
-- TOC entry 286 (class 1259 OID 17736)
-- Name: private_storage; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.private_storage (
    username text NOT NULL,
    namespace text NOT NULL,
    data text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.private_storage OWNER TO ejabberd;

--
-- TOC entry 287 (class 1259 OID 17743)
-- Name: pubsub_item; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.pubsub_item (
    nodeid bigint,
    itemid text,
    publisher text,
    creation text,
    modification text,
    payload text
);


ALTER TABLE public.pubsub_item OWNER TO ejabberd;

--
-- TOC entry 288 (class 1259 OID 17749)
-- Name: pubsub_node; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.pubsub_node (
    host text,
    node text,
    parent text,
    type text,
    nodeid integer NOT NULL
);


ALTER TABLE public.pubsub_node OWNER TO ejabberd;

--
-- TOC entry 289 (class 1259 OID 17755)
-- Name: pubsub_node_nodeid_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.pubsub_node_nodeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pubsub_node_nodeid_seq OWNER TO ejabberd;

--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 289
-- Name: pubsub_node_nodeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.pubsub_node_nodeid_seq OWNED BY public.pubsub_node.nodeid;


--
-- TOC entry 290 (class 1259 OID 17757)
-- Name: pubsub_node_option; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.pubsub_node_option (
    nodeid bigint,
    name text,
    val text
);


ALTER TABLE public.pubsub_node_option OWNER TO ejabberd;

--
-- TOC entry 291 (class 1259 OID 17763)
-- Name: pubsub_node_owner; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.pubsub_node_owner (
    nodeid bigint,
    owner text
);


ALTER TABLE public.pubsub_node_owner OWNER TO ejabberd;

--
-- TOC entry 292 (class 1259 OID 17769)
-- Name: pubsub_state; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.pubsub_state (
    nodeid bigint,
    jid text,
    affiliation character(1),
    subscriptions text,
    stateid integer NOT NULL
);


ALTER TABLE public.pubsub_state OWNER TO ejabberd;

--
-- TOC entry 293 (class 1259 OID 17775)
-- Name: pubsub_state_stateid_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.pubsub_state_stateid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pubsub_state_stateid_seq OWNER TO ejabberd;

--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 293
-- Name: pubsub_state_stateid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.pubsub_state_stateid_seq OWNED BY public.pubsub_state.stateid;


--
-- TOC entry 294 (class 1259 OID 17777)
-- Name: pubsub_subscription_opt; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.pubsub_subscription_opt (
    subid text,
    opt_name character varying(32),
    opt_value text
);


ALTER TABLE public.pubsub_subscription_opt OWNER TO ejabberd;

--
-- TOC entry 295 (class 1259 OID 17783)
-- Name: push_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.push_info (
    id integer NOT NULL,
    user_name character varying(255) NOT NULL,
    host character varying(255) NOT NULL,
    mac_key character varying(255),
    platname character varying(255),
    pkgname character varying(255),
    os character varying(50) NOT NULL,
    version character varying(50),
    create_time timestamp with time zone DEFAULT now(),
    update_at timestamp with time zone DEFAULT now(),
    show_content smallint DEFAULT 1,
    push_flag integer DEFAULT 0
);


ALTER TABLE public.push_info OWNER TO postgres;

--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 295
-- Name: TABLE push_info; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.push_info IS '存储用户推送信息表';


--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.user_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.user_name IS '用户用户名';


--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.host; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.host IS '用户域名';


--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.mac_key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.mac_key IS '用户上传唯一key,给指定key发送push';


--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.platname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.platname IS 'adr端平台名称，如mipush';


--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.pkgname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.pkgname IS 'adr端应用包名';


--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.os; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.os IS '平台系统 ios或android';


--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.version IS '版本号';


--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.create_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.create_time IS '创建时间';


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.update_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.update_at IS '更新时间';


--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.show_content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.show_content IS '是否显示推送详细内容，默认值1：显示，0：不显示';


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN push_info.push_flag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.push_info.push_flag IS '是否push标志位';


--
-- TOC entry 296 (class 1259 OID 17790)
-- Name: push_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.push_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.push_info_id_seq OWNER TO postgres;

--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 296
-- Name: push_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.push_info_id_seq OWNED BY public.push_info.id;


--
-- TOC entry 297 (class 1259 OID 17792)
-- Name: qcloud_main; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qcloud_main (
    id integer NOT NULL,
    q_user character varying(255),
    q_type integer,
    q_title text,
    q_introduce text,
    q_content text,
    q_time bigint,
    q_state integer DEFAULT 1
);


ALTER TABLE public.qcloud_main OWNER TO postgres;

--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 297
-- Name: TABLE qcloud_main; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qcloud_main IS 'Evernote主列表存储表';


--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN qcloud_main.q_user; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main.q_user IS '信息所属用户';


--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN qcloud_main.q_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main.q_type IS '信息类型';


--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN qcloud_main.q_title; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main.q_title IS '标题';


--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN qcloud_main.q_introduce; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main.q_introduce IS '介绍';


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN qcloud_main.q_content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main.q_content IS '内容';


--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN qcloud_main.q_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main.q_time IS '最后修改时间';


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN qcloud_main.q_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main.q_state IS '信息状态标记(正常、收藏、废纸篓、删除)';


--
-- TOC entry 298 (class 1259 OID 17799)
-- Name: qcloud_main_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qcloud_main_history (
    id integer NOT NULL,
    q_id integer,
    qh_content text,
    qh_time bigint,
    qh_state integer DEFAULT 1
);


ALTER TABLE public.qcloud_main_history OWNER TO postgres;

--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 298
-- Name: TABLE qcloud_main_history; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qcloud_main_history IS 'Evernote主列表操作历史';


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN qcloud_main_history.q_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main_history.q_id IS '主列表ID';


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN qcloud_main_history.qh_content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main_history.qh_content IS '操作内容';


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN qcloud_main_history.qh_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main_history.qh_time IS '操作时间';


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN qcloud_main_history.qh_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_main_history.qh_state IS '状态';


--
-- TOC entry 299 (class 1259 OID 17806)
-- Name: qcloud_main_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qcloud_main_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qcloud_main_history_id_seq OWNER TO postgres;

--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 299
-- Name: qcloud_main_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qcloud_main_history_id_seq OWNED BY public.qcloud_main_history.id;


--
-- TOC entry 300 (class 1259 OID 17808)
-- Name: qcloud_main_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qcloud_main_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qcloud_main_id_seq OWNER TO postgres;

--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 300
-- Name: qcloud_main_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qcloud_main_id_seq OWNED BY public.qcloud_main.id;


--
-- TOC entry 301 (class 1259 OID 17810)
-- Name: qcloud_sub; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qcloud_sub (
    id integer NOT NULL,
    q_id bigint NOT NULL,
    qs_user character varying(255),
    qs_type integer,
    qs_title text,
    qs_introduce text,
    qs_content text,
    qs_time bigint,
    qs_state integer DEFAULT 1
);


ALTER TABLE public.qcloud_sub OWNER TO postgres;

--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 301
-- Name: TABLE qcloud_sub; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qcloud_sub IS 'Evernote子列表存储表';


--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN qcloud_sub.q_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub.q_id IS '主列表ID';


--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN qcloud_sub.qs_user; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub.qs_user IS '信息所属用户';


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN qcloud_sub.qs_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub.qs_type IS '信息类型';


--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN qcloud_sub.qs_title; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub.qs_title IS '标题';


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN qcloud_sub.qs_introduce; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub.qs_introduce IS '介绍';


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN qcloud_sub.qs_content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub.qs_content IS '内容';


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN qcloud_sub.qs_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub.qs_time IS '最后修改时间';


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN qcloud_sub.qs_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub.qs_state IS '信息状态标记(正常、收藏、废纸篓、删除)';


--
-- TOC entry 302 (class 1259 OID 17817)
-- Name: qcloud_sub_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qcloud_sub_history (
    id integer NOT NULL,
    qs_id integer,
    qh_content text,
    qh_time bigint,
    qh_state integer DEFAULT 1
);


ALTER TABLE public.qcloud_sub_history OWNER TO postgres;

--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 302
-- Name: TABLE qcloud_sub_history; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qcloud_sub_history IS 'Evernote子列表操作历史';


--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 302
-- Name: COLUMN qcloud_sub_history.qs_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub_history.qs_id IS '主列表ID';


--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 302
-- Name: COLUMN qcloud_sub_history.qh_content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub_history.qh_content IS '操作内容';


--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 302
-- Name: COLUMN qcloud_sub_history.qh_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub_history.qh_time IS '操作时间';


--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 302
-- Name: COLUMN qcloud_sub_history.qh_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qcloud_sub_history.qh_state IS '状态';


--
-- TOC entry 303 (class 1259 OID 17824)
-- Name: qcloud_sub_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qcloud_sub_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qcloud_sub_history_id_seq OWNER TO postgres;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 303
-- Name: qcloud_sub_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qcloud_sub_history_id_seq OWNED BY public.qcloud_sub_history.id;


--
-- TOC entry 304 (class 1259 OID 17826)
-- Name: qcloud_sub_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qcloud_sub_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qcloud_sub_id_seq OWNER TO postgres;

--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 304
-- Name: qcloud_sub_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qcloud_sub_id_seq OWNED BY public.qcloud_sub.id;


--
-- TOC entry 305 (class 1259 OID 17828)
-- Name: qtalk_user_comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qtalk_user_comment (
    id bigint NOT NULL,
    from_user character varying(20) NOT NULL,
    to_user character varying(20) NOT NULL,
    create_time timestamp with time zone NOT NULL,
    comment character varying(500),
    grade boolean NOT NULL
);


ALTER TABLE public.qtalk_user_comment OWNER TO postgres;

--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN qtalk_user_comment.from_user; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qtalk_user_comment.from_user IS '点评人';


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN qtalk_user_comment.to_user; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qtalk_user_comment.to_user IS '被点评人';


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN qtalk_user_comment.create_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qtalk_user_comment.create_time IS '点评时间';


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN qtalk_user_comment.comment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qtalk_user_comment.comment IS '点评内容';


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN qtalk_user_comment.grade; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.qtalk_user_comment.grade IS 'true 赞 fasle 扁';


--
-- TOC entry 306 (class 1259 OID 17831)
-- Name: qtalk_user_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qtalk_user_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qtalk_user_comment_id_seq OWNER TO postgres;

--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 306
-- Name: qtalk_user_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qtalk_user_comment_id_seq OWNED BY public.qtalk_user_comment.id;


--
-- TOC entry 307 (class 1259 OID 17833)
-- Name: recv_msg_option; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.recv_msg_option (
    username text NOT NULL,
    rec_msg_opt smallint DEFAULT (2)::smallint,
    version integer
);


ALTER TABLE public.recv_msg_option OWNER TO ejabberd;

--
-- TOC entry 308 (class 1259 OID 17840)
-- Name: revoke_msg_history; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.revoke_msg_history (
    m_from text,
    m_to text,
    m_body text,
    id bigint NOT NULL,
    m_timestamp bigint DEFAULT date_part('epoch'::text, now()),
    msg_id text,
    create_time timestamp with time zone DEFAULT now()
);


ALTER TABLE public.revoke_msg_history OWNER TO ejabberd;

--
-- TOC entry 309 (class 1259 OID 17848)
-- Name: revoke_msg_history_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revoke_msg_history_backup (
    m_from text,
    m_to text,
    m_body text,
    id bigint NOT NULL,
    m_timestamp bigint DEFAULT date_part('epoch'::text, now()),
    msg_id text,
    create_time timestamp with time zone DEFAULT now()
);


ALTER TABLE public.revoke_msg_history_backup OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 17856)
-- Name: revoke_msg_history_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.revoke_msg_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revoke_msg_history_id_seq OWNER TO ejabberd;

--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 310
-- Name: revoke_msg_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.revoke_msg_history_id_seq OWNED BY public.revoke_msg_history.id;


--
-- TOC entry 311 (class 1259 OID 17858)
-- Name: robot_info; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.robot_info (
    en_name text NOT NULL,
    cn_name text NOT NULL,
    request_url text NOT NULL,
    rbt_desc text,
    rbt_body text NOT NULL,
    rbt_version bigint,
    password text,
    recommend smallint,
    host text DEFAULT 'ejabhost1'::text
);


ALTER TABLE public.robot_info OWNER TO ejabberd;

--
-- TOC entry 312 (class 1259 OID 17865)
-- Name: robot_pubsub; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.robot_pubsub (
    rbt_name text NOT NULL,
    user_name text NOT NULL,
    host text DEFAULT 'ejabhost1'::text,
    rbt_host text DEFAULT 'ejabhost1'::text,
    user_host text DEFAULT 'ejabhost1'::text
);


ALTER TABLE public.robot_pubsub OWNER TO ejabberd;

--
-- TOC entry 313 (class 1259 OID 17874)
-- Name: robot_pubsub_backup; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.robot_pubsub_backup (
    rbt_name text NOT NULL,
    user_name text NOT NULL
);


ALTER TABLE public.robot_pubsub_backup OWNER TO ejabberd;

--
-- TOC entry 314 (class 1259 OID 17880)
-- Name: robot_pubsub_test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.robot_pubsub_test (
    rbt_name text NOT NULL,
    user_name text NOT NULL,
    host text DEFAULT 'ejabhost1'::text,
    rbt_host text DEFAULT 'ejabhost1'::text,
    user_host text DEFAULT 'ejabhost1'::text
);


ALTER TABLE public.robot_pubsub_test OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 17889)
-- Name: users; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.users (
    username text NOT NULL,
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    name text,
    department text DEFAULT '未知部门'::text,
    dep1 text DEFAULT '未知部门'::text,
    dep2 text DEFAULT ''::text,
    dep3 text DEFAULT ''::text,
    dep4 text DEFAULT ''::text,
    dep5 text DEFAULT ''::text,
    fpinyin text,
    spinyin text,
    frozen_flag text DEFAULT '0'::text,
    sn text,
    id bigint NOT NULL,
    hire_type text,
    version integer DEFAULT 1,
    hire_flag smallint,
    type character(1) DEFAULT 'u'::bpchar,
    ps_deptid text DEFAULT 'QUNAR'::text NOT NULL
);


ALTER TABLE public.users OWNER TO ejabberd;

--
-- TOC entry 316 (class 1259 OID 17906)
-- Name: roommsgview_old; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.roommsgview_old AS
 SELECT u.username,
    rh.nick,
    rh.create_time
   FROM (public.muc_room_history rh
     JOIN public.users u ON (((rh.nick)::text = u.name)));


ALTER TABLE public.roommsgview_old OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 17910)
-- Name: roster_version; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.roster_version (
    username text NOT NULL,
    version text NOT NULL
);


ALTER TABLE public.roster_version OWNER TO ejabberd;

--
-- TOC entry 318 (class 1259 OID 17916)
-- Name: rostergroups; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.rostergroups (
    username text NOT NULL,
    jid text NOT NULL,
    grp text NOT NULL
);


ALTER TABLE public.rostergroups OWNER TO ejabberd;

--
-- TOC entry 319 (class 1259 OID 17922)
-- Name: rosterusers; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.rosterusers (
    username text NOT NULL,
    jid text NOT NULL,
    nick text NOT NULL,
    subscription character(1) NOT NULL,
    ask character(1) NOT NULL,
    askmessage text NOT NULL,
    server character(1) NOT NULL,
    subscribe text,
    type text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rosterusers OWNER TO ejabberd;

--
-- TOC entry 320 (class 1259 OID 17929)
-- Name: s2s_mapped_host; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.s2s_mapped_host (
    domain character varying(255) NOT NULL,
    host character varying(255) NOT NULL,
    port integer,
    priority character varying(255) NOT NULL,
    weight character varying(255) NOT NULL
);


ALTER TABLE public.s2s_mapped_host OWNER TO ejabberd;

--
-- TOC entry 321 (class 1259 OID 17932)
-- Name: scheduling_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scheduling_info (
    id integer NOT NULL,
    scheduling_id character varying(255) NOT NULL,
    scheduling_name character varying(255) NOT NULL,
    scheduling_type character varying(255) DEFAULT '0'::character varying,
    scheduling_remarks text DEFAULT ''::text,
    scheduling_intr text DEFAULT ''::text,
    scheduling_appointment text DEFAULT ''::text,
    scheduling_locale character varying(255) NOT NULL,
    scheduling_locale_id character varying(255) NOT NULL,
    scheduling_room character varying(255) NOT NULL,
    scheduling_room_id character varying(255) NOT NULL,
    schedule_time timestamp with time zone DEFAULT (now())::timestamp(3) with time zone,
    scheduling_date date NOT NULL,
    begin_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    inviter character varying(255) NOT NULL,
    member character varying(255) NOT NULL,
    mem_action character varying(255) DEFAULT '0'::character varying,
    remind_flag character varying(255) DEFAULT '0'::character varying,
    action_remark text DEFAULT ''::text,
    canceled boolean DEFAULT false,
    update_time timestamp with time zone DEFAULT (now())::timestamp(3) with time zone
);


ALTER TABLE public.scheduling_info OWNER TO postgres;

--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_id IS '行程ID';


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_name IS '行程名字';


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_type IS '行程类型，1是会议，2是约会';


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_remarks; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_remarks IS '行程备注';


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_intr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_intr IS '行程简介';


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_appointment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_appointment IS '行程介绍';


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_locale IS '行程地点';


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_locale_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_locale_id IS '行程地点编号';


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_room; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_room IS '行程房间';


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_room_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_room_id IS '行程房间编号';


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.schedule_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.schedule_time IS '行程约定的时间';


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.scheduling_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.scheduling_date IS '行程日期';


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.begin_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.begin_time IS '行程开始时间';


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.end_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.end_time IS '行程结束时间';


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.inviter; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.inviter IS '行程邀请者';


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.member; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.member IS '行程参与者';


--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.mem_action; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.mem_action IS '行程参与者接受状态';


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.remind_flag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.remind_flag IS '行程参与者提醒标志，0未提醒，1开始前15分钟已提醒，2结束前15分钟已提醒';


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.action_remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.action_remark IS '行程参与者接受时的备注';


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.canceled; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.canceled IS '行程是否被取消';


--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN scheduling_info.update_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scheduling_info.update_time IS '行程更新时间';


--
-- TOC entry 322 (class 1259 OID 17948)
-- Name: scheduling_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scheduling_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scheduling_info_id_seq OWNER TO postgres;

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 322
-- Name: scheduling_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scheduling_info_id_seq OWNED BY public.scheduling_info.id;


--
-- TOC entry 323 (class 1259 OID 17950)
-- Name: sms_log_info; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.sms_log_info (
    id bigint NOT NULL,
    ip text NOT NULL,
    tel text NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sms_log_info OWNER TO ejabberd;

--
-- TOC entry 324 (class 1259 OID 17957)
-- Name: sms_log_info_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.sms_log_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_log_info_id_seq OWNER TO ejabberd;

--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 324
-- Name: sms_log_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.sms_log_info_id_seq OWNED BY public.sms_log_info.id;


--
-- TOC entry 325 (class 1259 OID 17959)
-- Name: sms_request_info; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.sms_request_info (
    id bigint NOT NULL,
    ip text NOT NULL,
    tel text NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sms_request_info OWNER TO ejabberd;

--
-- TOC entry 326 (class 1259 OID 17966)
-- Name: sms_request_info_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.sms_request_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_request_info_id_seq OWNER TO ejabberd;

--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 326
-- Name: sms_request_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.sms_request_info_id_seq OWNED BY public.sms_request_info.id;


--
-- TOC entry 327 (class 1259 OID 17968)
-- Name: sms_user_info; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.sms_user_info (
    user_name text NOT NULL,
    last_sms_time timestamp without time zone DEFAULT now() NOT NULL,
    phone text NOT NULL,
    verify_code text
);


ALTER TABLE public.sms_user_info OWNER TO ejabberd;

--
-- TOC entry 328 (class 1259 OID 17975)
-- Name: spool; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.spool (
    username text NOT NULL,
    xml text NOT NULL,
    seq integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    send_flag text DEFAULT '1'::text,
    from_username text DEFAULT '未知'::text NOT NULL,
    notice_flag text DEFAULT '0'::text,
    away_flag text DEFAULT '0'::text
);


ALTER TABLE public.spool OWNER TO ejabberd;

--
-- TOC entry 329 (class 1259 OID 17986)
-- Name: spool_seq_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.spool_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.spool_seq_seq OWNER TO ejabberd;

--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 329
-- Name: spool_seq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.spool_seq_seq OWNED BY public.spool.seq;


--
-- TOC entry 330 (class 1259 OID 17988)
-- Name: sr_group; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.sr_group (
    name text NOT NULL,
    opts text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sr_group OWNER TO ejabberd;

--
-- TOC entry 331 (class 1259 OID 17995)
-- Name: sr_user; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.sr_user (
    jid text NOT NULL,
    grp text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sr_user OWNER TO ejabberd;

--
-- TOC entry 332 (class 1259 OID 18002)
-- Name: test1_table; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.test1_table (
    userid text DEFAULT ''::text NOT NULL,
    count1 integer,
    count2 integer
);


ALTER TABLE public.test1_table OWNER TO ejabberd;

--
-- TOC entry 333 (class 1259 OID 18009)
-- Name: test_user; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.test_user (
    id integer,
    name text,
    count integer
);


ALTER TABLE public.test_user OWNER TO ejabberd;

--
-- TOC entry 334 (class 1259 OID 18015)
-- Name: user_block_list; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.user_block_list (
    username text NOT NULL,
    blockuser text NOT NULL
);


ALTER TABLE public.user_block_list OWNER TO ejabberd;

--
-- TOC entry 335 (class 1259 OID 18021)
-- Name: user_friends; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.user_friends (
    username text NOT NULL,
    friend text NOT NULL,
    relationship smallint,
    version integer,
    host text DEFAULT 'ejabhost1'::text NOT NULL,
    userhost character varying(255) DEFAULT 'ejabhost1'::character varying
);


ALTER TABLE public.user_friends OWNER TO ejabberd;

--
-- TOC entry 336 (class 1259 OID 18029)
-- Name: user_mac_key; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.user_mac_key (
    user_name character varying(255) NOT NULL,
    host character varying(255) NOT NULL,
    mac_key character varying(255),
    os text DEFAULT 'ios'::text NOT NULL,
    version text,
    push_flag integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_mac_key OWNER TO ejabberd;

--
-- TOC entry 337 (class 1259 OID 18037)
-- Name: user_name; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.user_name (
    user_name text NOT NULL,
    masked_user text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_name OWNER TO ejabberd;

--
-- TOC entry 338 (class 1259 OID 18044)
-- Name: user_register_mucs; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.user_register_mucs (
    username text NOT NULL,
    muc_name text NOT NULL,
    domain character varying(200) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    registed_flag integer DEFAULT 1,
    host text DEFAULT 'ejabhost1'::text NOT NULL
);


ALTER TABLE public.user_register_mucs OWNER TO ejabberd;

--
-- TOC entry 339 (class 1259 OID 18053)
-- Name: user_register_mucs_backup; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.user_register_mucs_backup (
    username text NOT NULL,
    muc_name text NOT NULL,
    domain character varying(200) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    registed_flag integer DEFAULT 1
);


ALTER TABLE public.user_register_mucs_backup OWNER TO ejabberd;

--
-- TOC entry 340 (class 1259 OID 18061)
-- Name: user_relation_opts; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.user_relation_opts (
    username text NOT NULL,
    rec_msg_opt smallint DEFAULT (2)::smallint,
    vld_friend_opt smallint DEFAULT (1)::smallint,
    validate_quetion text,
    validate_answer text,
    vesion smallint,
    userhost text DEFAULT 'ejabhost1'::text
);


ALTER TABLE public.user_relation_opts OWNER TO ejabberd;

--
-- TOC entry 341 (class 1259 OID 18070)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO ejabberd;

--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 341
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 342 (class 1259 OID 18072)
-- Name: vcard; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.vcard (
    username text NOT NULL,
    vcard text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.vcard OWNER TO ejabberd;

--
-- TOC entry 343 (class 1259 OID 18079)
-- Name: vcard_search; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.vcard_search (
    username text NOT NULL,
    lusername text NOT NULL,
    fn text NOT NULL,
    lfn text NOT NULL,
    family text NOT NULL,
    lfamily text NOT NULL,
    given text NOT NULL,
    lgiven text NOT NULL,
    middle text NOT NULL,
    lmiddle text NOT NULL,
    nickname text NOT NULL,
    lnickname text NOT NULL,
    bday text NOT NULL,
    lbday text NOT NULL,
    ctry text NOT NULL,
    lctry text NOT NULL,
    locality text NOT NULL,
    llocality text NOT NULL,
    email text NOT NULL,
    lemail text NOT NULL,
    orgname text NOT NULL,
    lorgname text NOT NULL,
    orgunit text NOT NULL,
    lorgunit text NOT NULL
);


ALTER TABLE public.vcard_search OWNER TO ejabberd;

--
-- TOC entry 344 (class 1259 OID 18085)
-- Name: vcard_version; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.vcard_version (
    username text NOT NULL,
    version integer DEFAULT 1,
    url text,
    uin character varying(30),
    id bigint NOT NULL,
    profile_version smallint DEFAULT (1)::smallint,
    mood text,
    gender integer DEFAULT 0 NOT NULL,
    host text DEFAULT 'ejabhost1'::text
);


ALTER TABLE public.vcard_version OWNER TO ejabberd;

--
-- TOC entry 345 (class 1259 OID 18095)
-- Name: vcard_version_id_seq; Type: SEQUENCE; Schema: public; Owner: ejabberd
--

CREATE SEQUENCE public.vcard_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vcard_version_id_seq OWNER TO ejabberd;

--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 345
-- Name: vcard_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ejabberd
--

ALTER SEQUENCE public.vcard_version_id_seq OWNED BY public.vcard_version.id;


--
-- TOC entry 346 (class 1259 OID 18097)
-- Name: vcard_version_test_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vcard_version_test_id_seq
    START WITH 36101
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vcard_version_test_id_seq OWNER TO postgres;

--
-- TOC entry 347 (class 1259 OID 18099)
-- Name: vcard_version_test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vcard_version_test (
    username text NOT NULL,
    version integer DEFAULT 1,
    url text,
    uin character varying(30),
    id bigint DEFAULT nextval('public.vcard_version_test_id_seq'::regclass) NOT NULL,
    profile_version smallint DEFAULT (1)::smallint,
    mood text,
    gender integer DEFAULT 0 NOT NULL,
    host text DEFAULT 'ejabhost1'::text
);


ALTER TABLE public.vcard_version_test OWNER TO postgres;

--
-- TOC entry 348 (class 1259 OID 18110)
-- Name: vcard_xupdate; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.vcard_xupdate (
    username text NOT NULL,
    hash text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.vcard_xupdate OWNER TO ejabberd;

--
-- TOC entry 349 (class 1259 OID 18117)
-- Name: virtual_user_list; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.virtual_user_list (
    virtual_user text NOT NULL,
    real_user text NOT NULL,
    on_duty_flag smallint,
    busisupplierid text NOT NULL
);


ALTER TABLE public.virtual_user_list OWNER TO ejabberd;

--
-- TOC entry 350 (class 1259 OID 18123)
-- Name: warn_msg_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warn_msg_history (
    id bigint NOT NULL,
    m_from character varying(255),
    m_to character varying(255),
    read_flag smallint DEFAULT 0,
    msg_id text,
    from_host text,
    to_host text,
    m_body text,
    create_time timestamp with time zone DEFAULT now()
);


ALTER TABLE public.warn_msg_history OWNER TO postgres;

--
-- TOC entry 351 (class 1259 OID 18131)
-- Name: warn_msg_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.warn_msg_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warn_msg_history_id_seq OWNER TO postgres;

--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 351
-- Name: warn_msg_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.warn_msg_history_id_seq OWNED BY public.warn_msg_history.id;


--
-- TOC entry 352 (class 1259 OID 18133)
-- Name: warn_msg_history_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warn_msg_history_backup (
    id bigint DEFAULT nextval('public.warn_msg_history_id_seq'::regclass) NOT NULL,
    m_from character varying(255),
    m_to character varying(255),
    read_flag smallint DEFAULT 0,
    msg_id text,
    from_host text,
    to_host text,
    m_body text,
    create_time timestamp with time zone DEFAULT now()
);


ALTER TABLE public.warn_msg_history_backup OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 18142)
-- Name: white_list; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.white_list (
    username text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    single_flag text DEFAULT '1'::text
);


ALTER TABLE public.white_list OWNER TO ejabberd;

--
-- TOC entry 354 (class 1259 OID 18150)
-- Name: white_list_test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.white_list_test (
    username text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    single_flag text DEFAULT '1'::text
);


ALTER TABLE public.white_list_test OWNER TO postgres;

--
-- TOC entry 355 (class 1259 OID 18158)
-- Name: win_dump_url; Type: TABLE; Schema: public; Owner: ejabberd
--

CREATE TABLE public.win_dump_url (
    user_name character varying(50) NOT NULL,
    dump_url text NOT NULL,
    dump_time timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.win_dump_url OWNER TO ejabberd;

--
-- TOC entry 3837 (class 2604 OID 18165)
-- Name: android_send_stat id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.android_send_stat ALTER COLUMN id SET DEFAULT nextval('public.android_send_stat_id_seq'::regclass);


--
-- TOC entry 3842 (class 2604 OID 18166)
-- Name: client_config_sync id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_config_sync ALTER COLUMN id SET DEFAULT nextval('public.client_config_sync_id_seq'::regclass);


--
-- TOC entry 3844 (class 2604 OID 18167)
-- Name: destroy_muc_info id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.destroy_muc_info ALTER COLUMN id SET DEFAULT nextval('public.destroy_muc_info_id_seq'::regclass);


--
-- TOC entry 3856 (class 2604 OID 18169)
-- Name: fresh_empl_entering id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fresh_empl_entering ALTER COLUMN id SET DEFAULT nextval('public.fresh_empl_entering_id_seq'::regclass);


--
-- TOC entry 3860 (class 2604 OID 18170)
-- Name: group_extent id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.group_extent ALTER COLUMN id SET DEFAULT nextval('public.group_extent_id_seq'::regclass);


--
-- TOC entry 3862 (class 2604 OID 18171)
-- Name: host_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.host_info ALTER COLUMN id SET DEFAULT nextval('public.host_info_id_seq'::regclass);


--
-- TOC entry 3874 (class 2604 OID 18172)
-- Name: host_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.host_users ALTER COLUMN id SET DEFAULT nextval('public.host_users_id_seq'::regclass);


--
-- TOC entry 3897 (class 2604 OID 18173)
-- Name: mask_history id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.mask_history ALTER COLUMN id SET DEFAULT nextval('public.mask_history_id_seq'::regclass);


--
-- TOC entry 3905 (class 2604 OID 18174)
-- Name: meeting_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting_info ALTER COLUMN id SET DEFAULT nextval('public.meeting_info_id_seq'::regclass);


--
-- TOC entry 3927 (class 2604 OID 18175)
-- Name: msg_history id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.msg_history ALTER COLUMN id SET DEFAULT nextval('public.msg_history_id_seq'::regclass);


--
-- TOC entry 3932 (class 2604 OID 18176)
-- Name: msg_stat id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_stat ALTER COLUMN id SET DEFAULT nextval('public.msg_stat_id_seq'::regclass);


--
-- TOC entry 3939 (class 2604 OID 18177)
-- Name: muc_room_history id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_room_history ALTER COLUMN id SET DEFAULT nextval('public.muc_room_history_id_seq'::regclass);


--
-- TOC entry 3951 (class 2604 OID 18178)
-- Name: muc_spool seq; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_spool ALTER COLUMN seq SET DEFAULT nextval('public.muc_spool_seq_seq'::regclass);


--
-- TOC entry 3952 (class 2604 OID 18179)
-- Name: muc_user_mark id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_user_mark ALTER COLUMN id SET DEFAULT nextval('public.muc_user_mark_id_seq'::regclass);


--
-- TOC entry 3956 (class 2604 OID 18180)
-- Name: non_human id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.non_human ALTER COLUMN id SET DEFAULT nextval('public.non_human_id_seq'::regclass);


--
-- TOC entry 3959 (class 2604 OID 18181)
-- Name: notice_history id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.notice_history ALTER COLUMN id SET DEFAULT nextval('public.notice_history_id_seq'::regclass);


--
-- TOC entry 3964 (class 2604 OID 18182)
-- Name: person_extent id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.person_extent ALTER COLUMN id SET DEFAULT nextval('public.person_extent_id_seq'::regclass);


--
-- TOC entry 3978 (class 2604 OID 18183)
-- Name: privacy_list id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.privacy_list ALTER COLUMN id SET DEFAULT nextval('public.privacy_list_id_seq'::regclass);


--
-- TOC entry 3980 (class 2604 OID 18184)
-- Name: pubsub_node nodeid; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.pubsub_node ALTER COLUMN nodeid SET DEFAULT nextval('public.pubsub_node_nodeid_seq'::regclass);


--
-- TOC entry 3981 (class 2604 OID 18185)
-- Name: pubsub_state stateid; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.pubsub_state ALTER COLUMN stateid SET DEFAULT nextval('public.pubsub_state_stateid_seq'::regclass);


--
-- TOC entry 3986 (class 2604 OID 18186)
-- Name: push_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.push_info ALTER COLUMN id SET DEFAULT nextval('public.push_info_id_seq'::regclass);


--
-- TOC entry 3988 (class 2604 OID 18187)
-- Name: qcloud_main id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qcloud_main ALTER COLUMN id SET DEFAULT nextval('public.qcloud_main_id_seq'::regclass);


--
-- TOC entry 3990 (class 2604 OID 18188)
-- Name: qcloud_main_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qcloud_main_history ALTER COLUMN id SET DEFAULT nextval('public.qcloud_main_history_id_seq'::regclass);


--
-- TOC entry 3992 (class 2604 OID 18189)
-- Name: qcloud_sub id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qcloud_sub ALTER COLUMN id SET DEFAULT nextval('public.qcloud_sub_id_seq'::regclass);


--
-- TOC entry 3994 (class 2604 OID 18190)
-- Name: qcloud_sub_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qcloud_sub_history ALTER COLUMN id SET DEFAULT nextval('public.qcloud_sub_history_id_seq'::regclass);


--
-- TOC entry 3995 (class 2604 OID 18191)
-- Name: qtalk_user_comment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qtalk_user_comment ALTER COLUMN id SET DEFAULT nextval('public.qtalk_user_comment_id_seq'::regclass);


--
-- TOC entry 3999 (class 2604 OID 18192)
-- Name: revoke_msg_history id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.revoke_msg_history ALTER COLUMN id SET DEFAULT nextval('public.revoke_msg_history_id_seq'::regclass);


--
-- TOC entry 4032 (class 2604 OID 18193)
-- Name: scheduling_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduling_info ALTER COLUMN id SET DEFAULT nextval('public.scheduling_info_id_seq'::regclass);


--
-- TOC entry 4034 (class 2604 OID 18194)
-- Name: sms_log_info id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.sms_log_info ALTER COLUMN id SET DEFAULT nextval('public.sms_log_info_id_seq'::regclass);


--
-- TOC entry 4036 (class 2604 OID 18195)
-- Name: sms_request_info id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.sms_request_info ALTER COLUMN id SET DEFAULT nextval('public.sms_request_info_id_seq'::regclass);


--
-- TOC entry 4043 (class 2604 OID 18196)
-- Name: spool seq; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.spool ALTER COLUMN seq SET DEFAULT nextval('public.spool_seq_seq'::regclass);


--
-- TOC entry 4020 (class 2604 OID 18197)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4065 (class 2604 OID 18198)
-- Name: vcard_version id; Type: DEFAULT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.vcard_version ALTER COLUMN id SET DEFAULT nextval('public.vcard_version_id_seq'::regclass);


--
-- TOC entry 4074 (class 2604 OID 18199)
-- Name: warn_msg_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warn_msg_history ALTER COLUMN id SET DEFAULT nextval('public.warn_msg_history_id_seq'::regclass);


--
-- TOC entry 4084 (class 2606 OID 18201)
-- Name: admin_user admin_user_pk; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.admin_user
    ADD CONSTRAINT admin_user_pk PRIMARY KEY (username);


--
-- TOC entry 4272 (class 2606 OID 18203)
-- Name: muc_room_users_backup along_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_room_users_backup
    ADD CONSTRAINT along_tmp_pkey PRIMARY KEY (id);


--
-- TOC entry 4086 (class 2606 OID 18205)
-- Name: android_send_stat android_send_stat_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.android_send_stat
    ADD CONSTRAINT android_send_stat_pkey PRIMARY KEY (id);


--
-- TOC entry 4092 (class 2606 OID 18207)
-- Name: client_config_sync client_config_sync_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_config_sync
    ADD CONSTRAINT client_config_sync_pkey PRIMARY KEY (id);


--
-- TOC entry 4105 (class 2606 OID 18209)
-- Name: day_online_time day_online_time_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.day_online_time
    ADD CONSTRAINT day_online_time_pkey PRIMARY KEY (username, date_time);


--
-- TOC entry 4112 (class 2606 OID 18211)
-- Name: destroy_muc_info destroy_muc_info_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.destroy_muc_info
    ADD CONSTRAINT destroy_muc_info_pkey PRIMARY KEY (id);


--
-- TOC entry 4128 (class 2606 OID 18223)
-- Name: fresh_empl_entering fresh_empl_entering_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fresh_empl_entering
    ADD CONSTRAINT fresh_empl_entering_pkey PRIMARY KEY (id);


--
-- TOC entry 4132 (class 2606 OID 18225)
-- Name: group_extent group_extent_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.group_extent
    ADD CONSTRAINT group_extent_pkey PRIMARY KEY (id);


--
-- TOC entry 4134 (class 2606 OID 18227)
-- Name: host_info host_info_host_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.host_info
    ADD CONSTRAINT host_info_host_key UNIQUE (host);


--
-- TOC entry 4136 (class 2606 OID 18229)
-- Name: host_info host_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.host_info
    ADD CONSTRAINT host_info_pkey PRIMARY KEY (id);


--
-- TOC entry 4140 (class 2606 OID 18231)
-- Name: host_users host_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.host_users
    ADD CONSTRAINT host_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4150 (class 2606 OID 18233)
-- Name: host_users_test host_users_test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.host_users_test
    ADD CONSTRAINT host_users_test_pkey PRIMARY KEY (id);


--
-- TOC entry 4152 (class 2606 OID 18235)
-- Name: host_users_test host_users_test_user_id_host_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.host_users_test
    ADD CONSTRAINT host_users_test_user_id_host_id_key UNIQUE (user_id, host_id);


--
-- TOC entry 4142 (class 2606 OID 18237)
-- Name: host_users host_users_user_id_host_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.host_users
    ADD CONSTRAINT host_users_user_id_host_id_key UNIQUE (user_id, host_id);


--
-- TOC entry 4162 (class 2606 OID 18239)
-- Name: last last_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.last
    ADD CONSTRAINT last_pkey PRIMARY KEY (username);


--
-- TOC entry 4164 (class 2606 OID 18241)
-- Name: mac_push_notice mac_user_notice_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.mac_push_notice
    ADD CONSTRAINT mac_user_notice_pkey PRIMARY KEY (user_name, shield_user);


--
-- TOC entry 4185 (class 2606 OID 18243)
-- Name: meeting_info meeting_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting_info
    ADD CONSTRAINT meeting_info_pkey PRIMARY KEY (id);


--
-- TOC entry 4187 (class 2606 OID 18245)
-- Name: mission_list mission_list_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.mission_list
    ADD CONSTRAINT mission_list_pkey PRIMARY KEY (id);


--
-- TOC entry 4191 (class 2606 OID 18247)
-- Name: mission_milestone mission_milestone_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.mission_milestone
    ADD CONSTRAINT mission_milestone_pkey PRIMARY KEY (id);


--
-- TOC entry 4193 (class 2606 OID 18249)
-- Name: motd motd_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.motd
    ADD CONSTRAINT motd_pkey PRIMARY KEY (username);


--
-- TOC entry 4222 (class 2606 OID 18251)
-- Name: msg_history_backup msg_history_backup_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_history_backup
    ADD CONSTRAINT msg_history_backup_tmp_pkey PRIMARY KEY (id);


--
-- TOC entry 4224 (class 2606 OID 18253)
-- Name: msg_stat msg_stat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_stat
    ADD CONSTRAINT msg_stat_pkey PRIMARY KEY (id);


--
-- TOC entry 4230 (class 2606 OID 18255)
-- Name: muc_last muc_last_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_last
    ADD CONSTRAINT muc_last_pkey PRIMARY KEY (muc_name);


--
-- TOC entry 4250 (class 2606 OID 18257)
-- Name: muc_room_history_backup muc_room_history_2016_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muc_room_history_backup
    ADD CONSTRAINT muc_room_history_2016_pkey PRIMARY KEY (id);


--
-- TOC entry 4247 (class 2606 OID 18259)
-- Name: muc_room_history muc_room_history_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_room_history
    ADD CONSTRAINT muc_room_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4260 (class 2606 OID 18261)
-- Name: muc_room_users muc_room_users_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_room_users
    ADD CONSTRAINT muc_room_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4279 (class 2606 OID 18263)
-- Name: muc_spool muc_spool_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_spool
    ADD CONSTRAINT muc_spool_pkey PRIMARY KEY (seq);


--
-- TOC entry 4284 (class 2606 OID 18265)
-- Name: muc_user_mark muc_user_mark_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_user_mark
    ADD CONSTRAINT muc_user_mark_pkey PRIMARY KEY (id);


--
-- TOC entry 4289 (class 2606 OID 18267)
-- Name: muc_vcard_info_backup muc_vcard_info_backup_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_vcard_info_backup
    ADD CONSTRAINT muc_vcard_info_backup_pkey PRIMARY KEY (muc_name);


--
-- TOC entry 4287 (class 2606 OID 18269)
-- Name: muc_vcard_info muc_vcard_info_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_vcard_info
    ADD CONSTRAINT muc_vcard_info_pkey PRIMARY KEY (muc_name);


--
-- TOC entry 4291 (class 2606 OID 18271)
-- Name: muc_white_list muc_white_list_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.muc_white_list
    ADD CONSTRAINT muc_white_list_pkey PRIMARY KEY (muc_name);


--
-- TOC entry 4323 (class 2606 OID 18273)
-- Name: person_extent_backup_2018_01_28 new_person_extent_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.person_extent_backup_2018_01_28
    ADD CONSTRAINT new_person_extent_pkey PRIMARY KEY (id);


--
-- TOC entry 4293 (class 2606 OID 18275)
-- Name: non_human non_humam_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.non_human
    ADD CONSTRAINT non_humam_pkey PRIMARY KEY (id);


--
-- TOC entry 4300 (class 2606 OID 18277)
-- Name: notice_history notice_history_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.notice_history
    ADD CONSTRAINT notice_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4308 (class 2606 OID 18279)
-- Name: person_extent_2017_09_22 person_extent_2017_09_22_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_extent_2017_09_22
    ADD CONSTRAINT person_extent_2017_09_22_pkey PRIMARY KEY (id);


--
-- TOC entry 4313 (class 2606 OID 18281)
-- Name: person_extent_2018_05_02 person_extent_2018_05_02_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.person_extent_2018_05_02
    ADD CONSTRAINT person_extent_2018_05_02_pkey PRIMARY KEY (id);


--
-- TOC entry 4318 (class 2606 OID 18283)
-- Name: person_extent_2018_07_12 person_extent_2018_07_12_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_extent_2018_07_12
    ADD CONSTRAINT person_extent_2018_07_12_pkey PRIMARY KEY (id);


--
-- TOC entry 4305 (class 2606 OID 18285)
-- Name: person_extent person_extent_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.person_extent
    ADD CONSTRAINT person_extent_pkey PRIMARY KEY (id);


--
-- TOC entry 4325 (class 2606 OID 18287)
-- Name: person_user_mac_key person_user_mac_key_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.person_user_mac_key
    ADD CONSTRAINT person_user_mac_key_pkey PRIMARY KEY (user_name, host, os);


--
-- TOC entry 4114 (class 2606 OID 18289)
-- Name: domain_mapped_url pk_domain_mapped_url; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.domain_mapped_url
    ADD CONSTRAINT pk_domain_mapped_url PRIMARY KEY (domain, url);


--
-- TOC entry 4116 (class 2606 OID 18291)
-- Name: flogin_user pk_flogin_user; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.flogin_user
    ADD CONSTRAINT pk_flogin_user PRIMARY KEY (username);


--
-- TOC entry 4159 (class 2606 OID 18293)
-- Name: iplimit pk_iplimit; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.iplimit
    ADD CONSTRAINT pk_iplimit PRIMARY KEY (ip, name, priority);


--
-- TOC entry 4436 (class 2606 OID 18295)
-- Name: user_friends pk_user_friends; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.user_friends
    ADD CONSTRAINT pk_user_friends PRIMARY KEY (username, friend, host);


--
-- TOC entry 4484 (class 2606 OID 18297)
-- Name: virtual_user_list pk_virtual_user_list; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.virtual_user_list
    ADD CONSTRAINT pk_virtual_user_list PRIMARY KEY (real_user, virtual_user);


--
-- TOC entry 4181 (class 2606 OID 18299)
-- Name: mask_users pkmask_users_v2; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.mask_users
    ADD CONSTRAINT pkmask_users_v2 PRIMARY KEY (user_name, masked_user);


--
-- TOC entry 4329 (class 2606 OID 18301)
-- Name: privacy_default_list privacy_default_list_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.privacy_default_list
    ADD CONSTRAINT privacy_default_list_pkey PRIMARY KEY (username);


--
-- TOC entry 4333 (class 2606 OID 18303)
-- Name: privacy_list privacy_list_id_key; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.privacy_list
    ADD CONSTRAINT privacy_list_id_key UNIQUE (id);


--
-- TOC entry 4341 (class 2606 OID 18305)
-- Name: pubsub_node pubsub_node_nodeid_key; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.pubsub_node
    ADD CONSTRAINT pubsub_node_nodeid_key UNIQUE (nodeid);


--
-- TOC entry 4347 (class 2606 OID 18307)
-- Name: pubsub_state pubsub_state_stateid_key; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.pubsub_state
    ADD CONSTRAINT pubsub_state_stateid_key UNIQUE (stateid);


--
-- TOC entry 4350 (class 2606 OID 18309)
-- Name: push_info push_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.push_info
    ADD CONSTRAINT push_info_pkey PRIMARY KEY (id);


--
-- TOC entry 4360 (class 2606 OID 18311)
-- Name: qcloud_main_history qcloud_main_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qcloud_main_history
    ADD CONSTRAINT qcloud_main_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4358 (class 2606 OID 18313)
-- Name: qcloud_main qcloud_main_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qcloud_main
    ADD CONSTRAINT qcloud_main_pkey PRIMARY KEY (id);


--
-- TOC entry 4368 (class 2606 OID 18315)
-- Name: qcloud_sub_history qcloud_sub_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qcloud_sub_history
    ADD CONSTRAINT qcloud_sub_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4365 (class 2606 OID 18317)
-- Name: qcloud_sub qcloud_sub_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qcloud_sub
    ADD CONSTRAINT qcloud_sub_pkey PRIMARY KEY (id);


--
-- TOC entry 4372 (class 2606 OID 18319)
-- Name: qtalk_user_comment qtalk_user_comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qtalk_user_comment
    ADD CONSTRAINT qtalk_user_comment_pkey PRIMARY KEY (id);


--
-- TOC entry 4376 (class 2606 OID 18321)
-- Name: recv_msg_option recv_msg_option_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.recv_msg_option
    ADD CONSTRAINT recv_msg_option_pkey PRIMARY KEY (username);


--
-- TOC entry 4383 (class 2606 OID 18323)
-- Name: revoke_msg_history_backup revoke_msg_history_backup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revoke_msg_history_backup
    ADD CONSTRAINT revoke_msg_history_backup_pkey PRIMARY KEY (id);


--
-- TOC entry 4380 (class 2606 OID 18325)
-- Name: revoke_msg_history revoke_msg_history_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.revoke_msg_history
    ADD CONSTRAINT revoke_msg_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4386 (class 2606 OID 18327)
-- Name: robot_info robot_info_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.robot_info
    ADD CONSTRAINT robot_info_pkey PRIMARY KEY (en_name);


--
-- TOC entry 4390 (class 2606 OID 18329)
-- Name: robot_pubsub_backup robot_pubsub_backup_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.robot_pubsub_backup
    ADD CONSTRAINT robot_pubsub_backup_pkey PRIMARY KEY (rbt_name, user_name);


--
-- TOC entry 4388 (class 2606 OID 18331)
-- Name: robot_pubsub robot_pubsub_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.robot_pubsub
    ADD CONSTRAINT robot_pubsub_pkey PRIMARY KEY (rbt_name, user_name);


--
-- TOC entry 4392 (class 2606 OID 18333)
-- Name: robot_pubsub_test robot_pubsub_test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.robot_pubsub_test
    ADD CONSTRAINT robot_pubsub_test_pkey PRIMARY KEY (rbt_name, user_name);


--
-- TOC entry 4399 (class 2606 OID 18335)
-- Name: roster_version roster_version_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.roster_version
    ADD CONSTRAINT roster_version_pkey PRIMARY KEY (username);


--
-- TOC entry 4405 (class 2606 OID 18337)
-- Name: s2s_mapped_host s2s_mapped_host_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.s2s_mapped_host
    ADD CONSTRAINT s2s_mapped_host_pkey PRIMARY KEY (domain, host);


--
-- TOC entry 4411 (class 2606 OID 18339)
-- Name: scheduling_info scheduling_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduling_info
    ADD CONSTRAINT scheduling_info_pkey PRIMARY KEY (id);


--
-- TOC entry 4416 (class 2606 OID 18341)
-- Name: sms_log_info sms_log_info_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.sms_log_info
    ADD CONSTRAINT sms_log_info_pkey PRIMARY KEY (id);


--
-- TOC entry 4418 (class 2606 OID 18343)
-- Name: sms_request_info sms_request_info_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.sms_request_info
    ADD CONSTRAINT sms_request_info_pkey PRIMARY KEY (id);


--
-- TOC entry 4420 (class 2606 OID 18345)
-- Name: sms_user_info sms_user_info_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.sms_user_info
    ADD CONSTRAINT sms_user_info_pkey PRIMARY KEY (user_name);


--
-- TOC entry 4426 (class 2606 OID 18347)
-- Name: spool spool_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.spool
    ADD CONSTRAINT spool_pkey PRIMARY KEY (seq);


--
-- TOC entry 4434 (class 2606 OID 18349)
-- Name: user_block_list user_block_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.user_block_list
    ADD CONSTRAINT user_block_pkey PRIMARY KEY (username, blockuser);


--
-- TOC entry 4440 (class 2606 OID 18351)
-- Name: user_mac_key user_mac_key_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.user_mac_key
    ADD CONSTRAINT user_mac_key_pkey PRIMARY KEY (user_name, host, os);


--
-- TOC entry 4453 (class 2606 OID 18353)
-- Name: user_register_mucs_backup user_register_mucs_backup_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.user_register_mucs_backup
    ADD CONSTRAINT user_register_mucs_backup_pkey PRIMARY KEY (muc_name, username);


--
-- TOC entry 4444 (class 2606 OID 18355)
-- Name: user_register_mucs user_register_mucs_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.user_register_mucs
    ADD CONSTRAINT user_register_mucs_pkey PRIMARY KEY (muc_name, username);


--
-- TOC entry 4459 (class 2606 OID 18357)
-- Name: user_relation_opts user_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.user_relation_opts
    ADD CONSTRAINT user_relation_pkey PRIMARY KEY (username);


--
-- TOC entry 4396 (class 2606 OID 18359)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4461 (class 2606 OID 18361)
-- Name: vcard vcard_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.vcard
    ADD CONSTRAINT vcard_pkey PRIMARY KEY (username);


--
-- TOC entry 4474 (class 2606 OID 18363)
-- Name: vcard_search vcard_search_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.vcard_search
    ADD CONSTRAINT vcard_search_pkey PRIMARY KEY (lusername);


--
-- TOC entry 4476 (class 2606 OID 18365)
-- Name: vcard_version vcard_version_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.vcard_version
    ADD CONSTRAINT vcard_version_pkey PRIMARY KEY (id);


--
-- TOC entry 4479 (class 2606 OID 18367)
-- Name: vcard_version_test vcard_version_test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vcard_version_test
    ADD CONSTRAINT vcard_version_test_pkey PRIMARY KEY (id);


--
-- TOC entry 4482 (class 2606 OID 18369)
-- Name: vcard_xupdate vcard_xupdate_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.vcard_xupdate
    ADD CONSTRAINT vcard_xupdate_pkey PRIMARY KEY (username);


--
-- TOC entry 4505 (class 2606 OID 18371)
-- Name: warn_msg_history_backup warn_msg_history_backup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warn_msg_history_backup
    ADD CONSTRAINT warn_msg_history_backup_pkey PRIMARY KEY (id);


--
-- TOC entry 4494 (class 2606 OID 18373)
-- Name: warn_msg_history warn_msg_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warn_msg_history
    ADD CONSTRAINT warn_msg_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4507 (class 2606 OID 18375)
-- Name: white_list white_list_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.white_list
    ADD CONSTRAINT white_list_pkey PRIMARY KEY (username);


--
-- TOC entry 4509 (class 2606 OID 18377)
-- Name: white_list_test white_list_test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.white_list_test
    ADD CONSTRAINT white_list_test_pkey PRIMARY KEY (username);


--
-- TOC entry 4512 (class 2606 OID 18379)
-- Name: win_dump_url win_dump_url_pkey; Type: CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.win_dump_url
    ADD CONSTRAINT win_dump_url_pkey PRIMARY KEY (user_name, dump_url);


--
-- TOC entry 4269 (class 1259 OID 18380)
-- Name: along_tmp_muc_name_username_date_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX along_tmp_muc_name_username_date_idx ON public.muc_room_users_backup USING btree (muc_name, username, date);


--
-- TOC entry 4270 (class 1259 OID 18381)
-- Name: along_tmp_muc_name_username_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX along_tmp_muc_name_username_idx ON public.muc_room_users_backup USING btree (muc_name, username);


--
-- TOC entry 4273 (class 1259 OID 18382)
-- Name: along_tmp_username_date_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX along_tmp_username_date_idx ON public.muc_room_users_backup USING btree (username, date);


--
-- TOC entry 4274 (class 1259 OID 18383)
-- Name: along_tmp_username_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX along_tmp_username_idx ON public.muc_room_users_backup USING btree (username);


--
-- TOC entry 4087 (class 1259 OID 18384)
-- Name: android_send_stat_uuid_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX android_send_stat_uuid_idx ON public.android_send_stat USING btree (uuid);


--
-- TOC entry 4088 (class 1259 OID 18385)
-- Name: client_config_sync_configkey__idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_configkey__idx ON public.client_config_sync USING btree (configkey);


--
-- TOC entry 4089 (class 1259 OID 18386)
-- Name: client_config_sync_host__idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_host__idx ON public.client_config_sync USING btree (host);


--
-- TOC entry 4090 (class 1259 OID 18387)
-- Name: client_config_sync_operate_plat__idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_operate_plat__idx ON public.client_config_sync USING btree (operate_plat);


--
-- TOC entry 4093 (class 1259 OID 18388)
-- Name: client_config_sync_update_time__idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_update_time__idx ON public.client_config_sync USING btree (update_time);


--
-- TOC entry 4094 (class 1259 OID 18389)
-- Name: client_config_sync_username__idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_username__idx ON public.client_config_sync USING btree (username);


--
-- TOC entry 4095 (class 1259 OID 18390)
-- Name: client_config_sync_username_host_configkey_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_username_host_configkey_idx ON public.client_config_sync USING btree (username, host, configkey);


--
-- TOC entry 4096 (class 1259 OID 18391)
-- Name: client_config_sync_username_host_configkey_subkey_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX client_config_sync_username_host_configkey_subkey_idx ON public.client_config_sync USING btree (username, host, configkey, subkey);


--
-- TOC entry 4097 (class 1259 OID 18392)
-- Name: client_config_sync_username_host_configkey_subkey_version_i_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_username_host_configkey_subkey_version_i_idx ON public.client_config_sync USING btree (username, host, configkey, subkey, version, isdel);


--
-- TOC entry 4098 (class 1259 OID 18393)
-- Name: client_config_sync_username_host_configkey_subkey_version_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_username_host_configkey_subkey_version_idx ON public.client_config_sync USING btree (username, host, configkey, subkey, version);


--
-- TOC entry 4099 (class 1259 OID 18394)
-- Name: client_config_sync_username_host_configkey_subkey_version_isdel; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_username_host_configkey_subkey_version_isdel ON public.client_config_sync USING btree (username, host, configkey, subkey, version, isdel);


--
-- TOC entry 4100 (class 1259 OID 18395)
-- Name: client_config_sync_username_host_configkey_version_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_username_host_configkey_version_idx ON public.client_config_sync USING btree (username, host, configkey, version);


--
-- TOC entry 4101 (class 1259 OID 18396)
-- Name: client_config_sync_username_host_configkey_version_isdel_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_username_host_configkey_version_isdel_idx ON public.client_config_sync USING btree (username, host, configkey, version, isdel);


--
-- TOC entry 4102 (class 1259 OID 18397)
-- Name: client_config_sync_username_host_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_username_host_idx ON public.client_config_sync USING btree (username, host);


--
-- TOC entry 4103 (class 1259 OID 18398)
-- Name: client_config_sync_version__idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_config_sync_version__idx ON public.client_config_sync USING btree (version);


--
-- TOC entry 4106 (class 1259 OID 18399)
-- Name: destroy_muc_info_created_at_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX destroy_muc_info_created_at_idx ON public.destroy_muc_info USING btree (created_at);


--
-- TOC entry 4107 (class 1259 OID 18400)
-- Name: destroy_muc_info_muc_index; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX destroy_muc_info_muc_index ON public.destroy_muc_info USING btree (muc_name);


--
-- TOC entry 4108 (class 1259 OID 18401)
-- Name: destroy_muc_info_muc_name_created_at_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX destroy_muc_info_muc_name_created_at_idx ON public.destroy_muc_info USING btree (muc_name, created_at);


--
-- TOC entry 4109 (class 1259 OID 18402)
-- Name: destroy_muc_info_nick_name_created_at_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX destroy_muc_info_nick_name_created_at_idx ON public.destroy_muc_info USING btree (nick_name, created_at);


--
-- TOC entry 4110 (class 1259 OID 18403)
-- Name: destroy_muc_info_nick_name_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX destroy_muc_info_nick_name_idx ON public.destroy_muc_info USING btree (nick_name);


--
-- TOC entry 4129 (class 1259 OID 18404)
-- Name: fresh_empl_entering_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX fresh_empl_entering_user_id_idx ON public.fresh_empl_entering USING btree (user_id);


--
-- TOC entry 4130 (class 1259 OID 18405)
-- Name: group_extent_key_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX group_extent_key_idx ON public.group_extent USING btree (group_id, key);


--
-- TOC entry 4137 (class 1259 OID 18406)
-- Name: host_users_hire_flag_user_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_hire_flag_user_name_idx ON public.host_users USING btree (hire_flag, user_name);


--
-- TOC entry 4138 (class 1259 OID 18407)
-- Name: host_users_host_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_host_id_idx ON public.host_users USING btree (host_id);


--
-- TOC entry 4147 (class 1259 OID 18408)
-- Name: host_users_test_hire_flag_user_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_test_hire_flag_user_name_idx ON public.host_users_test USING btree (hire_flag, user_name);


--
-- TOC entry 4148 (class 1259 OID 18409)
-- Name: host_users_test_host_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_test_host_id_idx ON public.host_users_test USING btree (host_id);


--
-- TOC entry 4153 (class 1259 OID 18410)
-- Name: host_users_test_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_test_user_id_idx ON public.host_users_test USING btree (user_id);


--
-- TOC entry 4154 (class 1259 OID 18411)
-- Name: host_users_test_user_id_user_name_pinyin_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_test_user_id_user_name_pinyin_idx ON public.host_users_test USING gin (user_id public.gin_trgm_ops, user_name public.gin_trgm_ops, pinyin public.gin_trgm_ops) WHERE (hire_flag = 1);


--
-- TOC entry 4155 (class 1259 OID 18412)
-- Name: host_users_test_user_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_test_user_name_idx ON public.host_users_test USING btree (user_name);


--
-- TOC entry 4156 (class 1259 OID 18413)
-- Name: host_users_test_version_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_test_version_idx ON public.host_users_test USING btree (version);


--
-- TOC entry 4143 (class 1259 OID 18414)
-- Name: host_users_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_user_id_idx ON public.host_users USING btree (user_id);


--
-- TOC entry 4144 (class 1259 OID 18415)
-- Name: host_users_user_id_user_name_pinyin_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_user_id_user_name_pinyin_idx ON public.host_users USING gin (user_id public.gin_trgm_ops, user_name public.gin_trgm_ops, pinyin public.gin_trgm_ops) WHERE (hire_flag = 1);


--
-- TOC entry 4145 (class 1259 OID 18416)
-- Name: host_users_user_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_user_name_idx ON public.host_users USING btree (user_name);


--
-- TOC entry 4146 (class 1259 OID 18417)
-- Name: host_users_version_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX host_users_version_idx ON public.host_users USING btree (version);


--
-- TOC entry 4421 (class 1259 OID 18418)
-- Name: i_despool; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_despool ON public.spool USING btree (username);


--
-- TOC entry 4160 (class 1259 OID 18419)
-- Name: i_irc_custom_jid_host; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_irc_custom_jid_host ON public.irc_custom USING btree (jid, host);


--
-- TOC entry 4231 (class 1259 OID 18420)
-- Name: i_muc_registered_jid_host; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_muc_registered_jid_host ON public.muc_registered USING btree (jid, host);


--
-- TOC entry 4232 (class 1259 OID 18421)
-- Name: i_muc_registered_nick; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_muc_registered_nick ON public.muc_registered USING btree (nick);


--
-- TOC entry 4238 (class 1259 OID 18422)
-- Name: i_muc_room_history_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_muc_room_history_host_idx ON public.muc_room_history USING btree (host);


--
-- TOC entry 4233 (class 1259 OID 18423)
-- Name: i_muc_room_name_host; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_muc_room_name_host ON public.muc_room USING btree (name, host);


--
-- TOC entry 4330 (class 1259 OID 18424)
-- Name: i_privacy_list_username; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_privacy_list_username ON public.privacy_list USING btree (username);


--
-- TOC entry 4331 (class 1259 OID 18425)
-- Name: i_privacy_list_username_name; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_privacy_list_username_name ON public.privacy_list USING btree (username, name);


--
-- TOC entry 4334 (class 1259 OID 18426)
-- Name: i_private_storage_username; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_private_storage_username ON public.private_storage USING btree (username);


--
-- TOC entry 4335 (class 1259 OID 18427)
-- Name: i_private_storage_username_namespace; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_private_storage_username_namespace ON public.private_storage USING btree (username, namespace);


--
-- TOC entry 4336 (class 1259 OID 18428)
-- Name: i_pubsub_item_itemid; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_pubsub_item_itemid ON public.pubsub_item USING btree (itemid);


--
-- TOC entry 4337 (class 1259 OID 18429)
-- Name: i_pubsub_item_tuple; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_pubsub_item_tuple ON public.pubsub_item USING btree (nodeid, itemid);


--
-- TOC entry 4342 (class 1259 OID 18430)
-- Name: i_pubsub_node_option_nodeid; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_pubsub_node_option_nodeid ON public.pubsub_node_option USING btree (nodeid);


--
-- TOC entry 4343 (class 1259 OID 18431)
-- Name: i_pubsub_node_owner_nodeid; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_pubsub_node_owner_nodeid ON public.pubsub_node_owner USING btree (nodeid);


--
-- TOC entry 4338 (class 1259 OID 18432)
-- Name: i_pubsub_node_parent; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_pubsub_node_parent ON public.pubsub_node USING btree (parent);


--
-- TOC entry 4339 (class 1259 OID 18433)
-- Name: i_pubsub_node_tuple; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_pubsub_node_tuple ON public.pubsub_node USING btree (host, node);


--
-- TOC entry 4344 (class 1259 OID 18434)
-- Name: i_pubsub_state_jid; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_pubsub_state_jid ON public.pubsub_state USING btree (jid);


--
-- TOC entry 4345 (class 1259 OID 18435)
-- Name: i_pubsub_state_tuple; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_pubsub_state_tuple ON public.pubsub_state USING btree (nodeid, jid);


--
-- TOC entry 4348 (class 1259 OID 18436)
-- Name: i_pubsub_subscription_opt; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_pubsub_subscription_opt ON public.pubsub_subscription_opt USING btree (subid, opt_name);


--
-- TOC entry 4401 (class 1259 OID 18437)
-- Name: i_rosteru_jid; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_rosteru_jid ON public.rosterusers USING btree (jid);


--
-- TOC entry 4402 (class 1259 OID 18438)
-- Name: i_rosteru_user_jid; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_rosteru_user_jid ON public.rosterusers USING btree (username, jid);


--
-- TOC entry 4403 (class 1259 OID 18439)
-- Name: i_rosteru_username; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_rosteru_username ON public.rosterusers USING btree (username);


--
-- TOC entry 4428 (class 1259 OID 18440)
-- Name: i_sr_user_grp; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_sr_user_grp ON public.sr_user USING btree (grp);


--
-- TOC entry 4429 (class 1259 OID 18441)
-- Name: i_sr_user_jid; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_sr_user_jid ON public.sr_user USING btree (jid);


--
-- TOC entry 4430 (class 1259 OID 18442)
-- Name: i_sr_user_jid_grp; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX i_sr_user_jid_grp ON public.sr_user USING btree (jid, grp);


--
-- TOC entry 4441 (class 1259 OID 18443)
-- Name: i_user_register_mucs_user_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_user_register_mucs_user_idx ON public.user_register_mucs USING btree (username);


--
-- TOC entry 4462 (class 1259 OID 18444)
-- Name: i_vcard_search_lbday; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_lbday ON public.vcard_search USING btree (lbday);


--
-- TOC entry 4463 (class 1259 OID 18445)
-- Name: i_vcard_search_lctry; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_lctry ON public.vcard_search USING btree (lctry);


--
-- TOC entry 4464 (class 1259 OID 18446)
-- Name: i_vcard_search_lemail; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_lemail ON public.vcard_search USING btree (lemail);


--
-- TOC entry 4465 (class 1259 OID 18447)
-- Name: i_vcard_search_lfamily; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_lfamily ON public.vcard_search USING btree (lfamily);


--
-- TOC entry 4466 (class 1259 OID 18448)
-- Name: i_vcard_search_lfn; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_lfn ON public.vcard_search USING btree (lfn);


--
-- TOC entry 4467 (class 1259 OID 18449)
-- Name: i_vcard_search_lgiven; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_lgiven ON public.vcard_search USING btree (lgiven);


--
-- TOC entry 4468 (class 1259 OID 18450)
-- Name: i_vcard_search_llocality; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_llocality ON public.vcard_search USING btree (llocality);


--
-- TOC entry 4469 (class 1259 OID 18451)
-- Name: i_vcard_search_lmiddle; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_lmiddle ON public.vcard_search USING btree (lmiddle);


--
-- TOC entry 4470 (class 1259 OID 18452)
-- Name: i_vcard_search_lnickname; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_lnickname ON public.vcard_search USING btree (lnickname);


--
-- TOC entry 4471 (class 1259 OID 18453)
-- Name: i_vcard_search_lorgname; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_lorgname ON public.vcard_search USING btree (lorgname);


--
-- TOC entry 4472 (class 1259 OID 18454)
-- Name: i_vcard_search_lorgunit; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX i_vcard_search_lorgunit ON public.vcard_search USING btree (lorgunit);


--
-- TOC entry 4354 (class 1259 OID 18455)
-- Name: index_cloud_id_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_cloud_id_user ON public.qcloud_main USING btree (q_user, id);


--
-- TOC entry 4362 (class 1259 OID 18456)
-- Name: index_cloud_sub_user_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_cloud_sub_user_time ON public.qcloud_sub USING btree (q_id, qs_time);


--
-- TOC entry 4363 (class 1259 OID 18457)
-- Name: index_cloud_sub_user_time_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_cloud_sub_user_time_type ON public.qcloud_sub USING btree (q_id, qs_time, qs_type);


--
-- TOC entry 4355 (class 1259 OID 18458)
-- Name: index_cloud_user_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_cloud_user_time ON public.qcloud_main USING btree (q_user, q_time);


--
-- TOC entry 4356 (class 1259 OID 18459)
-- Name: index_cloud_user_time_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_cloud_user_time_type ON public.qcloud_main USING btree (q_user, q_time, q_type);


--
-- TOC entry 4157 (class 1259 OID 18460)
-- Name: invite_spool_username_inviter_host_ihost_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX invite_spool_username_inviter_host_ihost_idx ON public.invite_spool USING btree (username, inviter, host, ihost);


--
-- TOC entry 4189 (class 1259 OID 18461)
-- Name: ix_mission_member_list; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX ix_mission_member_list ON public.mission_member USING btree (id, publisher);


--
-- TOC entry 4431 (class 1259 OID 18462)
-- Name: ix_user_name; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX ix_user_name ON public.test_user USING btree (name);


--
-- TOC entry 4165 (class 1259 OID 18463)
-- Name: mask_history_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_create_time_idx ON public.mask_history USING btree (create_time);


--
-- TOC entry 4166 (class 1259 OID 18464)
-- Name: mask_history_create_time_m_from_m_to_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_create_time_m_from_m_to_idx ON public.mask_history USING btree (create_time, m_from, m_to);


--
-- TOC entry 4167 (class 1259 OID 18465)
-- Name: mask_history_from_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_from_host_idx ON public.mask_history USING btree (from_host);


--
-- TOC entry 4168 (class 1259 OID 18466)
-- Name: mask_history_id_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX mask_history_id_idx ON public.mask_history USING btree (id);


--
-- TOC entry 4169 (class 1259 OID 18467)
-- Name: mask_history_m_from_from_host_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_m_from_from_host_create_time_idx ON public.mask_history USING btree (m_from, from_host, create_time);


--
-- TOC entry 4170 (class 1259 OID 18468)
-- Name: mask_history_m_from_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_m_from_idx ON public.mask_history USING btree (m_from);


--
-- TOC entry 4171 (class 1259 OID 18469)
-- Name: mask_history_m_from_m_to_create_time_id_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX mask_history_m_from_m_to_create_time_id_idx ON public.mask_history USING btree (m_from, m_to, create_time, id);


--
-- TOC entry 4172 (class 1259 OID 18470)
-- Name: mask_history_m_from_m_to_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_m_from_m_to_create_time_idx ON public.mask_history USING btree (m_from, m_to, create_time);


--
-- TOC entry 4173 (class 1259 OID 18471)
-- Name: mask_history_m_from_m_to_from_host_to_host_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_m_from_m_to_from_host_to_host_create_time_idx ON public.mask_history USING btree (m_from, m_to, from_host, to_host, create_time);


--
-- TOC entry 4174 (class 1259 OID 18472)
-- Name: mask_history_m_from_m_to_id_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX mask_history_m_from_m_to_id_create_time_idx ON public.mask_history USING btree (m_from, m_to, id, create_time);


--
-- TOC entry 4175 (class 1259 OID 18473)
-- Name: mask_history_m_from_m_to_id_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX mask_history_m_from_m_to_id_idx ON public.mask_history USING btree (m_from, m_to, id);


--
-- TOC entry 4176 (class 1259 OID 18474)
-- Name: mask_history_m_to_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_m_to_idx ON public.mask_history USING btree (m_to);


--
-- TOC entry 4177 (class 1259 OID 18475)
-- Name: mask_history_m_to_to_host_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_m_to_to_host_create_time_idx ON public.mask_history USING btree (m_to, to_host, create_time);


--
-- TOC entry 4178 (class 1259 OID 18476)
-- Name: mask_history_msg_id_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_msg_id_idx ON public.mask_history USING btree (msg_id);


--
-- TOC entry 4179 (class 1259 OID 18477)
-- Name: mask_history_read_flag_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mask_history_read_flag_idx ON public.mask_history USING btree (read_flag);


--
-- TOC entry 4182 (class 1259 OID 18478)
-- Name: meeting_info_meeting_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX meeting_info_meeting_id_idx ON public.meeting_info USING btree (meeting_id);


--
-- TOC entry 4183 (class 1259 OID 18479)
-- Name: meeting_info_meeting_id_inviter_member_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX meeting_info_meeting_id_inviter_member_idx ON public.meeting_info USING btree (meeting_id, inviter, member);


--
-- TOC entry 4188 (class 1259 OID 18480)
-- Name: mission_list_publisher; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX mission_list_publisher ON public.mission_list USING btree (publisher);


--
-- TOC entry 4210 (class 1259 OID 18481)
-- Name: msg_history_backup_msg_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX msg_history_backup_msg_id_idx ON public.msg_history_backup USING btree (msg_id) WHERE (create_time >= '2017-12-06 00:00:00+08'::timestamp with time zone);


--
-- TOC entry 4211 (class 1259 OID 18482)
-- Name: msg_history_backup_msg_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX msg_history_backup_msg_id_idx1 ON public.msg_history_backup USING btree (msg_id);


--
-- TOC entry 4212 (class 1259 OID 18483)
-- Name: msg_history_backup_realfrom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX msg_history_backup_realfrom_idx ON public.msg_history_backup USING btree (realfrom);


--
-- TOC entry 4213 (class 1259 OID 18484)
-- Name: msg_history_backup_realto_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX msg_history_backup_realto_idx ON public.msg_history_backup USING btree (realto);


--
-- TOC entry 4214 (class 1259 OID 18485)
-- Name: msg_history_backup_tmp_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX msg_history_backup_tmp_create_time_idx ON public.msg_history_backup USING btree (create_time);


--
-- TOC entry 4215 (class 1259 OID 18486)
-- Name: msg_history_backup_tmp_create_time_m_from_from_host_m_to_to_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX msg_history_backup_tmp_create_time_m_from_from_host_m_to_to_idx ON public.msg_history_backup USING btree (create_time, m_from, from_host, m_to, to_host);


--
-- TOC entry 4216 (class 1259 OID 18487)
-- Name: msg_history_backup_tmp_create_time_m_from_m_to_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX msg_history_backup_tmp_create_time_m_from_m_to_idx ON public.msg_history_backup USING btree (create_time, m_from, m_to);


--
-- TOC entry 4217 (class 1259 OID 18488)
-- Name: msg_history_backup_tmp_m_from_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX msg_history_backup_tmp_m_from_idx ON public.msg_history_backup USING btree (m_from);


--
-- TOC entry 4218 (class 1259 OID 18489)
-- Name: msg_history_backup_tmp_m_from_m_to_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX msg_history_backup_tmp_m_from_m_to_create_time_idx ON public.msg_history_backup USING btree (m_from, m_to, create_time);


--
-- TOC entry 4219 (class 1259 OID 18490)
-- Name: msg_history_backup_tmp_m_from_m_to_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX msg_history_backup_tmp_m_from_m_to_id_idx ON public.msg_history_backup USING btree (m_from, m_to, id);


--
-- TOC entry 4220 (class 1259 OID 18491)
-- Name: msg_history_backup_tmp_m_to_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX msg_history_backup_tmp_m_to_idx ON public.msg_history_backup USING btree (m_to);


--
-- TOC entry 4194 (class 1259 OID 18492)
-- Name: msg_history_create_time_idx1; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_create_time_idx1 ON public.msg_history USING btree (create_time);


--
-- TOC entry 4195 (class 1259 OID 18493)
-- Name: msg_history_create_time_m_from_m_to_idx1; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_create_time_m_from_m_to_idx1 ON public.msg_history USING btree (create_time, m_from, m_to);


--
-- TOC entry 4196 (class 1259 OID 18494)
-- Name: msg_history_from_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_from_host_idx ON public.msg_history USING btree (from_host);


--
-- TOC entry 4197 (class 1259 OID 18495)
-- Name: msg_history_id_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX msg_history_id_idx ON public.msg_history USING btree (id);


--
-- TOC entry 4198 (class 1259 OID 18496)
-- Name: msg_history_m_from_from_host_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_m_from_from_host_create_time_idx ON public.msg_history USING btree (m_from, from_host, create_time);


--
-- TOC entry 4199 (class 1259 OID 18497)
-- Name: msg_history_m_from_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_m_from_idx ON public.msg_history USING btree (m_from);


--
-- TOC entry 4200 (class 1259 OID 18498)
-- Name: msg_history_m_from_m_to_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_m_from_m_to_create_time_idx ON public.msg_history USING btree (m_from, m_to, create_time);


--
-- TOC entry 4201 (class 1259 OID 18499)
-- Name: msg_history_m_from_m_to_from_host_to_host_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_m_from_m_to_from_host_to_host_create_time_idx ON public.msg_history USING btree (m_from, m_to, from_host, to_host, create_time);


--
-- TOC entry 4202 (class 1259 OID 18500)
-- Name: msg_history_m_from_m_to_id_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX msg_history_m_from_m_to_id_create_time_idx ON public.msg_history USING btree (m_from, m_to, id, create_time);


--
-- TOC entry 4203 (class 1259 OID 18501)
-- Name: msg_history_m_from_m_to_id_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX msg_history_m_from_m_to_id_idx ON public.msg_history USING btree (m_from, m_to, id);


--
-- TOC entry 4204 (class 1259 OID 18502)
-- Name: msg_history_m_to_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_m_to_idx ON public.msg_history USING btree (m_to);


--
-- TOC entry 4205 (class 1259 OID 18503)
-- Name: msg_history_m_to_to_host_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_m_to_to_host_create_time_idx ON public.msg_history USING btree (m_to, to_host, create_time);


--
-- TOC entry 4206 (class 1259 OID 18504)
-- Name: msg_history_msg_id_idx3; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX msg_history_msg_id_idx3 ON public.msg_history USING btree (msg_id);


--
-- TOC entry 4207 (class 1259 OID 18505)
-- Name: msg_history_read_flag_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_read_flag_idx ON public.msg_history USING btree (read_flag);


--
-- TOC entry 4208 (class 1259 OID 18506)
-- Name: msg_history_realfrom_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_realfrom_idx ON public.msg_history USING btree (realfrom);


--
-- TOC entry 4209 (class 1259 OID 18507)
-- Name: msg_history_realto_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX msg_history_realto_idx ON public.msg_history USING btree (realto);


--
-- TOC entry 4225 (class 1259 OID 18508)
-- Name: msg_stat_reportdate_m_from_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX msg_stat_reportdate_m_from_idx ON public.msg_stat USING btree (reportdate, m_from);


--
-- TOC entry 4226 (class 1259 OID 18509)
-- Name: msg_stat_reportdate_m_from_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX msg_stat_reportdate_m_from_idx1 ON public.msg_stat USING btree (reportdate, m_from) WHERE (flag = 'p2p'::text);


--
-- TOC entry 4227 (class 1259 OID 18510)
-- Name: msg_stat_reportdate_nickname_flag_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX msg_stat_reportdate_nickname_flag_idx ON public.msg_stat USING btree (reportdate, nickname, flag);


--
-- TOC entry 4228 (class 1259 OID 18511)
-- Name: msg_stat_reportdate_nickname_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX msg_stat_reportdate_nickname_idx ON public.msg_stat USING btree (reportdate, nickname) WHERE (flag = 'muc'::text);


--
-- TOC entry 4236 (class 1259 OID 18512)
-- Name: muc_room_backup_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_backup_host_idx ON public.muc_room_backup USING btree (host);


--
-- TOC entry 4237 (class 1259 OID 18513)
-- Name: muc_room_backup_name_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX muc_room_backup_name_host_idx ON public.muc_room_backup USING btree (name, host);


--
-- TOC entry 4248 (class 1259 OID 18514)
-- Name: muc_room_history_2016_muc_room_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX muc_room_history_2016_muc_room_name_idx ON public.muc_room_history_backup USING btree (muc_room_name);


--
-- TOC entry 4251 (class 1259 OID 18515)
-- Name: muc_room_history_backup_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX muc_room_history_backup_create_time_idx ON public.muc_room_history_backup USING btree (create_time);


--
-- TOC entry 4252 (class 1259 OID 18516)
-- Name: muc_room_history_backup_create_time_muc_room_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX muc_room_history_backup_create_time_muc_room_name_idx ON public.muc_room_history_backup USING btree (create_time, muc_room_name);


--
-- TOC entry 4253 (class 1259 OID 18517)
-- Name: muc_room_history_backup_create_time_nick_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX muc_room_history_backup_create_time_nick_idx ON public.muc_room_history_backup USING btree (create_time, nick);


--
-- TOC entry 4254 (class 1259 OID 18518)
-- Name: muc_room_history_backup_msg_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX muc_room_history_backup_msg_id_idx ON public.muc_room_history_backup USING btree (msg_id) WHERE (create_time >= '2017-12-06 00:00:00+08'::timestamp with time zone);


--
-- TOC entry 4255 (class 1259 OID 18519)
-- Name: muc_room_history_backup_msg_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX muc_room_history_backup_msg_id_idx1 ON public.muc_room_history_backup USING btree (msg_id);


--
-- TOC entry 4239 (class 1259 OID 18520)
-- Name: muc_room_history_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_history_create_time_idx ON public.muc_room_history USING btree (create_time);


--
-- TOC entry 4240 (class 1259 OID 18521)
-- Name: muc_room_history_create_time_msg_id_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_history_create_time_msg_id_idx ON public.muc_room_history USING btree (create_time, msg_id);


--
-- TOC entry 4241 (class 1259 OID 18522)
-- Name: muc_room_history_create_time_nick_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_history_create_time_nick_idx ON public.muc_room_history USING btree (create_time, nick);


--
-- TOC entry 4242 (class 1259 OID 18523)
-- Name: muc_room_history_msg_id_idx2; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX muc_room_history_msg_id_idx2 ON public.muc_room_history USING btree (msg_id);


--
-- TOC entry 4243 (class 1259 OID 18524)
-- Name: muc_room_history_muc_room_name_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_history_muc_room_name_create_time_idx ON public.muc_room_history USING btree (muc_room_name, create_time);


--
-- TOC entry 4244 (class 1259 OID 18525)
-- Name: muc_room_history_muc_room_name_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_history_muc_room_name_idx ON public.muc_room_history USING btree (muc_room_name);


--
-- TOC entry 4245 (class 1259 OID 18526)
-- Name: muc_room_history_nick_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_history_nick_idx ON public.muc_room_history USING btree (nick);


--
-- TOC entry 4234 (class 1259 OID 18527)
-- Name: muc_room_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_host_idx ON public.muc_room USING btree (host);


--
-- TOC entry 4235 (class 1259 OID 18528)
-- Name: muc_room_name_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX muc_room_name_idx ON public.muc_room USING btree (name);


--
-- TOC entry 4256 (class 1259 OID 18529)
-- Name: muc_room_users_date_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_users_date_idx ON public.muc_room_users USING btree (date);


--
-- TOC entry 4257 (class 1259 OID 18530)
-- Name: muc_room_users_muc_name_username_date_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_users_muc_name_username_date_idx ON public.muc_room_users USING btree (muc_name, username, date);


--
-- TOC entry 4258 (class 1259 OID 18531)
-- Name: muc_room_users_muc_name_username_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX muc_room_users_muc_name_username_idx ON public.muc_room_users USING btree (muc_name, username);


--
-- TOC entry 4261 (class 1259 OID 18532)
-- Name: muc_room_users_username_date_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_users_username_date_idx ON public.muc_room_users USING btree (username, date);


--
-- TOC entry 4262 (class 1259 OID 18533)
-- Name: muc_room_users_username_host_date_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_users_username_host_date_idx ON public.muc_room_users USING btree (username, host, date);


--
-- TOC entry 4263 (class 1259 OID 18534)
-- Name: muc_room_users_username_host_idx1; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_users_username_host_idx1 ON public.muc_room_users USING btree (username, host);


--
-- TOC entry 4264 (class 1259 OID 18535)
-- Name: muc_room_users_username_host_muc_name_domain_date_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX muc_room_users_username_host_muc_name_domain_date_idx ON public.muc_room_users USING btree (username, host, muc_name, domain, date);


--
-- TOC entry 4265 (class 1259 OID 18536)
-- Name: muc_room_users_username_host_muc_name_domain_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX muc_room_users_username_host_muc_name_domain_idx ON public.muc_room_users USING btree (username, host, muc_name, domain);


--
-- TOC entry 4266 (class 1259 OID 18537)
-- Name: muc_room_users_username_host_mucname_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_users_username_host_mucname_idx ON public.muc_room_users USING btree (username, host, muc_name);


--
-- TOC entry 4267 (class 1259 OID 18538)
-- Name: muc_room_users_username_host_update_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_users_username_host_update_time_idx ON public.muc_room_users USING btree (username, host, update_time);


--
-- TOC entry 4268 (class 1259 OID 18539)
-- Name: muc_room_users_username_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_room_users_username_idx ON public.muc_room_users USING btree (username);


--
-- TOC entry 4275 (class 1259 OID 18540)
-- Name: muc_spool_creaetd_at_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_spool_creaetd_at_idx ON public.muc_spool USING btree (created_at);


--
-- TOC entry 4276 (class 1259 OID 18541)
-- Name: muc_spool_created_at_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_spool_created_at_idx ON public.muc_spool USING btree (created_at) WHERE (send_flag = '1'::text);


--
-- TOC entry 4277 (class 1259 OID 18542)
-- Name: muc_spool_created_at_idx1; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_spool_created_at_idx1 ON public.muc_spool USING btree (created_at) WHERE (send_flag = '0'::text);


--
-- TOC entry 4280 (class 1259 OID 18543)
-- Name: muc_spool_send_flag_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_spool_send_flag_idx ON public.muc_spool USING btree (send_flag);


--
-- TOC entry 4281 (class 1259 OID 18544)
-- Name: muc_spool_username_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_spool_username_idx ON public.muc_spool USING btree (username);


--
-- TOC entry 4282 (class 1259 OID 18545)
-- Name: muc_user_mark_index; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_user_mark_index ON public.muc_user_mark USING btree (muc_name, user_name);


--
-- TOC entry 4285 (class 1259 OID 18546)
-- Name: muc_vcard_info_muc_name_show_name_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX muc_vcard_info_muc_name_show_name_idx ON public.muc_vcard_info USING gin (muc_name public.gin_trgm_ops, show_name public.gin_trgm_ops);


--
-- TOC entry 4319 (class 1259 OID 18547)
-- Name: new_person_extent_owner_host_idx1; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX new_person_extent_owner_host_idx1 ON public.person_extent_backup_2018_01_28 USING btree (owner, host);


--
-- TOC entry 4320 (class 1259 OID 18548)
-- Name: new_person_extent_owner_host_key_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX new_person_extent_owner_host_key_idx ON public.person_extent_backup_2018_01_28 USING btree (owner, host, key);


--
-- TOC entry 4321 (class 1259 OID 18549)
-- Name: new_person_extent_owner_key_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX new_person_extent_owner_key_idx ON public.person_extent_backup_2018_01_28 USING btree (owner, key);


--
-- TOC entry 4294 (class 1259 OID 18550)
-- Name: non_human_nickname_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX non_human_nickname_idx ON public.non_human USING btree (nickname);


--
-- TOC entry 4295 (class 1259 OID 18551)
-- Name: notice_history_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX notice_history_create_time_idx ON public.notice_history USING btree (create_time);


--
-- TOC entry 4296 (class 1259 OID 18552)
-- Name: notice_history_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX notice_history_host_idx ON public.notice_history USING btree (host);


--
-- TOC entry 4297 (class 1259 OID 18553)
-- Name: notice_history_m_from_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX notice_history_m_from_create_time_idx ON public.notice_history USING btree (m_from, create_time);


--
-- TOC entry 4298 (class 1259 OID 18554)
-- Name: notice_history_m_from_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX notice_history_m_from_idx ON public.notice_history USING btree (m_from);


--
-- TOC entry 4306 (class 1259 OID 18555)
-- Name: person_extent_2017_09_22_owner_key_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX person_extent_2017_09_22_owner_key_idx ON public.person_extent_2017_09_22 USING btree (owner, key);


--
-- TOC entry 4309 (class 1259 OID 18556)
-- Name: person_extent_2018_05_02_owner_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX person_extent_2018_05_02_owner_host_idx ON public.person_extent_2018_05_02 USING btree (owner, host);


--
-- TOC entry 4310 (class 1259 OID 18557)
-- Name: person_extent_2018_05_02_owner_host_key_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX person_extent_2018_05_02_owner_host_key_idx ON public.person_extent_2018_05_02 USING btree (owner, host, key);


--
-- TOC entry 4311 (class 1259 OID 18558)
-- Name: person_extent_2018_05_02_owner_key_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX person_extent_2018_05_02_owner_key_idx ON public.person_extent_2018_05_02 USING btree (owner, key);


--
-- TOC entry 4314 (class 1259 OID 18559)
-- Name: person_extent_2018_07_12_owner_host_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX person_extent_2018_07_12_owner_host_idx ON public.person_extent_2018_07_12 USING btree (owner, host);


--
-- TOC entry 4315 (class 1259 OID 18560)
-- Name: person_extent_2018_07_12_owner_host_key_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX person_extent_2018_07_12_owner_host_key_idx ON public.person_extent_2018_07_12 USING btree (owner, host, key);


--
-- TOC entry 4316 (class 1259 OID 18561)
-- Name: person_extent_2018_07_12_owner_key_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX person_extent_2018_07_12_owner_key_idx ON public.person_extent_2018_07_12 USING btree (owner, key);


--
-- TOC entry 4301 (class 1259 OID 18562)
-- Name: person_extent_owner_host_idx1; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX person_extent_owner_host_idx1 ON public.person_extent USING btree (owner, host);


--
-- TOC entry 4302 (class 1259 OID 18563)
-- Name: person_extent_owner_host_key_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX person_extent_owner_host_key_idx ON public.person_extent USING btree (owner, host, key);


--
-- TOC entry 4303 (class 1259 OID 18564)
-- Name: person_extent_owner_key_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX person_extent_owner_key_idx ON public.person_extent USING btree (owner, key);


--
-- TOC entry 4326 (class 1259 OID 18565)
-- Name: person_user_mac_key_user_name_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX person_user_mac_key_user_name_host_idx ON public.person_user_mac_key USING btree (user_name, host);


--
-- TOC entry 4327 (class 1259 OID 18566)
-- Name: person_user_mac_key_user_name_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX person_user_mac_key_user_name_idx ON public.person_user_mac_key USING btree (user_name);


--
-- TOC entry 4400 (class 1259 OID 18567)
-- Name: pk_rosterg_user_jid; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX pk_rosterg_user_jid ON public.rostergroups USING btree (username, jid);


--
-- TOC entry 4351 (class 1259 OID 18568)
-- Name: push_info_user_name_host_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX push_info_user_name_host_idx ON public.push_info USING btree (user_name, host);


--
-- TOC entry 4352 (class 1259 OID 18569)
-- Name: push_info_user_name_host_os_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX push_info_user_name_host_os_idx ON public.push_info USING btree (user_name, host, os);


--
-- TOC entry 4353 (class 1259 OID 18570)
-- Name: push_info_user_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX push_info_user_name_idx ON public.push_info USING btree (user_name);


--
-- TOC entry 4361 (class 1259 OID 18571)
-- Name: qcloud_main_history_q_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX qcloud_main_history_q_id_idx ON public.qcloud_main_history USING btree (q_id);


--
-- TOC entry 4369 (class 1259 OID 18572)
-- Name: qcloud_sub_history_qs_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX qcloud_sub_history_qs_id_idx ON public.qcloud_sub_history USING btree (qs_id);


--
-- TOC entry 4366 (class 1259 OID 18573)
-- Name: qcloud_sub_q_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX qcloud_sub_q_id_idx ON public.qcloud_sub USING btree (q_id);


--
-- TOC entry 4370 (class 1259 OID 18574)
-- Name: qtalk_user_comment_from_user_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX qtalk_user_comment_from_user_idx ON public.qtalk_user_comment USING btree (from_user);


--
-- TOC entry 4373 (class 1259 OID 18575)
-- Name: qtalk_user_comment_to_user_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX qtalk_user_comment_to_user_idx ON public.qtalk_user_comment USING btree (to_user);


--
-- TOC entry 4374 (class 1259 OID 18576)
-- Name: qtalk_user_comment_uniq_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX qtalk_user_comment_uniq_key ON public.qtalk_user_comment USING btree (from_user, to_user, public.qto_char(create_time, 'YYYY-WW'::text));


--
-- TOC entry 4381 (class 1259 OID 18577)
-- Name: revoke_msg_history_backup_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX revoke_msg_history_backup_create_time_idx ON public.revoke_msg_history_backup USING btree (create_time);


--
-- TOC entry 4377 (class 1259 OID 18578)
-- Name: revoke_msg_history_create_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX revoke_msg_history_create_time_idx ON public.revoke_msg_history USING btree (create_time);


--
-- TOC entry 4378 (class 1259 OID 18579)
-- Name: revoke_msg_history_msg_id_idx1; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX revoke_msg_history_msg_id_idx1 ON public.revoke_msg_history USING btree (msg_id);


--
-- TOC entry 4384 (class 1259 OID 18580)
-- Name: robot_info_cn_name_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX robot_info_cn_name_idx ON public.robot_info USING btree (cn_name);


--
-- TOC entry 4406 (class 1259 OID 18581)
-- Name: scheduling_info_begin_time_end_time_member_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scheduling_info_begin_time_end_time_member_idx ON public.scheduling_info USING btree (begin_time, end_time, member);


--
-- TOC entry 4407 (class 1259 OID 18582)
-- Name: scheduling_info_begin_time_mem_action_remind_flag_canceled_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scheduling_info_begin_time_mem_action_remind_flag_canceled_idx ON public.scheduling_info USING btree (begin_time, mem_action, remind_flag, canceled);


--
-- TOC entry 4408 (class 1259 OID 18583)
-- Name: scheduling_info_end_time_mem_action_remind_flag_canceled_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scheduling_info_end_time_mem_action_remind_flag_canceled_idx ON public.scheduling_info USING btree (end_time, mem_action, remind_flag, canceled);


--
-- TOC entry 4409 (class 1259 OID 18584)
-- Name: scheduling_info_inviter_member_scheduling_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX scheduling_info_inviter_member_scheduling_id_idx ON public.scheduling_info USING btree (inviter, member, scheduling_id);


--
-- TOC entry 4412 (class 1259 OID 18585)
-- Name: scheduling_info_scheduling_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scheduling_info_scheduling_id_idx ON public.scheduling_info USING btree (scheduling_id);


--
-- TOC entry 4413 (class 1259 OID 18586)
-- Name: scheduling_info_scheduling_id_member_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scheduling_info_scheduling_id_member_idx ON public.scheduling_info USING btree (scheduling_id, member);


--
-- TOC entry 4414 (class 1259 OID 18587)
-- Name: scheduling_info_update_time_member_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scheduling_info_update_time_member_idx ON public.scheduling_info USING btree (update_time, member);


--
-- TOC entry 4422 (class 1259 OID 18588)
-- Name: spool_crated_at_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX spool_crated_at_idx ON public.spool USING btree (created_at);


--
-- TOC entry 4423 (class 1259 OID 18589)
-- Name: spool_created_at_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX spool_created_at_idx ON public.spool USING btree (created_at) WHERE (send_flag = '1'::text);


--
-- TOC entry 4424 (class 1259 OID 18590)
-- Name: spool_created_at_idx1; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX spool_created_at_idx1 ON public.spool USING btree (created_at) WHERE (send_flag = '0'::text);


--
-- TOC entry 4427 (class 1259 OID 18591)
-- Name: spool_send_flag_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX spool_send_flag_idx ON public.spool USING btree (send_flag);


--
-- TOC entry 4438 (class 1259 OID 18592)
-- Name: uer_mac_key_user_name_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX uer_mac_key_user_name_idx ON public.user_mac_key USING btree (user_name);


--
-- TOC entry 4432 (class 1259 OID 18593)
-- Name: user_block_list_username_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_block_list_username_idx ON public.user_block_list USING btree (username);


--
-- TOC entry 4437 (class 1259 OID 18594)
-- Name: user_friends_username_userhost_friend_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX user_friends_username_userhost_friend_host_idx ON public.user_friends USING btree (username, userhost, friend, host);


--
-- TOC entry 4393 (class 1259 OID 18595)
-- Name: user_name_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_name_idx ON public.users USING btree (name);


--
-- TOC entry 4451 (class 1259 OID 18596)
-- Name: user_register_mucs_backup_created_at_username_registed_flag_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_backup_created_at_username_registed_flag_idx ON public.user_register_mucs_backup USING btree (created_at, username, registed_flag);


--
-- TOC entry 4454 (class 1259 OID 18597)
-- Name: user_register_mucs_backup_username_domain_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_backup_username_domain_idx ON public.user_register_mucs_backup USING btree (username, domain);


--
-- TOC entry 4455 (class 1259 OID 18598)
-- Name: user_register_mucs_backup_username_domain_muc_name_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_backup_username_domain_muc_name_idx ON public.user_register_mucs_backup USING btree (username, domain, muc_name);


--
-- TOC entry 4456 (class 1259 OID 18599)
-- Name: user_register_mucs_backup_username_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_backup_username_idx ON public.user_register_mucs_backup USING btree (username);


--
-- TOC entry 4457 (class 1259 OID 18600)
-- Name: user_register_mucs_backup_username_registed_flag_domain_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_backup_username_registed_flag_domain_idx ON public.user_register_mucs_backup USING btree (username, registed_flag, domain);


--
-- TOC entry 4442 (class 1259 OID 18601)
-- Name: user_register_mucs_created_at_username_registed_flag_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_created_at_username_registed_flag_idx ON public.user_register_mucs USING btree (created_at, username, registed_flag);


--
-- TOC entry 4445 (class 1259 OID 18602)
-- Name: user_register_mucs_username_domain_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_username_domain_idx ON public.user_register_mucs USING btree (username, domain);


--
-- TOC entry 4446 (class 1259 OID 18603)
-- Name: user_register_mucs_username_domain_muc_name_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_username_domain_muc_name_idx ON public.user_register_mucs USING btree (username, domain, muc_name);


--
-- TOC entry 4447 (class 1259 OID 18604)
-- Name: user_register_mucs_username_host_muc_name_domain_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX user_register_mucs_username_host_muc_name_domain_idx ON public.user_register_mucs USING btree (username, host, muc_name, domain);


--
-- TOC entry 4448 (class 1259 OID 18605)
-- Name: user_register_mucs_username_host_registed_flag_created_at_idx1; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_username_host_registed_flag_created_at_idx1 ON public.user_register_mucs USING btree (username, host, registed_flag, created_at);


--
-- TOC entry 4449 (class 1259 OID 18606)
-- Name: user_register_mucs_username_host_registed_flag_idx1; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_username_host_registed_flag_idx1 ON public.user_register_mucs USING btree (username, host, registed_flag);


--
-- TOC entry 4450 (class 1259 OID 18607)
-- Name: user_register_mucs_username_registed_flag_domain_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX user_register_mucs_username_registed_flag_domain_idx ON public.user_register_mucs USING btree (username, registed_flag, domain);


--
-- TOC entry 4394 (class 1259 OID 18608)
-- Name: users_name_hire_flag_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX users_name_hire_flag_idx ON public.users USING btree (name, hire_flag);


--
-- TOC entry 4397 (class 1259 OID 18609)
-- Name: users_username_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX users_username_idx ON public.users USING btree (username);


--
-- TOC entry 4480 (class 1259 OID 18610)
-- Name: vcard_version_test_username_host_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX vcard_version_test_username_host_idx ON public.vcard_version_test USING btree (username, host);


--
-- TOC entry 4477 (class 1259 OID 18611)
-- Name: vcard_version_username_host_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE UNIQUE INDEX vcard_version_username_host_idx ON public.vcard_version USING btree (username, host);


--
-- TOC entry 4496 (class 1259 OID 18612)
-- Name: warn_msg_history_backup_create_time_m_to_m_from_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_backup_create_time_m_to_m_from_idx ON public.warn_msg_history_backup USING btree (create_time, m_to, m_from);


--
-- TOC entry 4497 (class 1259 OID 18613)
-- Name: warn_msg_history_backup_create_time_m_to_to_host_m_from_fro_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_backup_create_time_m_to_to_host_m_from_fro_idx ON public.warn_msg_history_backup USING btree (create_time, m_to, to_host, m_from, from_host);


--
-- TOC entry 4498 (class 1259 OID 18614)
-- Name: warn_msg_history_backup_m_from_from_host_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_backup_m_from_from_host_create_time_idx ON public.warn_msg_history_backup USING btree (m_from, from_host, create_time);


--
-- TOC entry 4499 (class 1259 OID 18615)
-- Name: warn_msg_history_backup_m_from_m_to_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_backup_m_from_m_to_create_time_idx ON public.warn_msg_history_backup USING btree (m_from, m_to, create_time);


--
-- TOC entry 4500 (class 1259 OID 18616)
-- Name: warn_msg_history_backup_m_to_id_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX warn_msg_history_backup_m_to_id_create_time_idx ON public.warn_msg_history_backup USING btree (m_to, id, create_time) WHERE (((m_from)::text = 'qunar-message'::text) AND (from_host = 'ejabhost1'::text) AND (to_host = 'ejabhost1'::text));


--
-- TOC entry 4501 (class 1259 OID 18617)
-- Name: warn_msg_history_backup_m_to_id_create_time_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX warn_msg_history_backup_m_to_id_create_time_idx1 ON public.warn_msg_history_backup USING btree (m_to, id DESC, create_time);


--
-- TOC entry 4502 (class 1259 OID 18618)
-- Name: warn_msg_history_backup_m_to_to_host_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_backup_m_to_to_host_create_time_idx ON public.warn_msg_history_backup USING btree (m_to, to_host, create_time);


--
-- TOC entry 4503 (class 1259 OID 18619)
-- Name: warn_msg_history_backup_msg_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_backup_msg_id_idx ON public.warn_msg_history_backup USING btree (msg_id);


--
-- TOC entry 4485 (class 1259 OID 18620)
-- Name: warn_msg_history_create_time_m_to_m_from_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_create_time_m_to_m_from_idx ON public.warn_msg_history USING btree (create_time, m_to, m_from);


--
-- TOC entry 4486 (class 1259 OID 18621)
-- Name: warn_msg_history_create_time_m_to_to_host_m_from_from_host_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_create_time_m_to_to_host_m_from_from_host_idx ON public.warn_msg_history USING btree (create_time, m_to, to_host, m_from, from_host);


--
-- TOC entry 4487 (class 1259 OID 18622)
-- Name: warn_msg_history_m_from_from_host_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_m_from_from_host_create_time_idx ON public.warn_msg_history USING btree (m_from, from_host, create_time);


--
-- TOC entry 4488 (class 1259 OID 18623)
-- Name: warn_msg_history_m_from_m_to_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_m_from_m_to_create_time_idx ON public.warn_msg_history USING btree (m_from, m_to, create_time);


--
-- TOC entry 4489 (class 1259 OID 18624)
-- Name: warn_msg_history_m_to_id_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX warn_msg_history_m_to_id_create_time_idx ON public.warn_msg_history USING btree (m_to, id, create_time) WHERE (((m_from)::text = 'qunar-message'::text) AND (from_host = 'ejabhost1'::text) AND (to_host = 'ejabhost1'::text));


--
-- TOC entry 4490 (class 1259 OID 18625)
-- Name: warn_msg_history_m_to_id_create_time_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX warn_msg_history_m_to_id_create_time_idx1 ON public.warn_msg_history USING btree (m_to, id DESC, create_time);


--
-- TOC entry 4491 (class 1259 OID 18626)
-- Name: warn_msg_history_m_to_to_host_create_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_m_to_to_host_create_time_idx ON public.warn_msg_history USING btree (m_to, to_host, create_time);


--
-- TOC entry 4492 (class 1259 OID 18627)
-- Name: warn_msg_history_msg_id_idx2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX warn_msg_history_msg_id_idx2 ON public.warn_msg_history USING btree (msg_id);


--
-- TOC entry 4495 (class 1259 OID 18628)
-- Name: warn_msg_history_read_flag_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX warn_msg_history_read_flag_idx ON public.warn_msg_history USING btree (read_flag) WHERE (read_flag <> '3'::smallint);


--
-- TOC entry 4510 (class 1259 OID 18629)
-- Name: win_dump_url_dump_time_idx; Type: INDEX; Schema: public; Owner: ejabberd
--

CREATE INDEX win_dump_url_dump_time_idx ON public.win_dump_url USING btree (dump_time);


--
-- TOC entry 4513 (class 2606 OID 18630)
-- Name: privacy_list_data privacy_list_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.privacy_list_data
    ADD CONSTRAINT privacy_list_data_id_fkey FOREIGN KEY (id) REFERENCES public.privacy_list(id) ON DELETE CASCADE;


--
-- TOC entry 4514 (class 2606 OID 18635)
-- Name: pubsub_item pubsub_item_nodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.pubsub_item
    ADD CONSTRAINT pubsub_item_nodeid_fkey FOREIGN KEY (nodeid) REFERENCES public.pubsub_node(nodeid) ON DELETE CASCADE;


--
-- TOC entry 4515 (class 2606 OID 18640)
-- Name: pubsub_node_option pubsub_node_option_nodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.pubsub_node_option
    ADD CONSTRAINT pubsub_node_option_nodeid_fkey FOREIGN KEY (nodeid) REFERENCES public.pubsub_node(nodeid) ON DELETE CASCADE;


--
-- TOC entry 4516 (class 2606 OID 18645)
-- Name: pubsub_node_owner pubsub_node_owner_nodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.pubsub_node_owner
    ADD CONSTRAINT pubsub_node_owner_nodeid_fkey FOREIGN KEY (nodeid) REFERENCES public.pubsub_node(nodeid) ON DELETE CASCADE;


--
-- TOC entry 4517 (class 2606 OID 18650)
-- Name: pubsub_state pubsub_state_nodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ejabberd
--

ALTER TABLE ONLY public.pubsub_state
    ADD CONSTRAINT pubsub_state_nodeid_fkey FOREIGN KEY (nodeid) REFERENCES public.pubsub_node(nodeid) ON DELETE CASCADE;


--
-- TOC entry 4651 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM postgres;


--
-- TOC entry 4658 (class 0 OID 0)
-- Dependencies: 410
-- Name: FUNCTION gbtreekey16_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbtreekey16_in(cstring) FROM postgres;


--
-- TOC entry 4659 (class 0 OID 0)
-- Dependencies: 411
-- Name: FUNCTION gbtreekey16_out(public.gbtreekey16); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbtreekey16_out(public.gbtreekey16) FROM postgres;


--
-- TOC entry 4660 (class 0 OID 0)
-- Dependencies: 427
-- Name: FUNCTION gbtreekey32_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbtreekey32_in(cstring) FROM postgres;


--
-- TOC entry 4661 (class 0 OID 0)
-- Dependencies: 428
-- Name: FUNCTION gbtreekey32_out(public.gbtreekey32); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbtreekey32_out(public.gbtreekey32) FROM postgres;


--
-- TOC entry 4662 (class 0 OID 0)
-- Dependencies: 406
-- Name: FUNCTION gbtreekey4_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbtreekey4_in(cstring) FROM postgres;


--
-- TOC entry 4663 (class 0 OID 0)
-- Dependencies: 407
-- Name: FUNCTION gbtreekey4_out(public.gbtreekey4); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbtreekey4_out(public.gbtreekey4) FROM postgres;


--
-- TOC entry 4664 (class 0 OID 0)
-- Dependencies: 408
-- Name: FUNCTION gbtreekey8_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbtreekey8_in(cstring) FROM postgres;


--
-- TOC entry 4665 (class 0 OID 0)
-- Dependencies: 409
-- Name: FUNCTION gbtreekey8_out(public.gbtreekey8); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbtreekey8_out(public.gbtreekey8) FROM postgres;


--
-- TOC entry 4666 (class 0 OID 0)
-- Dependencies: 429
-- Name: FUNCTION gbtreekey_var_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbtreekey_var_in(cstring) FROM postgres;


--
-- TOC entry 4667 (class 0 OID 0)
-- Dependencies: 430
-- Name: FUNCTION gbtreekey_var_out(public.gbtreekey_var); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbtreekey_var_out(public.gbtreekey_var) FROM postgres;


--
-- TOC entry 4668 (class 0 OID 0)
-- Dependencies: 575
-- Name: FUNCTION gtrgm_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gtrgm_in(cstring) FROM postgres;


--
-- TOC entry 4669 (class 0 OID 0)
-- Dependencies: 576
-- Name: FUNCTION gtrgm_out(public.gtrgm); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gtrgm_out(public.gtrgm) FROM postgres;


--
-- TOC entry 4670 (class 0 OID 0)
-- Dependencies: 431
-- Name: FUNCTION cash_dist(money, money); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.cash_dist(money, money) FROM postgres;


--
-- TOC entry 4671 (class 0 OID 0)
-- Dependencies: 432
-- Name: FUNCTION date_dist(date, date); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.date_dist(date, date) FROM postgres;


--
-- TOC entry 4672 (class 0 OID 0)
-- Dependencies: 433
-- Name: FUNCTION float4_dist(real, real); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.float4_dist(real, real) FROM postgres;


--
-- TOC entry 4673 (class 0 OID 0)
-- Dependencies: 413
-- Name: FUNCTION float8_dist(double precision, double precision); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.float8_dist(double precision, double precision) FROM postgres;


--
-- TOC entry 4674 (class 0 OID 0)
-- Dependencies: 557
-- Name: FUNCTION gbt_bit_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bit_compress(internal) FROM postgres;


--
-- TOC entry 4675 (class 0 OID 0)
-- Dependencies: 556
-- Name: FUNCTION gbt_bit_consistent(internal, bit, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bit_consistent(internal, bit, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4676 (class 0 OID 0)
-- Dependencies: 512
-- Name: FUNCTION gbt_bit_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bit_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4677 (class 0 OID 0)
-- Dependencies: 513
-- Name: FUNCTION gbt_bit_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bit_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4678 (class 0 OID 0)
-- Dependencies: 515
-- Name: FUNCTION gbt_bit_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bit_same(public.gbtreekey_var, public.gbtreekey_var, internal) FROM postgres;


--
-- TOC entry 4679 (class 0 OID 0)
-- Dependencies: 514
-- Name: FUNCTION gbt_bit_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bit_union(internal, internal) FROM postgres;


--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 479
-- Name: FUNCTION gbt_bpchar_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bpchar_compress(internal) FROM postgres;


--
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 511
-- Name: FUNCTION gbt_bpchar_consistent(internal, character, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bpchar_consistent(internal, character, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 539
-- Name: FUNCTION gbt_bytea_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bytea_compress(internal) FROM postgres;


--
-- TOC entry 4683 (class 0 OID 0)
-- Dependencies: 484
-- Name: FUNCTION gbt_bytea_consistent(internal, bytea, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bytea_consistent(internal, bytea, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4684 (class 0 OID 0)
-- Dependencies: 541
-- Name: FUNCTION gbt_bytea_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bytea_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4685 (class 0 OID 0)
-- Dependencies: 542
-- Name: FUNCTION gbt_bytea_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bytea_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4686 (class 0 OID 0)
-- Dependencies: 544
-- Name: FUNCTION gbt_bytea_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bytea_same(public.gbtreekey_var, public.gbtreekey_var, internal) FROM postgres;


--
-- TOC entry 4687 (class 0 OID 0)
-- Dependencies: 543
-- Name: FUNCTION gbt_bytea_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_bytea_union(internal, internal) FROM postgres;


--
-- TOC entry 4688 (class 0 OID 0)
-- Dependencies: 473
-- Name: FUNCTION gbt_cash_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_cash_compress(internal) FROM postgres;


--
-- TOC entry 4689 (class 0 OID 0)
-- Dependencies: 493
-- Name: FUNCTION gbt_cash_consistent(internal, money, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_cash_consistent(internal, money, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4690 (class 0 OID 0)
-- Dependencies: 494
-- Name: FUNCTION gbt_cash_distance(internal, money, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_cash_distance(internal, money, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4691 (class 0 OID 0)
-- Dependencies: 474
-- Name: FUNCTION gbt_cash_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_cash_fetch(internal) FROM postgres;


--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 475
-- Name: FUNCTION gbt_cash_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_cash_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4693 (class 0 OID 0)
-- Dependencies: 476
-- Name: FUNCTION gbt_cash_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_cash_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4694 (class 0 OID 0)
-- Dependencies: 478
-- Name: FUNCTION gbt_cash_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_cash_same(public.gbtreekey16, public.gbtreekey16, internal) FROM postgres;


--
-- TOC entry 4695 (class 0 OID 0)
-- Dependencies: 477
-- Name: FUNCTION gbt_cash_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_cash_union(internal, internal) FROM postgres;


--
-- TOC entry 4696 (class 0 OID 0)
-- Dependencies: 403
-- Name: FUNCTION gbt_date_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_date_compress(internal) FROM postgres;


--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 401
-- Name: FUNCTION gbt_date_consistent(internal, date, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_date_consistent(internal, date, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4698 (class 0 OID 0)
-- Dependencies: 402
-- Name: FUNCTION gbt_date_distance(internal, date, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_date_distance(internal, date, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4699 (class 0 OID 0)
-- Dependencies: 404
-- Name: FUNCTION gbt_date_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_date_fetch(internal) FROM postgres;


--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 405
-- Name: FUNCTION gbt_date_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_date_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 383
-- Name: FUNCTION gbt_date_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_date_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4702 (class 0 OID 0)
-- Dependencies: 385
-- Name: FUNCTION gbt_date_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_date_same(public.gbtreekey8, public.gbtreekey8, internal) FROM postgres;


--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 384
-- Name: FUNCTION gbt_date_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_date_union(internal, internal) FROM postgres;


--
-- TOC entry 4704 (class 0 OID 0)
-- Dependencies: 426
-- Name: FUNCTION gbt_decompress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_decompress(internal) FROM postgres;


--
-- TOC entry 4705 (class 0 OID 0)
-- Dependencies: 532
-- Name: FUNCTION gbt_enum_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_enum_compress(internal) FROM postgres;


--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 531
-- Name: FUNCTION gbt_enum_consistent(internal, anyenum, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_enum_consistent(internal, anyenum, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4707 (class 0 OID 0)
-- Dependencies: 533
-- Name: FUNCTION gbt_enum_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_enum_fetch(internal) FROM postgres;


--
-- TOC entry 4708 (class 0 OID 0)
-- Dependencies: 534
-- Name: FUNCTION gbt_enum_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_enum_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4709 (class 0 OID 0)
-- Dependencies: 535
-- Name: FUNCTION gbt_enum_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_enum_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4710 (class 0 OID 0)
-- Dependencies: 536
-- Name: FUNCTION gbt_enum_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_enum_same(public.gbtreekey8, public.gbtreekey8, internal) FROM postgres;


--
-- TOC entry 4711 (class 0 OID 0)
-- Dependencies: 540
-- Name: FUNCTION gbt_enum_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_enum_union(internal, internal) FROM postgres;


--
-- TOC entry 4712 (class 0 OID 0)
-- Dependencies: 466
-- Name: FUNCTION gbt_float4_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float4_compress(internal) FROM postgres;


--
-- TOC entry 4713 (class 0 OID 0)
-- Dependencies: 464
-- Name: FUNCTION gbt_float4_consistent(internal, real, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float4_consistent(internal, real, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4714 (class 0 OID 0)
-- Dependencies: 465
-- Name: FUNCTION gbt_float4_distance(internal, real, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float4_distance(internal, real, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4715 (class 0 OID 0)
-- Dependencies: 467
-- Name: FUNCTION gbt_float4_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float4_fetch(internal) FROM postgres;


--
-- TOC entry 4716 (class 0 OID 0)
-- Dependencies: 468
-- Name: FUNCTION gbt_float4_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float4_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4717 (class 0 OID 0)
-- Dependencies: 469
-- Name: FUNCTION gbt_float4_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float4_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4718 (class 0 OID 0)
-- Dependencies: 471
-- Name: FUNCTION gbt_float4_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float4_same(public.gbtreekey8, public.gbtreekey8, internal) FROM postgres;


--
-- TOC entry 4719 (class 0 OID 0)
-- Dependencies: 470
-- Name: FUNCTION gbt_float4_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float4_union(internal, internal) FROM postgres;


--
-- TOC entry 4720 (class 0 OID 0)
-- Dependencies: 487
-- Name: FUNCTION gbt_float8_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float8_compress(internal) FROM postgres;


--
-- TOC entry 4721 (class 0 OID 0)
-- Dependencies: 485
-- Name: FUNCTION gbt_float8_consistent(internal, double precision, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float8_consistent(internal, double precision, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4722 (class 0 OID 0)
-- Dependencies: 486
-- Name: FUNCTION gbt_float8_distance(internal, double precision, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float8_distance(internal, double precision, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4723 (class 0 OID 0)
-- Dependencies: 491
-- Name: FUNCTION gbt_float8_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float8_fetch(internal) FROM postgres;


--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 492
-- Name: FUNCTION gbt_float8_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float8_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4725 (class 0 OID 0)
-- Dependencies: 490
-- Name: FUNCTION gbt_float8_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float8_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4726 (class 0 OID 0)
-- Dependencies: 392
-- Name: FUNCTION gbt_float8_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float8_same(public.gbtreekey16, public.gbtreekey16, internal) FROM postgres;


--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 506
-- Name: FUNCTION gbt_float8_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_float8_union(internal, internal) FROM postgres;


--
-- TOC entry 4728 (class 0 OID 0)
-- Dependencies: 517
-- Name: FUNCTION gbt_inet_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_inet_compress(internal) FROM postgres;


--
-- TOC entry 4729 (class 0 OID 0)
-- Dependencies: 516
-- Name: FUNCTION gbt_inet_consistent(internal, inet, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_inet_consistent(internal, inet, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 518
-- Name: FUNCTION gbt_inet_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_inet_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 519
-- Name: FUNCTION gbt_inet_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_inet_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 521
-- Name: FUNCTION gbt_inet_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_inet_same(public.gbtreekey16, public.gbtreekey16, internal) FROM postgres;


--
-- TOC entry 4733 (class 0 OID 0)
-- Dependencies: 520
-- Name: FUNCTION gbt_inet_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_inet_union(internal, internal) FROM postgres;


--
-- TOC entry 4734 (class 0 OID 0)
-- Dependencies: 442
-- Name: FUNCTION gbt_int2_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int2_compress(internal) FROM postgres;


--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 440
-- Name: FUNCTION gbt_int2_consistent(internal, smallint, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int2_consistent(internal, smallint, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4736 (class 0 OID 0)
-- Dependencies: 441
-- Name: FUNCTION gbt_int2_distance(internal, smallint, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int2_distance(internal, smallint, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4737 (class 0 OID 0)
-- Dependencies: 443
-- Name: FUNCTION gbt_int2_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int2_fetch(internal) FROM postgres;


--
-- TOC entry 4738 (class 0 OID 0)
-- Dependencies: 444
-- Name: FUNCTION gbt_int2_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int2_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4739 (class 0 OID 0)
-- Dependencies: 445
-- Name: FUNCTION gbt_int2_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int2_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4740 (class 0 OID 0)
-- Dependencies: 447
-- Name: FUNCTION gbt_int2_same(public.gbtreekey4, public.gbtreekey4, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int2_same(public.gbtreekey4, public.gbtreekey4, internal) FROM postgres;


--
-- TOC entry 4741 (class 0 OID 0)
-- Dependencies: 446
-- Name: FUNCTION gbt_int2_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int2_union(internal, internal) FROM postgres;


--
-- TOC entry 4742 (class 0 OID 0)
-- Dependencies: 450
-- Name: FUNCTION gbt_int4_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int4_compress(internal) FROM postgres;


--
-- TOC entry 4743 (class 0 OID 0)
-- Dependencies: 448
-- Name: FUNCTION gbt_int4_consistent(internal, integer, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int4_consistent(internal, integer, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4744 (class 0 OID 0)
-- Dependencies: 449
-- Name: FUNCTION gbt_int4_distance(internal, integer, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int4_distance(internal, integer, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4745 (class 0 OID 0)
-- Dependencies: 451
-- Name: FUNCTION gbt_int4_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int4_fetch(internal) FROM postgres;


--
-- TOC entry 4746 (class 0 OID 0)
-- Dependencies: 452
-- Name: FUNCTION gbt_int4_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int4_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4747 (class 0 OID 0)
-- Dependencies: 453
-- Name: FUNCTION gbt_int4_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int4_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4748 (class 0 OID 0)
-- Dependencies: 455
-- Name: FUNCTION gbt_int4_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int4_same(public.gbtreekey8, public.gbtreekey8, internal) FROM postgres;


--
-- TOC entry 4749 (class 0 OID 0)
-- Dependencies: 454
-- Name: FUNCTION gbt_int4_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int4_union(internal, internal) FROM postgres;


--
-- TOC entry 4750 (class 0 OID 0)
-- Dependencies: 458
-- Name: FUNCTION gbt_int8_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int8_compress(internal) FROM postgres;


--
-- TOC entry 4751 (class 0 OID 0)
-- Dependencies: 456
-- Name: FUNCTION gbt_int8_consistent(internal, bigint, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int8_consistent(internal, bigint, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4752 (class 0 OID 0)
-- Dependencies: 457
-- Name: FUNCTION gbt_int8_distance(internal, bigint, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int8_distance(internal, bigint, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4753 (class 0 OID 0)
-- Dependencies: 459
-- Name: FUNCTION gbt_int8_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int8_fetch(internal) FROM postgres;


--
-- TOC entry 4754 (class 0 OID 0)
-- Dependencies: 460
-- Name: FUNCTION gbt_int8_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int8_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4755 (class 0 OID 0)
-- Dependencies: 461
-- Name: FUNCTION gbt_int8_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int8_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4756 (class 0 OID 0)
-- Dependencies: 463
-- Name: FUNCTION gbt_int8_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int8_same(public.gbtreekey16, public.gbtreekey16, internal) FROM postgres;


--
-- TOC entry 4757 (class 0 OID 0)
-- Dependencies: 462
-- Name: FUNCTION gbt_int8_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_int8_union(internal, internal) FROM postgres;


--
-- TOC entry 4758 (class 0 OID 0)
-- Dependencies: 388
-- Name: FUNCTION gbt_intv_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_intv_compress(internal) FROM postgres;


--
-- TOC entry 4759 (class 0 OID 0)
-- Dependencies: 386
-- Name: FUNCTION gbt_intv_consistent(internal, interval, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_intv_consistent(internal, interval, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4760 (class 0 OID 0)
-- Dependencies: 389
-- Name: FUNCTION gbt_intv_decompress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_intv_decompress(internal) FROM postgres;


--
-- TOC entry 4761 (class 0 OID 0)
-- Dependencies: 387
-- Name: FUNCTION gbt_intv_distance(internal, interval, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_intv_distance(internal, interval, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4762 (class 0 OID 0)
-- Dependencies: 390
-- Name: FUNCTION gbt_intv_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_intv_fetch(internal) FROM postgres;


--
-- TOC entry 4763 (class 0 OID 0)
-- Dependencies: 391
-- Name: FUNCTION gbt_intv_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_intv_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4764 (class 0 OID 0)
-- Dependencies: 498
-- Name: FUNCTION gbt_intv_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_intv_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4765 (class 0 OID 0)
-- Dependencies: 505
-- Name: FUNCTION gbt_intv_same(public.gbtreekey32, public.gbtreekey32, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_intv_same(public.gbtreekey32, public.gbtreekey32, internal) FROM postgres;


--
-- TOC entry 4766 (class 0 OID 0)
-- Dependencies: 504
-- Name: FUNCTION gbt_intv_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_intv_union(internal, internal) FROM postgres;


--
-- TOC entry 4767 (class 0 OID 0)
-- Dependencies: 547
-- Name: FUNCTION gbt_macad8_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad8_compress(internal) FROM postgres;


--
-- TOC entry 4768 (class 0 OID 0)
-- Dependencies: 546
-- Name: FUNCTION gbt_macad8_consistent(internal, macaddr8, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad8_consistent(internal, macaddr8, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4769 (class 0 OID 0)
-- Dependencies: 548
-- Name: FUNCTION gbt_macad8_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad8_fetch(internal) FROM postgres;


--
-- TOC entry 4770 (class 0 OID 0)
-- Dependencies: 528
-- Name: FUNCTION gbt_macad8_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad8_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4771 (class 0 OID 0)
-- Dependencies: 529
-- Name: FUNCTION gbt_macad8_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad8_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4772 (class 0 OID 0)
-- Dependencies: 530
-- Name: FUNCTION gbt_macad8_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad8_same(public.gbtreekey16, public.gbtreekey16, internal) FROM postgres;


--
-- TOC entry 4773 (class 0 OID 0)
-- Dependencies: 552
-- Name: FUNCTION gbt_macad8_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad8_union(internal, internal) FROM postgres;


--
-- TOC entry 4774 (class 0 OID 0)
-- Dependencies: 500
-- Name: FUNCTION gbt_macad_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad_compress(internal) FROM postgres;


--
-- TOC entry 4775 (class 0 OID 0)
-- Dependencies: 503
-- Name: FUNCTION gbt_macad_consistent(internal, macaddr, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad_consistent(internal, macaddr, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4776 (class 0 OID 0)
-- Dependencies: 501
-- Name: FUNCTION gbt_macad_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad_fetch(internal) FROM postgres;


--
-- TOC entry 4777 (class 0 OID 0)
-- Dependencies: 488
-- Name: FUNCTION gbt_macad_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4778 (class 0 OID 0)
-- Dependencies: 489
-- Name: FUNCTION gbt_macad_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4779 (class 0 OID 0)
-- Dependencies: 509
-- Name: FUNCTION gbt_macad_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad_same(public.gbtreekey16, public.gbtreekey16, internal) FROM postgres;


--
-- TOC entry 4780 (class 0 OID 0)
-- Dependencies: 502
-- Name: FUNCTION gbt_macad_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_macad_union(internal, internal) FROM postgres;


--
-- TOC entry 4781 (class 0 OID 0)
-- Dependencies: 550
-- Name: FUNCTION gbt_numeric_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_numeric_compress(internal) FROM postgres;


--
-- TOC entry 4782 (class 0 OID 0)
-- Dependencies: 549
-- Name: FUNCTION gbt_numeric_consistent(internal, numeric, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_numeric_consistent(internal, numeric, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4783 (class 0 OID 0)
-- Dependencies: 551
-- Name: FUNCTION gbt_numeric_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_numeric_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4784 (class 0 OID 0)
-- Dependencies: 553
-- Name: FUNCTION gbt_numeric_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_numeric_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4785 (class 0 OID 0)
-- Dependencies: 555
-- Name: FUNCTION gbt_numeric_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_numeric_same(public.gbtreekey_var, public.gbtreekey_var, internal) FROM postgres;


--
-- TOC entry 4786 (class 0 OID 0)
-- Dependencies: 554
-- Name: FUNCTION gbt_numeric_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_numeric_union(internal, internal) FROM postgres;


--
-- TOC entry 4787 (class 0 OID 0)
-- Dependencies: 425
-- Name: FUNCTION gbt_oid_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_oid_compress(internal) FROM postgres;


--
-- TOC entry 4788 (class 0 OID 0)
-- Dependencies: 422
-- Name: FUNCTION gbt_oid_consistent(internal, oid, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_oid_consistent(internal, oid, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4789 (class 0 OID 0)
-- Dependencies: 423
-- Name: FUNCTION gbt_oid_distance(internal, oid, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_oid_distance(internal, oid, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4790 (class 0 OID 0)
-- Dependencies: 424
-- Name: FUNCTION gbt_oid_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_oid_fetch(internal) FROM postgres;


--
-- TOC entry 4791 (class 0 OID 0)
-- Dependencies: 436
-- Name: FUNCTION gbt_oid_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_oid_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4792 (class 0 OID 0)
-- Dependencies: 437
-- Name: FUNCTION gbt_oid_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_oid_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4793 (class 0 OID 0)
-- Dependencies: 439
-- Name: FUNCTION gbt_oid_same(public.gbtreekey8, public.gbtreekey8, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_oid_same(public.gbtreekey8, public.gbtreekey8, internal) FROM postgres;


--
-- TOC entry 4794 (class 0 OID 0)
-- Dependencies: 438
-- Name: FUNCTION gbt_oid_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_oid_union(internal, internal) FROM postgres;


--
-- TOC entry 4795 (class 0 OID 0)
-- Dependencies: 472
-- Name: FUNCTION gbt_text_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_text_compress(internal) FROM postgres;


--
-- TOC entry 4796 (class 0 OID 0)
-- Dependencies: 510
-- Name: FUNCTION gbt_text_consistent(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_text_consistent(internal, text, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4797 (class 0 OID 0)
-- Dependencies: 480
-- Name: FUNCTION gbt_text_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_text_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4798 (class 0 OID 0)
-- Dependencies: 481
-- Name: FUNCTION gbt_text_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_text_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4799 (class 0 OID 0)
-- Dependencies: 483
-- Name: FUNCTION gbt_text_same(public.gbtreekey_var, public.gbtreekey_var, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_text_same(public.gbtreekey_var, public.gbtreekey_var, internal) FROM postgres;


--
-- TOC entry 4800 (class 0 OID 0)
-- Dependencies: 482
-- Name: FUNCTION gbt_text_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_text_union(internal, internal) FROM postgres;


--
-- TOC entry 4801 (class 0 OID 0)
-- Dependencies: 378
-- Name: FUNCTION gbt_time_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_time_compress(internal) FROM postgres;


--
-- TOC entry 4802 (class 0 OID 0)
-- Dependencies: 375
-- Name: FUNCTION gbt_time_consistent(internal, time without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_time_consistent(internal, time without time zone, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4803 (class 0 OID 0)
-- Dependencies: 376
-- Name: FUNCTION gbt_time_distance(internal, time without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_time_distance(internal, time without time zone, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4804 (class 0 OID 0)
-- Dependencies: 380
-- Name: FUNCTION gbt_time_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_time_fetch(internal) FROM postgres;


--
-- TOC entry 4805 (class 0 OID 0)
-- Dependencies: 381
-- Name: FUNCTION gbt_time_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_time_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4806 (class 0 OID 0)
-- Dependencies: 382
-- Name: FUNCTION gbt_time_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_time_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4807 (class 0 OID 0)
-- Dependencies: 400
-- Name: FUNCTION gbt_time_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_time_same(public.gbtreekey16, public.gbtreekey16, internal) FROM postgres;


--
-- TOC entry 4808 (class 0 OID 0)
-- Dependencies: 399
-- Name: FUNCTION gbt_time_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_time_union(internal, internal) FROM postgres;


--
-- TOC entry 4809 (class 0 OID 0)
-- Dependencies: 379
-- Name: FUNCTION gbt_timetz_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_timetz_compress(internal) FROM postgres;


--
-- TOC entry 4810 (class 0 OID 0)
-- Dependencies: 377
-- Name: FUNCTION gbt_timetz_consistent(internal, time with time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_timetz_consistent(internal, time with time zone, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4811 (class 0 OID 0)
-- Dependencies: 368
-- Name: FUNCTION gbt_ts_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_ts_compress(internal) FROM postgres;


--
-- TOC entry 4812 (class 0 OID 0)
-- Dependencies: 393
-- Name: FUNCTION gbt_ts_consistent(internal, timestamp without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_ts_consistent(internal, timestamp without time zone, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4813 (class 0 OID 0)
-- Dependencies: 394
-- Name: FUNCTION gbt_ts_distance(internal, timestamp without time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_ts_distance(internal, timestamp without time zone, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4814 (class 0 OID 0)
-- Dependencies: 370
-- Name: FUNCTION gbt_ts_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_ts_fetch(internal) FROM postgres;


--
-- TOC entry 4815 (class 0 OID 0)
-- Dependencies: 371
-- Name: FUNCTION gbt_ts_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_ts_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4816 (class 0 OID 0)
-- Dependencies: 372
-- Name: FUNCTION gbt_ts_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_ts_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4817 (class 0 OID 0)
-- Dependencies: 374
-- Name: FUNCTION gbt_ts_same(public.gbtreekey16, public.gbtreekey16, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_ts_same(public.gbtreekey16, public.gbtreekey16, internal) FROM postgres;


--
-- TOC entry 4818 (class 0 OID 0)
-- Dependencies: 373
-- Name: FUNCTION gbt_ts_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_ts_union(internal, internal) FROM postgres;


--
-- TOC entry 4819 (class 0 OID 0)
-- Dependencies: 369
-- Name: FUNCTION gbt_tstz_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_tstz_compress(internal) FROM postgres;


--
-- TOC entry 4820 (class 0 OID 0)
-- Dependencies: 395
-- Name: FUNCTION gbt_tstz_consistent(internal, timestamp with time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_tstz_consistent(internal, timestamp with time zone, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4821 (class 0 OID 0)
-- Dependencies: 396
-- Name: FUNCTION gbt_tstz_distance(internal, timestamp with time zone, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_tstz_distance(internal, timestamp with time zone, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4822 (class 0 OID 0)
-- Dependencies: 524
-- Name: FUNCTION gbt_uuid_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_uuid_compress(internal) FROM postgres;


--
-- TOC entry 4823 (class 0 OID 0)
-- Dependencies: 522
-- Name: FUNCTION gbt_uuid_consistent(internal, uuid, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_uuid_consistent(internal, uuid, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4824 (class 0 OID 0)
-- Dependencies: 523
-- Name: FUNCTION gbt_uuid_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_uuid_fetch(internal) FROM postgres;


--
-- TOC entry 4825 (class 0 OID 0)
-- Dependencies: 525
-- Name: FUNCTION gbt_uuid_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_uuid_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4826 (class 0 OID 0)
-- Dependencies: 526
-- Name: FUNCTION gbt_uuid_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_uuid_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 545
-- Name: FUNCTION gbt_uuid_same(public.gbtreekey32, public.gbtreekey32, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_uuid_same(public.gbtreekey32, public.gbtreekey32, internal) FROM postgres;


--
-- TOC entry 4828 (class 0 OID 0)
-- Dependencies: 527
-- Name: FUNCTION gbt_uuid_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_uuid_union(internal, internal) FROM postgres;


--
-- TOC entry 4829 (class 0 OID 0)
-- Dependencies: 434
-- Name: FUNCTION gbt_var_decompress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_var_decompress(internal) FROM postgres;


--
-- TOC entry 4830 (class 0 OID 0)
-- Dependencies: 435
-- Name: FUNCTION gbt_var_fetch(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gbt_var_fetch(internal) FROM postgres;


--
-- TOC entry 4831 (class 0 OID 0)
-- Dependencies: 558
-- Name: FUNCTION gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) FROM postgres;


--
-- TOC entry 4832 (class 0 OID 0)
-- Dependencies: 585
-- Name: FUNCTION gin_extract_value_trgm(text, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) FROM postgres;


--
-- TOC entry 4833 (class 0 OID 0)
-- Dependencies: 559
-- Name: FUNCTION gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) FROM postgres;


--
-- TOC entry 4834 (class 0 OID 0)
-- Dependencies: 560
-- Name: FUNCTION gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) FROM postgres;


--
-- TOC entry 4835 (class 0 OID 0)
-- Dependencies: 579
-- Name: FUNCTION gtrgm_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gtrgm_compress(internal) FROM postgres;


--
-- TOC entry 4836 (class 0 OID 0)
-- Dependencies: 577
-- Name: FUNCTION gtrgm_consistent(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 580
-- Name: FUNCTION gtrgm_decompress(internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gtrgm_decompress(internal) FROM postgres;


--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 578
-- Name: FUNCTION gtrgm_distance(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) FROM postgres;


--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 581
-- Name: FUNCTION gtrgm_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) FROM postgres;


--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 582
-- Name: FUNCTION gtrgm_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) FROM postgres;


--
-- TOC entry 4841 (class 0 OID 0)
-- Dependencies: 584
-- Name: FUNCTION gtrgm_same(public.gtrgm, public.gtrgm, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) FROM postgres;


--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 583
-- Name: FUNCTION gtrgm_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.gtrgm_union(internal, internal) FROM postgres;


--
-- TOC entry 4844 (class 0 OID 0)
-- Dependencies: 414
-- Name: FUNCTION int2_dist(smallint, smallint); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.int2_dist(smallint, smallint) FROM postgres;


--
-- TOC entry 4845 (class 0 OID 0)
-- Dependencies: 415
-- Name: FUNCTION int4_dist(integer, integer); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.int4_dist(integer, integer) FROM postgres;


--
-- TOC entry 4846 (class 0 OID 0)
-- Dependencies: 416
-- Name: FUNCTION int8_dist(bigint, bigint); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.int8_dist(bigint, bigint) FROM postgres;


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 417
-- Name: FUNCTION interval_dist(interval, interval); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.interval_dist(interval, interval) FROM postgres;


--
-- TOC entry 4848 (class 0 OID 0)
-- Dependencies: 418
-- Name: FUNCTION oid_dist(oid, oid); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.oid_dist(oid, oid) FROM postgres;


--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 538
-- Name: FUNCTION pg_buffercache_pages(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.pg_buffercache_pages() FROM postgres;


--
-- TOC entry 4850 (class 0 OID 0)
-- Dependencies: 398
-- Name: FUNCTION pg_relpages(relname regclass); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.pg_relpages(relname regclass) FROM postgres;


--
-- TOC entry 4851 (class 0 OID 0)
-- Dependencies: 562
-- Name: FUNCTION pg_relpages(relname text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.pg_relpages(relname text) FROM postgres;


--
-- TOC entry 4852 (class 0 OID 0)
-- Dependencies: 563
-- Name: FUNCTION pgstatginindex(relname regclass, OUT version integer, OUT pending_pages integer, OUT pending_tuples bigint); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.pgstatginindex(relname regclass, OUT version integer, OUT pending_pages integer, OUT pending_tuples bigint) FROM postgres;


--
-- TOC entry 4853 (class 0 OID 0)
-- Dependencies: 495
-- Name: FUNCTION pgstathashindex(relname regclass, OUT version integer, OUT bucket_pages bigint, OUT overflow_pages bigint, OUT bitmap_pages bigint, OUT unused_pages bigint, OUT live_items bigint, OUT dead_items bigint, OUT free_percent double precision); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.pgstathashindex(relname regclass, OUT version integer, OUT bucket_pages bigint, OUT overflow_pages bigint, OUT bitmap_pages bigint, OUT unused_pages bigint, OUT live_items bigint, OUT dead_items bigint, OUT free_percent double precision) FROM postgres;


--
-- TOC entry 4854 (class 0 OID 0)
-- Dependencies: 397
-- Name: FUNCTION pgstatindex(relname regclass, OUT version integer, OUT tree_level integer, OUT index_size bigint, OUT root_block_no bigint, OUT internal_pages bigint, OUT leaf_pages bigint, OUT empty_pages bigint, OUT deleted_pages bigint, OUT avg_leaf_density double precision, OUT leaf_fragmentation double precision); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.pgstatindex(relname regclass, OUT version integer, OUT tree_level integer, OUT index_size bigint, OUT root_block_no bigint, OUT internal_pages bigint, OUT leaf_pages bigint, OUT empty_pages bigint, OUT deleted_pages bigint, OUT avg_leaf_density double precision, OUT leaf_fragmentation double precision) FROM postgres;


--
-- TOC entry 4855 (class 0 OID 0)
-- Dependencies: 537
-- Name: FUNCTION pgstatindex(relname text, OUT version integer, OUT tree_level integer, OUT index_size bigint, OUT root_block_no bigint, OUT internal_pages bigint, OUT leaf_pages bigint, OUT empty_pages bigint, OUT deleted_pages bigint, OUT avg_leaf_density double precision, OUT leaf_fragmentation double precision); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.pgstatindex(relname text, OUT version integer, OUT tree_level integer, OUT index_size bigint, OUT root_block_no bigint, OUT internal_pages bigint, OUT leaf_pages bigint, OUT empty_pages bigint, OUT deleted_pages bigint, OUT avg_leaf_density double precision, OUT leaf_fragmentation double precision) FROM postgres;


--
-- TOC entry 4856 (class 0 OID 0)
-- Dependencies: 412
-- Name: FUNCTION pgstattuple(reloid regclass, OUT table_len bigint, OUT tuple_count bigint, OUT tuple_len bigint, OUT tuple_percent double precision, OUT dead_tuple_count bigint, OUT dead_tuple_len bigint, OUT dead_tuple_percent double precision, OUT free_space bigint, OUT free_percent double precision); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.pgstattuple(reloid regclass, OUT table_len bigint, OUT tuple_count bigint, OUT tuple_len bigint, OUT tuple_percent double precision, OUT dead_tuple_count bigint, OUT dead_tuple_len bigint, OUT dead_tuple_percent double precision, OUT free_space bigint, OUT free_percent double precision) FROM postgres;


--
-- TOC entry 4857 (class 0 OID 0)
-- Dependencies: 561
-- Name: FUNCTION pgstattuple(relname text, OUT table_len bigint, OUT tuple_count bigint, OUT tuple_len bigint, OUT tuple_percent double precision, OUT dead_tuple_count bigint, OUT dead_tuple_len bigint, OUT dead_tuple_percent double precision, OUT free_space bigint, OUT free_percent double precision); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.pgstattuple(relname text, OUT table_len bigint, OUT tuple_count bigint, OUT tuple_len bigint, OUT tuple_percent double precision, OUT dead_tuple_count bigint, OUT dead_tuple_len bigint, OUT dead_tuple_percent double precision, OUT free_space bigint, OUT free_percent double precision) FROM postgres;


--
-- TOC entry 4858 (class 0 OID 0)
-- Dependencies: 507
-- Name: FUNCTION pgstattuple_approx(reloid regclass, OUT table_len bigint, OUT scanned_percent double precision, OUT approx_tuple_count bigint, OUT approx_tuple_len bigint, OUT approx_tuple_percent double precision, OUT dead_tuple_count bigint, OUT dead_tuple_len bigint, OUT dead_tuple_percent double precision, OUT approx_free_space bigint, OUT approx_free_percent double precision); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.pgstattuple_approx(reloid regclass, OUT table_len bigint, OUT scanned_percent double precision, OUT approx_tuple_count bigint, OUT approx_tuple_len bigint, OUT approx_tuple_percent double precision, OUT dead_tuple_count bigint, OUT dead_tuple_len bigint, OUT dead_tuple_percent double precision, OUT approx_free_space bigint, OUT approx_free_percent double precision) FROM postgres;


--
-- TOC entry 4859 (class 0 OID 0)
-- Dependencies: 564
-- Name: FUNCTION set_limit(real); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.set_limit(real) FROM postgres;


--
-- TOC entry 4860 (class 0 OID 0)
-- Dependencies: 565
-- Name: FUNCTION show_limit(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.show_limit() FROM postgres;


--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 566
-- Name: FUNCTION show_trgm(text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.show_trgm(text) FROM postgres;


--
-- TOC entry 4862 (class 0 OID 0)
-- Dependencies: 567
-- Name: FUNCTION similarity(text, text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.similarity(text, text) FROM postgres;


--
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 572
-- Name: FUNCTION similarity_dist(text, text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.similarity_dist(text, text) FROM postgres;


--
-- TOC entry 4864 (class 0 OID 0)
-- Dependencies: 568
-- Name: FUNCTION similarity_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.similarity_op(text, text) FROM postgres;


--
-- TOC entry 4865 (class 0 OID 0)
-- Dependencies: 419
-- Name: FUNCTION time_dist(time without time zone, time without time zone); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.time_dist(time without time zone, time without time zone) FROM postgres;


--
-- TOC entry 4866 (class 0 OID 0)
-- Dependencies: 420
-- Name: FUNCTION ts_dist(timestamp without time zone, timestamp without time zone); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.ts_dist(timestamp without time zone, timestamp without time zone) FROM postgres;


--
-- TOC entry 4867 (class 0 OID 0)
-- Dependencies: 421
-- Name: FUNCTION tstz_dist(timestamp with time zone, timestamp with time zone); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.tstz_dist(timestamp with time zone, timestamp with time zone) FROM postgres;


--
-- TOC entry 4868 (class 0 OID 0)
-- Dependencies: 569
-- Name: FUNCTION word_similarity(text, text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.word_similarity(text, text) FROM postgres;


--
-- TOC entry 4869 (class 0 OID 0)
-- Dependencies: 571
-- Name: FUNCTION word_similarity_commutator_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.word_similarity_commutator_op(text, text) FROM postgres;


--
-- TOC entry 4870 (class 0 OID 0)
-- Dependencies: 574
-- Name: FUNCTION word_similarity_dist_commutator_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) FROM postgres;


--
-- TOC entry 4871 (class 0 OID 0)
-- Dependencies: 573
-- Name: FUNCTION word_similarity_dist_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.word_similarity_dist_op(text, text) FROM postgres;


--
-- TOC entry 4872 (class 0 OID 0)
-- Dependencies: 570
-- Name: FUNCTION word_similarity_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.word_similarity_op(text, text) FROM postgres;


--
-- TOC entry 4873 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE a; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.a FROM postgres;


--
-- TOC entry 4875 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE b; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.b FROM postgres;


--
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE fresh_empl_entering; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.fresh_empl_entering FROM postgres;


--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE fresh_empl_entering_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.fresh_empl_entering_id_seq FROM postgres;


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE host_info; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.host_info FROM postgres;


--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 224
-- Name: SEQUENCE host_info_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.host_info_id_seq FROM postgres;


--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE host_users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.host_users FROM postgres;


--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 226
-- Name: SEQUENCE host_users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.host_users_id_seq FROM postgres;


--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE host_users_test_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.host_users_test_id_seq FROM postgres;


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE host_users_test; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.host_users_test FROM postgres;


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE msg_history_backup; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.msg_history_backup FROM postgres;


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE msg_history_view; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.msg_history_view FROM postgres;


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE msg_stat; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.msg_stat FROM postgres;


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 251
-- Name: SEQUENCE msg_stat_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.msg_stat_id_seq FROM postgres;


--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE muc_room_history_backup; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.muc_room_history_backup FROM postgres;


--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE non_human; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.non_human FROM postgres;


--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 272
-- Name: SEQUENCE non_human_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.non_human_id_seq FROM postgres;


--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE person_extent_2017_09_22; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.person_extent_2017_09_22 FROM postgres;


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 278
-- Name: TABLE person_extent_2018_07_12; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.person_extent_2018_07_12 FROM postgres;


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE pg_buffercache; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.pg_buffercache FROM postgres;


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 297
-- Name: TABLE qcloud_main; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.qcloud_main FROM postgres;


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 298
-- Name: TABLE qcloud_main_history; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.qcloud_main_history FROM postgres;


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 299
-- Name: SEQUENCE qcloud_main_history_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.qcloud_main_history_id_seq FROM postgres;


--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 300
-- Name: SEQUENCE qcloud_main_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.qcloud_main_id_seq FROM postgres;


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 301
-- Name: TABLE qcloud_sub; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.qcloud_sub FROM postgres;


--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 302
-- Name: TABLE qcloud_sub_history; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.qcloud_sub_history FROM postgres;


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 303
-- Name: SEQUENCE qcloud_sub_history_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.qcloud_sub_history_id_seq FROM postgres;


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 304
-- Name: SEQUENCE qcloud_sub_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.qcloud_sub_id_seq FROM postgres;


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE revoke_msg_history_backup; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.revoke_msg_history_backup FROM postgres;


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 314
-- Name: TABLE robot_pubsub_test; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.robot_pubsub_test FROM postgres;


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE scheduling_info; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.scheduling_info FROM postgres;


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 322
-- Name: SEQUENCE scheduling_info_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.scheduling_info_id_seq FROM postgres;


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 346
-- Name: SEQUENCE vcard_version_test_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.vcard_version_test_id_seq FROM postgres;


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE vcard_version_test; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.vcard_version_test FROM postgres;


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE warn_msg_history; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.warn_msg_history FROM postgres;


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 351
-- Name: SEQUENCE warn_msg_history_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.warn_msg_history_id_seq FROM postgres;


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE warn_msg_history_backup; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.warn_msg_history_backup FROM postgres;


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE white_list_test; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.white_list_test FROM postgres;


-- Completed on 2018-12-13 17:11:42 CST

--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

-- Started on 2018-12-13 17:11:42 CST

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
-- TOC entry 3010 (class 0 OID 0)
-- Dependencies: 3009
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 1 (class 3079 OID 13086)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3012 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


-- Completed on 2018-12-13 17:11:42 CST

--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

-- Started on 2018-12-13 17:11:42 CST

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
-- TOC entry 3010 (class 0 OID 0)
-- Dependencies: 3009
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- TOC entry 1 (class 3079 OID 13086)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3012 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


-- Completed on 2018-12-13 17:11:43 CST

--
-- PostgreSQL database dump complete
--

-- Completed on 2018-12-13 17:11:43 CST

--
-- PostgreSQL database cluster dump complete
--

