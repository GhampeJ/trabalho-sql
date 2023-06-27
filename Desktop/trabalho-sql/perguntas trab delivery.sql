-- 1- Qual o número de hubs por cidade?
select count(hub_city),hub_city from db_deliverycenter.hubs group by hub_city limit 1000;
-- 2- Qual o número de pedidos (orders) por status?
select count(order_id) as pedidos ,order_status from db_deliverycenter.orders group by order_status limit 1000;
-- 3- Qual o número de lojas (stores) por cidade dos hubs?
select count(store_id), h.hub_city from stores as s
inner join hubs as h ON s.hub_id = h.hub_id
group by hub_city;
-- 4- Qual o maior e o menor valor de pagamento (payment_amount) registrado?
select max(payment_amount),min(payment_amount) from payments;
-- 5- Qual tipo de driver (driver_type) fez o maior número de entregas?
select count(driver_type),driver_type from drivers
group by driver_type ORDER BY max(driver_type);
-- 6- Qual a distância média das entregas por tipo de driver (driver_modal)?
SELECT AVG(delivery_distance_meters) FROM drivers AS dr
INNER JOIN deliveries AS de ON dr.driver_id = de.driver_id 
GROUP BY driver_modal limit 10;
-- 7- Qual a média de valor de pedido (order_amount) por loja, em ordem decrescente?
SELECT s.store_id,s.store_name,
AVG(o.order_amount) AS average_order_amount
FROM stores s
JOIN orders o ON s.store_id = o.store_id
GROUP BY s.store_id,s.store_name
ORDER BY average_order_amount DESC;
-- 8- Existem pedidos que não estão associados a lojas? Se caso positivo, quantos?
SELECT COUNT(*) AS count_orders_without_store
FROM orders
WHERE store_id is null;
-- pra q sor n tem nada
-- 9- Qual o valor total de pedido (order_amount) no channel 'FOOD PLACE'?
SELECT SUM(o.order_amount) AS total_pedido
FROM orders AS o
INNER JOIN channels AS c ON o.channel_id = c.channel_id
WHERE c.channel_name = 'FOOD PLACE';

-- 10- Quantos pagamentos foram cancelados (chargeback)?
SELECT COUNT(*) AS pagamentos_cancelados
FROM payments
WHERE payment_status = 'chargeback';

-- 11- Qual foi o valor médio dos pagamentos cancelados (chargeback)?

SELECT AVG(payment_amount) AS media_pagamentos_cancelados
FROM payments
WHERE payment_status = 'chargeback';

-- 12- Qual a média do valor de pagamento por método de pagamento
-- (payment_method) em ordem decrescente?
SELECT payment_method, AVG(payment_amount) AS media_pagamento_metodo
FROM payments
GROUP BY payment_method
ORDER BY media_pagamento_metodo DESC;
-- 13- Quais métodos de pagamento tiveram valor médio superior a 100?
SELECT payment_method
FROM payments
GROUP BY payment_method
HAVING AVG(payment_amount) > 100;
-- 14- Qual a média de valor de pedido (order_amount) por estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type)?
SELECT hubs.hub_state, stores.store_segment, channels.channel_type, AVG(orders.order_amount) AS average_order_amount
FROM orders
inner JOIN stores ON orders.store_id = stores.store_id
inner JOIN channels ON orders.channel_id = channels.channel_id
inner JOIN hubs ON stores.hub_id = hubs.hub_id
GROUP BY hubs.hub_state, stores.store_segment, channels.channel_type;
-- 15- Qual estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type) teve média de valor de pedido (order_amount) maior que 450?
SELECT hubs.hub_state, stores.store_segment, channels.channel_type
FROM hubs
LEFT JOIN stores ON hubs.hub_id = stores.hub_id
LEFT JOIN orders ON stores.store_id = orders.store_id
LEFT JOIN channels ON orders.channel_id = channels.channel_id
GROUP BY hubs.hub_state, stores.store_segment, channels.channel_type
HAVING AVG(orders.order_amount) > 450;

