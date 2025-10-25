--
-- PostgreSQL database dump
--

\restrict vBpQsplp4OHxo2d0J71fSrm3rZ27Xifkg6Hkb6hiAFFmWWULFdnsnORauWgu3mK

-- Dumped from database version 16.10 (Ubuntu 16.10-1.pgdg24.04+1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-1.pgdg24.04+1)

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: document_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.document_status_enum AS ENUM (
    'pending',
    'approved',
    'rejected'
);


ALTER TYPE public.document_status_enum OWNER TO postgres;

--
-- Name: document_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.document_type_enum AS ENUM (
    'id_card',
    'selfie',
    'passport',
    'drivers_license'
);


ALTER TYPE public.document_type_enum OWNER TO postgres;

--
-- Name: escrow_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.escrow_status_enum AS ENUM (
    'held',
    'released',
    'refunded'
);


ALTER TYPE public.escrow_status_enum OWNER TO postgres;

--
-- Name: kyc_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.kyc_status_enum AS ENUM (
    'pending',
    'approved',
    'rejected'
);


ALTER TYPE public.kyc_status_enum OWNER TO postgres;

--
-- Name: otp_purpose_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.otp_purpose_enum AS ENUM (
    'registration',
    'login',
    'transaction',
    'password_reset'
);


ALTER TYPE public.otp_purpose_enum OWNER TO postgres;

--
-- Name: transaction_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transaction_status_enum AS ENUM (
    'pending',
    'in_escrow',
    'completed',
    'refunded',
    'disputed',
    'cancelled'
);


ALTER TYPE public.transaction_status_enum OWNER TO postgres;

--
-- Name: transaction_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transaction_type_enum AS ENUM (
    'escrow',
    'direct'
);


ALTER TYPE public.transaction_type_enum OWNER TO postgres;

--
-- Name: user_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_type_enum AS ENUM (
    'buyer',
    'seller',
    'rider'
);


ALTER TYPE public.user_type_enum OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: disputes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disputes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    transaction_id uuid NOT NULL,
    raised_by uuid NOT NULL,
    reason text NOT NULL,
    status character varying(20) DEFAULT 'open'::character varying,
    resolution text,
    resolved_by uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    resolved_at timestamp without time zone
);


ALTER TABLE public.disputes OWNER TO postgres;

--
-- Name: escrow_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.escrow_accounts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    transaction_id uuid NOT NULL,
    amount numeric(15,2) NOT NULL,
    status public.escrow_status_enum DEFAULT 'held'::public.escrow_status_enum,
    held_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    released_at timestamp without time zone,
    refunded_at timestamp without time zone,
    notes text,
    CONSTRAINT escrow_accounts_amount_check CHECK ((amount > (0)::numeric))
);


ALTER TABLE public.escrow_accounts OWNER TO postgres;

--
-- Name: kyc_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kyc_documents (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    document_type public.document_type_enum NOT NULL,
    document_url character varying(255) NOT NULL,
    status public.document_status_enum DEFAULT 'pending'::public.document_status_enum,
    rejection_reason text,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    verified_at timestamp without time zone,
    verified_by uuid
);


ALTER TABLE public.kyc_documents OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    title character varying(100) NOT NULL,
    message text NOT NULL,
    type character varying(50) NOT NULL,
    is_read boolean DEFAULT false,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    read_at timestamp without time zone
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: otp_verifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_verifications (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    phone_number character varying(20) NOT NULL,
    otp_code character varying(6) NOT NULL,
    purpose public.otp_purpose_enum NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    verified boolean DEFAULT false,
    verified_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    attempts integer DEFAULT 0,
    CONSTRAINT otp_verifications_attempts_check CHECK ((attempts >= 0))
);


ALTER TABLE public.otp_verifications OWNER TO postgres;

--
-- Name: transaction_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction_logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    transaction_id uuid NOT NULL,
    action character varying(100) NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);


