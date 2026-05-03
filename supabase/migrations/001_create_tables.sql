-- ============================================================
-- Entremares Investor Platform — Initial Schema
-- ============================================================

-- Investors -------------------------------------------------------
create table if not exists investors (
  id             uuid primary key default gen_random_uuid(),
  email          text unique not null,
  full_name      text not null,
  country        text,
  phone          text,
  wallet_balance numeric default 0,
  total_invested numeric default 0,
  total_returns  numeric default 0,
  member_since   date,
  status         text default 'pending'
                   check (status in ('pending', 'active', 'inactive')),
  created_at     timestamptz default now()
);

-- Projects --------------------------------------------------------
create table if not exists projects (
  id                uuid primary key default gen_random_uuid(),
  name              text not null,
  location          text,
  description       text,
  type              text,
  total_capex       numeric,
  amount_raised     numeric default 0,
  target_return_min numeric,
  target_return_max numeric,
  timeline_months   integer,
  status            text default 'upcoming'
                      check (status in ('upcoming', 'funding', 'active', 'completed')),
  start_date        date,
  end_date          date,
  cover_image_url   text,
  created_at        timestamptz default now()
);

-- Investments -----------------------------------------------------
create table if not exists investments (
  id                uuid primary key default gen_random_uuid(),
  investor_id       uuid not null references investors(id) on delete cascade,
  project_id        uuid not null references projects(id) on delete cascade,
  amount            numeric not null,
  status            text default 'pending'
                      check (status in ('pending', 'confirmed', 'completed')),
  return_amount     numeric default 0,
  return_percentage numeric default 0,
  invested_at       timestamptz default now(),
  document_url      text
);

-- Transactions ----------------------------------------------------
create table if not exists transactions (
  id            uuid primary key default gen_random_uuid(),
  investor_id   uuid not null references investors(id) on delete cascade,
  investment_id uuid references investments(id) on delete set null,
  type          text not null
                  check (type in ('deposit', 'return', 'reinvestment', 'withdrawal')),
  amount        numeric not null,
  description   text,
  created_at    timestamptz default now()
);

-- Indexes ---------------------------------------------------------
create index if not exists idx_investments_investor on investments(investor_id);
create index if not exists idx_investments_project  on investments(project_id);
create index if not exists idx_transactions_investor on transactions(investor_id);
create index if not exists idx_transactions_investment on transactions(investment_id);
