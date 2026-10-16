-- ============================================================
-- 005 - Two-factor authentication (proposed change to the DDL)
-- Adds the columns the web app needs to store each account's
-- authenticator-app secret (stored ENCRYPTED by the app).
-- Run AFTER 001-004.
-- ============================================================
ALTER TABLE user_accounts
    ADD COLUMN two_factor_enabled BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE user_accounts
    ADD COLUMN two_factor_secret VARCHAR(255);
