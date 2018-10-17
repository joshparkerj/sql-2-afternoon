/* *********************** */
/* PRACTICE CROSS PRODUCTS */
/* *********************** */

SELECT Invoice.InvoiceId,CustomerId,InvoiceDate,BillingAddress,
BillingCity,BillingState,BillingCountry,BillingPostalCode,Total
FROM Invoice,InvoiceLine
WHERE Invoice.InvoiceId = InvoiceLine.InvoiceId
AND UnitPrice > 0.99;

SELECT InvoiceDate,FirstName,LastName,Total
FROM Invoice,Customer
WHERE Invoice.CustomerId = Customer.CustomerId
ORDER BY LastName ASC;

SELECT Customer.FirstName,Customer.LastName,
Employee.FirstName AS RepFirstName, Employee.LastName AS RepLastName
FROM Customer,Employee
WHERE Customer.SupportRepId = Employee.EmployeeId;

SELECT Title,Name FROM Album,Artist
WHERE Album.ArtistId = Artist.ArtistId;

SELECT TrackId FROM PlaylistTrack,Playlist
WHERE PlaylistTrack.PlaylistId = Playlist.PlaylistId
AND Name = 'Music';

SELECT Name FROM Track,PlaylistTrack
WHERE Track.TrackId = PlaylistTrack.TrackId
AND PlaylistId = 5;

SELECT Track.Name AS Track,Playlist.Name AS Playlist
FROM Track,PlaylistTrack,Playlist
WHERE Track.TrackId = PlaylistTrack.TrackId
AND Playlist.PlaylistId = PlaylistTrack.PlaylistId;

SELECT Track.Name,Title FROM Track,Album,Genre
WHERE Track.AlbumId = Album.AlbumId
AND Track.GenreId = Genre.GenreId
AND Genre.Name = 'Alternative';

/* BLACK DIAMOND */

SELECT Track.Name AS Track,Genre.Name AS Genre,
Title AS Album,Artist.Name AS Artist
FROM Track,Genre,Album,Artist,PlaylistTrack,Playlist
WHERE Track.GenreId = Genre.GenreId
AND Track.AlbumId = Album.AlbumId
AND Album.ArtistId = Artist.ArtistId
AND Track.TrackId = PlaylistTrack.TrackId
AND PlaylistTrack.PlaylistId = Playlist.PlaylistId
AND Playlist.Name = 'Music';

/* ************** */
/* PRACTICE JOINS */
/* ************** */

SELECT * 
FROM Invoice i
JOIN InvoiceLine il 
ON i.InvoiceId = il.InvoiceId
WHERE UnitPrice > 0.99;

/* *********************** */
/* PRACTICE NESTED QUERIES */
/* *********************** */

SELECT * FROM Invoice
WHERE InvoiceId IN (
SELECT InvoiceId FROM InvoiceLine
WHERE UnitPrice > 0.99);

SELECT * FROM Track
WHERE TrackId IN (
SELECT TrackId FROM PlaylistTrack
WHERE PlaylistId IN (
SELECT Playlistid FROM Playlist
WHERE Name = 'Music'));

SELECT Name FROM Track
WHERE TrackId IN (
SELECT TrackId FROM PlaylistTrack
WHERE PlaylistId = 5);

SELECT * FROM Track
WHERE GenreId IN (
SELECT GenreId FROM Genre
WHERE Name = 'Comedy');

SELECT * FROM Track
WHERE AlbumId IN (
SELECT AlbumId FROM Album
WHERE Title = 'Fireball');

SELECT * FROM Track
WHERE AlbumId IN (
SELECT AlbumId FROM Album
WHERE ArtistId IN (
SELECT ArtistId FROM Artist
WHERE Name = 'Queen'));

/* ********************** */
/* PRACTICE UPDATING ROWS */
/* ********************** */

UPDATE Customer
SET Fax = NULL
WHERE Fax IS NOT NULL;

UPDATE Customer
SET Company = 'Self'
WHERE Company IS NULL;

UPDATE Customer
SET LastName = 'Thompson'
WHERE FirstName = 'Julia'
AND LastName = 'Barnett';

UPDATE Customer
SET SupportRepId = 4
WHERE Email = 'luisrojas@yahoo.cl';

UPDATE Track
SET Composer = 'The darkness around us'
WHERE Composer IS NULL
AND GenreId IN (
SELECT GenreId FROM Genre
WHERE Name = 'Metal');

/* ***************** */
/* PRACTICE GROUP BY */
/* ***************** */

SELECT Genre.Name, COUNT(*) FROM Genre,Track
WHERE Genre.GenreId = Track.GenreId
GROUP BY Genre.GenreId
ORDER BY Genre.Name ASC;

SELECT Genre.Name, COUNT(*) FROM Genre,Track
WHERE Genre.GenreId = Track.GenreId
AND (Genre.Name = 'Pop'
OR Genre.Name = 'Rock')
GROUP BY Genre.GenreId;

SELECT Name, COUNT(*) FROM Artist,Album
WHERE Artist.ArtistId = Album.ArtistId
GROUP BY Artist.ArtistId;

