CREATE SCHEMA IF NOT EXISTS ANYA;

CREATE OR REPLACE FUNCTION generate_custom_sid(id INT, prefix character(1))
returns text
as
$$
  SELECT prefix || TO_CHAR(now(), 'YY') || '_' ||
  TO_CHAR(id,'FM000000');
$$
language sql
immutable;

CREATE TABLE IF NOT EXISTS anya.company(
    pid SERIAL PRIMARY KEY,
    sid text UNIQUE GENERATED ALWAYS AS ( generate_custom_sid(pid, 'C')) STORED,
    name text NOT NULL,
    address text,
    city text,
    state text,
    country text,
    cin CHAR(21) UNIQUE CONSTRAINT cin_check CHECK (char_length(cin) = 21),
    pan CHAR(10) UNIQUE CONSTRAINT pan_check CHECK (char_length(pan) = 10),
    gstin CHAR(15) UNIQUE CONSTRAINT gstin_check CHECK (char_length(gstin) = 15)
);
INSERT INTO anya.company(name) VALUES('Primary');

CREATE TABLE IF NOT EXISTS anya.brand(
  pid SERIAL PRIMARY KEY,
  sid text UNIQUE GENERATED ALWAYS AS ( generate_custom_sid(pid, 'B')) STORED,
  name text NOT NULL,
  company_sid text REFERENCES anya.company(sid) ON DELETE RESTRICT DEFAULT 'C23_000001'
);
INSERT INTO anya.brand(name) VALUES('primary');

CREATE TABLE IF NOT EXISTS anya.product_category(
  pid SERIAL PRIMARY KEY,
  sid text UNIQUE GENERATED ALWAYS AS ( generate_custom_sid(pid, 'PC')) STORED,
  name text NOT NULL
);
INSERT INTO anya.product_category(name) VALUES('primary');

CREATE TYPE anya.code_type AS ENUM ('HSN', 'SAC');
CREATE TABLE IF NOT EXISTS anya.tax_class(
    pid SERIAL PRIMARY KEY,
    code INT NOT NULL UNIQUE,
    type_of_code anya.code_type DEFAULT 'HSN',
    description VARCHAR(150),
    rate INT NOT NULL
);
INSERT INTO anya.tax_class(code, description, rate) VALUES(0, 'default', 0);

CREATE TYPE anya.supply_type AS ENUM ('goods', 'services');
CREATE TABLE IF NOT EXISTS anya.product(
    pid SERIAL PRIMARY KEY,
    sid text UNIQUE GENERATED ALWAYS AS ( generate_custom_sid(pid, 'P')) STORED,
    name text NOT NULL,
    brand_sid text REFERENCES anya.brand(sid) ON DELETE RESTRICT DEFAULT 'B23_000001',
    category_sid text REFERENCES anya.product_category(sid) ON DELETE RESTRICT DEFAULT 'PC23_000001',
    tax_class_code INT REFERENCES anya.tax_class(code) ON DELETE RESTRICT DEFAULT 0,
    type_of_supply anya.supply_type DEFAULT 'goods',
    UNIQUE (name, brand_sid, category_sid)
);
INSERT INTO anya.product(name) VALUES('primary');

CREATE TABLE IF NOT EXISTS anya.account(
    pid SERIAL PRIMARY KEY,
    sid text UNIQUE GENERATED ALWAYS AS ( generate_custom_sid(pid, 'A')) STORED,
    name text NOT NULL,
    usrname text NOT NULL UNIQUE,
    passwd text NOT NULL,
    UNIQUE (usrname, passwd)
);
INSERT INTO anya.account(name, usrname, passwd) VALUES('admin', 'admin', 'admin');

CREATE TABLE IF NOT EXISTS anya.user(
    pid SERIAL PRIMARY KEY,
    name text NOT NULL,
    email text NOT NULL,
    usrname text NOT NULL UNIQUE,
    passwd text NOT NULL,
);




