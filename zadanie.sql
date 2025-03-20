CREATE OR REPLACE FUNCTION calculate_product_profit(
    product_id_param NUMBER,
    start_date_param DATE,
    end_date_param   DATE
)
  RETURN NUMBER
IS
  total_profit NUMBER := 0;
  product_count NUMBER;
BEGIN
  IF start_date_param > end_date_param THEN
    raise_application_error(-20004, 'Start date must be before end date');
  END IF;
  
  SELECT COUNT(*) INTO product_count
    FROM products
   WHERE id = product_id_param;
  
  IF product_count = 0 THEN
    raise_application_error(-20001, 'Product not found');
  END IF;

  SELECT NVL(SUM( (p.price + p.price * v.rate / 100) * uo.amount ), 0)
    INTO total_profit
    FROM user_orders uo
         JOIN orders o ON uo.orders_id = o.id
         JOIN prices p ON uo.prices_id = p.id
         JOIN vat v    ON uo.vat_id    = v.id
   WHERE uo.products_id = product_id_param
     AND o.created_at BETWEEN start_date_param AND end_date_param;

  RETURN total_profit;
EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20099, 'Error: ' || SQLERRM);
END;
/


SELECT calculate_product_profit(1, TO_DATE('2025-03-18', 'YYYY-MM-DD'), TO_DATE('2025-03-20', 'YYYY-MM-DD')) AS total_profit;