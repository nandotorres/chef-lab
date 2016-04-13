CREATE TABLE customers(
  id CHAR (32) not null,
  primary key(id),
  first_name VARCHAR(64),
  last_name VARCHAR(64),
  email VARCHAR(64)
);

INSERT INTO customers (id, first_name, last_name, email) values (uuid(), 'Fernando', 'Torres', 'nandotorres@gmail.com');
INSERT INTO customers (id, first_name, last_name, email) values (uuid(), 'John', 'Doe', 'johndoe@example.com');
INSERT INTO customers (id, first_name, last_name, email) values (uuid(), 'Sam', 'Fox', 'samfox@example.com');