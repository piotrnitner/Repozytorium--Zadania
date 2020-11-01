-- utworzenie schematu dml_exercise
DROP SCHEMA IF EXISTS dml_exercises CASCADE;
CREATE SCHEMA IF NOT EXISTS dml_exercises;

--utworzenie tabeli sales
DROP TABLE IF EXISTS dml_exercises.sales;
CREATE TABLE dml_exercises.sales 
    (id SERIAL
    ,sales_date TIMESTAMP NOT NULL
    ,sales_amount NUMERIC (38,2)
    ,sales_qty NUMERIC (10,2)
    ,added_by TEXT DEFAULT 'admin'
    ,CONSTRAINT pk_sales PRIMARY KEY (id)
    ,CONSTRAINT sales_less_1k CHECK (sales_amount <=1000)
    );

--dodanie nowych wierszy do tabeli
INSERT INTO dml_exercises.sales 
	(sales_date, sales_amount, sales_qty)
	VALUES (NOW(), 500, 9000);

--dodanie NULLa
INSERT INTO dml_exercises.sales 
	(sales_date, sales_amount, sales_qty, added_by)
	VALUES (NOW(), 330, 1000, NULL);

--sprawdzenie dzialania warunku - zadzia³a³
INSERT INTO dml_exercises.sales 
	(sales_date, sales_amount, sales_qty) 
	VALUES (NOW(), 5000, 9000);

--sprawdzenie dodania daty w proponowanym formacie - dane dostosowaly sie do pozostalych danych dat
INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
	VALUES ('20/11/2019', 101, 50, NULL);

--dodanie kolejnej daty, w tym przypadku mamy dane wyswietlaja sie: YYYY-MM-DD
INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
	VALUES ('04/04/2020', 101, 50, NULL);

--dodawanie danych z serii - 20 000 wierszy
INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty,added_by)
	SELECT NOW() + (random() * (interval '90 days')) + '30 days',
	random() * 500 + 1,
	random() * 100 + 1,
	NULL
	FROM generate_series(1, 20000) s(i);

--UPDATE atrybut added_by, wpisuj¹c mu wartosc 'sales_over_200', gdy wart.sprz (sales_amount jest wieksza lub rowna 200)
UPDATE dml_exercises.sales 
	SET added_by = 'sales_over_200'
	WHERE sales_amount >= 200;

--sprawdzenie dzialania 
SELECT * FROM dml_exercises.sales
WHERE added_by = 'sales_over_200';

--DELETE  usun te wiersze z tabeli sales, dla ktorych wartosc w polu added_by jest NULL - wariant IS NULL (7990 usunieto)
DELETE FROM dml_exercises.sales
	WHERE added_by IS NULL;

--DELETE - wariant added_by = NULL (blad: null value represents an unknown value(...))
DELETE FROM dml_exercises.sales
	WHERE added_by = NULL;

--usuniecie danych i restart sekwencji
TRUNCATE TABLE dml_exercises.sales RESTART IDENTITY;

--utworzenie backup
--pg_dump host localhost ^
       -- port 5432 ^
       -- username postgres ^
       -- format d ^
       -- file "c:\PostgreSQL_dump\db_postgres_dump" ^
       -- table dml_exercises.sales ^
	   -- postgres

--odtworzenie kopii
--pg_restore --host localhost ^
           --port 5432 ^
           --username postgres ^
           --dbname postgres ^
           --clean ^
           --"C:\PostgreSQL_dump\db_postgres_dump"