/* ********************* */
/* PRACTICE USE DISTINCT */
/* ********************* */

SELECT DISTINCT Composer FROM Track;

SELECT DISTINCT BillingPostalCode FROM Invoice;

SELECT DISTINCT Company FROM Customer;

/* ******************** */
/* PRACTICE DELETE ROWS */
/* ******************** */

/* CREATE DUMMY TABLE */

CREATE TABLE practice_delete ( Name string, Type string, Value integer );
INSERT INTO practice_delete ( Name, Type, Value ) VALUES ("delete", "bronze", 50);
INSERT INTO practice_delete ( Name, Type, Value ) VALUES ("delete", "bronze", 50);
INSERT INTO practice_delete ( Name, Type, Value ) VALUES ("delete", "bronze", 50);
INSERT INTO practice_delete ( Name, Type, Value ) VALUES ("delete", "silver", 100);
INSERT INTO practice_delete ( Name, Type, Value ) VALUES ("delete", "silver", 100);
INSERT INTO practice_delete ( Name, Type, Value ) VALUES ("delete", "gold", 150);
INSERT INTO practice_delete ( Name, Type, Value ) VALUES ("delete", "gold", 150);
INSERT INTO practice_delete ( Name, Type, Value ) VALUES ("delete", "gold", 150);
INSERT INTO practice_delete ( Name, Type, Value ) VALUES ("delete", "gold", 150);

SELECT * FROM practice_delete;

/* SELECT FIRST BEFORE DELETING */

SELECT * FROM practice_delete
WHERE Type = 'bronze';

SELECT * FROM practice_delete
WHERE Type = 'silver';

SELECT * FROM practice_delete
WHERE Value = 150;

/* DELETE EM */

DELETE FROM practice_delete
WHERE Type = 'bronze';

DELETE FROM practice_delete
WHERE Type = 'silver';

DELETE FROM practice_delete
WHERE Value = 150;

/* ****************** */
/* PRACTICE SITUATION */
/* ****************** */

CREATE TABLE users (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT,
email TEXT);

CREATE TABLE products (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT,
price DECIMAL);

CREATE TABLE orders (
id INTEGER PRIMARY KEY AUTOINCREMENT,
userid INTEGER REFERENCES users(id));

CREATE TABLE products_ordered (
id INTEGER PRIMARY KEY AUTOINCREMENT,
orderid INTEGER REFERENCES orders(id),
productid INTEGER REFERENCES products(id),
qty INTEGER);

INSERT INTO users ( name, email ) VALUES ('Huy', 'h@uy.com');
INSERT INTO users ( name, email ) VALUES ("Sarah", "s@arah.com");
INSERT INTO users ( name, email ) VALUES ("Keith", "k@eith.com");
INSERT INTO products ( name, price ) VALUES ("car", 10000);
INSERT INTO products ( name, price ) VALUES ("truck", 30000);
INSERT INTO products ( name, price ) VALUES ("bus", 90000);
INSERT INTO products ( name, price ) VALUES ("plane", 270000);
INSERT INTO orders ( userid ) VALUES (2);
INSERT INTO orders ( userid ) VALUES (1);
INSERT INTO orders ( userid ) VALUES (3);
INSERT INTO orders ( userid ) VALUES (2);
INSERT INTO orders ( userid ) VALUES (1);
INSERT INTO products_ordered ( orderid, productid, qty ) VALUES (1, 1, 1);
INSERT INTO products_ordered ( orderid, productid, qty ) VALUES (2, 2, 2);
INSERT INTO products_ordered ( orderid, productid, qty ) VALUES (5, 4, 3);
INSERT INTO products_ordered ( orderid, productid, qty ) VALUES (4, 3, 4);
INSERT INTO products_ordered ( orderid, productid, qty ) VALUES (3, 4, 5);
INSERT INTO products_ordered ( orderid, productid, qty ) VALUES (2, 1, 6);

SELECT * FROM products
WHERE id IN (
SELECT productid FROM products_ordered
WHERE orderid = 1);

SELECT users.name AS user,products.name AS product,qty,orderid
FROM users,products,orders,products_ordered
WHERE users.id = userid
AND products.id = productid
AND orders.id = orderid
ORDER BY orderid ASC;

SELECT users.name AS user,orderid,SUM(qty*price) AS total
FROM users,products,orders,products_ordered
WHERE users.id = userid
AND products.id = productid
AND orders.id = orderid
GROUP BY orderid
ORDER BY total DESC;

SELECT users.name AS user,orders.id AS orderid
FROM users,orders
WHERE users.id = userid
AND user = 'Sarah';

SELECT users.name AS user, COUNT(*) AS number_of_orders
FROM users,orders
WHERE users.id = userid
GROUP BY userid;

/* BLACK DIAMOND */

SELECT users.name AS user,SUM(qty*price) AS total_over_all_orders
FROM users,products,orders,products_ordered
WHERE users.id = userid
AND products.id = productid
AND orders.id = orderid
GROUP BY userid
ORDER BY total_over_all_orders DESC;