USE transactions;

-- Exercise 2: Using JOIN you will perform the following queries
-- List of countries that are generating sales.

SELECT DISTINCT c.country
FROM  transaction AS t
JOIN company c
ON t.company_id = c.id
WHERE t.amount > 0 AND t.declined = 0
ORDER BY c.country
;

-- From how many countries sales are generated.

SELECT COUNT(DISTINCT c.country) AS total_countries_with_sales
FROM  transaction AS t
JOIN company c
ON t.company_id = c.id
WHERE t.amount > 0 AND t.declined = 0
;





-- Identify the company with the highest average sales. 

SELECT c.company_name AS company_highest_average_sales, ROUND(avg(t.amount),2) AS average_sales
FROM  transaction AS t
JOIN company c
ON t.company_id = c.id
WHERE t.amount > 0 AND t.declined = 0
GROUP BY c.company_name
ORDER BY average_sales DESC
LIMIT 1
;






-- Exercise 3: Using only subqueries (without using JOIN)
-- Show all transactions made by companies from Germany. 

SELECT *
FROM transaction AS t
WHERE t.company_id IN (SELECT id 
							FROM company 
                            WHERE company.country = 'Germany')
						
;

-- List the companies that have made transactions for an amount greater than the average of all transactions. 

SELECT DISTINCT
    c.company_name
FROM
    company AS c
WHERE
    c.id IN (
			SELECT 
				t.company_id
			FROM
				transaction AS t
			WHERE
				t.amount > (SELECT 
                    AVG(t.amount)
					FROM
                    transaction AS t
				)
			);

-- They will remove from the system the companies that do not have any registered transactions, provide the list of these companies.

SELECT c.company_name
FROM company AS c
WHERE c.id NOT IN (
					SELECT DISTINCT company_id 
					FROM transaction
                    );
 
-- Level 2
-- Exercise 1: Identify the five days when the highest amount of income was generated in the company from sales. Show the date of each transaction along with the total sales.

SELECT 
	DATE_FORMAT(DATE(timestamp), '%M %e, %Y') AS sale_date, 
    ROUND(SUM(amount), 2) AS total_sales
FROM transaction AS t
WHERE declined = 0
GROUP BY sale_date
ORDER BY total_sales DESC 
LIMIT 5
;

-- Exercise 2: What is the average sales by country? Present the results sorted from highest to lowest average.

SELECT c.country, ROUND(AVG(t.amount),2) AS sales_average
FROM transaction AS t
JOIN company AS c ON c.id = t.company_id
WHERE declined = 0
GROUP BY c.country
ORDER BY sales_average DESC
;


-- Exercise 3: In your company, a new project is proposed to launch some advertising campaigns to compete with the company "Non Institute". For this, you are asked for the list of all transactions made by companies that are located in the same country as this company.Show the list applying JOIN and subqueries. Show the list applying only subqueries.
-- Applying Join and subqueries

SELECT *
FROM transaction as t
JOIN company c on c.id = t.company_id
WHERE c.country = (
					SELECT country
                    FROM company
                    WHERE company_name = "Non Institute"
                    )
;







-- Applying only subqueries
					
SELECT *
FROM transaction as t

WHERE t.company_id IN (
					SELECT id
                    FROM company
                    WHERE country = (
									SELECT country
									FROM company
									WHERE company_name = "Non Institute"
									)
                    )
;

-- Level 3
-- Exercise 1: Present the name, phone number, country, date, and amount of those companies that made transactions with a value between 350 and 400 euros on any of these dates: April 29, 2015, July 20, 2018, and March 13, 2024. Sort the results from highest to lowest amount.

SELECT 
    c.company_name,
    c.phone,
    c.country,
    DATE_FORMAT(t.timestamp, '%M %e, %Y') AS transaction_date, 
    t.amount
FROM transaction AS t
JOIN company AS c ON t.company_id = c.id
WHERE
    t.declined = 0
    AND t.amount BETWEEN 350 AND 400
    AND DATE(t.timestamp) IN (
        STR_TO_DATE('2015-04-29', '%Y-%m-%d'),
        STR_TO_DATE('2018-07-20', '%Y-%m-%d'),
        STR_TO_DATE('2024-03-13', '%Y-%m-%d')
    )
ORDER BY t.amount DESC
;

-- Exercise 2: We need to optimize the allocation of resources, which will depend on the operational capacity required. Therefore, they ask you for information about the number of transactions that companies carry out, but the human resources department is demanding and wants a list of the companies specifying whether they have more than 400 transactions or less.

SELECT 
    c.id,
    c.company_name,
    COUNT(t.id) AS 'number_of_transactions',
    CASE
        WHEN COUNT(t.id) > 400 THEN 'Higher than 400'
        WHEN COUNT(t.id) < 400 THEN 'Smaller 400'
        ELSE 'Exactly 400'
    END AS 'transaction_state'
FROM transaction AS t
JOIN company AS c ON t.company_id = c.id
GROUP BY c.id , c.company_name
ORDER BY COUNT(t.id) DESC
;





 