--Wyœwietl unikatowe daty stworzenia produktów (wed³ug atrybutu manufactured_date)

SELECT DISTINCT manufactured_date 
	FROM products p;

--Jak sprawdzisz czy 10 wstawionych produktów to 10 unikatowych kodów produktów?
SELECT DISTINCT ON (product_code) product_code 
	FROM products p 
	ORDER BY product_code DESC 
	LIMIT 10;


--Korzystaj¹c ze sk³adni IN wyœwietl produkty od kodach PRD1 i PRD9
SELECT product_code 
	FROM products p
	WHERE product_code IN ('PRD1', 'PRD9');

/*Wyœwietl wszystkie atrybuty z danych sprzeda¿owych, takie ¿e data sprzeda¿y jest w
zakresie od 1 sierpnia 2020 do 31 sierpnia 2020 (w³¹cznie). Dane wynikowe maj¹ byæ
posortowane wed³ug wartoœci sprzeda¿y malej¹co i daty sprzeda¿y rosn¹co.*/

SELECT *
	FROM sales s 
	WHERE s.sal_date BETWEEN '2020-08-01' AND '2020-08-31'
		ORDER BY s.sal_value DESC, 
			 	 s.sal_date ASC;

/*Korzystaj¹c ze sk³adni NOT EXISTS wyœwietl te produkty z tabeli PRODUCTS, które nie
bior¹ udzia³u w transakcjach sprzeda¿owych (tabela SALES). ID z tabeli Products i
SAL_PRODUCT_ID to klucz ³¹czenia.*/

SELECT *
	FROM products p 
	WHERE NOT EXISTS(
		SELECT 1
		FROM sales s
			WHERE s.sal_product_id = p.id);
	
/*Korzystaj¹c ze sk³adni ANY i operatora = wyœwietl te produkty, których wystêpuj¹ w
transakcjach sprzeda¿owych (wed³ug klucza Products ID, Sales SAL_PRODUCT_ID)
takich, ¿e wartoœæ sprzeda¿y w transakcji jest wiêksza od 100.*/

SELECT * 
	FROM products p 
	WHERE p.id = ANY 
		(SELECT s.sal_product_id 
			FROM sales s
				WHERE s.sal_value>100);
				
/*Stwórz now¹ tabelê PRODUCTS_OLD_WAREHOUSE o takich samych kolumnach jak
istniej¹ca tabela produktów (tabela PRODUCTS). Wstaw do nowej tabeli kilka wierszy -
dowolnych wed³ug Twojego uznania*/

DROP TABLE IF EXISTS products_old_warehouse;

CREATE TABLE products_old_warehouse (
	id SERIAL
	,product_name VARCHAR(100)
	,product_code VARCHAR(10)
	,product_quantity NUMERIC(10,2)
	,manufactured_date DATE
	,added_by TEXT DEFAULT 'admin'
	,created_date TIMESTAMP DEFAULT now()
	);

INSERT INTO  products_old_warehouse (product_name, product_code, product_quantity, manufactured_date, added_by, created_date)
	VALUES ('Product 11', 'PRD11', 111, '2010-05-15', 'warehouse_manager', '2010-04-01'),
			('Product 1', 'PRD1', 11, '2010-06-15', 'warehouse_manager', '2010-05-01'),
			('Product 15', 'PRD15', 222, '2010-06-25', 'buyer', '2010-05-01');
		
/* Na podstawie tabeli z zadania 7, korzystaj¹c z operacji UNION oraz UNION ALL po³¹cz
tabelê PRODUCTS_OLD_WAREHOUSE z 5 dowolnym produktami z tabeli
PRODUCTS, w wyniku wyœwietl jedynie nazwê produktu (kolumna PRODUCT_NAME)
i kod produktu (kolumna PRODUCT_CODE). Czy w przypadku wykorzystania UNION
jakieœ wierszy zosta³y pominiête? */

--UNION: 10 + 3 = da³o 13 rekordów, bez "strat"
		
SELECT product_name, product_code 
	FROM products p 
	UNION
	SELECT product_name, product_code 
		FROM products_old_warehouse pow
	ORDER BY product_code;

--UNION ALL - wynik ten sam
SELECT product_name, product_code 
	FROM products p 
	UNION ALL
	SELECT product_name, product_code 
		FROM products_old_warehouse pow
	ORDER BY product_code;
				
/*Na podstawie tabeli z zadania 7, korzystaj¹c z operacji EXCEPT znajdŸ ró¿nicê zbiorów
pomiêdzy tabel¹ PRODUCTS_OLD_WAREHOUSE a PRODUCTS, w wyniku wyœwietl
jedynie kod produktu (kolumna PRODUCT_CODE).*/

SELECT product_code 
	FROM products p 
	EXCEPT
	SELECT product_code 
		FROM products_old_warehouse pow
	ORDER BY product_code;


/*Wyœwietl 10 rekordów z tabeli sprzeda¿owej sales. Dane powinny byæ posortowane
wed³ug wartoœci sprzeda¿y (kolumn SAL_VALUE) malej¹co.*/

SELECT * 
	FROM sales s 
	ORDER BY sal_value DESC
	LIMIT 10;


/*Korzystaj¹c z funkcji SUBSTRING na atrybucie SAL_DESCRIPTION, wyœwietl 3 dowolne
wiersze z tabeli sprzeda¿owej w taki sposób, aby w kolumnie wynikowej dla
SUBSTRING z SAL_DESCRIPTION wyœwietlonych zosta³o tylko 3 pierwsze znaki.*/

SELECT sal_description, substring (sal_description, 1, 3) AS shorter_description
FROM sales s;
	
/*Korzystaj¹c ze sk³adni LIKE znajdŸ wszystkie dane sprzeda¿owe, których opis sprzeda¿y
(SAL_DESCRIPTION) zaczyna siê od c4c.*/

SELECT *
	FROM sales s 
	WHERE sal_description LIKE 'cdc%';

				