ALTER TABLE public.transaction_logs OWNER TO postgres;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    transaction_ref character varying(50) NOT NULL,
    buyer_id uuid NOT NULL,
    seller_id uuid NOT NULL,
    rider_id uuid,
    amount numeric(15,2) NOT NULL,
    commission numeric(15,2) DEFAULT 0.00,
    status public.transaction_status_enum DEFAULT 'pending'::public.transaction_status_enum,
    type public.transaction_type_enum NOT NULL,
    description text,
    payment_method character varying(50),
    payment_reference character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    completed_at timestamp without time zone,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_check CHECK ((buyer_id <> seller_id))
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying(50) NOT NULL,
    phone_number character varying(20) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(100) NOT NULL,
    user_type public.user_type_enum NOT NULL,
    email character varying(100),
    is_verified boolean DEFAULT false,
    is_active boolean DEFAULT true,
    kyc_status public.kyc_status_enum DEFAULT 'pending'::public.kyc_status_enum,
    profile_image_url character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_login_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: wallet_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallet_transactions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    wallet_id uuid NOT NULL,
    amount numeric(15,2) NOT NULL,
    type character varying(20) NOT NULL,
    description text,
    reference character varying(100),
    balance_before numeric(15,2) NOT NULL,
    balance_after numeric(15,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.wallet_transactions OWNER TO postgres;

--
-- Name: wallets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallets (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    balance numeric(15,2) DEFAULT 0.00,
    currency character varying(3) DEFAULT 'GHS'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.wallets OWNER TO postgres;

--
-- Data for Name: disputes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disputes (id, transaction_id, raised_by, reason, status, resolution, resolved_by, created_at, resolved_at) FROM stdin;
\.


--
-- Data for Name: escrow_accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.escrow_accounts (id, transaction_id, amount, status, held_at, released_at, refunded_at, notes) FROM stdin;
3241231f-f507-4693-96fd-bf715c326afc	422d68aa-5a8a-462f-bd6f-3cade391d353	150.00	released	2025-10-24 17:18:07.340774	2025-10-24 17:22:15.362104	\N	Delivery confirmed by buyer
\.


--
-- Data for Name: kyc_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kyc_documents (id, user_id, document_type, document_url, status, rejection_reason, uploaded_at, verified_at, verified_by) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, title, message, type, is_read, metadata, created_at, read_at) FROM stdin;
111313be-6336-4eee-9ac4-978a6601a57d	9578ff5c-694e-49e0-b5d3-0b02c3d22e7f	New Escrow Payment	You have received an escrow payment of GHS 150 for: Laptop	transaction	f	\N	2025-10-24 17:18:07.340774	\N
e1d45733-8567-42a9-bccd-c5c82188edcf	9578ff5c-694e-49e0-b5d3-0b02c3d22e7f	Payment Released	Delivery confirmed! GHS 147.00 has been credited to your wallet.	transaction	f	\N	2025-10-24 17:22:15.362104	\N
\.


--
-- Data for Name: otp_verifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otp_verifications (id, phone_number, otp_code, purpose, expires_at, verified, verified_at, created_at, attempts) FROM stdin;
bd9f0368-be7f-473c-a4e7-a128d6c87f97	+233241234567	611643	registration	2025-10-24 10:40:01.498	t	2025-10-24 10:35:37.383701	2025-10-24 10:35:01.499419	0
081c5c30-006c-41b7-9ed4-8dc8b4e69462	+233241234567	967352	login	2025-10-24 10:41:40.661	t	2025-10-24 10:37:05.868317	2025-10-24 10:36:40.662768	0
e0a11e71-a2ea-49f3-82d9-a1250925dec5	+233247654321	200991	registration	2025-10-24 10:42:47.501	f	\N	2025-10-24 10:37:47.502393	0
ea1fd36a-8732-43c5-8ffa-de934747e364	+233243334444	372787	registration	2025-10-24 10:42:55.323	f	\N	2025-10-24 10:37:55.323943	0
b99f76c8-df01-4276-8ef6-657781ed3ba2	+233241234567	453875	login	2025-10-24 10:42:19.747	f	\N	2025-10-24 10:37:19.74808	1
b96078b4-3262-4c34-9cf9-696333d090dc	+233241234567	929620	login	2025-10-24 17:14:50.466	t	2025-10-24 17:09:57.468426	2025-10-24 17:09:50.467163	0
70e290ce-43bc-42c6-9e6f-fa7f01716f3b	+233245555555	054820	registration	2025-10-24 10:45:39.765	t	2025-10-24 10:41:10.048508	2025-10-24 10:40:39.765884	1
c8733dea-b429-40d9-b7f6-cf0231079616	+233245555555	058419	login	2025-10-24 10:46:55.139	f	\N	2025-10-24 10:41:55.140804	0
a735c66e-3650-46ac-9f96-87fe37f7fefc	+233245555555	488541	login	2025-10-24 11:08:52.523	f	\N	2025-10-24 11:03:52.52522	0
bfbcebd3-ee60-492a-9d20-c9363b84fa8e	+233245555555	903021	login	2025-10-24 11:09:06.306	f	\N	2025-10-24 11:04:06.307862	0
3c57a668-b514-4070-ac44-1b281fecc757	+233245555555	130331	login	2025-10-24 11:16:27.492	t	2025-10-24 11:11:39.434189	2025-10-24 11:11:27.494409	0
0cb514bf-c17e-4649-8d59-56484fc68ce0	+233246666666	436677	registration	2025-10-24 11:18:31.638	t	2025-10-24 11:13:45.690037	2025-10-24 11:13:31.639697	0
0f8377eb-540d-44ad-a6e7-dd954d14d591	+233246666666	271604	login	2025-10-24 11:19:23.622	t	2025-10-24 11:14:34.953108	2025-10-24 11:14:23.62319	0
c53c2e12-1f28-4f24-8b33-4262a9b78895	+233247777777	134821	registration	2025-10-24 11:20:41.276	t	2025-10-24 11:15:52.572066	2025-10-24 11:15:41.276658	0
a445610f-e7ba-4798-8f4f-38d648a54e5c	+233245555555	103027	login	2025-10-24 11:22:40.529	f	\N	2025-10-24 11:17:40.530151	0
96fee2ad-d1d0-4454-a089-6971c1ddbe5b	+233245555555	153817	login	2025-10-24 11:23:31.307	t	2025-10-24 11:18:40.931992	2025-10-24 11:18:31.308216	0
719365c6-deaf-4d0e-9a7a-0947a5a820c3	+233248888888	006563	registration	2025-10-24 11:25:51.458	f	\N	2025-10-24 11:20:51.459549	0
5b599bb6-201d-4457-b071-f84e06a2d9fc	+233248888888	340846	registration	2025-10-24 11:33:23.292	t	2025-10-24 11:28:32.713877	2025-10-24 11:28:23.29332	0
0dd17b78-cc0b-4323-918b-a7c3c2b2ef59	+233245555555	634631	login	2025-10-24 13:51:39.304	t	2025-10-24 13:46:50.652552	2025-10-24 13:46:39.305425	0
c3b36761-a733-46e6-9eca-cb5ed38d740f	+233241111111	871101	registration	2025-10-24 13:53:08.794	t	2025-10-24 13:48:21.769382	2025-10-24 13:48:08.795129	0
973d53e8-42e9-45c6-bcfd-e2170478cb69	+233241111111	420786	login	2025-10-24 13:53:22.008	t	2025-10-24 13:48:30.792636	2025-10-24 13:48:22.008865	0
c35094e3-c201-49be-be48-82979d410b2a	+233241111111	084481	login	2025-10-24 13:53:30.902	f	\N	2025-10-24 13:48:30.902664	0
72a7e0f4-36cc-4f5d-8b9e-4c1678c74e24	+233242222222	550706	registration	2025-10-24 13:53:31.016	f	\N	2025-10-24 13:48:31.016955	0
5ae19332-f881-4334-bb42-c3b9272a98c9	+233243333333	472831	registration	2025-10-24 13:53:31.188	f	\N	2025-10-24 13:48:31.188471	0
46dd9ade-489e-4698-b8ce-c92b9db63a8a	+233176131564	389319	registration	2025-10-24 14:25:42.123	f	\N	2025-10-24 14:20:42.124	1
e4b4763e-dfe1-458b-af33-074642506471	+233176131574	891955	registration	2025-10-24 14:27:22.775	f	\N	2025-10-24 14:22:22.77543	1
1452e73f-b62b-4161-b847-5513139d5b21	+233176131590	893616	registration	2025-10-24 14:30:04.047	f	\N	2025-10-24 14:25:04.047321	0
6cefaf56-113d-4623-a24f-7468ac174348	+233245001001	945514	registration	2025-10-24 14:36:19.841	t	2025-10-24 14:31:31.455519	2025-10-24 14:31:19.841999	0
a224859a-90bc-4525-beed-255d206fb3b1	+233245002002	957177	registration	2025-10-24 14:36:36.544	t	2025-10-24 14:31:45.211897	2025-10-24 14:31:36.544422	0
76377b49-d627-446b-938d-e75611f01fcb	+233244999999	859330	registration	2025-10-24 14:42:57.016	t	2025-10-24 14:38:12.517508	2025-10-24 14:37:57.017502	0
7c714ae4-3be8-49eb-bae3-805ded732a76	+233244000000	392934	registration	2025-10-24 14:43:50.246	t	2025-10-24 14:39:21.669053	2025-10-24 14:38:50.247148	1
2c3eeec2-43ec-4967-b1ec-f4daa4842b78	+233245555555	341139	login	2025-10-24 14:50:18.612	t	2025-10-24 14:45:38.541368	2025-10-24 14:45:18.612629	0
4180b99b-34f3-483e-904b-fddf7c2891cd	+233241234567	861985	login	2025-10-24 14:58:22.907	t	2025-10-24 14:53:33.69262	2025-10-24 14:53:22.907784	0
7ced42b1-9666-43d2-944b-9aa0390f09d6	+233241234567	257267	login	2025-10-24 15:00:49.402	t	2025-10-24 14:55:58.776944	2025-10-24 14:55:49.403358	0
0312860f-b6bf-4847-bf2d-39f97f5d7961	+233241234567	730767	login	2025-10-24 16:28:37.047	t	2025-10-24 16:23:50.957473	2025-10-24 16:23:37.048491	0
edf3cf52-9f23-4d0e-bfc0-54ef59241797	+233244999999	079818	login	2025-10-24 16:29:31.83	t	2025-10-24 16:24:41.117889	2025-10-24 16:24:31.830441	0
a4817f0d-1a25-425c-9188-17a6e82c1aa5	+233241234567	241460	login	2025-10-24 16:53:03.531	t	2025-10-24 16:48:17.672489	2025-10-24 16:48:03.53266	0
d51b685f-3c18-43e0-94f9-c6a3b5d643c0	+233241234567	181497	login	2025-10-24 17:22:28.243	t	2025-10-24 17:17:39.95676	2025-10-24 17:17:28.243764	0
abeb1b8a-49b4-41b4-822a-bd4526b42431	+233244999999	631354	login	2025-10-24 17:24:43.553	t	2025-10-24 17:19:50.294334	2025-10-24 17:19:43.554019	0
9f68ec0a-15be-48c7-bd7d-f20e72d688c2	+233241234567	904067	login	2025-10-24 17:26:32.265	t	2025-10-24 17:21:48.179256	2025-10-24 17:21:32.266211	0
\.


--
-- Data for Name: transaction_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction_logs (id, transaction_id, action, description, metadata, created_at, created_by) FROM stdin;
116a75a3-8d9e-473b-9e63-28cd5983f473	422d68aa-5a8a-462f-bd6f-3cade391d353	created	Escrow transaction created	\N	2025-10-24 17:18:07.340774	bda6ab6a-46dc-45f6-9d0d-57f7d94e6253
cff1406c-e357-4cc4-a350-8dc14bb826b0	422d68aa-5a8a-462f-bd6f-3cade391d353	completed	Delivery confirmed. Funds released to seller	\N	2025-10-24 17:22:15.362104	bda6ab6a-46dc-45f6-9d0d-57f7d94e6253
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, transaction_ref, buyer_id, seller_id, rider_id, amount, commission, status, type, description, payment_method, payment_reference, created_at, updated_at, completed_at) FROM stdin;
422d68aa-5a8a-462f-bd6f-3cade391d353	ESC176132628733987JKPCKTM	bda6ab6a-46dc-45f6-9d0d-57f7d94e6253	9578ff5c-694e-49e0-b5d3-0b02c3d22e7f	\N	150.00	3.00	completed	escrow	Laptop	wallet	\N	2025-10-24 17:18:07.340774	2025-10-24 17:22:15.362104	2025-10-24 17:22:15.362104
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, phone_number, password_hash, full_name, user_type, email, is_verified, is_active, kyc_status, profile_image_url, created_at, updated_at, last_login_at) FROM stdin;
9112455c-f5fe-4f14-9466-a673f046a7da	admin	+233000000000	$2a$10$rGHvQZXm8l.xM5PxN8yZ.uYvXZDK9F8T3qQJ8aJ9I0YPH7N3QV6Wu	System Administrator	buyer	admin@suresend.com	t	t	approved	\N	2025-10-24 10:33:15.757647	2025-10-24 10:33:15.757647	\N
ba080b54-fe61-4112-b718-ffcf6e49d622	testbuyerstage03	+233245001001	$2a$10$P7QbIAEu5qEak0Eg4mp6q.4A.Uwk3N8tZpnkgASIDjSXeedfVTrgG	Stage 3 Test Buyer	buyer	buyer.stage3@test.com	t	t	pending	\N	2025-10-24 14:31:19.841999	2025-10-24 14:31:31.462484	2025-10-24 14:31:31.462484
4d06a979-c816-41dd-b5ba-41f31dfbedc4	testseller	+233247654321	$2a$10$vwxwHL17USxU4dVPvpAoGODnNDVGmNJzrGjkwvnoM/V9jwWtA1gnS	Test Seller	seller	\N	f	t	pending	\N	2025-10-24 10:37:47.502393	2025-10-24 10:37:47.502393	\N
c4cd87c7-e24a-407c-a449-f632e3e713d6	testrider	+233243334444	$2a$10$/PY/sMoPzDrIrnwVEmjFPeLkUIryK3ToFb2sJ36fimTwqv7h26BqC	Test Rider	rider	\N	f	t	pending	\N	2025-10-24 10:37:55.323943	2025-10-24 10:37:55.323943	\N
bea06074-4ea2-42cf-a24e-28dfde1f99aa	testsellerstage3	+233245002002	$2a$10$VPwESvQvhlDAVhURybfLr.xhvqAquhUDOd.EDhSYma7/h2RK3l3iq	Stage 3 Test Seller	seller	\N	t	t	pending	\N	2025-10-24 14:31:36.544422	2025-10-24 14:31:45.276876	2025-10-24 14:31:45.276876
e4e15bf3-29e8-4128-8bf5-a01bbd2a1f95	mobileseller	+233246666666	$2a$10$Mcnsoac12daKjnltbMbIQeDUGnJdBOufmBuFERTyzuG6/Nzcaj6gq	Mobile Seller	seller	seller@email.com	t	t	pending	\N	2025-10-24 11:13:31.639697	2025-10-24 11:14:35.018929	2025-10-24 11:14:35.018929
f7f45ca6-3c62-4ae9-89d2-c1604ea055b6	mobilerider	+233247777777	$2a$10$UD9k0or1oJRyeGqlXSYBZeYyb0GhDztyXY2SaI4bkxZLf054xgeHm	Mobile Rider	rider	rider@email.com	t	t	pending	\N	2025-10-24 11:15:41.276658	2025-10-24 11:15:52.644822	2025-10-24 11:15:52.644822
bbfc37cd-e4df-4ed0-be1f-96318903e877	thomasthompson	+233244000000	$2a$10$8pPYEmfbEmYOAWvoOfLcjODQg.tfN409Hlk1T6g0ESuQ7MAr4hKr.	Thomas Thompson	buyer	\N	t	t	pending	\N	2025-10-24 14:38:50.247148	2025-10-24 14:39:21.736218	2025-10-24 14:39:21.736218
c129373f-c592-43c9-9229-b2b057aaf75b	mobilebuyer	+233245555555	$2a$10$UAd/5n3MUEQ57FUgUDJDMeS9QgLTplGwyzOzZU7pb1CQqQZ2dpjTy	Mobile Test Buyer	buyer	mobile@test.com	t	t	pending	\N	2025-10-24 10:40:39.765884	2025-10-24 14:45:38.60308	2025-10-24 14:45:38.60308
d4a14f95-b5c5-4157-b590-4ff8542f45b0	mobilenii	+233248888888	$2a$10$WXY.sQEnVLWcjp9uDXzvdO0BGjuq6CSJr6D3giq/8dCnJTu0IWfo6	Mobile Nii	buyer	\N	t	t	pending	\N	2025-10-24 11:20:51.459549	2025-10-24 11:28:32.787444	2025-10-24 11:28:32.787444
ec6a5b60-8c99-461e-ad3f-6cbeb6361572	testbuyer123	+233241111111	$2a$10$X68XqMv16oWFjW35A3Q9kujy20biBztWUDFMtMrDDrEVoMdUv.20u	Test Buyer Updated	buyer	updated@example.com	t	t	pending	\N	2025-10-24 13:48:08.795129	2025-10-24 13:48:30.862676	2025-10-24 13:48:30.862676
48296c79-52e1-4750-97e8-67088fbf907c	testseller123	+233242222222	$2a$10$HcAqZAz82UbzrYDvHb2Kg.wGXGb./7TgkuIH1VayD4MyjmAM66E1S	Test Seller Script	seller	\N	f	t	pending	\N	2025-10-24 13:48:31.016955	2025-10-24 13:48:31.016955	\N
8e639280-8293-444d-a5d0-7d9a570111ba	testrider123	+233243333333	$2a$10$sJgGp4FRy/aaZNcM9rTvBu3MqoqSvdUtFlaM5n5ERPf4t6lep884e	Test Rider Script	rider	\N	f	t	pending	\N	2025-10-24 13:48:31.188471	2025-10-24 13:48:31.188471	\N
2afad7c7-f187-4455-8ccc-0458f257dfba	testbuyerr1761315641	+233176131564	$2a$10$8Iu8erHHeej0jHNcinqy0OV6Vmb5J8Vk6WVWrAxCMdR5XMjEAlqFG	Test Buyer	buyer	testbuyer1761315641@example.com	f	t	pending	\N	2025-10-24 14:20:42.124	2025-10-24 14:20:42.124	\N
f2cbbe0f-8157-42db-be21-c8f14087ddff	testbuyerr1761315742	+233176131574	$2a$10$WicynnlkZ3qds0IUPDPH/etZ8AhHOzbBhaG9OH5Y26QGcXIRQhpGy	Test Buyer	buyer	testbuyer1761315742@example.com	f	t	pending	\N	2025-10-24 14:22:22.77543	2025-10-24 14:22:22.77543	\N
b84765fd-0502-4371-811e-dcf876835524	testbuyer1761315903	+233176131590	$2a$10$YbrsCedHm.XqNPTglq0cJ.VlLLITHOgsDcyI0sEV4HUbcD3duUgWu	Test Buyer	buyer	testbuyer1761315903@example.com	f	t	pending	\N	2025-10-24 14:25:04.047321	2025-10-24 14:25:04.047321	\N
9578ff5c-694e-49e0-b5d3-0b02c3d22e7f	terrythompson	+233244999999	$2a$10$uqDE7I05N.yLW95fEkGcx.mjEqZcUJorZ7buOjtI/nz7PikBEPuVO	Terry Thompson	seller	\N	t	t	pending	\N	2025-10-24 14:37:57.017502	2025-10-24 17:19:50.3571	2025-10-24 17:19:50.3571
bda6ab6a-46dc-45f6-9d0d-57f7d94e6253	testbuyer	+233241234567	$2a$10$modKSojfRIqYKnmKus2Y5.uOuwfzHcrqtMdPNgoww.ayZRiMlEQuC	Test Buyer Updated	buyer	updated@example.com	t	t	pending	\N	2025-10-24 10:35:01.499419	2025-10-24 17:21:48.241775	2025-10-24 17:21:48.241775
\.


