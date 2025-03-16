/*
Final Project.

THE SITUATION: Cindy is close to securing Maven Fuzzy Factory's next round of funding, and she needs my help to tell a compelling story to investors. 
I will need to pull the relevant data, and help my CEO - Cindy craft a story about a data-driven company that has been producing rapid growth. 

THE OBJECTIVE: Extract and analyze traffic and website performance data to craft a growth story that my CEO can sell. Dive in to the marketing 
activities and the website improvements that have contributed to our success to date, and use the opportunity to my analytical skills for the investors
while I am at it. 

As an Analyst, the first part of my job is extracting and analyzing the data. The next (equally important) part is communicating the story effectively to 
our stakeholders. 

My objectives: 
		1. Tell the story of my company's growth, using trended performance data. 
        2. Use the database to explain how I've been abel to produce growth, by diving in to channels and website optimizations. 
        3. Flex my analytical muscles so taht VCs know my company is a serious data-driven shop 

The timeframe should be 2012-03-19 - 2015-03-20 
*/

use mavenfuzzyfactory;

 /* Question 1 
 First Cindy would like to show our volume growth. She is asking if I can pull overall session and order volume, trended by quarter for the life of the business? Since the most recent 
quarter is incomplete, I can decide how to handle it. 
*/
 
 SELECT * FROM website_sessions; 
 SELECT * FROM orders; 
 
 SELECT 
			YEAR(ws.created_at) AS yr, 
			QUARTER(ws.created_at) AS qtr, 
            COUNT(DISTINCT ws.website_session_id) AS total_sessions, 
            COUNT(DISTINCT o.order_id) AS orders
FROM website_sessions AS ws
	LEFT JOIN orders AS o
		ON ws.website_session_id = o.website_session_id
WHERE ws.created_at >= '2012-03-19'  -- The beginning of the life of the business
	  AND ws.created_at < '2015-03-20'   -- The prescribed date of the project 
GROUP BY 1, 2
; 
 
 
 /* RESULT
 2012	1	1879	60
2012	2	11433	347
2012	3	16892	684
2012	4	32266	1495
2013	1	19833	1273
2013	2	24745	1718
2013	3	27663	1840
2013	4	40540	2616
2014	1	46779	3069
2014	2	53129	3848
2014	3	57141	4035
2014	4	76373	5908
2015	1	64198	5420
*/
 
 /* Question 2 
 Next, let's showcase all of our efficiency improvements. Cindy would love for us to show quarterly figures since we launched, for session-to-order conversion rate, 
revenue per order, and revenue per session.
 */ 
 
 SELECT * FROM website_sessions; 
 SELECT * FROM orders; 
 
 SELECT 
			YEAR(ws.created_at) AS yr, 
			QUARTER(ws.created_at) AS qtr, 
            -- COUNT(DISTINCT ws.website_session_id) AS total_sessions, 
            -- COUNT(DISTINCT o.order_id) AS orders, 
            COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) AS session_to_order_conversion_rate, 
            -- SUM(o.price_usd) AS total_revenue, 
            SUM(o.price_usd)/COUNT(DISTINCT o.order_id) AS revenue_per_order, 
            SUM(o.price_usd)/COUNT(DISTINCT ws.website_session_id) AS revenue_per_session
FROM website_sessions AS ws
	LEFT JOIN orders AS o
		ON ws.website_session_id = o.website_session_id
WHERE ws.created_at >= '2012-03-19'  -- The beginning of the life of the business
	  AND ws.created_at < '2015-03-20'   -- The prescribed date of the project 
GROUP BY 1, 2
; 
 
 /*RESULT
 
 # yr	qtr	session_to_order_conversion_rate	revenue_per_order	revenue_per_session
2012	1	0.0319	49.990000	1.596275
2012	2	0.0304	49.990000	1.517233
2012	3	0.0405	49.990000	2.024222
2012	4	0.0463	49.990000	2.316217
2013	1	0.0642	52.142396	3.346809
2013	2	0.0694	51.538312	3.578211
2013	3	0.0665	51.734533	3.441114
2013	4	0.0645	54.715688	3.530741
2014	1	0.0656	62.160684	4.078136
2014	2	0.0724	64.374207	4.662462
2014	3	0.0706	64.494949	4.554298
2014	4	0.0774	63.793497	4.934885
2015	1	0.0844	62.799917	5.301965
 
 */

