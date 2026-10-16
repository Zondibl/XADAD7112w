-- ============================================================
-- 002 - Staff login (proposed change to the original DDL)
-- user_accounts only supported customers, so employees had no
-- way to log in. This lets an account belong to EITHER a
-- customer OR an employee.
-- Run AFTER 001_schema.sql.
-- ============================================================
ALTER TABLE user_accounts
    ALTER COLUMN customer_id DROP NOT NULL;

ALTER TABLE user_accounts
    ADD COLUMN employee_id INT UNIQUE;

ALTER TABLE user_accounts
    ADD CONSTRAINT fk_user_accounts_employee
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
    ON DELETE CASCADE;

ALTER TABLE user_accounts
    ADD CONSTRAINT chk_account_owner
    CHECK (
        (customer_id IS NOT NULL AND employee_id IS NULL) OR
        (customer_id IS NULL AND employee_id IS NOT NULL)
    );
