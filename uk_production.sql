--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY achievements (id, name, description, key, created_at, updated_at, image) FROM stdin;
3	Изобретательность II	Проведите 3 мероприятия в Уникальных Кальянных	izobretatelnost-ii	2015-11-09 12:35:35.967076	2015-11-17 11:47:06.71573	_____________1___________________2.png
17	Энтузиазм	Посетите заведение Уникальных Кальянных в пределах 10 минут после открытия	enjoyment	2015-11-12 15:59:40.103265	2015-11-17 11:24:30.52767	_____________1__________.png
16	Постоянство IX	Проведите в заведениях Уникальных Кальянных 1000 часов	postoyanstvo_9	2015-11-12 15:59:15.941867	2015-11-17 11:25:57.916517	_____________1_____________8.png
2	Изобретательность I	Проведите 1 мероприятие в Уникальных Кальянных	izobretatelnost-i	2015-11-09 12:35:19.786852	2015-11-17 11:48:25.200217	_____________1_____________________1__.png
1	Приверженность	Посетите Уникальные Кальянные 30 раз в течение месяца и получите не менее 90 000 единиц опыта за это время.	priverzhennost	2015-11-06 13:52:15.881405	2015-11-17 11:49:14.809336	_____________1_______________-.png
12	Постоянство V	Проведите в заведениях Уникальных Кальянных 50 часов	postoyanstvo-v	2015-11-12 15:57:52.575903	2015-11-17 11:58:30.294592	_____________1_____________5.png
11	Постоянство IV	Проведите в заведениях Уникальных Кальянных 25 часов	postoyanstvo_4	2015-11-12 15:57:34.337374	2015-11-17 11:28:14.696592	_____________1_____________4.png
10	Постоянство III	Проведите в заведениях Уникальных Кальянных 10 часов	postoyanstvo_3	2015-11-12 15:57:10.920053	2015-11-17 11:28:36.237888	_____________1_____________3.png
9	Постоянство II	Проведите в заведениях Уникальных Кальянных 5 часов	postoyanstvo_2	2015-11-12 15:56:45.215437	2015-11-17 11:29:17.902346	_____________1_____________2.png
8	Постоянство I	Проведите в заведениях Уникальных Кальянных 1 час	postoyanstvo-i	2015-11-12 15:56:20.655959	2015-11-17 11:32:18.665775	_____________1_____________1-31.png
15	Постоянство VIII	Проведите в заведениях Уникальных Кальянных 500 часов	postoyanstvo-viii	2015-11-12 15:58:55.74384	2015-11-17 11:38:24.61448	_____________1_____________7.png
14	Постоянство VII	Проведите в заведениях Уникальных Кальянных 250 часов	postoyanstvo-vii	2015-11-12 15:58:29.739392	2015-11-17 11:39:50.044858	_____________1_____________6.png
13	Постоянство VI	Проведите в заведениях Уникальных Кальянных 100 часов	postoyanstvo-vi	2015-11-12 15:58:12.603807	2015-11-17 11:40:51.436386	_____________1_____________5.png
7	Открытость	Заполните свой профиль на 100%	otkrytost	2015-11-09 12:37:02.178155	2015-11-17 11:43:25.56575	_____________1____________.png
6	Изобретательность V	Проведите 25 мероприятий в Уникальных Кальянных	izobretatelnost-v	2015-11-09 12:36:39.282097	2015-11-17 11:45:53.036212	_____________1___________________5.png
5	Изобретательность IV	Проведите 10 мероприятий в Уникальных Кальянных	izobretatelnost-iv	2015-11-09 12:36:16.888387	2015-11-17 11:46:15.604279	_____________1___________________4.png
4	Изобретательность III	Проведите 5 мероприятий в Уникальных Кальянных	izobretatelnost-iii	2015-11-09 12:35:54.960908	2015-11-17 11:46:40.807857	_____________1___________________3.png
\.