--
-- Data for Name: wallet_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallet_transactions (id, wallet_id, amount, type, description, reference, balance_before, balance_after, created_at) FROM stdin;
1ca507bc-1983-4ac9-9bc3-ac2ea8210afb	596cba19-101a-43ae-ad98-9ad45ed97af2	150.00	debit	Escrow payment	ESC176132628733987JKPCKTM	500.00	350.00	2025-10-24 17:18:07.340774
6e98b8fa-387c-4aed-b899-c6fdcbb2c92d	46dd42d7-0687-4794-910b-d6df20790032	147.00	credit	Escrow payment received	ESC176132628733987JKPCKTM	0.00	147.00	2025-10-24 17:22:15.362104
\.


--
-- Data for Name: wallets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallets (id, user_id, balance, currency, created_at, updated_at) FROM stdin;
ad81ecfc-1d47-43eb-a489-fd3de6546f2e	9112455c-f5fe-4f14-9466-a673f046a7da	0.00	GHS	2025-10-24 10:33:15.760044	2025-10-24 10:33:15.760044
c6dc9dbe-6acc-4f05-8d57-d02843135208	4d06a979-c816-41dd-b5ba-41f31dfbedc4	0.00	GHS	2025-10-24 10:37:47.502393	2025-10-24 10:37:47.502393
04c7a795-74c3-4b30-9152-65cb7ab1461d	c4cd87c7-e24a-407c-a449-f632e3e713d6	0.00	GHS	2025-10-24 10:37:55.323943	2025-10-24 10:37:55.323943
2a379f39-7089-4cee-ba9a-c58da5354335	c129373f-c592-43c9-9229-b2b057aaf75b	0.00	GHS	2025-10-24 10:40:39.765884	2025-10-24 10:40:39.765884
84645757-9929-4f11-9cef-038bde507173	e4e15bf3-29e8-4128-8bf5-a01bbd2a1f95	0.00	GHS	2025-10-24 11:13:31.639697	2025-10-24 11:13:31.639697
279aaaec-4df0-455b-ae3a-a1414713f1dd	f7f45ca6-3c62-4ae9-89d2-c1604ea055b6	0.00	GHS	2025-10-24 11:15:41.276658	2025-10-24 11:15:41.276658
b0427afc-58b5-459c-becf-c4ce6c2280b5	d4a14f95-b5c5-4157-b590-4ff8542f45b0	0.00	GHS	2025-10-24 11:20:51.459549	2025-10-24 11:20:51.459549
314fc424-9a92-4c96-84c6-9ca7c1f6e686	ec6a5b60-8c99-461e-ad3f-6cbeb6361572	0.00	GHS	2025-10-24 13:48:08.795129	2025-10-24 13:48:08.795129
7378eb46-0e72-400c-b743-719d2700e3d6	48296c79-52e1-4750-97e8-67088fbf907c	0.00	GHS	2025-10-24 13:48:31.016955	2025-10-24 13:48:31.016955
57562d26-7e63-496b-8741-18f75747bba8	8e639280-8293-444d-a5d0-7d9a570111ba	0.00	GHS	2025-10-24 13:48:31.188471	2025-10-24 13:48:31.188471
7b42d546-fe83-4dbb-a1ea-d791490ef007	2afad7c7-f187-4455-8ccc-0458f257dfba	0.00	GHS	2025-10-24 14:20:42.124	2025-10-24 14:20:42.124
b2ebaa18-12f5-4903-a8b3-c69c04d27cef	f2cbbe0f-8157-42db-be21-c8f14087ddff	0.00	GHS	2025-10-24 14:22:22.77543	2025-10-24 14:22:22.77543
750f8ecd-347b-463e-86d5-628543047f9d	b84765fd-0502-4371-811e-dcf876835524	0.00	GHS	2025-10-24 14:25:04.047321	2025-10-24 14:25:04.047321
4f0494d6-4c8a-44e3-86b7-5710fadba087	ba080b54-fe61-4112-b718-ffcf6e49d622	500.00	GHS	2025-10-24 14:31:19.841999	2025-10-24 14:31:36.349929
96b2a885-bcf9-4ac5-8bd9-9ecfba2d014c	bea06074-4ea2-42cf-a24e-28dfde1f99aa	0.00	GHS	2025-10-24 14:31:36.544422	2025-10-24 14:31:36.544422
74d6e9f3-3988-4f4b-a65f-73fb779691ea	bbfc37cd-e4df-4ed0-be1f-96318903e877	0.00	GHS	2025-10-24 14:38:50.247148	2025-10-24 14:38:50.247148
596cba19-101a-43ae-ad98-9ad45ed97af2	bda6ab6a-46dc-45f6-9d0d-57f7d94e6253	350.00	GHS	2025-10-24 10:35:01.499419	2025-10-24 17:18:07.340774
46dd42d7-0687-4794-910b-d6df20790032	9578ff5c-694e-49e0-b5d3-0b02c3d22e7f	147.00	GHS	2025-10-24 14:37:57.017502	2025-10-24 17:22:15.362104
\.


