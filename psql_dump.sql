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

COPY achievements (id, name, description, key, created_at, updated_at, image, role) FROM stdin;
18	Бережливый		berezhlivyy	2015-12-07 16:36:01.550832	2015-12-07 16:36:01.550832	_____________2____________-.png	1
20	Кальянный мастер II		kalyannyy-master-ii	2015-12-07 16:37:09.87027	2015-12-07 16:37:09.87027	_____________2___________________2.png	1
21	Кальянный мастер III		kalyannyy-master-iii	2015-12-07 16:37:44.470172	2015-12-07 16:37:44.470172	_____________2___________________3.png	1
22	Кальянный мастер IV		kalyannyy-master-iv	2015-12-07 16:38:04.025819	2015-12-07 16:38:04.025819	_____________2___________________4.png	1
23	Кальянный мастер V		kalyannyy-master-v	2015-12-07 16:38:21.610198	2015-12-07 16:38:21.610198	_____________2___________________5.png	1
24	Кальянный мастер VI		kalyannyy-master-vi	2015-12-07 16:38:39.218418	2015-12-07 16:38:39.218418	_____________2___________________6.png	1
25	Кальянный мастер VII		kalyannyy-master-vii	2015-12-07 16:38:59.529342	2015-12-07 16:38:59.529342	_____________2___________________7_.png	1
26	Кальянный мастер VIII		kalyannyy-master-viii	2015-12-07 16:39:25.829634	2015-12-07 16:39:25.829634	_____________2___________________8.png	1
27	Легендарный торговец		legendarnyy-torgovets	2015-12-07 16:39:50.87031	2015-12-07 16:39:50.87031	_____________2______________________.png	1
28	Легендарный трудяга		legendarnyy-trudyaga	2015-12-07 16:40:38.255979	2015-12-07 16:40:38.255979	_____________2_____________________.png	1
30	Неудержимый II		neuderzhimyy-ii	2015-12-07 16:41:33.212582	2015-12-07 16:41:33.212582	_____________2_______________2.png	1
31	Неудержимый III		neuderzhimyy-iii	2015-12-07 16:42:07.537134	2015-12-07 16:42:07.537134	_____________2_______________3.png	1
32	Неудержимый IV		neuderzhimyy-iv	2015-12-07 16:42:34.221401	2015-12-07 16:42:34.221401	_____________2_______________4.png	1
33	Неудержимый V		neuderzhimyy-v	2015-12-07 16:43:03.065526	2015-12-07 16:43:09.267579	_____________2_______________5.png	1
34	Неудержимый VI		neuderzhimyy-vi	2015-12-07 16:43:38.821046	2015-12-07 16:43:38.821046	_____________2_______________6.png	1
19	Кальянный мастер I		kalyannyy-master-i	2015-12-07 16:36:41.982841	2015-12-07 16:44:29.279451	_____________2__________________.png	1
29	Неудержимый I		neuderzhimyy-i	2015-12-07 16:41:12.324089	2015-12-07 16:44:41.527074	_____________2______________.png	1
35	Табачный эксперт I		tabachnyy-ekspert-i	2015-12-07 16:44:08.482367	2015-12-07 16:45:09.97695	_____________2___________________1.png	1
36	Табачный эксперт II		tabachnyy-ekspert-ii	2015-12-07 16:45:30.360184	2015-12-07 16:45:30.360184	_____________2___________________2.png	1
37	Табачный эксперт III		tabachnyy-ekspert-iii	2015-12-07 16:45:51.445342	2015-12-07 16:45:51.445342	_____________2___________________3.png	1
38	Табачный эксперт IV		tabachnyy-ekspert-iv	2015-12-07 16:46:23.85816	2015-12-07 16:46:23.85816	_____________2___________________4.png	1
39	Табачный эксперт V		tabachnyy-ekspert-v	2015-12-07 16:46:43.502011	2015-12-07 16:46:43.502011	_____________2___________________5.png	1
40	Табачный эксперт VI		tabachnyy-ekspert-vi	2015-12-07 16:47:01.795327	2015-12-07 16:47:01.795327	_____________2___________________6.png	1
41	Табачный эксперт VII		tabachnyy-ekspert-vii	2015-12-07 16:47:19.962194	2015-12-07 16:47:19.962194	_____________2___________________7.png	1
42	Табачный эксперт VIII		tabachnyy-ekspert-viii	2015-12-07 16:47:39.014891	2015-12-07 16:47:39.014891	_____________2___________________8.png	1
43	Трудяга I		trudyaga-i	2015-12-07 16:47:57.291065	2015-12-07 16:47:57.291065	_____________2________.png	1
44	Трудяга II		trudyaga-ii	2015-12-07 16:48:17.372164	2015-12-07 16:48:17.372164	_____________2_________2.png	1
45	Трудяга III		trudyaga-iii	2015-12-07 16:48:35.531353	2015-12-07 16:48:35.531353	_____________2_________3.png	1
17	Энтузиазм	Посетите заведение Уникальных Кальянных в пределах 10 минут после открытия	entuziazm	2015-11-12 15:59:40.103265	2015-12-07 16:54:36.244554	_____________1__________.png	0
16	Постоянство IX	Проведите в заведениях Уникальных Кальянных 1000 часов	postoyanstvo-ix	2015-11-12 15:59:15.941867	2015-12-07 16:54:50.353253	_____________1_____________8.png	0
15	Постоянство VIII	Проведите в заведениях Уникальных Кальянных 500 часов	postoyanstvo-viii	2015-11-12 15:58:55.74384	2015-12-07 16:55:06.125822	_____________1_____________7.png	0
14	Постоянство VII	Проведите в заведениях Уникальных Кальянных 250 часов	postoyanstvo-vii	2015-11-12 15:58:29.739392	2015-12-07 16:55:21.043808	_____________1_____________6.png	0
13	Постоянство VI	Проведите в заведениях Уникальных Кальянных 100 часов	postoyanstvo-vi	2015-11-12 15:58:12.603807	2015-12-07 16:55:34.172517	_____________1_____________5.png	0
12	Постоянство V	Проведите в заведениях Уникальных Кальянных 50 часов	postoyanstvo-v	2015-11-12 15:57:52.575903	2015-12-07 16:55:47.364056	_____________1_____________5.png	0
11	Постоянство IV	Проведите в заведениях Уникальных Кальянных 25 часов	postoyanstvo-iv	2015-11-12 15:57:34.337374	2015-12-07 16:56:02.195272	_____________1_____________4.png	0
10	Постоянство III	Проведите в заведениях Уникальных Кальянных 10 часов	postoyanstvo-iii	2015-11-12 15:57:10.920053	2015-12-07 16:56:15.245754	_____________1_____________3.png	0
9	Постоянство II	Проведите в заведениях Уникальных Кальянных 5 часов	postoyanstvo-ii	2015-11-12 15:56:45.215437	2015-12-07 16:56:29.842804	_____________1_____________2.png	0
8	Постоянство I	Проведите в заведениях Уникальных Кальянных 1 час	postoyanstvo-i	2015-11-12 15:56:20.655959	2015-12-07 16:56:44.018486	_____________1_____________1-31.png	0
7	Открытость	Заполните свой профиль на 100%	otkrytost	2015-11-09 12:37:02.178155	2015-12-07 16:56:59.209528	_____________1____________.png	0
6	Изобретательность V	Проведите 25 мероприятий в Уникальных Кальянных	izobretatelnost-v	2015-11-09 12:36:39.282097	2015-12-07 16:57:12.840931	_____________1___________________5.png	0
5	Изобретательность IV	Проведите 10 мероприятий в Уникальных Кальянных	izobretatelnost-iv	2015-11-09 12:36:16.888387	2015-12-07 16:57:26.278896	_____________1___________________4.png	0
4	Изобретательность III	Проведите 5 мероприятий в Уникальных Кальянных	izobretatelnost-iii	2015-11-09 12:35:54.960908	2015-12-07 16:57:39.780689	_____________1___________________3.png	0
3	Изобретательность II	Проведите 3 мероприятия в Уникальных Кальянных	izobretatelnost-ii	2015-11-09 12:35:35.967076	2015-12-07 16:57:54.126015	_____________1___________________2.png	0
2	Изобретательность I	Проведите 1 мероприятие в Уникальных Кальянных	izobretatelnost-i	2015-11-09 12:35:19.786852	2015-12-07 16:58:06.751928	_____________1_____________________1__.png	0
46	Трудяга IV		trudyaga-iv	2015-12-07 16:48:56.634758	2015-12-07 16:48:56.634758	_____________2_________4.png	1
47	Трудяга V		trudyaga-v	2015-12-07 16:49:15.282088	2015-12-07 16:49:15.282088	_____________2_________5.png	1
48	Трудяга VI		trudyaga-vi	2015-12-07 16:49:32.955349	2015-12-07 16:49:32.955349	_____________2_________6.png	1
49	Трудяга VII		trudyaga-vii	2015-12-07 16:49:54.629564	2015-12-07 16:49:54.629564	_____________2_________7.png	1
50	Трудяга VIII		trudyaga-viii	2015-12-07 16:50:21.592017	2015-12-07 16:50:21.592017	_____________2_________8.png	1
51	Щедрость I		schedrost-i	2015-12-07 16:51:57.558536	2015-12-07 16:51:57.558536	_____________2_________.png	1
52	Щедрость II		schedrost-ii	2015-12-07 16:52:22.526987	2015-12-07 16:52:22.526987	_____________2__________2.png	1
53	Щедрость III		schedrost-iii	2015-12-07 16:52:41.361994	2015-12-07 16:52:41.361994	_____________2__________3.png	1
54	Щедрость IV		schedrost-iv	2015-12-07 16:53:01.58338	2015-12-07 16:53:01.58338	_____________2__________4.png	1
55	Щедрость V		schedrost-v	2015-12-07 16:53:20.978975	2015-12-07 16:53:20.978975	_____________2__________5.png	1
56	Щедрость VI		schedrost-vi	2015-12-07 16:53:41.286934	2015-12-07 16:53:41.286934	_____________2__________6.png	1
57	Щедрость VII		schedrost-vii	2015-12-07 16:54:02.254404	2015-12-07 16:54:02.254404	_____________2__________7.png	1
1	Приверженность	Посетите Уникальные Кальянные 30 раз в течение месяца и получите не менее 90 000 единиц опыта за это время.	priverzhennost	2015-11-06 13:52:15.881405	2015-12-07 16:54:22.486895	_____________1_______________-.png	0
\.


