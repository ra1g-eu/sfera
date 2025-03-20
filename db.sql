-- Users Table
CREATE TABLE users (
  id    NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  name  VARCHAR2(45) NOT NULL,
  email VARCHAR2(45) NOT NULL UNIQUE
);

-- Prices Table
CREATE TABLE prices (
  id    NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  price NUMBER NOT NULL
);

-- VAT Table
CREATE TABLE vat (
  id   NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  rate NUMBER NOT NULL
);

-- Products Table
CREATE TABLE products (
  id         NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  name       VARCHAR2(45) NOT NULL,
  prices_id  NUMBER NOT NULL,
  vat_id     NUMBER NOT NULL,
  CONSTRAINT fk_products_prices1 FOREIGN KEY (prices_id) REFERENCES prices(id),
  CONSTRAINT fk_products_vat1    FOREIGN KEY (vat_id) REFERENCES vat(id)
);

CREATE INDEX fk_products_prices1_idx ON products(prices_id);
CREATE INDEX fk_products_vat1_idx ON products(vat_id);

-- Orders Table
CREATE TABLE orders (
  id         NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  created_at DATE NOT NULL
);

-- User_Orders Table
CREATE TABLE user_orders (
  id          NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  products_id NUMBER NOT NULL,
  users_id    NUMBER NOT NULL,
  orders_id   NUMBER NOT NULL,
  vat_id      NUMBER NOT NULL,
  prices_id   NUMBER NOT NULL,
  amount      NUMBER DEFAULT 1 NOT NULL,
  CONSTRAINT fk_user_products_products FOREIGN KEY (products_id) REFERENCES products(id),
  CONSTRAINT fk_user_products_users1   FOREIGN KEY (users_id)    REFERENCES users(id),
  CONSTRAINT fk_user_orders_orders1      FOREIGN KEY (orders_id)   REFERENCES orders(id),
  CONSTRAINT fk_user_orders_vat1         FOREIGN KEY (vat_id)      REFERENCES vat(id),
  CONSTRAINT fk_user_orders_prices1      FOREIGN KEY (prices_id)   REFERENCES prices(id)
);

CREATE INDEX fk_user_products_products_idx ON user_orders(products_id);
CREATE INDEX fk_user_products_users1_idx    ON user_orders(users_id);
CREATE INDEX fk_user_orders_orders1_idx       ON user_orders(orders_id);
CREATE INDEX fk_user_orders_vat1_idx          ON user_orders(vat_id);
CREATE INDEX fk_user_orders_prices1_idx       ON user_orders(prices_id);