/* Question 3 
Cindy would like to show how we've grown specific channels. Could you pull a quarterly view of orders from Gsearch nonbrand, Bsearch nonbrand, brand search overall, 
organic search, and direct type-in? 
*/ 
 
        SELECT DISTINCT
		CASE 
			   WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN 'organic_search'
               WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN 'Gsearch_nonbrand'
               WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN 'Bsearch_nonbrand'
               -- vWHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
               WHEN utm_campaign = 'brand' THEN 'brand_search_overall'
               WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
               -- WHEN utm_source = 'socialbook' THEN 'paid_social'
		END AS channel_group, 
        utm_source, 
        utm_campaign, 
        http_referer
FROM website_sessions
WHERE DATE(created_at) < '2015-03-20'
		AND DATE(created_at) >= '2012-03-19';
        
SELECT 
		YEAR(ws.created_at) AS yr, 
        QUARTER(ws.created_at) AS qtr, 
        COUNT(DISTINCT CASE WHEN ws.utm_source = 'gsearch' AND ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS Gsearch_nonbrand, 
        COUNT(DISTINCT CASE WHEN ws.utm_source = 'bsearch' AND ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS Bsearch_nonbrand,
        COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'brand' THEN o.order_id ELSE NULL END) AS brand_search_overall,
        COUNT(DISTINCT CASE WHEN ws.utm_source IS NULL AND ws.http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN o.order_id ELSE NULL END) AS organic_search, 
        COUNT(DISTINCT CASE WHEN ws.utm_source IS NULL AND ws.http_referer IS NULL THEN o.order_id ELSE NULL END) AS direct_type_in
FROM website_sessions AS ws
	LEFT JOIN orders AS o
		ON ws.website_session_id = o.website_session_id
WHERE ws.created_at >= '2012-03-19'  -- The beginning of the life of the business
	  AND ws.created_at < '2015-03-20'   -- The prescribed date of the project 
GROUP BY 1, 2
; 
        
/*RESULT
# yr	qtr	Gsearch_nonbrand	Bsearch_nonbrand	brand_search_overall	organic_search	direct_type_in
2012	1	60	0	0	0	0
2012	2	291	0	20	15	21
2012	3	482	82	48	40	32
2012	4	913	311	88	94	89
2013	1	766	183	108	125	91
2013	2	1114	237	114	134	119
2013	3	1132	245	153	167	143
2013	4	1657	291	248	223	197
2014	1	1667	344	354	338	311
2014	2	2208	427	410	436	367
2014	3	2259	434	432	445	402
2014	4	3248	683	615	605	532
2015	1	3025	581	622	640	552

*/

/* Question 4 
Next, let's show the overall session-to-order conversion rate trends for those same channels, by quarter. Please also make a note of any periods where we 
made major improvements or optimizations. 
*/ 

SELECT 
		YEAR(ws.created_at) AS yr, 
        QUARTER(ws.created_at) AS qtr, 
        -- COUNT(DISTINCT ws.website_session_id) AS total_sessions, 
        -- COUNT(DISTINCT CASE WHEN ws.utm_source = 'gsearch' AND ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS Gsearch_nonbrand, 
        COUNT(DISTINCT CASE WHEN ws.utm_source = 'gsearch' AND ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN ws.utm_source = 'gsearch' AND ws.utm_campaign = 'nonbrand' THEN ws.website_session_id ELSE NULL END) AS gsearch_nonbrand_session_to_order_conv_rate, 
        -- COUNT(DISTINCT CASE WHEN ws.utm_source = 'bsearch' AND ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS Bsearch_nonbrand,
        COUNT(DISTINCT CASE WHEN ws.utm_source = 'bsearch' AND ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN ws.utm_source = 'bsearch' AND ws.utm_campaign = 'nonbrand' THEN ws.website_session_id ELSE NULL END) AS bsearch_nonbrand_session_to_order_conv_rate,
        -- COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'brand' THEN o.order_id ELSE NULL END) AS brand_search_overall,
        COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'brand' THEN o.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'brand' THEN ws.website_session_id ELSE NULL END) AS brand_search_overall_session_to_order_conv_rate, 
        -- COUNT(DISTINCT CASE WHEN ws.utm_source IS NULL AND ws.http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN o.order_id ELSE NULL END) AS organic_search,
        COUNT(DISTINCT CASE WHEN ws.utm_source IS NULL AND ws.http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN o.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN ws.utm_source IS NULL AND ws.http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN ws.website_session_id ELSE NULL END) AS organic_search_session_to_order_conv_rate, 
        -- COUNT(DISTINCT CASE WHEN ws.utm_source IS NULL AND ws.http_referer IS NULL THEN o.order_id ELSE NULL END) AS direct_type_in, 
        COUNT(DISTINCT CASE WHEN ws.utm_source IS NULL AND ws.http_referer IS NULL THEN o.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN ws.utm_source IS NULL AND ws.http_referer IS NULL THEN ws.website_session_id ELSE NULL END) AS direct_type_in_session_to_order_conv_rate
FROM website_sessions AS ws
	LEFT JOIN orders AS o
		ON ws.website_session_id = o.website_session_id
WHERE ws.created_at >= '2012-03-19'  -- The beginning of the life of the business
	  AND ws.created_at < '2015-03-20'   -- The prescribed date of the project 
GROUP BY 1, 2
; 

/*
RESULT
yr, qtr, gsearch_nonbrand_session_to_order_conv_rate, bsearch_nonbrand_session_to_order_conv_rate, brand_search_overall_session_to_order_conv_rate, organic_search_session_to_order_conv_rate, direct_type_in_session_to_order_conv_rate
2012	1	0.0324		0.0000	0.0000	0.0000
2012	2	0.0284		0.0526	0.0359	0.0536
2012	3	0.0384	0.0408	0.0602	0.0498	0.0443
2012	4	0.0436	0.0497	0.0531	0.0539	0.0537
2013	1	0.0612	0.0693	0.0703	0.0753	0.0614
2013	2	0.0685	0.0690	0.0679	0.0760	0.0735
2013	3	0.0639	0.0697	0.0703	0.0734	0.0719
2013	4	0.0629	0.0601	0.0801	0.0694	0.0647
2014	1	0.0693	0.0704	0.0839	0.0756	0.0765
2014	2	0.0702	0.0695	0.0804	0.0797	0.0738
2014	3	0.0703	0.0698	0.0756	0.0733	0.0702
2014	4	0.0782	0.0841	0.0812	0.0784	0.0748
2015	1	0.0861	0.0850	0.0852	0.0821	0.0775

*/

/* Question 5 
We've come a long way since the days of selling a single product. Let's pull monthly trending for revenue and margin by product, along with total sales and revenue. 
Note anything you notice about seasonality.
*/

SELECT * 
FROM orders 
WHERE created_at >= '2012-03-19'  -- The beginning of the life of the business
	  AND created_at < '2015-03-20'  ;  
      
SELECT * FROM order_items; 

SELECT 
			YEAR(created_at) AS yr, 
            MONTH(created_at) AS mo, 
            SUM(CASE WHEN product_id = 1 THEN price_usd ELSE NULL END) AS MrFuzzy_Revenue, 
            SUM(CASE WHEN product_id = 1 THEN price_usd - cogs_usd ELSE NULL END) AS MrFuzzy_Margin,
            SUM(CASE WHEN product_id = 2 THEN price_usd ELSE NULL END) AS LoveBear_Revenue,
            SUM(CASE WHEN product_id = 2 THEN price_usd - cogs_usd ELSE NULL END) AS LoveBear_Margin,
            SUM(CASE WHEN product_id = 3 THEN price_usd ELSE NULL END) AS SugarPanda_Revenue,
            SUM(CASE WHEN product_id = 3 THEN price_usd - cogs_usd ELSE NULL END) AS SugarPanda_Margin,
            SUM(CASE WHEN product_id = 4 THEN price_usd ELSE NULL END) AS HudsonriverMiniBear_Revenue, 
            SUM(CASE WHEN product_id = 4 THEN price_usd - cogs_usd ELSE NULL END) AS HudsonriverMiniBear_Margin, 
            SUM(price_usd) AS total_revenue, 
            SUM(price_usd - cogs_usd) AS total_margin
FROM order_items
WHERE is_primary_item = 1

GROUP BY 1, 2
;

/*
RESULT: 
yr, mo, MrFuzzy_Revenue, MrFuzzy_Margin, LoveBear_Revenue, LoveBear_Margin, SugarPanda_Revenue, SugarPanda_Margin, HudsonriverMiniBear_Revenue, HudsonriverMiniBear_Margin, total_revenue, total_margin
2012	3	2999.40	1830.00							2999.40	1830.00
2012	4	4949.01	3019.50							4949.01	3019.50
2012	5	5398.92	3294.00							5398.92	3294.00
2012	6	6998.60	4270.00							6998.60	4270.00
2012	7	8448.31	5154.50							8448.31	5154.50
2012	8	11397.72	6954.00							11397.72	6954.00
2012	9	14347.13	8753.50							14347.13	8753.50
2012	10	18546.29	11315.50							18546.29	11315.50
2012	11	30893.82	18849.00							30893.82	18849.00
2012	12	25294.94	15433.00							25294.94	15433.00
2013	1	17146.57	10461.50	2819.53	1762.50					19966.10	12224.00
2013	2	16796.64	10248.00	9718.38	6075.00					26515.02	16323.00
2013	3	15996.80	9760.00	3899.35	2437.50					19896.15	12197.50
2013	4	22945.41	13999.50	5639.06	3525.00					28584.47	17524.50
2013	5	24445.11	14914.50	4919.18	3075.00					29364.29	17989.50
2013	6	25144.97	15341.50	5399.10	3375.00					30544.07	18716.50
2013	7	25444.91	15524.50	5699.05	3562.50					31143.96	19087.00
2013	8	25494.90	15555.00	5879.02	3675.00					31373.92	19230.00
2013	9	26794.64	16348.00	5579.07	3487.50					32373.71	19835.50
2013	10	30143.97	18391.50	6298.95	3937.50					36442.92	22329.00
2013	11	36092.78	22021.00	8338.61	5212.50					44431.39	27233.50
2013	12	40141.97	24491.50	8638.56	5400.00	4599.00	3150.00			53379.53	33041.50
2014	1	35642.87	21746.50	8518.58	5325.00	5840.73	4000.50			50002.18	31072.00
2014	2	28544.29	17415.50	19196.80	12000.00	5978.70	4095.00			53719.79	33510.50
2014	3	38192.36	23302.00	9298.45	5812.50	6760.53	4630.50			54251.34	33745.00
2014	4	45040.99	27480.50	9598.40	6000.00	8278.20	5670.00			62917.59	39150.50
2014	5	50689.86	30927.00	11338.11	7087.50	7588.35	5197.50			69616.32	43212.00
2014	6	43641.27	26626.50	11338.11	7087.50	8140.23	5575.50			63119.61	39289.50
2014	7	47090.58	28731.00	10678.22	6675.00	7634.34	5229.00			65403.14	40635.00
2014	8	46940.61	28639.50	11338.11	7087.50	9060.03	6205.50			67338.75	41932.50
2014	9	51989.60	31720.00	11938.01	7462.50	8508.15	5827.50			72435.76	45010.00
2014	10	57338.53	34983.50	13617.73	8512.50	10807.65	7402.50			81763.91	50898.50
2014	11	70885.82	43249.00	17997.00	11250.00	12279.33	8410.50			101162.15	62909.50
2014	12	77834.43	47488.50	17457.09	10912.50	14486.85	9922.50	4528.49	3095.50	114306.86	71419.00
2015	1	67186.56	40992.00	17817.03	11137.50	12739.23	8725.50	5398.20	3690.00	103141.02	64545.00
2015	2	54139.17	33031.50	34794.20	21750.00	11543.49	7906.50	4618.46	3157.00	105095.32	65845.00
2015	3	41791.64	25498.00	10378.27	6487.50	6852.51	4693.50	2879.04	1968.00	61901.46	38647.00

*/


/* Question 6 
Let's dive deeper into the impact of introducing new products. Please pull monthly sessions to the /products page, and show how the % of those sessions clicking 
through another page has changed over time, along with a view of how conversion from /products to placing an order has improved. 
*/

    -- first, identify all the views of the /products page
    
    CREATE TEMPORARY TABLE product_pageview_temp_table
    SELECT
			 website_session_id,
            website_pageview_id,
            created_at AS saw_product_page_at 
            
    FROM website_pageviews
    WHERE pageview_url = '/products'
    ; 
    SELECT * FROM product_pageview_temp_table; 
    -- find the pages with pageview_id > product pageview_id 
    
    
    SELECT 
			YEAR(saw_product_page_at) AS yr, 
			MONTH(saw_product_page_at) AS mo, 
			COUNT(DISTINCT pp.website_session_id) AS sessions_to_product_page, 
            COUNT(DISTINCT wp.website_session_id) AS clicked_to_next_page, 
			COUNT(DISTINCT wp.website_session_id)/COUNT(DISTINCT pp.website_session_id) AS clickthrough_rate, 
			COUNT(DISTINCT o.order_id) AS orders, 
            COUNT(DISTINCT o.order_id)/COUNT(DISTINCT pp.website_session_id) AS products_to_order_rate
   FROM product_pageview_temp_table AS pp
		LEFT JOIN website_pageviews AS wp 
			ON pp.website_session_id = wp.website_session_id   -- same session
            AND wp.website_pageview_id > pp.website_pageview_id -- they had another page AFTER
		LEFT JOIN orders AS o
			ON o.website_session_id = pp.website_session_id
	GROUP BY 1, 2
    ;
 
/*
RESULT: 
yr, mo, sessions_to_product_page, clicked_to_next_page, clickthrough_rate, orders, products_to_order_rate
2012	3	743	530	0.7133	60	0.0808
2012	4	1447	1029	0.7111	99	0.0684
2012	5	1584	1135	0.7165	108	0.0682
2012	6	1752	1247	0.7118	140	0.0799
2012	7	2018	1438	0.7126	169	0.0837
2012	8	3012	2198	0.7297	228	0.0757
2012	9	3126	2258	0.7223	287	0.0918
2012	10	4030	2948	0.7315	371	0.0921
2012	11	6743	4849	0.7191	618	0.0917
2012	12	5013	3620	0.7221	506	0.1009
2013	1	3380	2595	0.7678	391	0.1157
2013	2	3685	2803	0.7607	497	0.1349
2013	3	3371	2576	0.7642	385	0.1142
2013	4	4362	3356	0.7694	553	0.1268
2013	5	4684	3609	0.7705	571	0.1219
2013	6	4600	3536	0.7687	594	0.1291
2013	7	5020	3890	0.7749	603	0.1201
2013	8	5226	3951	0.7560	608	0.1163
2013	9	5399	4072	0.7542	629	0.1165
2013	10	6038	4564	0.7559	708	0.1173
2013	11	7886	5900	0.7482	861	0.1092
2013	12	8840	7026	0.7948	1047	0.1184
2014	1	7790	6387	0.8199	983	0.1262
2014	2	7960	6485	0.8147	1021	0.1283
2014	3	8110	6669	0.8223	1065	0.1313
2014	4	9744	7958	0.8167	1241	0.1274
2014	5	10261	8465	0.8250	1368	0.1333
2014	6	10011	8260	0.8251	1239	0.1238
2014	7	10837	8958	0.8266	1287	0.1188
2014	8	10768	8980	0.8340	1324	0.1230
2014	9	11128	9156	0.8228	1424	0.1280
2014	10	12335	10235	0.8298	1609	0.1304
2014	11	14476	12020	0.8303	1985	0.1371
2014	12	17240	14609	0.8474	2314	0.1342
2015	1	15217	12992	0.8538	2099	0.1379
2015	2	14373	12187	0.8479	2067	0.1438
2015	3	9022	7723	0.8560	1254	0.1390

*/
    
/* Question 7 
We made our 4th product available as a primary product on December 05, 2014 (it was previously only a cross-sell item). Cindy ask me if I can pull sales data since then, 
and show how well each product cross-sells from on another? 
*/ 

-- the timeframe should be 2014-12-05 - 2015-03-20 

CREATE TEMPORARY TABLE primary_products
SELECT 
		order_id, 
        primary_product_id, 
        created_at AS ordered_at
FROM orders
WHERE created_at > '2014-12-05' -- when the 4th product was added
; 

SELECT pp.*, 
			oi.product_id AS cross_sell_product_id
FROM primary_products AS pp
	LEFT JOIN order_items AS oi
		ON pp.order_id = oi.order_id
        AND oi.is_primary_item = 0 -- only bringing in cross-sells
; 

SELECT
			primary_product_id, 
            COUNT(DISTINCT order_id) AS total_orders,
			COUNT(DISTINCT CASE WHEN cross_sell_product_id = 1 THEN order_id ELSE NULL END) AS xsold_p1, 
            COUNT(DISTINCT CASE WHEN cross_sell_product_id = 2 THEN order_id ELSE NULL END) AS xsold_p2,
            COUNT(DISTINCT CASE WHEN cross_sell_product_id = 3 THEN order_id ELSE NULL END) AS xsold_p3,
            COUNT(DISTINCT CASE WHEN cross_sell_product_id = 4 THEN order_id ELSE NULL END) AS xsold_p4,
            COUNT(DISTINCT CASE WHEN cross_sell_product_id = 1 THEN order_id ELSE NULL END)/COUNT(DISTINCT order_id) AS p1_xsell_rate, 
            COUNT(DISTINCT CASE WHEN cross_sell_product_id = 2 THEN order_id ELSE NULL END)/COUNT(DISTINCT order_id) AS p2_xsell_rate,
            COUNT(DISTINCT CASE WHEN cross_sell_product_id = 3 THEN order_id ELSE NULL END)/COUNT(DISTINCT order_id) AS p3_xsell_rate,
            COUNT(DISTINCT CASE WHEN cross_sell_product_id = 4 THEN order_id ELSE NULL END)/COUNT(DISTINCT order_id) AS p4_xsell_rate
FROM (

	SELECT pp.*, 
			oi.product_id AS cross_sell_product_id
	FROM primary_products AS pp
		LEFT JOIN order_items AS oi
			ON pp.order_id = oi.order_id
			AND oi.is_primary_item = 0

) AS primary_w_cross_sell
GROUP BY 1
; 

/*
RESULT: 
primary_product_id, total_orders, xsold_p1, xsold_p2, xsold_p3, xsold_p4, p1_xsell_rate, p2_xsell_rate, p3_xsell_rate, p4_xsell_rate
1	4467	0	238	553	933	0.0000	0.0533	0.1238	0.2089
2	1277	25	0	40	260	0.0196	0.0000	0.0313	0.2036
3	929	84	40	0	208	0.0904	0.0431	0.0000	0.2239
4	581	16	9	22	0	0.0275	0.0155	0.0379	0.0000
*/


/* Question 8 

Cindy is asking me: "In addition to telling investors about what we've already achieved, let's show them that we still have plenty of gas in the tank. Based on all the analysis you've done, could 
you share some recommendations and opportunities for us going forward? No right or wrong answer here - I'd just like to hear your perspective!" 
*/ 

/* 
Recommendation: 
			1. We are seeing product 1 is selling really well along with other cross sell products so I recommend to make it as our flagship product 
            2. I recommend we add more vendors into production just in case one vendor went down and the other vendors can pick it up from there. 
*/ 


	