--
-- Name: achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('achievements_id_seq', 102, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (id, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, name, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, role, invitation_token, invitation_created_at, invitation_sent_at, invitation_accepted_at, invitation_limit, invited_by_id, invited_by_type, invitations_count, phone, phone_token, experience, level, skill_point, avatar, auth_token, email, spent_money, idrref, city, employe, work_company, hobby) FROM stdin;
58	$2a$10$fIkIPl1vbNJhfgduaiE2Ses6UTnFXUWro5VJuQjTeDVyI5p/wlb.W	\N	\N	\N	160	2015-12-09 23:05:22.452095	2015-12-09 23:05:22.34882	5.18.63.193	5.18.63.193	2015-12-09 12:18:34.458746	2015-12-10 13:14:12.190921	New 4	\N	2015-12-09 12:18:34.520371	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	74444444444	1234	8000.0	2	1	\N	562b882e5ee69c13b8c6f99d57691b0f	\N	\N	\N	\N	\N	\N	\N
56	$2a$10$lVJfqky7nU2nvTfRfv0Ige.CArkRuLexuKTwD8750jFM0OxG33sfe	\N	\N	\N	7	2015-12-09 11:39:27.594423	2015-12-09 11:39:27.480276	89.188.110.205	89.188.110.205	2015-12-09 11:39:18.850516	2015-12-11 13:47:54.885572	Test	\N	2015-12-09 11:39:26.77572	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79313592924	1234	0.0	1	3	\N	a3b790a93fd748709ebc31797ecd14cc		\N	\N	\N	\N	\N	\N
23	$2a$10$R5nssSAsEXqeahAAK4pQU.X8r2Ssyegiqz1yjHZWG7hOJ6r.s5Y5i	\N	\N	\N	5	2015-11-24 13:40:52.455284	2015-11-24 13:40:52.338402	192.168.1.40	192.168.1.40	2015-11-24 13:39:29.193197	2015-11-24 13:40:52.457465	Бураков ИА	\N	2015-11-24 13:39:29.268097	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79125271477	1234	0	1	0	\N	18fccc2ccfc0838616c91dff8aa6f929	\N	\N	\N	\N	\N	\N	\N
80	$2a$10$NaOM1Tcgq3r6YKSOMO5EluMYG8hjuJfEKN1Ct.8eIoJmdnYEkYX9O	\N	\N	\N	6	2015-12-12 20:28:20.550597	2015-12-12 20:28:20.435443	178.66.252.141	178.66.252.141	2015-12-12 20:28:18.757017	2015-12-12 20:28:20.553863	dsfsd sdf dsf sdfdsf	\N	2015-12-12 20:28:19.000368	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79500464090	1234	0.0	1	0	\N	38bb8de320f7fde5a03cb3f5ab85bb15	\N	\N	\N	\N	\N	\N	\N
62	$2a$10$xnivzO5yJOCgcC69oN1yjeB283SKvI1yPpAE3hr77DNKtAysg1KYG	\N	\N	\N	203	2015-12-10 19:17:08.546425	2015-12-10 19:17:08.436193	5.18.139.55	5.18.139.55	2015-12-10 17:42:00.746535	2015-12-10 19:17:08.548555	Евгений	\N	2015-12-10 17:42:00.785994	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79312296028	1234	1000000.0	99	43	\N	b7a0b57513343662cfbd0289ab2476d1	evgeniy.shchukin@gmail.com	\N	\N	Мурманск	Менеджер	Среднее звено	Люблю бить людей мухобойкой
66	$2a$10$h9VyYNHQ/pZPnI1B.U3qyOC53loVrsFP6pvVCl3IKKtNnm3aSpyTK	\N	\N	\N	373	2015-12-14 08:43:43.528547	2015-12-14 08:43:43.337767	89.188.110.205	89.188.110.205	2015-12-11 12:37:50.504925	2015-12-14 08:43:43.53047	Tretyakov Pavel	\N	2015-12-11 12:37:50.564154	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	7333	1234	0.0	1	0	\N	d3e8da3640e36a2266df52f85f89933e	\N	\N	\N	\N	\N	\N	\N
24	$2a$10$xPUxBxxilmsb3wUiFzIM7uIWDad021sGjYX3JN06Xyt.Pa9ZS/yZe	\N	\N	\N	7	2015-11-26 12:47:01.948049	2015-11-26 12:47:01.89342	192.168.1.38	192.168.1.38	2015-11-26 12:06:18.826131	2015-11-26 12:47:01.949527	Жернов Вадим Робертович	\N	2015-11-26 12:47:01.111392	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79218843642	1234	0	1	0	\N	8d7efa1ce3af44d0778fbb7960bc1571	\N	\N	\N	\N	\N	\N	\N
79	$2a$10$JG9z0Q4dFbbD7lHVWEexQOWKXGhotZmMBxt4p18tx/DLYz6tgCa4S	\N	\N	\N	11	2015-12-12 17:29:44.331208	2015-12-12 17:29:44.154517	178.66.252.141	178.66.252.141	2015-12-12 16:50:32.983647	2015-12-12 17:29:44.334068	ваыав ваыва вы авыа	\N	2015-12-12 16:50:34.066096	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79214465999	1234	0.0	1	0	\N	68839d1d0fc5c1a094ac0d71377722cb	\N	\N	\N	\N	\N	\N	\N
25	$2a$10$OlN22lOkCkT9YRBd2NXAdOi2uQZIibhx3KXr.XIBNxgZr.FZZfkAO	\N	\N	\N	3	2015-11-26 15:44:49.413374	2015-11-26 15:44:49.364109	192.168.1.35	192.168.1.35	2015-11-26 15:44:48.784019	2015-11-26 15:44:49.414849	Бураков ИА	\N	2015-11-26 15:44:48.830632	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	66366	1234	0	1	0	\N	d78ac3936be483e862ddd8caf7e7fd36	\N	\N	\N	\N	\N	\N	\N
1	$2a$10$UJTXsdnobcoMek3jbZAmjuhiZFmJyytrElNnJd1oojec9K9ptPU2G	\N	\N	2015-12-14 08:25:44.831447	30	2015-12-14 08:36:05.124249	2015-12-14 08:25:44.840069	89.188.110.205	89.188.110.205	2015-10-29 11:08:40.916895	2015-12-14 08:36:05.126556	Admin	\N	2015-11-09 14:28:36.043207	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	0	1234	1234	0	1	0	\N	61b85afe6f6b489ec67bf1b91d64d8ba	\N	\N	\N	\N	\N	\N	\N
63	$2a$10$PKQRaIrvpM10YsCHeeZkS.4IGzUqk8Ofkmg6fnyWWDVXbDNOfK/xK	\N	\N	\N	4	2015-12-10 19:11:29.368031	2015-12-10 19:11:29.250391	89.188.110.205	89.188.110.205	2015-12-10 19:11:27.580108	2015-12-10 19:11:29.370028	Бураков Илья	\N	2015-12-10 19:11:27.648562	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79119164762	1234	0.0	1	0	\N	ea80b16e34811903a5372c146057cdaa	\N	\N	\N	\N	\N	\N	\N
26	$2a$10$npwBLloC1V8uHyOpEEdfS.iJr7d02qavtejZlFpfaVndJsmg5N0mG	\N	\N	\N	28	2015-11-29 12:48:33.318646	2015-11-29 12:48:19.323478	192.168.1.35	192.168.1.35	2015-11-29 11:02:11.074336	2015-12-08 19:27:26.291515	Бураков Илья	\N	2015-12-08 19:27:26.286379	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79125271466	1234	0	1	0	\N	762ef1d771f5596a64c980bf3ba1001b	\N	\N	\N	\N	\N	\N	\N
42	$2a$10$MILf7qrU7zybxHARYPwxtON29fFtw52TP5zC9NsWRVut7sB5leGm6	\N	\N	\N	9	2015-12-07 18:40:33.568341	2015-12-07 18:39:36.993398	94.188.17.113	94.188.17.113	2015-12-07 17:32:21.98779	2015-12-07 18:40:33.57025	Коновалов Игорь	\N	2015-12-07 17:32:22.102205	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79643957552	1234	0.0	1	0	\N	9c2607b8c23b23babe3a925282a4e609	\N	\N	\N	\N	\N	\N	\N
67	$2a$10$5RNywnXo6pj8j9HGJteC4un6xIOAoCcBKSPePOfyuf6r8ONH28b2i	\N	\N	\N	8	2015-12-11 12:45:11.706076	2015-12-11 12:45:11.570412	89.188.110.205	89.188.110.205	2015-12-11 12:44:58.920445	2015-12-11 12:45:11.707956	Fio	\N	2015-12-11 12:45:10.75725	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79999999999	1234	0.0	1	0	\N	77f9f6646b856702977601f3daed69e2	\N	\N	\N	\N	\N	\N	\N
41	$2a$10$Cxc/gv7qC/xGcfYBmtOWzeUt5XwpYtgzhblXwAvB5QnowdJ9rcyCO	\N	\N	\N	31	2015-12-07 21:58:30.030061	2015-12-07 21:58:30.011228	89.188.110.205	89.188.110.205	2015-12-07 17:26:31.80328	2015-12-07 21:58:30.031877	Бураков Илья	\N	2015-12-07 17:26:31.846142	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79125254345	1234	0.0	1	0	\N	46b970db45bf972bda988b3164e49057		\N	\N	Санкт-Петербург	Дизайнер	CPD&BBK	Люблю кальяны
59	$2a$10$iNh1CIGx2ln9yaWRkfR2Gu38gjiqRMZztsL2MaboCuA8pE82yGUdq	\N	\N	\N	159	2015-12-10 13:35:41.137319	2015-12-10 13:35:41.057921	89.188.110.205	89.188.110.205	2015-12-09 23:12:13.765013	2015-12-10 13:35:41.139192	Hookmaster	\N	2015-12-09 23:12:53.647311	\N	\N	3	\N	\N	\N	\N	\N	\N	\N	0	79313592925	1234	0.0	1	0	\N	290b8c2ec8c0c2ede3fbce42557a567b		\N	\N	\N	\N	\N	\N
36	$2a$10$zD0KUzRjfo0vpLKeVQm68uPqVGTpW/gWwEF8a7LvCwidaiwB/v0je	\N	\N	\N	123	2015-12-09 02:12:43.267024	2015-12-09 02:12:43.026859	5.18.139.55	5.18.139.55	2015-12-05 00:06:42.155253	2015-12-10 19:25:31.270864	Щукин Евгений Александрович	\N	2015-12-09 02:11:31.059689	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79212804388	1234	\N	\N	\N	\N	a42977f86a3931d18dae2e0734abaa0e	evgeniy.shchukin@gmail.com	\N	\N	Санкт-Петербург	Управляющий	Миструм	Книги, сноуборд, психология
30	$2a$10$iHrIun4hvbc.82EA8kTTJ.S6/kLw6cemmQUmPmHs5fgMtnlvm3Xbu	\N	\N	\N	21	2015-12-03 08:41:21.450524	2015-12-03 08:41:21.340117	31.173.242.192	31.173.242.192	2015-12-03 07:22:57.747788	2015-12-03 08:41:21.453205	Рябиченко В.К.	\N	2015-12-03 08:29:47.635983	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79993030503	1234	0.0	1	0	\N	ce5b12479e3c16cee3ee18b7dc2c7bd8	\N	\N	\N	\N	\N	\N	\N
38	$2a$10$ivjep5sf1uzcFhBcf9WHq.L77.3LlI9GfU2w8QBjPdoM0qqS0dPKO	\N	\N	\N	1567	2015-12-12 10:35:04.327183	2015-12-12 10:35:04.03716	5.18.63.193	5.18.63.193	2015-12-05 13:53:14.136318	2015-12-12 10:35:04.329107	Maxim	\N	2015-12-12 10:35:03.485284	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79313592921	1234	0.0	1	943	\N	20f3d641518b1093277fbe5808cf2328	indmaksim@gmail.com	\N	\N	Санкт-Петербург	Developer	Company	Hello
29	$2a$10$jiuyXHkRwZhOogN0Wfc6veRdradrSbpG7c40Oq9VOivFt6jahqQPu	\N	\N	\N	30	2015-12-07 22:16:13.628043	2015-12-07 22:16:13.44841	5.18.139.55	5.18.139.55	2015-12-03 00:23:48.344036	2015-12-07 22:16:13.630046	Горбунова Екатерина Сергеевна	\N	2015-12-07 21:48:18.156244	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79313495723	1234	0.0	1	0	\N	c243fa6c7e45128f9cf588831557d6f8	ekaterina.gorbunova30@gmail.com	\N	\N	Санкт-Петербург	Маркетолог	Проектная деятельность в нескольких компаниях	Фотография, путешествия, World of tanks, кулинария, кино, книги
32	$2a$10$QfftbOC1LrfL93NO.tTsV.m5mtj7hT62Mfk6x5qR1r/TStU7P30Ae	\N	\N	\N	6	2015-12-03 10:00:16.199954	2015-12-03 10:00:16.055106	178.66.192.158	178.66.192.158	2015-12-03 10:00:15.389934	2015-12-03 10:00:16.204989	Дмитриев Александр Алексеевич	\N	2015-12-03 10:00:15.434669	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79118356658	1234	0.0	1	0	\N	a38d0d9bcf65113bd241d90467b9e17a	\N	\N	\N	\N	\N	\N	\N
45	$2a$10$HI63gsVyNh6kO8G4rwjevexVg3Jj/bNWSaDih2jGkWiW8HDgjtHV.	\N	\N	\N	5	2015-12-08 12:04:28.322336	2015-12-08 12:04:28.274363	89.188.110.205	89.188.110.205	2015-12-08 12:04:27.49884	2015-12-08 12:04:28.324139	Цыганюк Кирилл	\N	2015-12-08 12:04:27.548007	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79313784719	1234	0.0	1	0	\N	656d8d693f1d27406ef386c2800caeb8	\N	\N	\N	\N	\N	\N	\N
31	$2a$10$aIXIEReCcrY3CnEXJHIsAeLxxV1zADQ3FTCQ3qADVrjPh0wNGKHoK	\N	\N	\N	10	2015-12-03 08:24:21.639646	2015-12-03 08:23:18.989912	95.26.55.229	95.26.55.229	2015-12-03 08:16:42.804274	2015-12-03 08:24:21.641714	rem	\N	2015-12-03 08:23:18.541449	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79104009455	1234	0.0	1	0	\N	75b29d761d16b46f5484199bd3044e90	\N	\N	\N	\N	\N	\N	\N
64	$2a$10$QAv0amZKlh6YQWyGgUazZecn4rR1jsDUsxLs63i6r1kCFNndMCLHO	\N	\N	\N	69	2015-12-12 20:00:40.56129	2015-12-12 20:00:40.540713	5.18.139.55	5.18.139.55	2015-12-10 19:26:30.123106	2015-12-12 20:00:40.563179	Игнат	\N	2015-12-10 20:30:06.36305	\N	\N	3	\N	\N	\N	\N	\N	\N	\N	0	71111111111	1234	0.0	1	0	\N	c32d994ba3d0fd9ec2ce2b389f1b4238		\N	\N	\N	\N	\N	\N
28	$2a$10$GrZB5WKGC4ifeINOGPKLFu49iHCs/xgNuoIbx.htfO9XYuVDwxXpC	\N	\N	\N	11	2015-12-07 17:18:26.08596	2015-12-07 17:18:26.029295	94.188.17.113	94.188.17.113	2015-12-03 00:04:07.5594	2015-12-07 17:18:26.08791	Бураков Илья	\N	2015-12-03 00:04:07.672055	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79111164762	1234	0.0	1	0	\N	0bd147a12d6fc7c1f72732a950f51b7c	\N	\N	\N	\N	\N	\N	\N
57	$2a$10$BEOXgXaaFFhNXK7/ujjQVe8xRytZDZT8EqdsT1c6V1cqoZYOyjtta	\N	\N	\N	2223	2015-12-14 08:43:31.548568	2015-12-14 08:43:31.262759	89.188.110.205	89.188.110.205	2015-12-09 11:40:48.273074	2015-12-14 08:43:31.551827	test	\N	2015-12-13 04:48:20.045591	\N	\N	3	\N	\N	\N	\N	\N	\N	\N	0	79111111111	1234	0.0	1	999999864	\N	492e172366a430a5a66e17850f4be729		\N	\N	\N	\N	\N	\N
65	$2a$10$lULHVDvfN99pqbGmk4Wn7uJaEHq8wPwo6Sz9XROKkBCokD6ibLZ3C	\N	\N	\N	18	2015-12-10 20:55:08.96219	2015-12-10 20:55:08.729867	37.78.76.185	37.78.76.185	2015-12-10 20:32:50.062427	2015-12-10 20:55:08.965266	Шмидт Михаил Анатольевич	\N	2015-12-10 20:52:17.352598	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79186372653	1234	0.0	1	0	\N	87ed771f62cfc7f1ac17ad552bbb196f	\N	\N	\N	\N	\N	\N	\N
77	$2a$10$6f4rwXu1q17bug4kI9eII.Otu7mMlx8fkeKae6KfjdHW.ql7VYauW	\N	\N	\N	11	2015-12-11 14:39:32.272663	2015-12-11 14:39:32.240413	89.188.110.205	89.188.110.205	2015-12-11 14:15:24.94719	2015-12-11 14:39:32.275649	234234234	\N	2015-12-11 14:15:25.065549	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	72342342342	1234	0.0	1	0	\N	b1d396e29ef7d6b68d1b10277b72e532	\N	\N	\N	\N	\N	\N	\N
78	$2a$10$0CFWGMyj6sFFnK960zSly.WKQBFd/XCE096lTH5pl3b9G0C78iLBG	\N	\N	\N	9	2015-12-11 14:45:50.602782	2015-12-11 14:45:50.573592	89.188.110.205	89.188.110.205	2015-12-11 14:42:23.7889	2015-12-11 14:45:50.604714	Тестовый аккаунт нужен	\N	2015-12-11 14:42:24.100138	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79500464099	1234	0.0	1	0	\N	c4e78a0540f3a381518a169cf0e53773	\N	\N	\N	\N	\N	\N	\N
61	$2a$10$jpdwbMAXiSzX2zW1jT/v2uOWuPeadAQuJE/EbXYoq7PIhCACv4GVO	\N	\N	\N	132	2015-12-10 18:39:32.272277	2015-12-10 18:39:32.17131	5.18.139.55	5.18.139.55	2015-12-10 16:38:46.011314	2015-12-10 18:39:32.274379	Александр Лашин	\N	2015-12-10 17:42:33.930384	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	79213137731	1234	1000000.0	99	6	\N	b7a0e028d9cb3c59cd9b12c19689c70d	aleksandr.lashin@gmail.com	\N	\N	Санкт-Петербург	Рабочая должность	Компания раобтодаеля	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed feugiat pulvinar lacus eu faucibus. Phasellus quis laoreet ligula. Maecenas mattis velit eget porta elementum. Nam maximus suscipit fringilla. Vivamus pellentesque nisl vitae nisl dignissim, sit amet rutrum ex ultricies. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut felis felis, bibendum sit amet felis non, ullamcorper mattis leo. Sed facilisis pretium ultricies. Pellentesque at nisl at metus pretium aliquet vel in nisi. Cras laoreet imperdiet nunc vel ornare.  Aliquam justo nisl, scelerisque et odio vel, fermentum vulputate tellus. Sed mattis, massa quis tempor suscipit, elit est ultricies ipsum, vitae dictum orci dui quis ex. Phasellus luctus, augue dignissim tristique scelerisque, turpis tortor eleifend turpis, vitae pellentesque tortor tellus vitae mauris. Vivamus varius congue eros eget vestibulum. Nam ut dui ut orci congue rhoncus dapibus at sapien. Sed aliquet ipsum non nisl molestie, et dictum libero semper. Morbi id pellentesque arcu. Maecenas imperdiet, mi sit amet pellentesque ultrices, risus massa mattis lorem, quis mattis tellus lacus in sem. Nunc ac urna ac nibh dictum pellentesque.  Fusce molestie, risus id commodo egestas, odio metus porttitor sem, eu venenatis mauris velit sit amet est. Aliquam consectetur convallis sem, eu dictum nibh tincidunt quis. Aliquam eros lorem, iaculis in leo vitae, ornare sollicitudin augue. Nullam et vestibulum quam, vel finibus massa. Aliquam porttitor vulputate justo, sed facilisis urna molestie vel. Cras sed risus eget mi semper molestie. Morbi et neque non mi convallis pretium in eget justo.  Pellentesque cursus molestie tincidunt. Vestibulum elementum libero et justo malesuada, et laoreet urna lobortis. In facilisis, leo id pulvinar cursus, elit nibh lobortis felis, vel scelerisque sapien est non ligula. Nulla metus libero, cursus a venenatis et, posuere sit amet magna. Proin aliquam venenatis dictum. Quisque faucibus blandit mi, eu sodales nulla vulputate sit amet. Aliquam id mauris non ligula suscipit gravida eget eget sapien. Fusce non lacus vel turpis ornare tempor vitae vel tellus.  Mauris rutrum felis quis ornare gravida. Nam sem enim, malesuada blandit eros et, rutrum congue ex. Morbi mollis sem scelerisque odio molestie placerat. Morbi vitae nulla hendrerit, sodales metus vitae, bibendum tortor. Cras aliquet, magna sed ornare pharetra, massa nisi semper magna, nec rutrum urna sem eget enim. Duis mollis sem eget nisi accumsan, sit amet faucibus nulla tristique. Mauris felis tellus, suscipit euismod elit at, bibendum rutrum libero.
\.


--
-- Data for Name: achievements_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY achievements_users (id, achievement_id, user_id, created_at, updated_at) FROM stdin;
47	44	36	2015-12-09 00:35:35.56712	2015-12-09 02:06:30.271675
48	23	36	2015-12-09 02:06:30.278589	2015-12-09 02:06:30.278589
49	56	36	2015-12-09 02:06:30.284509	2015-12-09 02:06:30.284509
50	7	36	2015-12-09 02:06:30.29241	2015-12-09 02:06:30.29241
51	7	61	2015-12-10 16:57:01.450215	2015-12-10 16:57:01.450215
52	7	62	2015-12-10 17:55:11.762104	2015-12-10 17:55:11.762104
46	7	38	2015-12-08 23:51:21.125153	2015-12-08 23:51:21.125153
\.


--
-- Name: achievements_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('achievements_users_id_seq', 52, true);


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
-- Data for Name: bonus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY bonus (id, name, description, slug, image, created_at, updated_at) FROM stdin;
\.


--
-- Name: bonus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('bonus_id_seq', 1, false);


--
-- Data for Name: bonus_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY bonus_users (id, bonus_id, user_id) FROM stdin;
\.


--
-- Name: bonus_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('bonus_users_id_seq', 1, false);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cities (id, name, created_at, updated_at) FROM stdin;
1	Санкт-Петербург	2015-10-29 11:14:29.010932	2015-10-29 11:14:29.010932
2	Тюмень	2015-11-09 09:51:11.904232	2015-11-09 09:51:11.904232
3	Воронеж	2015-11-09 09:51:21.829369	2015-11-09 09:51:21.829369
4	Казань	2015-11-09 09:51:28.780946	2015-11-09 09:51:28.780946
5	Новосибирск	2015-11-09 09:52:07.014276	2015-11-09 09:52:07.014276
6	Нижний Новгород	2015-12-08 00:33:16.416516	2015-12-08 00:33:16.416516
\.


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cities_id_seq', 7, true);


--
-- Data for Name: lounges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY lounges (id, title, city_id, color, blazon, created_at, updated_at, active) FROM stdin;
2	Либерти	1	#6CB9DD	gerb_spb_liberty.svg	2015-10-29 14:50:23.989509	2015-12-02 18:03:43.754426	t
5	Резерв	2	#7AC36C	reserv.svg	2015-11-09 10:39:29.108686	2015-12-06 14:53:51.116896	f
4	Зал Единства	4	#da6f50	unityhall.svg	2015-10-29 14:53:00.70965	2015-12-06 14:53:59.815387	f
1	Академия	5	#7946D6	academy_novosibirsk.svg	2015-10-29 11:16:41.518935	2015-12-06 14:55:39.064221	f
6	Облака	3	#64B6DC	oblaka.svg	2015-11-09 10:40:29.07182	2015-12-10 17:48:16.939882	f
9	Крафт	6	#C14253	ak_bars.svg	2015-12-08 19:59:13.341577	2015-12-11 12:15:36.994357	f
\.


--
-- Name: lounges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('lounges_id_seq', 9, true);


--
-- Data for Name: tables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tables (id, title, lounge_id, seats, created_at, updated_at, vip) FROM stdin;
2	Круглый	2	4	2015-11-29 12:31:19.357185	2015-11-29 12:31:19.357185	\N
3	Большой	1	5	2015-11-29 12:35:27.675715	2015-11-29 12:35:27.675715	\N
4	У входа	2	4	2015-11-29 12:36:25.802728	2015-11-29 12:36:25.802728	\N
5	1	2	4	2015-12-02 17:51:19.233381	2015-12-02 17:51:19.233381	\N
6	2	2	4	2015-12-02 17:51:29.799446	2015-12-02 17:51:29.799446	\N
7	В Либерти	2	4	2015-12-02 17:51:38.917644	2015-12-10 13:13:55.015343	\N
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY reservations (id, table_id, visit_date, user_id, created_at, updated_at, idrref, client_count, duration, end_visit_date) FROM stdin;
55	2	2015-12-11 17:30:00	66	2015-12-11 15:42:51.213838	2015-12-11 15:42:51.213838	\N	2	\N	2015-12-11 19:00:00
56	2	2015-12-13 14:00:00	57	2015-12-13 02:33:30.190206	2015-12-13 02:33:30.190206	\N	2	\N	2015-12-13 15:30:00
57	2	2015-12-14 18:00:00	66	2015-12-14 07:43:32.595597	2015-12-14 07:43:32.595597	\N	2	\N	2015-12-14 19:30:00
22	2	2015-12-29 23:00:00	30	2015-12-03 08:38:34.946098	2015-12-03 08:38:34.946098	\N	5	2.5	\N
45	2	2015-12-10 18:30:00	38	2015-12-10 13:36:51.153125	2015-12-10 13:36:51.153125	\N	3	\N	2015-12-10 20:00:00
53	2	2015-12-12 15:00:00	57	2015-12-11 11:49:04.567884	2015-12-11 11:49:04.567884	\N	2	\N	2015-12-12 16:30:00
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

COPY payments (id, amount, user_id, created_at, updated_at, table_id) FROM stdin;
3	2000	38	2015-12-05 14:59:49.477049	2015-12-05 14:59:49.477049	\N
4	9999	38	2015-12-08 12:26:54.308909	2015-12-08 12:26:54.308909	2
7	4000	58	2015-12-09 13:37:37.197688	2015-12-09 13:37:37.197688	2
8	4000	58	2015-12-10 13:14:12.182419	2015-12-10 13:14:12.182419	7
\.


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('payments_id_seq', 8, true);


--
-- Data for Name: penalties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY penalties (id, name, description, slug, image, created_at, updated_at) FROM stdin;
\.


--
-- Name: penalties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('penalties_id_seq', 1, false);


--
-- Data for Name: penalties_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY penalties_users (id, penalty_id, user_id) FROM stdin;
\.


--
-- Name: penalties_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('penalties_users_id_seq', 1, false);


--
-- Name: reservations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('reservations_id_seq', 57, true);


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

COPY skills (id, name, description, created_at, updated_at, image, ancestry, cost, parent_id, role, "row") FROM stdin;
5	Знак расположения	Вы получаете постоянную скидку на аренду кальянщика для своих мероприятий в размере 10%.	2015-11-18 10:15:24.329569	2015-12-07 14:44:18.329956	_____________1__________________.png	4	2	\N	0	2
6	Первое посвящение	Позволяет вам бесплатно принимать участие в днях экспериментов вместе с кальянными мастерами.	2015-11-18 10:16:05.43157	2015-12-07 14:44:41.366388	_____________1__________________.png	4	2	\N	0	4
7	Второе посвящение	Позволяет вам один раз в месяц присутствовать на Циклах Уникальных Встреч за счет Уникальных Кальянных.	2015-11-18 10:16:41.33946	2015-12-07 14:44:57.797828	_____________1__________________.png	4/6	3	\N	0	4
18	Абсолютное здоровье	Уникальные Кальянные оплачивают тебе годовой абонемент в спорт-зал по твоему выбору. Годовая выплата на абонемент не может превышать 40 000 руб. Данный навык нельзя накапливать.	2015-12-07 16:15:21.714116	2015-12-07 23:05:27.509926	_____________1____________________.png	\N	3	\N	1	2
8	Равенство двух/многих	Позволяет вам один раз в месяц послать через личный кабинет приглашение на встречу пользователю, который старше вас на 10 уровней.	2015-11-18 10:18:45.484466	2015-12-07 14:45:17.490842	_____________1_______________-_______.png	4/5	3	\N	0	2
9	Путь славы	Позволяет вам один раз в месяц бесплатно разместить на ресурсах Уникальных Кальянных рекламу вашего мероприятия, проводимого в Уникальных Кальянных.	2015-11-18 10:19:25.359196	2015-12-07 14:45:34.185872	_____________1___________.png	4/5/8	4	\N	0	5
14	Ne plus ultra	При бронировании места, вам автоматически вызывается такси до заведения за счет Уникальных Кальянных, а из заведения вы можете отправиться  на такси до любой необходимой вам точки, опять же за счёт Уникальных Кальянных.	2015-11-18 10:23:32.142981	2015-12-07 14:30:45.617944	_____________1_Ne_plus_ultra___2__.png	\N	6	\N	0	3
4	Добродетель гостеприимства	При первом заказе за день вы имеете право бесплатно получить чайник чая на выбор: черный или зеленый.	2015-11-18 10:14:46.638044	2015-12-07 14:31:03.735715	_____________1___________________________.png	\N	1	\N	0	3
11	Добродетель щедрости	При первом заказе за день вы имеете право получить дополнительный кальян бесплатно.	2015-11-18 10:21:22.805623	2015-12-07 14:42:37.644968	_____________1______________________same_.png	\N	4	\N	0	1
10	Третье посвящение	Позволяет вам бесплатно посещать два любых мероприятия Уникальных Кальянных в месяц.	2015-11-18 10:20:17.731062	2015-12-07 14:45:49.807183	_____________1__________________.png	4/6/7	4	\N	0	3
13	Открытые врата	При звонке не менее, чем за два часа, позволяет вам отдыхать в заведении, даже если оно не работает в это время.	2015-11-18 10:22:46.163503	2015-12-07 14:46:05.806145	_____________1_______________.png	\N	5	\N	0	2
12	Право посвященного	При звонке не менее, чем за пол часа, позволяет вам получить место в заведении при любых условиях, даже если все забито.	2015-11-18 10:21:54.437715	2015-12-11 13:53:05.186607	_____________1_______________original.png	\N	5	\N	0	4
16	Звездная болезнь	Пиар тебя любимого по твоему запросу на любых из доступных ресурсах УК один раз в месяц. Данный навык нельзя накапливать.	2015-12-07 16:11:03.191773	2015-12-10 10:17:21.967101	_____________1_________________.png	\N	1	\N	1	4
19	Приятный бонус	Один раз в месяц ты имеешь право получить дополнительную премию, равную ежедневной ставке кальянщика. Данный навык нельзя накапливать.\r\n	2015-12-07 16:15:58.264605	2015-12-10 10:18:12.300695	_____________1_______________.png	\N	3	\N	1	4
17	Чувство стиля	Изготовление твоей персональной футболки/свитшота. Дизайн и надпись выбираешь ты сам, но при этом нельзя нарушать требования франшизы. Один раз в 3 месяца дается возможность изготовить новую футболку/свитшот.	2015-12-07 16:12:08.979435	2015-12-07 23:02:07.393076	_____________1______________.png	\N	2	\N	1	3
20	Общий сбор	Один раз в три месяца ты можешь поехать на концерт/матч/мероприятие зрителем за счет Уникальных Кальянных. Оплачивается проживание, дорога и тд и тп. Общая сумма затрат не должна превышать 30 000 рублей, на руки выдаются только командировочные, а все билеты покупаем мы, согласовав их с тобой. Данный навык нельзя накапливать.	2015-12-07 16:16:40.784244	2015-12-10 10:21:26.203374	_____________1____________.png	\N	4	\N	1	1
15	Маскировка	Возможность один раз в месяц посидеть компанией «своих». Не больше 4-х человек, по предварительной брони, наличию мест и не более 2,5 часов. Компании выдается два кальяна за счет УК. Нельзя использовать табаки:«Tangiers», «Fumary» и накапливать данный навык.	2015-12-07 16:09:01.676926	2015-12-07 23:05:06.444623	_____________1____________.png	\N	1	\N	1	2
21	Тусовка своих	Один раз в три месяца, ты можешь поехать на мероприятие кальянщиков или в одну из Уникальных Кальянных на выбор. Уникальные Кальянные оплачивают дорогу, проживание, расходники для выступления и тд и тп. Общая сумма затрат не должна превышать 30 000 рублей, на руки выдаются только командировочные, а все билеты и расходники покупаем мы, согласовав их с тобой. Данный навык нельзя накапливать.	2015-12-07 16:17:19.167976	2015-12-10 10:18:42.323247	_____________1______________.png	\N	4	\N	1	3
22	Логистика	Ты добился, ты смог! Из дома на смену тебя доставляют на такси и тем же образом возвращают домой.	2015-12-07 16:18:08.555922	2015-12-10 10:19:11.410319	_____________1______________2__.png	\N	4	\N	1	5
\.


--
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('skills_id_seq', 22, true);


--
-- Data for Name: skills_links; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY skills_links (id, parent_id, child_id, created_at, updated_at) FROM stdin;
71	16	17	2015-12-07 23:02:07.375312	2015-12-07 23:02:07.375312
72	15	17	2015-12-07 23:02:07.385908	2015-12-07 23:02:07.385908
79	17	18	2015-12-07 23:05:27.486254	2015-12-07 23:05:27.486254
83	17	19	2015-12-10 10:18:12.293106	2015-12-10 10:18:12.293106
84	19	21	2015-12-10 10:18:42.31612	2015-12-10 10:18:42.31612
85	19	22	2015-12-10 10:19:11.402364	2015-12-10 10:19:11.402364
86	18	20	2015-12-10 10:21:26.196532	2015-12-10 10:21:26.196532
87	9	12	2015-12-11 13:53:05.169666	2015-12-11 13:53:05.169666
88	10	12	2015-12-11 13:53:05.178221	2015-12-11 13:53:05.178221
57	13	14	2015-12-07 14:30:45.60147	2015-12-07 14:30:45.60147
58	12	14	2015-12-07 14:30:45.610164	2015-12-07 14:30:45.610164
59	8	11	2015-12-07 14:42:37.637005	2015-12-07 14:42:37.637005
60	4	5	2015-12-07 14:44:18.321792	2015-12-07 14:44:18.321792
61	4	6	2015-12-07 14:44:41.357949	2015-12-07 14:44:41.357949
62	6	7	2015-12-07 14:44:57.789635	2015-12-07 14:44:57.789635
63	5	8	2015-12-07 14:45:17.48252	2015-12-07 14:45:17.48252
64	7	9	2015-12-07 14:45:34.177951	2015-12-07 14:45:34.177951
65	7	10	2015-12-07 14:45:49.790161	2015-12-07 14:45:49.790161
66	8	10	2015-12-07 14:45:49.798783	2015-12-07 14:45:49.798783
67	11	13	2015-12-07 14:46:05.787675	2015-12-07 14:46:05.787675
68	10	13	2015-12-07 14:46:05.797479	2015-12-07 14:46:05.797479
\.


--
-- Name: skills_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('skills_links_id_seq', 88, true);


--
-- Data for Name: skills_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY skills_users (id, skill_id, user_id, used_at, taken_at) FROM stdin;
156	4	57	2015-12-14 08:43:23.51498	2015-12-14 08:42:24.894688
\.


--
-- Name: skills_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('skills_users_id_seq', 156, true);


--
-- Name: tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tables_id_seq', 7, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 80, true);


--
-- Data for Name: works; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY works (id, lounge_id, user_id, work_at, created_at, updated_at, amount, end_work_at) FROM stdin;
1	2	59	2015-12-11 07:00:00	2015-12-10 09:38:14.935904	2015-12-10 09:40:55.162136	10000.0	2015-12-11 19:00:00
2	2	59	2015-12-09 23:00:00	2015-12-10 13:15:14.91283	2015-12-10 13:15:14.91283	3000.0	2015-12-10 19:00:00
\.


--
-- Name: works_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('works_id_seq', 2, true);


--
-- PostgreSQL database dump complete
--
