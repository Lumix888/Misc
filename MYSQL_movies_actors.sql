
CREATE DATABASE moviedb;
USE moviedb;

CREATE TABLE genre (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    genre VARCHAR(30) NOT NULL
);


CREATE TABLE quote (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    quote VARCHAR(60) NOT NULL
);

CREATE TABLE artist (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    mid_name VARCHAR(20),
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL
);

CREATE TABLE production (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) UNIQUE NOT NULL,
    country VARCHAR(30) NOT NULL,
    state  VARCHAR(30) NOT NULL,
    city   VARCHAR(30) NOT NULL,
    street  VARCHAR(30) NOT NULL,
    street_n  INT(3) UNSIGNED NOT NULL
);

CREATE TABLE movie (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    release_year YEAR NOT NULL,
    title VARCHAR(20) NOT NULL,
    minutes_lengt INT NOT NULL,
    plot_outline VARCHAR(100) NOT NULL,
    production_id INT(6) UNSIGNED,
    FOREIGN KEY (production_id) REFERENCES production(id)
);

CREATE TABLE actor (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    artist_id INT(6) UNSIGNED,
    movie_id INT(6) UNSIGNED,
    role VARCHAR(30) NOT NULL,
    quotes_id INT(6) UNSIGNED,
	FOREIGN KEY (artist_id) REFERENCES artist(id),
	FOREIGN KEY (movie_id) REFERENCES movie(id),
    FOREIGN KEY (quotes_id) REFERENCES quote(id)
);

CREATE TABLE movie_genre (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    movie_id INT(6) UNSIGNED,
    genre_id INT(6) UNSIGNED,
	FOREIGN KEY (movie_id) REFERENCES movie(id),
	FOREIGN KEY (genre_id) REFERENCES genre(id)
);

CREATE TABLE director (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    artist_id INT(6) UNSIGNED,
    movie_id INT(6) UNSIGNED,
	FOREIGN KEY (artist_id) REFERENCES artist(id),
	FOREIGN KEY (movie_id) REFERENCES movie(id)
);



INSERT INTO genre (genre)
VALUES ('war');
INSERT INTO genre (genre)
VALUES ('romantic');
INSERT INTO genre (genre)
VALUES ('adventure');

INSERT INTO quote (quote)
VALUES ('io sono io e voi non siete niente');
INSERT INTO quote (quote)
VALUES ('vado un attimo in bagno');

INSERT INTO artist  (first_name, last_name, birth_date)
VALUES ('peppe', 'er magnfico', '1999-12-05');
INSERT INTO artist  (first_name, last_name, birth_date)
VALUES ('mikk', 'martson', '1996-09-25');
INSERT INTO artist  (first_name, last_name, birth_date)
VALUES ('bono', 'vox', '1980-12-05');
INSERT INTO artist  (first_name, last_name, birth_date)
VALUES ('sabrina', 'ivanova', '1997-12-05');


INSERT INTO production  (name, country, state, city, street, street_n)
VALUES ('pretzels inc', 'USA', 'california', 'Los Angeles', 'street', 21);
INSERT INTO production  (name, country, state, city, street, street_n)
VALUES ('films inc', 'USA', 'california', 'Los Angeles', 'some stuff', 31);



INSERT INTO movie (release_year, minutes_lengt, title, plot_outline, production_id)
SELECT  '2021', 120, 'thor', 'the story of thor', production.id
FROM production
WHERE production.name = 'pretzels inc';
INSERT INTO movie (release_year, minutes_lengt, title, plot_outline, production_id)
SELECT  '2021', 120, 'bono', 'the life of a singer', production.id
FROM production
WHERE production.name = 'films inc';





INSERT INTO actor (artist_id, movie_id, role, quotes_id)
SELECT artist.id, movie.id, 'bidone', quote.id
FROM artist, movie, quote
WHERE artist.first_name = 'peppe'
  AND movie.title = 'thor'
  AND quote.quote = 'io sono io e voi non siete niente';
