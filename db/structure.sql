--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: achievements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE achievements (
    id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    key character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image character varying
);


--
-- Name: achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE achievements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE achievements_id_seq OWNED BY achievements.id;


--
-- Name: achievements_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE achievements_users (
    id integer NOT NULL,
    achievement_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: achievements_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE achievements_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: achievements_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE achievements_users_id_seq OWNED BY achievements_users.id;


--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    namespace character varying,
    body text,
    resource_id character varying NOT NULL,
    resource_type character varying NOT NULL,
    author_id integer,
    author_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cities (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cities_id_seq OWNED BY cities.id;


--
-- Name: lounges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lounges (
    id integer NOT NULL,
    title character varying,
    city_id integer,
    color character varying,
    blazon character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lounges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lounges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lounges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lounges_id_seq OWNED BY lounges.id;


--
-- Name: meets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE meets (
    id integer NOT NULL,
    reservation_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: meets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE meets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE meets_id_seq OWNED BY meets.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payments (
    id integer NOT NULL,
    amount integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payments_id_seq OWNED BY payments.id;


--
-- Name: reservations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reservations (
    id integer NOT NULL,
    table_id integer,
    visit_date timestamp without time zone,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    idrref bytea
);


--
-- Name: reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reservations_id_seq OWNED BY reservations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: skill_hierarchies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skill_hierarchies (
    ancestor_id integer NOT NULL,
    descendant_id integer NOT NULL,
    generations integer NOT NULL
);


--
-- Name: skills; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skills (
    id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image character varying,
    ancestry character varying,
    cost integer DEFAULT 1,
    parent_id integer
);


--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skills_id_seq OWNED BY skills.id;


--
-- Name: skills_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skills_links (
    id integer NOT NULL,
    parent_id integer,
    child_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skills_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skills_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skills_links_id_seq OWNED BY skills_links.id;


--
-- Name: skills_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skills_users (
    id integer NOT NULL,
    skill_id integer,
    user_id integer
);


--
-- Name: skills_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skills_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skills_users_id_seq OWNED BY skills_users.id;


--
-- Name: tables; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tables (
    id integer NOT NULL,
    title character varying,
    lounge_id integer,
    seats integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tables_id_seq OWNED BY tables.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    role integer,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_id integer,
    invited_by_type character varying,
    invitations_count integer DEFAULT 0,
    phone character varying,
    phone_token character varying,
    experience numeric DEFAULT 0,
    level integer DEFAULT 1,
    skill_point integer DEFAULT 0,
    avatar character varying,
    auth_token character varying,
    email character varying,
    spent_money numeric(8,2),
    idrref bytea
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY achievements ALTER COLUMN id SET DEFAULT nextval('achievements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY achievements_users ALTER COLUMN id SET DEFAULT nextval('achievements_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities ALTER COLUMN id SET DEFAULT nextval('cities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lounges ALTER COLUMN id SET DEFAULT nextval('lounges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY meets ALTER COLUMN id SET DEFAULT nextval('meets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments ALTER COLUMN id SET DEFAULT nextval('payments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reservations ALTER COLUMN id SET DEFAULT nextval('reservations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skills ALTER COLUMN id SET DEFAULT nextval('skills_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skills_links ALTER COLUMN id SET DEFAULT nextval('skills_links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skills_users ALTER COLUMN id SET DEFAULT nextval('skills_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tables ALTER COLUMN id SET DEFAULT nextval('tables_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- Name: achievements_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY achievements_users
    ADD CONSTRAINT achievements_users_pkey PRIMARY KEY (id);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: lounges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lounges
    ADD CONSTRAINT lounges_pkey PRIMARY KEY (id);


--
-- Name: meets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY meets
    ADD CONSTRAINT meets_pkey PRIMARY KEY (id);


--
-- Name: payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: skills_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skills_links
    ADD CONSTRAINT skills_links_pkey PRIMARY KEY (id);


--
-- Name: skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: skills_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skills_users
    ADD CONSTRAINT skills_users_pkey PRIMARY KEY (id);


--
-- Name: tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_achievements_users_on_achievement_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_achievements_users_on_achievement_id ON achievements_users USING btree (achievement_id);


--
-- Name: index_achievements_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_achievements_users_on_user_id ON achievements_users USING btree (user_id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_lounges_on_city_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lounges_on_city_id ON lounges USING btree (city_id);


--
-- Name: index_meets_on_reservation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_meets_on_reservation_id ON meets USING btree (reservation_id);


--
-- Name: index_meets_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_meets_on_user_id ON meets USING btree (user_id);


--
-- Name: index_payments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payments_on_user_id ON payments USING btree (user_id);


--
-- Name: index_reservations_on_table_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reservations_on_table_id ON reservations USING btree (table_id);


--
-- Name: index_reservations_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reservations_on_user_id ON reservations USING btree (user_id);


--
-- Name: index_tables_on_lounge_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tables_on_lounge_id ON tables USING btree (lounge_id);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON users USING btree (invitation_token);


--
-- Name: index_users_on_invitations_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_invitations_count ON users USING btree (invitations_count);


--
-- Name: index_users_on_invited_by_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_invited_by_id ON users USING btree (invited_by_id);


--
-- Name: index_users_on_phone; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_phone ON users USING btree (phone);


--
-- Name: index_users_on_phone_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_phone_token ON users USING btree (phone_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: skill_anc_desc_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX skill_anc_desc_idx ON skill_hierarchies USING btree (ancestor_id, descendant_id, generations);


--
-- Name: skill_desc_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skill_desc_idx ON skill_hierarchies USING btree (descendant_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_081dc04a02; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT fk_rails_081dc04a02 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_23ce71128d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reservations
    ADD CONSTRAINT fk_rails_23ce71128d FOREIGN KEY (table_id) REFERENCES tables(id);


--
-- Name: fk_rails_48a92fce51; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reservations
    ADD CONSTRAINT fk_rails_48a92fce51 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_48c504a13c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY achievements_users
    ADD CONSTRAINT fk_rails_48c504a13c FOREIGN KEY (achievement_id) REFERENCES achievements(id);


--
-- Name: fk_rails_5a74a04b93; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY meets
    ADD CONSTRAINT fk_rails_5a74a04b93 FOREIGN KEY (reservation_id) REFERENCES reservations(id);


--
-- Name: fk_rails_9714ca694f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY meets
    ADD CONSTRAINT fk_rails_9714ca694f FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_b31babba9a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tables
    ADD CONSTRAINT fk_rails_b31babba9a FOREIGN KEY (lounge_id) REFERENCES lounges(id);


--
-- Name: fk_rails_be1053a52e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY achievements_users
    ADD CONSTRAINT fk_rails_be1053a52e FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_c95b188c7b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lounges
    ADD CONSTRAINT fk_rails_c95b188c7b FOREIGN KEY (city_id) REFERENCES cities(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151026083731');

INSERT INTO schema_migrations (version) VALUES ('20151026083735');

INSERT INTO schema_migrations (version) VALUES ('20151026083738');

INSERT INTO schema_migrations (version) VALUES ('20151026083744');

INSERT INTO schema_migrations (version) VALUES ('20151026083817');

INSERT INTO schema_migrations (version) VALUES ('20151027085335');

INSERT INTO schema_migrations (version) VALUES ('20151027102829');

INSERT INTO schema_migrations (version) VALUES ('20151029093841');

INSERT INTO schema_migrations (version) VALUES ('20151029095446');

INSERT INTO schema_migrations (version) VALUES ('20151029103007');

INSERT INTO schema_migrations (version) VALUES ('20151030140601');

INSERT INTO schema_migrations (version) VALUES ('20151030141026');

INSERT INTO schema_migrations (version) VALUES ('20151102152908');

INSERT INTO schema_migrations (version) VALUES ('20151102152934');

INSERT INTO schema_migrations (version) VALUES ('20151103112905');

INSERT INTO schema_migrations (version) VALUES ('20151103124552');

INSERT INTO schema_migrations (version) VALUES ('20151105111648');

INSERT INTO schema_migrations (version) VALUES ('20151105153953');

INSERT INTO schema_migrations (version) VALUES ('20151105164205');

INSERT INTO schema_migrations (version) VALUES ('20151106113129');

INSERT INTO schema_migrations (version) VALUES ('20151106125755');

INSERT INTO schema_migrations (version) VALUES ('20151106130013');

INSERT INTO schema_migrations (version) VALUES ('20151109124608');

INSERT INTO schema_migrations (version) VALUES ('20151109143056');

INSERT INTO schema_migrations (version) VALUES ('20151114161248');

INSERT INTO schema_migrations (version) VALUES ('20151117110321');

INSERT INTO schema_migrations (version) VALUES ('20151117112513');

INSERT INTO schema_migrations (version) VALUES ('20151118104002');

INSERT INTO schema_migrations (version) VALUES ('20151118104702');

INSERT INTO schema_migrations (version) VALUES ('20151118115824');

INSERT INTO schema_migrations (version) VALUES ('20151127100242');

INSERT INTO schema_migrations (version) VALUES ('20151130115444');

INSERT INTO schema_migrations (version) VALUES ('20151201122419');

