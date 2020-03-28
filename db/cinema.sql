DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS screens;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS customers;

DROP TABLE IF EXISTS cinemas;

CREATE TABLE cinemas (
  id SERIAL PRIMARY KEY,
  till NUMERIC,
  name VARCHAR(255)
);

CREATE TABLE screens (
  id SERIAL PRIMARY KEY,
  cinema_id INT REFERENCES cinemas(id) ON DELETE CASCADE,
  name VARCHAR(255)
);

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  funds NUMERIC
);

CREATE TABLE films (
  id SERIAL PRIMARY KEY,
  cinema_id INT REFERENCES cinemas(id) ON DELETE CASCADE,
  title VARCHAR(255),
  price NUMERIC
);

CREATE TABLE screenings (
  id SERIAL PRIMARY KEY,
  screen_time TIME,
  film_id INT REFERENCES films(id) ON DELETE CASCADE,
  screen_id INT REFERENCES screens(id) ON DELETE CASCADE,
  max_tickets INT
);

CREATE TABLE tickets (
  id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
  film_id INT REFERENCES films(id) ON DELETE CASCADE,
  screening_id INT REFERENCES screenings(id) ON DELETE CASCADE
);