--
-- Name: achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('achievements_id_seq', 17, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (id, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, name, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, role, invitation_token, invitation_created_at, invitation_sent_at, invitation_accepted_at, invitation_limit, invited_by_id, invited_by_type, invitations_count, phone, phone_token, experience, level, skill_point, avatar, auth_token, email, spent_money) FROM stdin;
10	$2a$10$F34fL7PQdahQEbIRjjqjOuPCd8QHcmmOxysKf5Rp9BoyJfUb0KxAK	\N	\N	\N	1	2015-11-14 16:58:51.389876	2015-11-14 16:58:51.389876	192.168.1.36	192.168.1.36	2015-11-14 16:58:51.366117	2015-11-14 16:58:51.417862	\N	\N	2015-11-14 16:58:51.41543	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	234234	1234	0	1	0	\N	a4aede1630140f1186768d9bb9856d6d	\N	\N
14	$2a$10$mMvdMkfKZNCv7KktjIAaqufDckPLNmkEbx1.KUE1UZ5LudISLCy6i	\N	\N	\N	1	2015-11-17 10:16:29.25687	2015-11-17 10:16:29.25687	192.168.1.36	192.168.1.36	2015-11-17 10:16:29.232105	2015-11-17 14:48:27.184231	\N	\N	2015-11-17 14:48:27.181478	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	4	1234	0	1	0	\N	850c0c6398268121ddecbd8ac0312966	\N	\N
18	$2a$10$69LS4y1zPZFN3ZggP.uWGeBueADCcVF796WiX3uqg2MvnQy0/unFm	\N	\N	\N	24	2015-11-29 12:51:46.292416	2015-11-29 12:51:46.232395	192.168.1.35	192.168.1.35	2015-11-17 16:27:26.494289	2015-11-29 12:51:46.293884	123	\N	2015-11-17 16:27:26.553537	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	666666	1234	0	1	0	\N	1befed89839ce9334471b54ec4ed1b09	\N	\N
11	$2a$10$4kg1Yrv5rFg3S3Pnht8F3eths76JStBts9tgUMfUsEWb/ci14BkB2	\N	\N	\N	1	2015-11-17 10:12:10.966787	2015-11-17 10:12:10.966787	192.168.1.36	192.168.1.36	2015-11-17 10:12:10.938298	2015-11-17 10:14:01.244457	\N	\N	2015-11-17 10:14:01.24174	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	7777	1234	0	1	0	\N	b311e4628a75d4ae53c1eb4645421b5f	\N	\N
4	$2a$10$q9MIpcGDQ267y3UyoFdtMOk7yVzrM3cYgwdVPdVgFEiu.9C/RWfl6	\N	\N	\N	1	2015-11-14 16:14:19.383389	2015-11-14 16:14:19.383389	192.168.1.36	192.168.1.36	2015-11-14 16:14:19.331756	2015-11-14 16:14:19.384568	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	23423423	1234	0	1	0	\N	44f07642b2b1566484ba0bb3c1d3a890	\N	\N
23	$2a$10$R5nssSAsEXqeahAAK4pQU.X8r2Ssyegiqz1yjHZWG7hOJ6r.s5Y5i	\N	\N	\N	5	2015-11-24 13:40:52.455284	2015-11-24 13:40:52.338402	192.168.1.40	192.168.1.40	2015-11-24 13:39:29.193197	2015-11-24 13:40:52.457465	Бураков ИА	\N	2015-11-24 13:39:29.268097	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79125271477	1234	0	1	0	\N	18fccc2ccfc0838616c91dff8aa6f929	\N	\N
19	$2a$10$z8JSpoYcRVcCUFOcHQwClOslAexgmwAwQ8oG0EI/NLH9ii6KacJU2	\N	\N	\N	27	2015-11-17 18:21:26.877739	2015-11-17 18:21:26.711852	127.0.0.1	127.0.0.1	2015-11-17 17:21:06.543664	2015-11-17 18:21:26.879945	Бураков Илья	\N	2015-11-17 17:22:55.361401	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	666666666	1234	0	1	0	\N	b1f1fad9439f97e433b3b305c6283c23	\N	\N
6	$2a$10$ycSKZalegCT/TBcakJuHqOjBXDmvorE8Z.3Pz4F8oH/cm3TL0fr6u	\N	\N	\N	1	2015-11-14 16:17:39.160281	2015-11-14 16:17:39.160281	192.168.1.36	192.168.1.36	2015-11-14 16:17:39.129686	2015-11-14 16:17:39.161257	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	234233	1234	0	1	0	\N	a3b7af8e8de7338648aa675da1c7cae6	\N	\N
12	$2a$10$MR78tmOyC0vDoLp.Jq/9q.faopBdVSic0sT1f8DTaj0fy3zhg/Xa6	\N	\N	\N	1	2015-11-17 10:14:36.131133	2015-11-17 10:14:36.131133	192.168.1.36	192.168.1.36	2015-11-17 10:14:36.100473	2015-11-17 10:15:47.880265	\N	\N	2015-11-17 10:15:47.8782	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	333	1234	0	1	0	\N	2b2c7907d7d526cc3d2f102defd880cf	\N	\N
17	$2a$10$SjtMlC5ZsrCvR2Fj61OPqO/s.1vz7bHPOEEjrjAJRvccyA3/ewagy	\N	\N	\N	8	2015-11-17 16:19:37.143632	2015-11-17 16:19:36.463451	192.168.1.40	192.168.1.40	2015-11-17 10:35:06.886739	2015-11-17 16:19:37.145041	Илья	\N	2015-11-17 10:35:06.947754	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	666	1234	0	1	0	\N	36cc7d588f8cb7fb2d59f7ae057e8543	\N	\N
8	$2a$10$ksbVjUAatgN./PSdbS8eY.sBYHK7NsVr2S3vf3rUfSEakdamA7UEy	\N	\N	\N	1	2015-11-14 16:55:40.660975	2015-11-14 16:55:40.660975	192.168.1.36	192.168.1.36	2015-11-14 16:55:40.634246	2015-11-14 16:55:40.66184	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	2	1234	0	1	0	\N	286529a4a6ddfcec22eaca4af1c2dd47	\N	\N
13	$2a$10$PyNLtueyQWr95icEfQyEFOBReHKTOFQP9j8uSrKqbNZVPLsUTuiyW	\N	\N	\N	1	2015-11-17 10:16:09.467587	2015-11-17 10:16:09.467587	192.168.1.36	192.168.1.36	2015-11-17 10:16:09.430216	2015-11-17 10:16:09.505461	\N	\N	2015-11-17 10:16:09.503346	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	3	1234	0	1	0	\N	d91e80e277e20470de96512cad2e1ce1	\N	\N
9	$2a$10$ljeIQVZY/K1ybwmilqvBY.tYboN6Fls8W0DPj4rIKDEABMQdlZG2O	\N	\N	\N	1	2015-11-14 16:57:49.157627	2015-11-14 16:57:49.157627	192.168.1.36	192.168.1.36	2015-11-14 16:57:49.149331	2015-11-14 16:57:49.186388	\N	\N	2015-11-14 16:57:49.183983	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	3423423	1234	0	1	0	\N	52c483fdc16c09102c775a1fdf2afde1	\N	\N
7	$2a$10$LWR15XO0LqzmahrjUp44quXQwLAgG4jBBZpxQM0qWlFe508ncSFvi	\N	\N	\N	1	2015-11-14 16:53:37.936753	2015-11-14 16:53:37.936753	192.168.1.40	192.168.1.40	2015-11-14 16:53:37.911384	2015-11-17 14:41:18.690301	\N	\N	2015-11-17 14:41:18.68788	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79119164762	1234	0	1	0	\N	05b08327082f8c871dab2cae5e950a2a	\N	\N
15	$2a$10$mSD5B1ePO9bsCbg4Be8f7.kzabnRy1BRe.6ShE..n6oNrKleefjHG	\N	\N	\N	1	2015-11-17 10:18:10.142027	2015-11-17 10:18:10.142027	192.168.1.36	192.168.1.36	2015-11-17 10:18:10.113187	2015-11-17 10:18:10.169419	\N	\N	2015-11-17 10:18:10.167051	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	5	1234	0	1	0	\N	8d51854440eb2e49a44cf1cc0ce6f9d7	\N	\N
21	$2a$10$TN5MhBjy/Tq9jqpVgOMilOE8.LMMNMJ5soneZIGX6tjgQx.XAz42i	\N	\N	\N	3	2015-11-19 14:56:02.912405	2015-11-19 14:56:02.56098	127.0.0.1	127.0.0.1	2015-11-19 14:56:01.351468	2015-11-19 14:56:02.914015	крюк	\N	2015-11-19 14:56:01.871096	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79675625082	1234	0	1	0	\N	ac6208cb54d6f966fd3c6bf76d1beac5	\N	\N
20	$2a$10$Vq0Xaf0xIA.6UFA2gOCOvueXJsSCkDckgofzsEKQ51zRHGg1xS6Y.	\N	\N	\N	3	2015-11-17 18:42:32.179294	2015-11-17 18:42:31.428651	127.0.0.1	127.0.0.1	2015-11-17 18:42:28.576867	2015-11-17 18:42:32.180849	Бураков Илья	\N	2015-11-17 18:42:29.378495	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	123456789	1234	0	1	0	\N	23ae5cb2e5ae3425b14628c14e4a2257	\N	\N
5	$2a$10$Xh1cGZG4AhNUK6PlF6Ot..PIlwog2l1X/8/4bX8ACv1qQSlakgiXa	\N	\N	\N	1	2015-11-14 16:15:26.331387	2015-11-14 16:15:26.331387	192.168.1.36	192.168.1.36	2015-11-14 16:15:26.303958	2015-11-17 17:19:27.760404	\N	\N	2015-11-17 17:19:27.758043	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	1	1234	0	1	0	\N	bd8e572bd801fdc7cc9e09c6012373ec	\N	\N
1	$2a$10$UJTXsdnobcoMek3jbZAmjuhiZFmJyytrElNnJd1oojec9K9ptPU2G	\N	\N	2015-11-17 11:13:43.924986	10	2015-11-29 12:30:57.533059	2015-11-17 11:14:12.903581	192.168.1.40	192.168.1.41	2015-10-29 11:08:40.916895	2015-11-29 12:30:57.534412	Admin	\N	2015-11-09 14:28:36.043207	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	0	1234	1234	0	1	0	\N	61b85afe6f6b489ec67bf1b91d64d8ba	\N	\N
24	$2a$10$xPUxBxxilmsb3wUiFzIM7uIWDad021sGjYX3JN06Xyt.Pa9ZS/yZe	\N	\N	\N	7	2015-11-26 12:47:01.948049	2015-11-26 12:47:01.89342	192.168.1.38	192.168.1.38	2015-11-26 12:06:18.826131	2015-11-26 12:47:01.949527	Жернов Вадим Робертович	\N	2015-11-26 12:47:01.111392	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79218843642	1234	0	1	0	\N	8d7efa1ce3af44d0778fbb7960bc1571	\N	\N
22	$2a$10$8qb7yLI.aCl56lHmnCzkj.2yQcXC95krwx83GMP0MLlSIHBlYDniK	\N	\N	\N	5	2015-11-23 08:38:53.234542	2015-11-23 08:38:53.118379	192.168.1.37	192.168.1.37	2015-11-23 08:38:41.114188	2015-11-23 08:38:53.236751	admin	\N	2015-11-23 08:38:41.179127	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	123	1234	0	1	0	\N	bc11aa14dfbba4b7b7e56d392b004272	\N	\N
26	$2a$10$npwBLloC1V8uHyOpEEdfS.iJr7d02qavtejZlFpfaVndJsmg5N0mG	\N	\N	\N	28	2015-11-29 12:48:33.318646	2015-11-29 12:48:19.323478	192.168.1.35	192.168.1.35	2015-11-29 11:02:11.074336	2015-11-29 12:48:33.320199	Бураков Илья	\N	2015-11-29 12:01:03.100529	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79125271466	1234	0	1	0	\N	762ef1d771f5596a64c980bf3ba1001b	\N	\N
25	$2a$10$OlN22lOkCkT9YRBd2NXAdOi2uQZIibhx3KXr.XIBNxgZr.FZZfkAO	\N	\N	\N	3	2015-11-26 15:44:49.413374	2015-11-26 15:44:49.364109	192.168.1.35	192.168.1.35	2015-11-26 15:44:48.784019	2015-11-26 15:44:49.414849	Бураков ИА	\N	2015-11-26 15:44:48.830632	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	66366	1234	0	1	0	\N	d78ac3936be483e862ddd8caf7e7fd36	\N	\N
16	$2a$10$BPw57hQ5rXhEerst6I.Whe9xdstsmpb1QDstbVQAiKz3eYh4nxOJ.	\N	\N	\N	1363	2015-12-02 12:00:52.12212	2015-12-02 12:00:52.0667	192.168.1.34	192.168.1.34	2015-11-17 10:22:44.908984	2015-12-02 12:00:52.123538	Maxim	\N	2015-12-02 10:22:50.854735	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	9	1234	0	1	0	\N	f711a98afad9e802e748edfeaeb0b0a4	\N	\N
\.


--
-- Data for Name: achievements_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY achievements_users (id, achievement_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: achievements_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('achievements_users_id_seq', 1, false);


--
-- Data for Name: active_admin_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY active_admin_comments (id, namespace, body, resource_id, resource_type, author_id, author_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('active_admin_comments_id_seq', 1, false);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cities (id, name, created_at, updated_at) FROM stdin;
1	Санкт-Петербург	2015-10-29 11:14:29.010932	2015-10-29 11:14:29.010932
2	Тюмень	2015-11-09 09:51:11.904232	2015-11-09 09:51:11.904232
3	Воронеж	2015-11-09 09:51:21.829369	2015-11-09 09:51:21.829369
4	Казань	2015-11-09 09:51:28.780946	2015-11-09 09:51:28.780946
5	Новосибирск	2015-11-09 09:52:07.014276	2015-11-09 09:52:07.014276
\.


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cities_id_seq', 5, true);


--
-- Data for Name: lounges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY lounges (id, title, city_id, color, blazon, created_at, updated_at) FROM stdin;
4	Unity Hall	4	#da6f50	gerb_kazan_unityhall.svg	2015-10-29 14:53:00.70965	2015-11-09 09:52:27.69889
6	Облака	3	#64B6DC	gerb_spb_liberty.svg	2015-11-09 10:40:29.07182	2015-11-09 10:40:29.07182
5	Резерв	2	#7AC36C	gerb_spb_blazon.svg	2015-11-09 10:39:29.108686	2015-11-09 10:40:56.517866
1	Академия	5	#7946D6	gerb_spb_academy.svg	2015-10-29 11:16:41.518935	2015-11-09 10:41:39.08966
2	Либерти	1	#6CB9DD	gerb_spb_liberty.svg	2015-10-29 14:50:23.989509	2015-11-09 10:42:15.264209
\.


--
-- Name: lounges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('lounges_id_seq', 6, true);


--
-- Data for Name: tables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tables (id, title, lounge_id, seats, created_at, updated_at) FROM stdin;
1	1	1	5	2015-10-30 15:03:00.539722	2015-10-30 15:03:00.539722
2	Круглый	2	4	2015-11-29 12:31:19.357185	2015-11-29 12:31:19.357185
3	Большой	1	5	2015-11-29 12:35:27.675715	2015-11-29 12:35:27.675715
4	У входа	2	4	2015-11-29 12:36:25.802728	2015-11-29 12:36:25.802728
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY reservations (id, table_id, visit_date, user_id, created_at, updated_at) FROM stdin;
1	1	2015-11-10 12:30:00	1	2015-11-09 15:10:09.819686	2015-11-09 15:10:09.819686
2	1	2015-12-14 12:04:00	16	2015-11-29 12:40:51.278535	2015-11-29 12:40:51.278535
3	3	2015-12-14 15:00:00	16	2015-11-29 13:04:06.745941	2015-11-29 13:04:06.745941
\.


--
-- Data for Name: meets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY meets (id, reservation_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: meets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('meets_id_seq', 1, false);


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY payments (id, amount, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('payments_id_seq', 1, false);


--
-- Name: reservations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('reservations_id_seq', 4, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_migrations (version) FROM stdin;
20151026083731
20151026083735
20151026083738
20151026083744
20151026083817
20151027085335
20151027102829
20151029093841
20151029095446
20151029103007
20151030140601
20151030141026
20151102152908
20151102152934
20151103112905
20151103124552
20151105111648
20151105153953
20151105164205
20151106113129
20151106125755
20151106130013
20151109124608
20151109143056
20151114161248
20151117110321
20151117112513
20151118104002
20151118104702
20151118115824
20151127100242
\.


--
-- Data for Name: skill_hierarchies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY skill_hierarchies (ancestor_id, descendant_id, generations) FROM stdin;
13	13	0
14	14	0
4	4	0
5	5	0
6	6	0
7	7	0
8	8	0
9	9	0
10	10	0
11	11	0
12	12	0
\.


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY skills (id, name, description, created_at, updated_at, image, ancestry, cost, parent_id) FROM stdin;
13	Открытые врата	При звонке не менее, чем за два часа, позволяет вам отдыхать в заведении, даже если оно не работает в это время.	2015-11-18 10:22:46.163503	2015-11-18 10:22:46.163503	Clean_UHP_icons_______________.png	\N	5	\N
14	Ne plus ultra	При бронировании места, вам автоматически вызывается такси до заведения за счет Уникальных Кальянных, а из заведения вы можете отправиться  на такси до любой необходимой вам точки, опять же за счёт Уникальных Кальянных.	2015-11-18 10:23:32.142981	2015-11-18 10:23:32.142981	\N	\N	6	\N
4	Добродетель гостеприимства	При первом заказе за день вы имеете право бесплатно получить чайник чая на выбор: черный или зеленый.	2015-11-18 10:14:46.638044	2015-11-18 10:14:46.638044	Clean_UHP_icons___________________________.png	\N	1	\N
5	Знак расположения	Вы получаете постоянную скидку на аренду кальянщика для своих мероприятий в размере 10%.	2015-11-18 10:15:24.329569	2015-11-18 10:15:31.512517	Clean_UHP_icons__________________.png	4	2	\N
6	Первое посвящение	Позволяет вам бесплатно принимать участие в днях экспериментов вместе с кальянными мастерами.	2015-11-18 10:16:05.43157	2015-11-18 10:16:17.243819	Clean_UHP_icons__________________.png	4	2	\N
7	Второе посвящение	Позволяет вам один раз в месяц присутствовать на Циклах Уникальных Встреч за счет Уникальных Кальянных.	2015-11-18 10:16:41.33946	2015-11-18 10:17:00.361943	Clean_UHP_icons__________________.png	4/6	3	\N
8	Равенство двух/многих	Позволяет вам один раз в месяц послать через личный кабинет приглашение на встречу пользователю, который старше вас на 10 уровней.	2015-11-18 10:18:45.484466	2015-11-18 10:18:52.347792	Clean_UHP_icons_______________-_______.png	4/5	3	\N
9	Путь славы	Позволяет вам один раз в месяц бесплатно разместить на ресурсах Уникальных Кальянных рекламу вашего мероприятия, проводимого в Уникальных Кальянных.	2015-11-18 10:19:25.359196	2015-11-18 10:19:46.020353	Clean_UHP_icons___________.png	4/5/8	4	\N
10	Третье посвящение	Позволяет вам бесплатно посещать два любых мероприятия Уникальных Кальянных в месяц.	2015-11-18 10:20:17.731062	2015-11-18 10:20:29.190193	Clean_UHP_icons__________________.png	4/6/7	4	\N
11	Добродетель щедрости	При первом заказе за день вы имеете право получить дополнительный кальян бесплатно.	2015-11-18 10:21:22.805623	2015-11-18 10:21:22.805623	\N	\N	4	\N
12	Право посвященного	При звонке не менее, чем за пол часа, позволяет вам получить место в заведении при любых условиях, даже если все забито.	2015-11-18 10:21:54.437715	2015-11-18 10:21:54.437715	Clean_UHP_icons___________________.png	\N	5	\N
\.


--
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('skills_id_seq', 14, true);


--
-- Data for Name: skills_links; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY skills_links (id, parent_id, child_id) FROM stdin;
\.


--
-- Name: skills_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('skills_links_id_seq', 1, false);


--
-- Data for Name: skills_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY skills_users (id, skill_id, user_id) FROM stdin;
\.


--
-- Name: skills_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('skills_users_id_seq', 1, false);


--
-- Name: tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tables_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 26, true);


--
-- PostgreSQL database dump complete
--

