-- ============================================================
-- 004 - Lets the 5 test customers log in to the web app.
-- Password for all of them: Test#1234
-- Run AFTER 003_test_data.sql (test use only - never in production).
-- ============================================================
UPDATE user_accounts SET password_hash = 'AQAAAAEAAYagAAAAEBKwt7oLDnw5+GSjYxjXaqj+a+tlhLEoM1XRbWo9e8T85vz97IfHIY3amJhlX6eh1A==' WHERE username = 'john.smith';
UPDATE user_accounts SET password_hash = 'AQAAAAEAAYagAAAAENPG6bNvWBkKAMim+5oLC6fhp4zhLSuulpkCXSvXE4vq5ElRNA3663GWtLHS9iHOvA==' WHERE username = 'thandi.mokoena';
UPDATE user_accounts SET password_hash = 'AQAAAAEAAYagAAAAEFq8ovOOzd677DZhMYlXhsnWFaHVM4xvwXxk/am3k/nj/4mFHSPUJBdQ3CKpkotdYA==' WHERE username = 'michael.naidoo';
UPDATE user_accounts SET password_hash = 'AQAAAAEAAYagAAAAEHmDjg3XAwn8uNsUwEcVduUsxTbKS/MsVwBbfNT/ZiunXDS6vq764bbqjIDgdwiIew==' WHERE username = 'sarah.dlamini';
UPDATE user_accounts SET password_hash = 'AQAAAAEAAYagAAAAEDjbqcEHOminQIETASVssIrlhzDO152Drs4JfbADcwig3csEcIXy1tTTiPiT0AJMsA==' WHERE username = 'david.williams';
