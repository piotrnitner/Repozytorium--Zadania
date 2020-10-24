--utworzenie u�ytkownika user_training z loginem

DROP ROLE IF EXISTS user_training;
CREATE ROLE user_training WITH LOGIN PASSWORD 'CEBE0B3C0d!';

--utworzenie schematu training wraz z atrybutem AUTHORIZATION, kt�rej w�a�cicielem b�dzie accountant
CREATE SCHEMA IF NOT EXISTS training AUTHORIZATION user_training;
GRANT USAGE ON SCHEMA training TO user_training;

--zabranie przywileje do roli public
REVOKE ALL PRIVILEGES ON SCHEMA public FROM user_training;

--pr�ba usuni�cia roli user_training z poziomu zalogowanego postgres
DROP ROLE IF EXISTS user_training;
--pr�ba nieudana, istniej� zale�ne od niej obiekty

--przeniesienie uprawnie� na u�ytkownika postgres i usuni�cie roli user_training
REASSIGN OWNED BY user_training TO postgres;
DROP OWNED BY user_training;
DROP ROLE user_training;

--utworzenie nowej roli reporting_ro
--dodanie uprawnie� do schematu training dla roli reporting_ro
DROP ROLE IF EXISTS reporting_ro;
CREATE ROLE reporting_ro;
GRANT CONNECT ON DATABASE postgres TO reporting_ro
GRANT USAGE, CREATE ON SCHEMA training TO reporting_ro;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA training TO reporting_ro;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM reporting_ro;

--utworzenie nowego u�ytkownika z has�em i brakiem praw do PUBLIC
CREATE ROLE reporting_user WITH LOGIN PASSWORD 'Wt##Wt#$#WSx1';
GRANT CONNECT ON DATABASE postgres TO reporting_user;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM reporting_ro;

--po przelogowaniu na posgres_user pr�ba (udana) utworzenia nowej tabeli
CREATE TABLE IF NOT EXISTS training.test_table
	(id INTEGER
	,item_code VARCHAR(25)
	);
 
--zabranie uprawnie� do tworzenia uprawnie� dla roli reporting_ro w schemacie training
REVOKE CREATE ON SCHEMA training FROM reporting_ro;


--po przelogowaniu na postgres_user pr�ba (nieudane) utworzenia nowej tabeli w obu schematach
CREATE TABLE IF NOT EXISTS training.test_table
	(id INTEGER
	,item_code VARCHAR(25)
	);

CREATE TABLE IF NOT EXISTS public.test_table
	(id INTEGER
	,item_code VARCHAR(25)
	);
 