--
-- Name: disputes disputes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_pkey PRIMARY KEY (id);


--
-- Name: escrow_accounts escrow_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escrow_accounts
    ADD CONSTRAINT escrow_accounts_pkey PRIMARY KEY (id);


--
-- Name: escrow_accounts escrow_accounts_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escrow_accounts
    ADD CONSTRAINT escrow_accounts_transaction_id_key UNIQUE (transaction_id);


--
-- Name: kyc_documents kyc_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc_documents
    ADD CONSTRAINT kyc_documents_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: otp_verifications otp_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_verifications
    ADD CONSTRAINT otp_verifications_pkey PRIMARY KEY (id);


--
-- Name: transaction_logs transaction_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_logs
    ADD CONSTRAINT transaction_logs_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_transaction_ref_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_transaction_ref_key UNIQUE (transaction_ref);


--
-- Name: users users_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key UNIQUE (phone_number);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: wallet_transactions wallet_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_pkey PRIMARY KEY (id);


--
-- Name: wallets wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- Name: wallets wallets_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_user_id_key UNIQUE (user_id);


--
-- Name: idx_escrow_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escrow_status ON public.escrow_accounts USING btree (status);


--
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id);


--
-- Name: idx_otp_expires; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_otp_expires ON public.otp_verifications USING btree (expires_at);


