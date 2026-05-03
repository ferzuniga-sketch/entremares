-- ============================================================
-- Entremares — Seed Data
-- ============================================================
-- UUIDs are fixed so foreign keys resolve correctly.

-- Projects -------------------------------------------------------
insert into projects (
  id, name, location, description, type,
  total_capex, amount_raised,
  target_return_min, target_return_max,
  timeline_months, status, start_date, end_date
) values
(
  'aaaaaaaa-0001-0001-0001-000000000001',
  'Kabil',
  'Tijuana, Mexico',
  'Boutique 4-apartment building in Tijuana''s premium residential district. '
  'Fully sold on exit, delivering 18% total return to investors.',
  'Residential',
  500000, 500000,
  18, 18,
  30, 'completed',
  '2020-06-01', '2022-12-31'
),
(
  'aaaaaaaa-0002-0002-0002-000000000002',
  'Allure',
  'Tijuana, Mexico',
  'Two luxury townhouses in Tijuana''s exclusive Zona Río. '
  'Delivered ahead of schedule with a 22% average return.',
  'Residential',
  600000, 600000,
  22, 22,
  24, 'completed',
  '2023-01-01', '2024-12-31'
),
(
  'aaaaaaaa-0003-0003-0003-000000000003',
  'Real del Monte',
  'Tijuana, Mexico',
  'Boutique residential development in the premium Real del Monte district. '
  'Targeting 20–25% total return over 24 months. Currently in active fundraising.',
  'Residential',
  800000, 250000,
  20, 25,
  24, 'funding',
  '2025-01-01', null
);

-- Investor (Carlos Martinez) -------------------------------------
-- Wallet math:
--   Deposit $25 000 → invest Kabil → return $29 500 (+18%)
--   Top-up $2 500 → reinvest $32 000 in Allure → return $41 600 (+30%)
--   Current wallet: $41 600 (all Allure proceeds pending reinvestment)
insert into investors (
  id, email, full_name, country, phone,
  wallet_balance, total_invested, total_returns,
  member_since, status
) values (
  'bbbbbbbb-0001-0001-0001-000000000001',
  'carlos@test.com',
  'Carlos Martinez',
  'Mexico',
  '+52 664 555 0123',
  41600,   -- available balance
  57000,   -- 25 000 (Kabil) + 32 000 (Allure)
  14100,   -- 4 500 (Kabil) + 9 600 (Allure)
  '2020-06-01',
  'active'
);

-- Investments ----------------------------------------------------
insert into investments (
  id, investor_id, project_id,
  amount, status,
  return_amount, return_percentage,
  invested_at
) values
(
  'cccccccc-0001-0001-0001-000000000001',
  'bbbbbbbb-0001-0001-0001-000000000001',
  'aaaaaaaa-0001-0001-0001-000000000001',
  25000, 'completed',
  4500, 18,
  '2020-06-01 00:00:00+00'
),
(
  'cccccccc-0002-0002-0002-000000000002',
  'bbbbbbbb-0001-0001-0001-000000000001',
  'aaaaaaaa-0002-0002-0002-000000000002',
  32000, 'completed',
  9600, 30,
  '2023-01-01 00:00:00+00'
);

-- Transactions ---------------------------------------------------
-- Chronological ledger for Carlos's account.
insert into transactions (investor_id, investment_id, type, amount, description, created_at)
values
-- 1. Initial deposit to fund Kabil
(
  'bbbbbbbb-0001-0001-0001-000000000001',
  null,
  'deposit',
  25000,
  'Initial deposit',
  '2020-06-01 09:00:00+00'
),
-- 2. Capital committed to Kabil
(
  'bbbbbbbb-0001-0001-0001-000000000001',
  'cccccccc-0001-0001-0001-000000000001',
  'reinvestment',
  25000,
  'Investment committed — Kabil',
  '2020-06-01 10:00:00+00'
),
-- 3. Kabil exits: principal + 18% return
(
  'bbbbbbbb-0001-0001-0001-000000000001',
  'cccccccc-0001-0001-0001-000000000001',
  'return',
  29500,
  'Capital + 18% return received — Kabil',
  '2022-12-31 12:00:00+00'
),
-- 4. Top-up to reach Allure ticket size
(
  'bbbbbbbb-0001-0001-0001-000000000001',
  null,
  'deposit',
  2500,
  'Top-up deposit for Allure investment',
  '2022-12-15 09:00:00+00'
),
-- 5. Reinvestment into Allure
(
  'bbbbbbbb-0001-0001-0001-000000000001',
  'cccccccc-0002-0002-0002-000000000002',
  'reinvestment',
  32000,
  'Reinvestment committed — Allure',
  '2023-01-01 10:00:00+00'
),
-- 6. Allure exits: principal + 30% return (first-tranche premium)
(
  'bbbbbbbb-0001-0001-0001-000000000001',
  'cccccccc-0002-0002-0002-000000000002',
  'return',
  41600,
  'Capital + 30% return received — Allure',
  '2024-12-31 12:00:00+00'
);
