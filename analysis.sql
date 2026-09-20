-- ============================================================
-- Factory Operations Analytics Database
-- Analyses
-- ============================================================


-- Analysis #1: Downtime-Adjusted Throughput.
WITH downtime_minutes AS (
	SELECT
		pr.run_id, pr.line_id, pr.units_produced,
		ROUND(EXTRACT( EPOCH FROM pr.end_time - pr.start_time)/60.0) AS scheduled_run_minutes,
		CASE WHEN d.downtime_id IS NULL THEN 0
		ELSE(ROUND(EXTRACT( EPOCH FROM LEAST(pr.end_time, d.end_time) - GREATEST(pr.start_time,d.start_time))/60.0))
		END AS downtime_minutes
	FROM production_runs pr
	LEFT JOIN downtime d
		ON pr.line_id = d.line_id
		AND pr.start_time < d.end_time
		AND pr.end_time > d.start_time
),
run_downtime AS (
	SELECT
		dm.run_id, dm.line_id, dm.scheduled_run_minutes, dm.units_produced,
		SUM( dm.downtime_minutes) AS downtime_minutes
	FROM downtime_minutes dm
	GROUP BY dm.run_id, dm.line_id, dm.scheduled_run_minutes, dm.units_produced
),
line_totals AS (
	SELECT 
		r.line_id, 
		SUM(r.scheduled_run_minutes) AS scheduled_minutes,
		SUM( r.downtime_minutes) AS downtime_minutes,
		SUM(r.units_produced) AS total_units
	FROM run_downtime r
	GROUP BY r.line_id
)
SELECT
	pl.line_name, l.total_units, l.scheduled_minutes, l.downtime_minutes,
	l.scheduled_minutes - l.downtime_minutes AS operating_minutes,
	ROUND(
		l.total_units * 60.0 / 
		(l.scheduled_minutes - l.downtime_minutes),
		2
	) AS adjusted_throughput
FROM line_totals l
JOIN production_lines pl
	ON l.line_id = pl.line_id
ORDER BY adjusted_throughput ;


-- Analysis #2 — Product Defect Rate
WITH production_totals AS (
	SELECT
		run_id, product_id,
		SUM(units_produced) AS total_units
	FROM production_runs
	GROUP BY run_id, product_id
),
run_defects AS (
	SELECT 
		run_id,
		SUM(defective_units) AS run_defects
	FROM defects
	GROUP BY run_id
)
SELECT
	p.sku, p.product_name,
	SUM(t.total_units) AS units_produced,
	COALESCE(SUM(d.run_defects), 0) AS defective_units,
	ROUND(
		COALESCE(SUM(d.run_defects), 0) * 100.0 / SUM(t.total_units),
		2
	) AS defect_percentage
FROM production_totals t
LEFT JOIN run_defects d
	ON t.run_id = d.run_id
JOIN products p
	ON t.product_id = p.product_id
GROUP BY p.sku, p.product_name
ORDER BY defect_percentage DESC;


--Analysis #3 — Picking Exceptions by SKU
WITH product_exceptions AS (
	SELECT
		o.product_id,
		COUNT(e.exception_id) AS picking_exceptions
	FROM order_items o
	LEFT JOIN picking_exceptions e
		ON o.order_item_id = e.order_item_id
	GROUP BY o.product_id
)
SELECT
	p.sku, p.product_name, 
	COALESCE(e.picking_exceptions, 0) AS picking_exceptions
FROM products p
LEFT JOIN product_exceptions e
	ON p.product_id = e.product_id
ORDER BY picking_exceptions DESC;


--Analysis #4 — SLA Miss Percentage by Shift
WITH late_orders AS (
	SELECT
		shift,
		COUNT(order_id) AS total_completed_orders,
		SUM(CASE WHEN actual_ship_time > promised_ship_time THEN 1
		ELSE 0
		END) AS late_orders
	FROM orders
	WHERE actual_ship_time IS NOT NULL
	GROUP BY shift
)
SELECT
	shift, total_completed_orders, late_orders,
	ROUND(late_orders * 100.0/ total_completed_orders, 2) AS sla_miss_percentage
FROM late_orders
ORDER BY sla_miss_percentage DESC;


--Analysis #5 — Downtime Percentage by Production Line
WITH downtime_minutes AS (
	SELECT
		r.run_id, r.line_id,
		ROUND(EXTRACT(EPOCH FROM r.end_time - r.start_time)/60.0) AS scheduled_minutes,
		CASE WHEN d.downtime_id IS NULL THEN 0
		ELSE(ROUND(EXTRACT(EPOCH FROM LEAST(r.end_time, d.end_time) - GREATEST(r.start_time, d.start_time))/60.0))
		END AS downtime_minutes
	FROM production_runs r
	LEFT JOIN downtime d
		ON r.line_id = d.line_id
		AND d.start_time < r.end_time
		AND d.end_time > r.start_time
),
run_minutes AS (
	SELECT 
		run_id, line_id, scheduled_minutes,
		SUM(downtime_minutes) AS run_downtime
	FROM downtime_minutes 
	GROUP BY run_id, line_id, scheduled_minutes
)
SELECT
	l.line_name,
	SUM(r.scheduled_minutes) AS scheduled_minutes,
	SUM(r.run_downtime) AS downtime_minutes,
	ROUND(SUM(r.run_downtime) * 100.0 / SUM(r.scheduled_minutes), 2) AS downtime_percentage
FROM run_minutes r
JOIN production_lines l
	ON r.line_id = l.line_id
GROUP BY l.line_name
ORDER BY downtime_percentage DESC;


--Analysis #6 — Production Run Ranking
SELECT
	l.line_name, r.run_id, r.start_time, r.units_produced,
	RANK() OVER (
		PARTITION BY r.line_id
		ORDER BY r.units_produced DESC
	) AS output_rank
FROM production_runs r
JOIN production_lines l
	ON r.line_id = l.line_id
ORDER BY l.line_name, output_rank;