INSERT INTO actor (artist_id, movie_id, role)
SELECT artist.id, movie.id, 'hammer'
FROM artist, movie
WHERE artist.first_name = 'mikk'
  AND movie.title = 'thor';
INSERT INTO actor (artist_id, movie_id, role, quotes_id)
SELECT artist.id, movie.id, 'bidone', quote.id
FROM artist, movie,  quote
WHERE artist.first_name = 'peppe'
  AND movie.title = 'bono'
  AND quote.quote = 'vado un attimo in bagno';
INSERT INTO actor (artist_id, movie_id, role)
SELECT artist.id, movie.id, 'singer'
FROM artist, movie
WHERE artist.first_name = 'bono'
  AND movie.title = 'bono';
INSERT INTO actor (artist_id, movie_id, role)
SELECT artist.id, movie.id, 'zucculun'
FROM artist, movie
WHERE artist.first_name = 'sabrina'
  AND movie.title = 'bono';



INSERT INTO movie_genre (movie_id, genre_id)
SELECT movie.id, genre.id
FROM movie, genre
WHERE movie.title = 'thor'
  AND genre.genre = 'war';
INSERT INTO movie_genre (movie_id, genre_id)
SELECT movie.id, genre.id
FROM movie, genre
WHERE movie.title = 'bono'
  AND genre.genre = 'adventure';
INSERT INTO movie_genre (movie_id, genre_id)
SELECT movie.id, genre.id
FROM movie, genre
WHERE movie.title = 'bono'
  AND genre.genre = 'romantic';


INSERT INTO director (artist_id, movie_id)
SELECT artist.id, movie.id
FROM artist, movie
WHERE artist.first_name = 'peppe'
  AND movie.title = 'thor';
INSERT INTO director (artist_id, movie_id)
SELECT artist.id, movie.id
FROM artist, movie
WHERE artist.first_name = 'peppe'
  AND movie.title = 'bono';


SELECT movie.title, movie.release_year, cnt.actors
FROM movie
INNER JOIN (
    SELECT movie.id, COUNT(*) AS actors
    FROM actor
    INNER JOIN movie on movie.id = actor.movie_id
    GROUP BY movie.id
) AS cnt ON movie.id = cnt.id
WHERE movie.release_year > '2020'
    AND movie.release_year <= '2022';



SELECT artist.first_name, artist.last_name, movie.release_year, movie.title, quote.quote
FROM actor
INNER JOIN artist ON actor.artist_id = artist.id
INNER JOIN movie ON actor.movie_id = movie.id
INNER JOIN quote ON actor.quotes_id = quote.id
WHERE artist.first_name = 'peppe'
  AND artist.last_name = 'er magnfico';



CREATE VIEW first_query AS
SELECT movie.title, movie.release_year, cnt.actors
FROM movie
INNER JOIN (
    SELECT movie.id, COUNT(*) AS actors
    FROM actor
    INNER JOIN movie on movie.id = actor.movie_id
    GROUP BY movie.id
) AS cnt ON movie.id = cnt.id
WHERE movie.release_year > '2020'
    AND movie.release_year <= '2022';


DELIMITER //
CREATE FUNCTION first_query_count()
RETURNS INTEGER DETERMINISTIC
BEGIN
    DECLARE temp INT;
    SELECT COUNT(*) INTO temp FROM first_query;
    RETURN temp;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE quotes()
BEGIN
    SELECT artist.first_name, artist.last_name, movie.release_year, movie.title, quote.quote
    FROM actor
    INNER JOIN artist ON actor.artist_id = artist.id
    INNER JOIN movie ON actor.movie_id = movie.id
    INNER JOIN quote ON actor.quotes_id = quote.id
    WHERE artist.first_name = 'peppe'
      AND artist.last_name = 'er magnfico';
END//
DELIMITER ;




