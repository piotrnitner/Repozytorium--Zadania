--Wy�wietl unikatowe daty stworzenia produkt�w (wed�ug atrybutu manufactured_date)

SELECT DISTINCT manufactured_date 
	FROM products p;

--Jak sprawdzisz czy 10 wstawionych produkt�w to 10 unikatowych kod�w produkt�w?
SELECT DISTINCT ON (product_code) product_code 
	FROM products p 
	ORDER BY product_code DESC 
	LIMIT 10;


--Korzystaj�c ze sk�adni IN wy�wietl produkty od kodach PRD1 i PRD9
SELECT product_code 
	FROM products p
	WHERE product_code IN ('PRD1', 'PRD9');

/*Wy�wietl wszystkie atrybuty z danych sprzeda�owych, takie �e data sprzeda�y jest w
zakresie od 1 sierpnia 2020 do 31 sierpnia 2020 (w��cznie). Dane wynikowe maj� by�
posortowane wed�ug warto�ci sprzeda�y malej�co i daty sprzeda�y rosn�co.*/

SELECT *
	FROM sales s 
	WHERE s.sal_date BETWEEN '2020-08-01' AND '2020-08-31'
		ORDER BY s.sal_value DESC, 
			 	 s.sal_date ASC;

/*Korzystaj�c ze sk�adni NOT EXISTS wy�wietl te produkty z tabeli PRODUCTS, kt�re nie
bior� udzia�u w transakcjach sprzeda�owych (tabela SALES). ID z tabeli Products i
SAL_PRODUCT_ID to klucz ��czenia.*/

SELECT *
	FROM products p 
	WHERE NOT EXISTS(
		SELECT 1
		FROM sales s
			WHERE s.sal_product_id = p.id);
	
/*Korzystaj�c ze sk�adni ANY i operatora = wy�wietl te produkty, kt�rych wyst�puj� w
transakcjach sprzeda�owych (wed�ug klucza Products ID, Sales SAL_PRODUCT_ID)
takich, �e warto�� sprzeda�y w transakcji jest wi�ksza od 100.*/

SELECT * 
	FROM products p 
	WHERE p.id = ANY 
		(SELECT s.sal_product_id 
			FROM sales s
				WHERE s.sal_value>100);
				
/*Stw�rz now� tabel� PRODUCTS_OLD_WAREHOUSE o takich samych kolumnach jak
istniej�ca tabela produkt�w (tabela PRODUCTS). Wstaw do nowej tabeli kilka wierszy -
dowolnych wed�ug Twojego uznania*/

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
		
/* Na podstawie tabeli z zadania 7, korzystaj�c z operacji UNION oraz UNION ALL po��cz
tabel� PRODUCTS_OLD_WAREHOUSE z 5 dowolnym produktami z tabeli
PRODUCTS, w wyniku wy�wietl jedynie nazw� produktu (kolumna PRODUCT_NAME)
i kod produktu (kolumna PRODUCT_CODE). Czy w przypadku wykorzystania UNION
jakie� wierszy zosta�y pomini�te? */

--UNION: 10 + 3 = da�o 13 rekord�w, bez "strat"
		
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
				
/*Na podstawie tabeli z zadania 7, korzystaj�c z operacji EXCEPT znajd� r�nic� zbior�w
pomi�dzy tabel� PRODUCTS_OLD_WAREHOUSE a PRODUCTS, w wyniku wy�wietl
jedynie kod produktu (kolumna PRODUCT_CODE).*/

SELECT product_code 
	FROM products p 
	EXCEPT
	SELECT product_code 
		FROM products_old_warehouse pow
	ORDER BY product_code;


/*Wy�wietl 10 rekord�w z tabeli sprzeda�owej sales. Dane powinny by� posortowane
wed�ug warto�ci sprzeda�y (kolumn SAL_VALUE) malej�co.*/

SELECT * 
	FROM sales s 
	ORDER BY sal_value DESC
	LIMIT 10;


/*Korzystaj�c z funkcji SUBSTRING na atrybucie SAL_DESCRIPTION, wy�wietl 3 dowolne
wiersze z tabeli sprzeda�owej w taki spos�b, aby w kolumnie wynikowej dla
SUBSTRING z SAL_DESCRIPTION wy�wietlonych zosta�o tylko 3 pierwsze znaki.*/

SELECT sal_description, substring (sal_description, 1, 3) AS shorter_description
FROM sales s;
	
/*Korzystaj�c ze sk�adni LIKE znajd� wszystkie dane sprzeda�owe, kt�rych opis sprzeda�y
(SAL_DESCRIPTION) zaczyna si� od c4c.*/

SELECT *
	FROM sales s 
	WHERE sal_description LIKE 'cdc%';

				


