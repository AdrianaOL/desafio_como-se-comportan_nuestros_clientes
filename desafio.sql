

--C:\Program Files\PostgreSQL\14\bin 
-- Creacion BD.
CREATE DATABASE unidad2;
--Cargar el respaldo de la base de datos unidad2.sql.
psql -U postgres unidad2 <  C:\Users\SSI\Desktop\unidad2.sql
-- Desabilitar autocomit---
\set AUTOCOMMIT off

--2. El cliente usuario01 ha realizado la siguiente compra:
--● producto: producto9.
--● cantidad: 5.
--● fecha: fecha del sistema.
--Mediante el uso de transacciones, realiza las consultas correspondientes para este
--requerimiento y luego consulta la tabla producto para validar si fue efectivamente
--descontado en el stock.

BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha) VALUES (33,1,now());
UPDATE producto SET stock = stock - 5 WHERE id = 9;
COMMIT;

--3. El cliente usuario02 ha realizado la siguiente compra:
--● producto: producto1, producto 2, producto 8.
--● cantidad: 3 de cada producto.
--● fecha: fecha del sistema.
--Mediante el uso de transacciones, realiza las consultas correspondientes para este
--requerimiento y luego consulta la tabla producto para validar que si alguno de ellos se queda sin stock, no se realice la compra.

BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha) VALUES (34,2,now());
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (1,34,3);
UPDATE producto SET stock = stock - 3 WHERE id = 1;
SAVEPOINT checkpoint1;
BEGIN TRANSACTION;
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (2,34,3);
UPDATE producto SET stock = stock - 3 WHERE id = 2;
SAVEPOINT checkpoint2;
BEGIN TRANSACTION;
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (8,34,3);
UPDATE producto SET stock = stock - 3 WHERE id = 8;
ROLLBACK TO checkpoint2;

--4. Realizar las siguientes consultas:
--a. Deshabilitar el AUTOCOMMIT.
\set AUTOCOMMIT off
--b. Insertar un nuevo cliente.
INSERT INTO cliente (nombre, email) VALUES ('usuario11', 'usuario11@outlook.es');
--c. Confirmar que fue agregado en la tabla cliente.
SELECT * FROM cliente;
--d. Realizar un ROLLBACK.
ROLLBACK;
--e. Confirmar que se restauró la información, sin considerar la inserción del punto b.
SELECT * FROM cliente;
--f. Habilitar de nuevo el AUTOCOMMIT.
\set  AUTOCOMMIT on