--
-- Name: idx_otp_phone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_otp_phone ON public.otp_verifications USING btree (phone_number);


--
-- Name: idx_transactions_buyer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_buyer ON public.transactions USING btree (buyer_id);


--
-- Name: idx_transactions_ref; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_ref ON public.transactions USING btree (transaction_ref);


--
-- Name: idx_transactions_seller; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_seller ON public.transactions USING btree (seller_id);


--
-- Name: idx_transactions_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_status ON public.transactions USING btree (status);


--
-- Name: idx_users_phone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_phone ON public.users USING btree (phone_number);


--
-- Name: idx_users_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_type ON public.users USING btree (user_type);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: idx_wallet_transactions_wallet; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wallet_transactions_wallet ON public.wallet_transactions USING btree (wallet_id);


--
-- Name: transactions update_transactions_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: wallets update_wallets_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_wallets_updated_at BEFORE UPDATE ON public.wallets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: disputes disputes_raised_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_raised_by_fkey FOREIGN KEY (raised_by) REFERENCES public.users(id);


--
-- Name: disputes disputes_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.users(id);


--
-- Name: disputes disputes_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputes
    ADD CONSTRAINT disputes_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id);


--
-- Name: escrow_accounts escrow_accounts_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escrow_accounts
    ADD CONSTRAINT escrow_accounts_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


--
-- Name: kyc_documents kyc_documents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc_documents
    ADD CONSTRAINT kyc_documents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: kyc_documents kyc_documents_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc_documents
    ADD CONSTRAINT kyc_documents_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES public.users(id);


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: transaction_logs transaction_logs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_logs
    ADD CONSTRAINT transaction_logs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: transaction_logs transaction_logs_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_logs
    ADD CONSTRAINT transaction_logs_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_buyer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public.users(id);


--
-- Name: transactions transactions_rider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.users(id);


--
-- Name: transactions transactions_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(id);


--
-- Name: wallet_transactions wallet_transactions_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON DELETE CASCADE;


--
-- Name: wallets wallets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict vBpQsplp4OHxo2d0J71fSrm3rZ27Xifkg6Hkb6hiAFFmWWULFdnsnORauWgu3mK

